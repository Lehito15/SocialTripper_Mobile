import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/Shared/titled_section_small.dart';

Column TripDescriptionMaster({
  required String description
}) {
  return TitledSectionSmall(title: "Description", child: _DesciptionText(description));
}


Text _DesciptionText(String description) {
  return Text(
    description,
    style: TextStyle(
        fontFamily: "Source Sans 3",
        fontWeight: FontWeight.w300,
        fontSize: 12
    ),
    overflow: TextOverflow.ellipsis,
    maxLines: 5,
  );
}