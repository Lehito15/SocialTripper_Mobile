import 'package:flutter/material.dart';

Column TitledSectionSmall({
  required String title,
  required Widget child,
  FontWeight titleWeight = FontWeight.w500,
  double titleSize = 13,
  double spacing = 5,
  CrossAxisAlignment xAxisAlignment = CrossAxisAlignment.start,
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start
}) {
  return Column(
    crossAxisAlignment: xAxisAlignment,
    children: [
      Row(
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: titleWeight, fontSize: titleSize),
          ),
        ],
      ),
      SizedBox(
        height: spacing,
      ),
      Container(
        child: child,
      )
    ],
  );
}