import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'bottom_nav_item.dart';


class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;

  const CustomBottomNavBar({super.key, required this.currentIndex});  // Wymagamy tego parametru

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  // Usuwamy _currentIndex, ponieważ teraz jest przekazywany przez konstruktor
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;  // Ustawiamy indeks z widgetu
  }

  @override
  Widget build(BuildContext context) {
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
                _currentIndex == 0,  // Indeks dla "Home"
                    () {
                  setState(() {
                    _currentIndex = 0;  // Aktualizuj stan
                  });
                  context.go("/home");  // Przejdź do strony Home
                },
              ),
              BottomNavItem(
                "Trips",
                "assets/icons/trip_icon_black.svg",
                "svg",
                _currentIndex == 1,  // Indeks dla "Trips"
                    () {
                  setState(() {
                    _currentIndex = 1;  // Aktualizuj stan
                  });
                  context.go("/trips");  // Przejdź do strony Trips
                },
              ),
              BottomNavItem(
                "Relations",
                "assets/icons/relacja.svg",
                "svg",
                _currentIndex == 2,  // Indeks dla "Relations"
                    () {
                  setState(() {
                    _currentIndex = 2;  // Aktualizuj stan
                  });
                  context.go("/relations");  // Przejdź do strony Relations
                },
              ),
              BottomNavItem(
                "Groups",
                "assets/icons/group.svg",
                "svg",
                _currentIndex == 3,  // Indeks dla "Groups"
                    () {
                  setState(() {
                    _currentIndex = 3;  // Aktualizuj stan
                  });
                  context.go("/groups");  // Przejdź do strony Groups
                },
              ),
              BottomNavItem(
                "Explore",
                "assets/icons/explore.svg",
                "svg",
                _currentIndex == 4,  // Indeks dla "Explore"
                    () {
                  setState(() {
                    _currentIndex = 4;  // Aktualizuj stan
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