import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tuple/tuple.dart';

Container BorderedUserPicture({
  required double radius,
  required String pictureURI,
  double borderWidth = 1,
}) {
  return Container(
    width: radius,
    height: radius,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.black,
        width: borderWidth,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25), // Kolor cienia
          spreadRadius: 0, // Rozproszenie
          blurRadius: 4, // Rozmycie
          offset: Offset(0, 2), // Przesunięcie w osi x, y
        ),
      ],
    ),
    child: ClipOval(
      child: pictureURI.endsWith('.svg') // Sprawdzamy, czy obraz to SVG
          ? SvgPicture.asset(
        pictureURI,
        fit: BoxFit.cover,
      )
          : pictureURI.startsWith('http') || pictureURI.startsWith('https')
          ? Image.network(
        pictureURI,
        fit: BoxFit.cover,
      )
          : Image.asset(
        pictureURI,
        fit: BoxFit.cover,
      ),
    ),
  );
}