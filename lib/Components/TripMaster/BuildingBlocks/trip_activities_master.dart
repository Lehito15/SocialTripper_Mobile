import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/Shared/activity_master.dart';
import 'package:social_tripper_mobile/Components/Shared/titled_section_small.dart';
import 'package:social_tripper_mobile/Utilities/Retrievers/activity_retriever.dart';
import '../../Shared/limited_retrieved_elements_row.dart';

Column TripActivitiesMaster({
  required Set<String> activities,
  int maxElements = 5,
  double spacing = 5,
}) {
  return TitledSectionSmall(
      title: "Activities",
      spacing: spacing,
      child: LimitedRetrievedElementsRow(
          activities,
          maxElements,
          ActivityRetriever(),
          wrapper: ActivityMaster,
          lastItemBorderRadius: 6.0,
        elementWidth: 25,
      )
  );
}