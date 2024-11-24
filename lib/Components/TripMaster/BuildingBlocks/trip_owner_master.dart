import 'package:flutter/material.dart';

Row TripOwnerMaster() {
  return Row(
    children: [
      Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: ClipOval(
          child: Image.asset(
            "assets/MediaFiles/zbigniew.jpg",
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(
        width: 5,
      ),
      Text(
        "Zbigniew Kucharski",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      )
    ],
  );
}