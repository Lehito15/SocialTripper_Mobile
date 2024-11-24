import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/TripMaster/BuildingBlocks/trip_activities_master.dart';

import 'trip_languages_master.dart';

Row TripSkillsMaster() {
  return Row(
    children: [
      Expanded(child: TripActivitiesMaster()),
      SizedBox(
        width: 36,
      ),
      Expanded(child: TripLanguagesMaster())
    ],
  );
}