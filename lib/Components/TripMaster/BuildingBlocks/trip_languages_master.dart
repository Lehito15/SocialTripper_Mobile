import 'package:flutter/material.dart';

import '../../Shared/limited_elements_row.dart';

Column TripLanguagesMaster({
  required List<String> languages,
  int maxElements = 5,
}) {
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
        child: LimitedElementsRow(languages, maxElements, "Language"),
      )
    ],
  );
}
