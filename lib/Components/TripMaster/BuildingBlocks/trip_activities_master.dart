import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/Shared/activity_master.dart';

Column TripActivitiesMaster() {
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
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ActivityMaster(),
          ActivityMaster(),
          ActivityMaster(),
          ActivityMaster(),
          ActivityMaster()
        ],
      )
    ],
  );
}