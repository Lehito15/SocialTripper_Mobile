import 'package:cached_network_image/cached_network_image.dart';
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
                ? CachedNetworkImage(
              imageUrl: photoURI,
              maxWidthDiskCache: 500,
              fit: fitType,
              placeholder: (context, url) => const SizedBox.shrink(), // Brak placeholdera
              errorWidget: (context, url, error) => const Center(child: Text('Image load failed', style: TextStyle(color: Colors.red))),
              fadeInDuration: const Duration(milliseconds: 150), // Płynne wczytywanie
              fadeOutDuration: const Duration(milliseconds: 150), // Płynne znikanie
              // Możesz też dodać animację fadeOutDuration, aby animacja znikania była płynna
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