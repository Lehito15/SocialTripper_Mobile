import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'bloc/navigation_bloc.dart';
import 'bloc/navigation_event.dart';
import 'bloc/navigation_state.dart';

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
                  bottomNavItem("Trips", "assets/icons/path_black.svg", "svg", 1 == currentIndex, () {
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

  // Dodany parametr isActive
  GestureDetector bottomNavItem(String name, String iconPath, String type, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          bottomNavIconZone(iconPath, type, isActive),
          Text(
            name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w400 : FontWeight.w300,
              color: Colors.black, // Zmieniamy kolor tekstu na czerwony, jeśli aktywne
            ),
          ),
        ],
      ),
    );
  }

  // Zmieniamy kolor ikony, jeśli jest aktywna
  Container bottomNavIconZone(String iconPath, String type, bool isActive) {
    return Container(
      width: isActive ? 36 : 34,
      height: isActive ? 36 : 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.black : Colors.transparent, // Zmieniamy kolor tła na czerwony, jeśli aktywne
        boxShadow: isActive ? [
          BoxShadow(
            color: Color(0xffBDF271),
            blurRadius: 0,
            spreadRadius: 2
          )
        ] : null,
        border: isActive ? Border.all(color: Color(0xff2F3C1C), width: 2.0) : null
      ),
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: type == "svg"
            ? SvgPicture.asset(iconPath, color: isActive ? Color(0xffBDF271) : null)
            : Image.asset(iconPath, color: isActive ? Color(0xffBDF271) : null),
      ),
    );
  }
}