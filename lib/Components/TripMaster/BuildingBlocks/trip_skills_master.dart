import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/TripMaster/BuildingBlocks/trip_activities_master.dart';
import 'package:social_tripper_mobile/Models/Shared/required_activity.dart';
import 'package:social_tripper_mobile/Models/Shared/required_language.dart';

import 'trip_languages_master.dart';

Row TripSkillsMaster({
  required Set<RequiredActivity> activities,
  required Set<RequiredLanguage> languages
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