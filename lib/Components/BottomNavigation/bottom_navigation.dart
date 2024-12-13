import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_tripper_mobile/VM/app_viewmodel.dart';
import 'bottom_nav_item.dart';


class CustomBottomNavBar extends StatefulWidget {

  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppViewModel appViewModel = Provider.of<AppViewModel>(context, listen: false);
    return SafeArea(
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 0,
              blurRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BottomNavItem(
                "Home",
                "assets/icons/house_filled_black.png",
                "png",
                appViewModel.currentNavIndex == 0,
                    () {
                  setState(() {
                    appViewModel.changeIndex(0);  // Aktualizuj stan
                  });
                  context.go("/home");  // Przejdź do strony Home
                },
              ),
              BottomNavItem(
                "Trips",
                "assets/icons/trip_icon_black.svg",
                "svg",
                appViewModel.currentNavIndex == 1,
                    () {
                  setState(() {
                    appViewModel.changeIndex(1);  // Aktualizuj stan
                  });
                  context.go("/trips");  // Przejdź do strony Trips
                },
              ),
              BottomNavItem(
                "Relations",
                "assets/icons/relacja.svg",
                "svg",
                appViewModel.currentNavIndex == 2,
                    () {
                  setState(() {
                    appViewModel.changeIndex(2);  // Aktualizuj stan
                  });
                  context.go("/relations");  // Przejdź do strony Relations
                },
              ),
              // BottomNavItem(
              //   "Groups",
              //   "assets/icons/group.svg",
              //   "svg",
              //   appViewModel.currentNavIndex == 3,
              //       () {
              //     setState(() {
              //       appViewModel.changeIndex(3);  // Aktualizuj stan
              //     });
              //     context.go("/groups");  // Przejdź do strony Groups
              //   },
              // ),
              BottomNavItem(
                "Explore",
                "assets/icons/explore.svg",
                "svg",
                appViewModel.currentNavIndex == 4,
                    () {
                  setState(() {
                    appViewModel.changeIndex(4);  // Aktualizuj stan
                  });
                  context.go("/explore");  // Przejdź do strony Explore
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}