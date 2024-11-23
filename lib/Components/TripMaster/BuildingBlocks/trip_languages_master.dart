import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/Shared/language_master.dart';

Column TripLanguagesMaster() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Languages",
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      ),
      SizedBox(
        height: 5,
      ),
      Container(
        height: 25,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LanguageMaster(),
            LanguageMaster(),
            LanguageMaster(),
            LanguageMaster(),
            LanguageMaster(),
          ],
        ),
      )
    ],
  );
}