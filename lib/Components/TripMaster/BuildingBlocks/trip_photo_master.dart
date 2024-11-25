import 'package:flutter/material.dart';

Row TripPhotoMaster({
  required String photoURI,
  double aspectRatio = 16 / 9,
  double borderRadius = 12.0,
  BoxFit fitType = BoxFit.cover,
  bool isNetworkImage = false, // Flaga określająca typ obrazu
}) {
  return Row(
    children: [
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: isNetworkImage
                ? Image.network(
              photoURI,
              fit: fitType,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Text('Image load failed', style: TextStyle(color: Colors.red)));
              },
            )
                : Image.asset(
              photoURI,
              fit: fitType,
            ),
          ),
        ),
      ),
    ],
  );
}