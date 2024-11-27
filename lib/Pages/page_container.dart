import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_tripper_mobile/Components/TopNavigation/appbar.dart';
import 'package:social_tripper_mobile/Components/TripMaster/trip_master.dart';
import 'package:social_tripper_mobile/Pages/trips_page.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/Trip/trip_generator.dart';

import '../Components/BottomNavigation/bloc/navigation_bloc.dart';
import '../Components/BottomNavigation/bloc/navigation_state.dart';
import '../Components/BottomNavigation/bottom_navigation.dart';
import '../Models/Trip/trip_master.dart';

class PageContainer extends StatefulWidget {
  @override
  _PageContainerState createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text("Home Page")), // Placeholder dla stron
    TripsPage(key: TripsPage.tripsPageKey), // Strona wycieczek z GlobalKey
    Center(child: Text("Relations Page")), // Placeholder
    Center(child: Text("Groups Page")), // Placeholder
    Center(child: Text("Explore Page")), // Placeholder
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