import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/Shared/titled_section_small.dart';

import '../../Shared/expandable_text.dart';


TextStyle _TripDescriptionMasterTextStyle() {
  return TextStyle(fontFamily: "Source Sans 3", fontWeight: FontWeight.w300, fontSize: 12);
}



class TripDescriptionMaster extends StatelessWidget {
  final String description;

  TripDescriptionMaster({required this.description});

  @override
  Widget build(BuildContext context) {
    return TitledSectionSmall(
      title: "Description",
      child: ExpandableDescriptionText(description: description, textStyle: _TripDescriptionMasterTextStyle(),),
    );
  }
}

