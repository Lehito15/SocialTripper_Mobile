import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/Shared/activity_master.dart';

import '../../../Models/Activity/activity_thumbnail.dart';
import '../../Shared/limited_elements_row.dart';

Column TripActivitiesMaster({
  required List<String> activities,
  int maxElements = 5,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Activities",
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      ),
      SizedBox(
        height: 5,
      ),
      Container(
        height: 25,
        child: LimitedElementsRow(activities, maxElements, "Activity"),
      )
    ],
  );
}