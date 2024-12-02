import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

GestureDetector BottomNavItem(String name, String iconPath, String type, bool isActive, VoidCallback onTap) {
  print(isActive);
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