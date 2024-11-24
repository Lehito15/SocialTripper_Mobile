import 'package:flutter/material.dart';

Row TripPhotoMaster({
  required String photoURI,
  double aspectRatio = 16 / 9,
  double borderRadius = 12.0,
  BoxFit fitType = BoxFit.cover
}) {
  return Row(
    children: [
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Image.asset(
              photoURI,
              fit: fitType,
            ),
          ),
        ),
      ),
    ],
  );
}