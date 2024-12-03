import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Row TripMembers({
  required currentMembers,
  required maxMembers,
  double iconRadius = 20,
  double fontSize = 12,
  double spacing = 5
}) {
  return Row(
    children: [
      Text(
        maxMembers == -1 ? "$currentMembers" : "$currentMembers/$maxMembers",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: fontSize),
      ),
      SizedBox(
        width: spacing,
      ),
      Container(
        width: iconRadius,
        height: iconRadius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: SvgPicture.asset(
            "assets/icons/trip_members.svg",
            fit: BoxFit.cover,
          ),
        ),
      ),
    ],
  );
}