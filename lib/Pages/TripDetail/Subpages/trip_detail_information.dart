import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';

import '../../../Components/Shared/titled_section_medium_bordered.dart';

Widget Information(TripMaster trip) {
  return Column(
    children: [
      TitledSectionMediumBordered(
        title: "General information",
        child: TripDetailGeneralInformation(trip.description),
        spacing: 9,
        padding: EdgeInsets.symmetric(horizontal: 9),
      ),
      TitledSectionMediumBordered(
        title: "Trip rules",
        child: TripDetailGeneralInformation(trip.rules),
        spacing: 9,
        padding: EdgeInsets.symmetric(horizontal: 9),
      ),
    ],
  );
}

Text TripDetailGeneralInformation(String information) {
  return Text(
    information,
    style: TextStyle(
      fontFamily: "Source Sans 3",
      fontSize: 12,
    ),
  );
}