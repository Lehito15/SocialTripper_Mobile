import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/navigation_bloc.dart';
import 'bloc/navigation_event.dart';
import 'bloc/navigation_state.dart';
import 'bottom_nav_item.dart';


class CustomBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        int currentIndex = 0;
        if (state is TabChangedState) {
          currentIndex = state.currentIndex;
        }

        return SafeArea(
          child: Container(
            height: 72,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      spreadRadius: 0,
                      blurRadius: 2
                  )
                ]
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  bottomNavItem("Home", "assets/icons/house_filled_black.png", "png", 0 == currentIndex, () {
                    context.read<NavigationBloc>().add(ChangeTabEvent(0));
                  }),
                  bottomNavItem("Trips", "assets/icons/trip_icon_black.svg", "svg", 1 == currentIndex, () {
                    context.read<NavigationBloc>().add(ChangeTabEvent(1));
                  }),
                  bottomNavItem("Relations", "assets/icons/relacja.svg", "svg", 2 == currentIndex, () {
                    context.read<NavigationBloc>().add(ChangeTabEvent(2));
                  }),
                  bottomNavItem("Groups", "assets/icons/group.svg", "svg", 3 == currentIndex, () {
                    context.read<NavigationBloc>().add(ChangeTabEvent(3));
                  }),
                  bottomNavItem("Explore", "assets/icons/explore.svg", "svg", 4 == currentIndex, () {
                    context.read<NavigationBloc>().add(ChangeTabEvent(4));
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}