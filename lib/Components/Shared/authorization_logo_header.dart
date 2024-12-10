import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget AuthorizationLogoHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 70,
        height: 70,
        child: SvgPicture.asset("assets/icons/main_logo.svg"),
      ),
      SizedBox(
        width: 10,
      ),
      Text(
        "SocialTripper",
        style: TextStyle(
          fontSize: 32,
          shadows: [
            Shadow(
              offset: Offset(-1, 1),
              // Wektor przesunięcia cienia (x, y)
              blurRadius: 1,
              // Promień rozmycia cienia
              color: Colors.black.withOpacity(
                  0.25), // Kolor cienia (możesz dostosować przezroczystość)
            ),
          ],
        ),
      )
    ],
  );
}