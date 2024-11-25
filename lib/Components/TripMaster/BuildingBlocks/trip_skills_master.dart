import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/TripMaster/BuildingBlocks/trip_activities_master.dart';

import 'trip_languages_master.dart';

Row TripSkillsMaster({
  required Set<String> activities,
  required Set<String> languages
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: TripActivitiesMaster(
        activities: activities,
        spacing: 5
      )),
      SizedBox(
        width: 36,
      ),
      Expanded(child: TripLanguagesMaster(
        languages: languages,
        spacing: 8.5

      ))
    ],
  );
}