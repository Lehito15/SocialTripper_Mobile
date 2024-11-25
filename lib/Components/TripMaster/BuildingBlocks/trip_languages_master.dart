import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/Shared/language_master.dart';
import 'package:social_tripper_mobile/Components/Shared/titled_section_small.dart';
import 'package:social_tripper_mobile/Utilities/Retrievers/flag_retriever.dart';

import '../../Shared/limited_retrieved_elements_row.dart';

Column TripLanguagesMaster({
  required Set<String> languages,
  int maxElements = 5,
  spacing = 5
}) {
  return TitledSectionSmall(
      title: "Languages",
      spacing: spacing,
      child: LimitedRetrievedElementsRow(
          languages,
          maxElements,
          FlagRetriever(),
          wrapper: LanguageMaster
      )
  );
}
