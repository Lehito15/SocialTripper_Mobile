import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/Shared/activity_master.dart';
import 'package:social_tripper_mobile/Components/Shared/titled_section_small.dart';
import 'package:social_tripper_mobile/Models/Shared/required_activity.dart';
import 'package:social_tripper_mobile/Utilities/Retrievers/activity_retriever.dart';
import '../../Shared/limited_retrieved_elements_row.dart';

Column TripActivitiesMaster({
  required Set<RequiredActivity> activities,
  int maxElements = 5,
  double spacing = 5,
}) {
  Set<String> activityNames = Set();
  for (var element in activities) {
    activityNames.add(element.activity.name);
  }
  return TitledSectionSmall(
      title: "Activities",
      spacing: spacing,
      child: LimitedRetrievedElementsRow(
          activityNames,
          maxElements,
          ActivityRetriever(),
          wrapper: ActivityMaster,
          lastItemBorderRadius: 6.0,
        elementWidth: 25,
      )
  );
}