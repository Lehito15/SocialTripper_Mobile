import 'package:flutter/material.dart';
import '../../Shared/expandable_text.dart';


class PostTextContent extends StatelessWidget {
  final String content;

  PostTextContent({required this.content});

  @override
  Widget build(BuildContext context) {
    return ExpandableDescriptionText(
      description: content,
      textStyle: TextStyle(
        fontSize: 13,
        fontFamily: "Source Sans 3",
        fontWeight: FontWeight.w400,
      ),
    );
  }
}