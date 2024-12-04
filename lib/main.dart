
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_tripper_mobile/Models/Post/post_master_model.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';
import 'package:social_tripper_mobile/Pages/config/data_retrieving_config.dart';
import 'package:social_tripper_mobile/Pages/home_page.dart';
import 'package:social_tripper_mobile/Pages/post_comments_page.dart';
import 'package:social_tripper_mobile/Pages/trip_interface.dart';
import 'package:social_tripper_mobile/Pages/trips_page.dart';
import 'package:social_tripper_mobile/Repositories/post_repository.dart';
import 'package:social_tripper_mobile/Repositories/trip_repository.dart';
import 'package:social_tripper_mobile/Utilities/Converters/language_converter.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/user_generator.dart';
import 'package:go_router/go_router.dart';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'Pages/data_loading_page.dart';
import 'amplifyconfiguration.dart';

import 'Components/BottomNavigation/bottom_navigation.dart';
import 'Components/TopNavigation/appbar.dart';
import 'Pages/TripDetail/trip_detail_page.dart';
import 'Utilities/Tasks/location_task.dart';





Future<void> _configureAmplify() async {
  // To be filled in
  try {
    // Create the API plugin.
    //
    // If `ModelProvider.instance` is not available, try running
    // `amplify codegen models` from the root of your project.
    // final api = AmplifyAPI();
    // Create the Auth plugin.
    final auth = AmplifyAuthCognito();
    // Add the plugins and configure Amplify for your app.
    await Amplify.addPlugins([auth]);
    await Amplify.configure(amplifyconfig);
    safePrint('Successfully configured');
  } on Exception catch (e) {
    safePrint('Error configuring Amplify: $e');
  }
}

Future<void> initExamples() async {
  await UserGenerator.fetchRandomUsers(115);
  await LanguageConverter.initialize();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initExamples();
  await initService();
  DataRetrievingConfig.source == Source.BACKEND
      ? await PostRepository.initialize()
      : print("");
  DataRetrievingConfig.source == Source.BACKEND
      ? await TripRepository.initialize()
      : print("");
  await _configureAmplify();
  // if (kDebugMode) {
  //   await Amplify.Auth.signOut();
  //   final prefs = await SharedPreferences.getInstance();  // Pobiera instancję SharedPreferences
  //   prefs.clear();
  //   print("wyczyszczono");
  // }
  runApp(const MyApp());
}

final GoRouter router = GoRouter(
  initialLocation: '/data_loading', // Domyślna lokalizacja
  routes: [
    GoRoute(
      path: '/data_loading', // Strona powitalna, która będzie ładować dane
      builder: (context, state) {
        return DataLoadingPage(); // Nasz SplashScreen
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state,
          StatefulNavigationShell navigationShell) {
        return Scaffold(
          appBar: CustomAppBar(context),
          backgroundColor: const Color(0xFFF0F2F5),
          body: navigationShell, // Używamy nawigacji jako dziecko
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: 0,
          ),
        );
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
          ),
        ]),
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
              path: '/trips',
              builder: (context, state) => const TripsPage(),
              routes: [
                GoRoute(
                    path: 'detail',
                    builder: (context, state) {
                      final data = state.extra as Map<String, dynamic>?;
                      final tripMaster = data?['trip'] as TripMaster;
                      final isOwner = data?['isOwner'] as bool;
                      final isMember = data?['isMember'] as bool;
                      final isRequested = data?['isRequested'] as bool;
                      return TripDetailPage(
                        trip: tripMaster,
                        isOwner: isOwner,
                        isMember: isMember,
                        isRequested: isRequested,
                      );
                    })
              ]),
        ]),
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
            path: '/relations',
            builder: (context, state) => const Text("relations"),
          ),
        ]),
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
            path: '/groups',
            builder: (context, state) => const Text("grp"),
          )
        ]),
        StatefulShellBranch(routes: <RouteBase>[
          GoRoute(
            path: '/explore',
            builder: (context, state) => const TripInterface(),
          )
        ]),
      ],
    ),
    StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell) {
          return Scaffold(
            appBar: null,
            backgroundColor: Colors.white,
            body: navigationShell,
          );
        }
        ,branches: [
      StatefulShellBranch(routes: <RouteBase>[
        GoRoute(
            path: '/post_comments',
            builder: (context, state) {
              final data = state.extra as Map<String, dynamic>?;
              final postMaster = data?['model'] as PostMasterModel?;
              final likeCallback = data?['like_callback'] as void Function()?;
              final commentCallback = data?['comment_callback'] as void Function()?;
              return PostCommentsPage(postMaster!, likeCallback!, commentCallback!);
            })
      ]
      )
    ])
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      authenticatorBuilder: (BuildContext context, AuthenticatorState state) {
        switch (state.currentStep) {
          case AuthenticatorStep.signIn:
            return CustomScaffold(
              state: state,
              // Prezentujemy formularz logowania
              body: SignInForm(),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () => state.changeStep(AuthenticatorStep.signUp),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            );
          case AuthenticatorStep.signUp:
            return CustomScaffold(
              state: state,
              // Prezentujemy formularz rejestracji
              body: SignUpForm(),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () => state.changeStep(AuthenticatorStep.signIn),
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            );
          default:
            // Inne kroki mogą być obsługiwane domyślnie
            return null;
        }
      },
      child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppThemeData(),
          routerConfig: router,
          builder: Authenticator.builder()),
    );
  }

  ThemeData AppThemeData() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Kanit',
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.green,
        backgroundColor: Colors.black,
      ).copyWith(
        primary: Colors.black,
        onPrimary: Color(0xFFBDF271),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFF0F2F5).withOpacity(0.6),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(60),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(60),
        ),
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        labelStyle: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontSize: 14,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        isDense: false,
      ),
    );
  }
}

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.state,
    required this.body,
    this.footer,
  });

  final AuthenticatorState state;
  final Widget body;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      child: SvgPicture.asset("assets/icons/main_logo.svg"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "SocialTripper",
                      style: TextStyle(
                        fontSize: 32,
                        shadows: [
                          Shadow(
                            offset: Offset(-1, 1),
                            // Wektor przesunięcia cienia (x, y)
                            blurRadius: 1,
                            // Promień rozmycia cienia
                            color: Colors.black.withOpacity(
                                0.25), // Kolor cienia (możesz dostosować przezroczystość)
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: body,
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: footer != null ? [footer!] : null,
    );
  }
}
