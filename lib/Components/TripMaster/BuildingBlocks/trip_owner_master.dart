import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/Shared/bordered_user_picture.dart';

Row TripOwnerMaster({
  required String nickname,
  required String profilePictureUrl,
  double spacing = 5,
  double pictureRadius = 20,
  double fontSize = 12,
}) {
  return Row(
    children: [
      BorderedUserPicture(radius: pictureRadius, pictureURI: profilePictureUrl),
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