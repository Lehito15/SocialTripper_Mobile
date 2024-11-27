import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_tripper_mobile/Pages/page_container.dart';
import 'package:social_tripper_mobile/Utilities/Converters/language_converter.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/user_generator.dart';

import 'Components/BottomNavigation/bloc/navigation_bloc.dart';
import '../Utilities/Tasks/location_task.dart';

Future<void> initExamples() async {
  await UserGenerator.fetchRandomUsers(115);
  await LanguageConverter.initialize();
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initExamples();
  await initService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(
          create: (context) => NavigationBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Kanit'),
        home: PageContainer(),
      ),
    );
  }
}

