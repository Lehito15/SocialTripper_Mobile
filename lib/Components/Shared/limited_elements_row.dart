import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/Shared/activity_master.dart';
import 'package:social_tripper_mobile/Models/Activity/activity_thumbnail.dart';

import '../../Models/Language/language_thumbnail.dart';
import 'language_master.dart';

Row LimitedElementsRow(List<String> elements, int elementNumber, String type) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: List.generate(elementNumber, (index) {
      if (index < elements.length) {
        return Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerLeft,
            child: type == "Language" ? LanguageMaster(language: LanguageThumbnail(name: elements[index])) : ActivityMaster(activity: ActivityThumbnail(name: elements[index])),
          ),
        );
      }
      return Expanded(flex: 1, child: Container());
    }),
  );
}