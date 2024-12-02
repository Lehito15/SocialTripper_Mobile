import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_detail.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';
import 'package:social_tripper_mobile/Pages/home_page.dart';
import 'package:social_tripper_mobile/Pages/trips_page.dart';
import 'package:social_tripper_mobile/Repositories/post_repository.dart';
import 'package:social_tripper_mobile/Services/post_service.dart';
import 'package:social_tripper_mobile/Utilities/Converters/language_converter.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/user_generator.dart';
import 'package:go_router/go_router.dart';

import 'Components/BottomNavigation/bottom_navigation.dart';
import 'Components/TopNavigation/appbar.dart';
import 'Pages/trip_detail_page.dart';
import 'Utilities/Tasks/location_task.dart';

Future<void> initExamples() async {
  await UserGenerator.fetchRandomUsers(115);
  await LanguageConverter.initialize();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initExamples();
  await initService();
  await PostRepository.initialize();
  runApp(const MyApp());
}

final GoRouter router = GoRouter(
  initialLocation: '/home', // Domyślna lokalizacja
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state,
          StatefulNavigationShell navigationShell) {
        return Scaffold(
          appBar: CustomAppBar(),
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
                    final tripMaster = state.extra as TripMaster;
                    return TripDetailPage(tripDetail: TripDetail.fromTripMaster(tripMaster)!,);
                  }
                )
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
            builder: (context, state) => const Text("xplr"),
          )
        ]),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Kanit'),
      routerConfig: router,
    );
  }
}
