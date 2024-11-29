import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Models/Shared/interaction.dart';


class Interaction extends StatelessWidget {
  final InteractionType type;
  final int interactionCount;
  final VoidCallback onToggleInteraction; // Callback do informowania o zmianie

  Interaction({
    required this.type,
    required this.interactionCount,
    required this.onToggleInteraction,
  });

  @override
  Widget build(BuildContext context) {
    // Ścieżka do odpowiedniej ikony na podstawie typu interakcji
    String path = "";
    switch (type) {
      case InteractionType.LIKE:
        path = "assets/interactions/like.svg";
        break;
      case InteractionType.COMMENT:
        path = "assets/interactions/comment.svg";
        break;
      case InteractionType.LIKE_ACTIVE:
        path = "assets/interactions/like_active.svg";
        break;
    }

    // Tworzymy obrazek SVG
    SvgPicture interactionPicture = SvgPicture.asset(
      path,
      width: 18, // Ustawiamy stałą szerokość i wysokość dla ikony
      height: 18, // Dzięki temu ikony nie będą się powiększać podczas animacji
    );

    return GestureDetector(
      onTap: onToggleInteraction, // Wywołanie callbacka przy kliknięciu
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.only(top: 9, bottom: 9),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: SizedBox(
                key: ValueKey<int>(interactionCount), // Klucz do identyfikacji zmiany
                child: interactionPicture,
              ),
            ),
            SizedBox(width: 6),
            // Wyświetlamy liczbę interakcji
            Text(
              "$interactionCount", // Liczba interakcji przekazywana jako parametr
              style: TextStyle(
                height: 0.2,
                fontWeight: FontWeight.w600,
                fontSize: 15,
                fontFamily: "Source Sans 3",
              ),
            ),
          ],
        ),
      ),
    );
  }
}