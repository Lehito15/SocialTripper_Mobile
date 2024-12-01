import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_tripper_mobile/Components/TopNavigation/appbar.dart';
import 'package:social_tripper_mobile/Pages/home_page.dart';
import 'package:social_tripper_mobile/Pages/trips_page.dart';

import '../Components/BottomNavigation/bloc/navigation_bloc.dart';
import '../Components/BottomNavigation/bloc/navigation_state.dart';
import '../Components/BottomNavigation/bottom_navigation.dart';

class PageContainer extends StatefulWidget {
  @override
  _PageContainerState createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(key: HomePage.homePageKey),
    TripsPage(key: TripsPage.tripsPageKey),
    Center(child: Text("Relations Page")),
    Center(child: Text("Groups Page")),
    Center(child: Text("Explore Page")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: const Color(0xffF0F2F5),
      body: BlocListener<NavigationBloc, NavigationState>(
        listener: (context, state) {
          if (state is TabChangedState) {
            if (_currentIndex == 1 && _currentIndex == state.currentIndex) {
              final tripsPageState = TripsPage.tripsPageKey.currentState;
              if (tripsPageState != null) {
                tripsPageState.scrollToTop();
              }
            }

            if (_currentIndex == 0 && _currentIndex == state.currentIndex) {
              final homePageState = HomePage.homePageKey.currentState;
              if (homePageState != null) {
                homePageState.scrollToTop();
              }
            }
            setState(() {
              _currentIndex = state.currentIndex;
            });
          }
        },
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
