import 'package:flutter/material.dart';

Row TripOwnerMaster({
  required String nickname,
  required String profilePictureUrl,
  double spacing = 5,
  double pictureRadius = 20,
  double fontSize = 12,
}) {
  return Row(
    children: [
      Container(
        width: pictureRadius,
        height: pictureRadius,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: ClipOval(
          child: Image.asset(
            profilePictureUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(
        width: 5,
      ),
      Text(
        nickname,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: fontSize),
      )
    ],
  );
}