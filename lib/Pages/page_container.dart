import 'package:social_tripper_mobile/Components/BottomNavigation/bloc/navigation_bloc.dart';
import 'package:social_tripper_mobile/Components/BottomNavigation/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_tripper_mobile/Components/TopNavigation/appbar.dart';
import 'package:social_tripper_mobile/Components/TripMaster/trip_master.dart';
import 'package:social_tripper_mobile/Pages/trip_interface.dart';

import '../Components/BottomNavigation/bloc/navigation_state.dart';

class PageContainer extends StatelessWidget {
  PageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
        backgroundColor: Color(0xffF0F2F5),
        body: BlocBuilder<NavigationBloc, NavigationState>(
            builder: (context, state) {
          int currentIndex = 0;
          if (state is TabChangedState) {
            currentIndex = state.currentIndex;
          }
          switch (currentIndex) {
            case 4:
              return TripInterface();
            default:
              return ListView.separated(
                itemCount: 1,
                padding: EdgeInsets.only(top: 9, bottom: 9),
                itemBuilder: (context, index) {
                  return TripMasterView();
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 9); //
                },
              );
          }
        }),
        bottomNavigationBar: CustomBottomNavBar());
  }
}
