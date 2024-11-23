import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Row TripMembers() {
  return Row(
    children: [
      Text(
        "4/15",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      ),
      SizedBox(
        width: 5,
      ),
      Container(
        width: 20,
        height: 20,
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