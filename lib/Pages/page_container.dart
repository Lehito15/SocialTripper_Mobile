import 'package:social_tripper_mobile/Components/BottomNavigation/bloc/navigation_bloc.dart';
import 'package:social_tripper_mobile/Components/BottomNavigation/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_tripper_mobile/Components/TopNavigation/appbar.dart';
import 'package:social_tripper_mobile/Pages/trip_interface.dart';
import '../Components/BottomNavigation/bloc/navigation_state.dart';
import 'home_page.dart';

class PageContainer extends StatefulWidget {
  const PageContainer({super.key});

  @override
  State<PageContainer> createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {
  int currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    HomePage(),
    HomePage(),
    HomePage(),
    TripInterface(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Color(0xffF0F2F5),
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          if (state is TabChangedState) {
            currentIndex = state.currentIndex;
          }
          return IndexedStack(
            index: currentIndex,
            children: _pages,
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
