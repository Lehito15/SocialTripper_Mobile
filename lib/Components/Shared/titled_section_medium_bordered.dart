import 'package:flutter/material.dart';

Widget TitledSectionMediumBordered({
  required String title,
  required Widget child,
  FontWeight titleWeight = FontWeight.w500,
  double titleSize = 13,
  double spacing = 5,
  CrossAxisAlignment xAxisAlignment = CrossAxisAlignment.start,
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
  bool showEdit = false,
  EdgeInsets padding = const EdgeInsets.all(0)
}) {
  return Container(
    color: Colors.white,
    child: Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: xAxisAlignment,
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xffD9D9D9),
                    width: 1.0,
                  ),
                )
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: spacing, top: spacing),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(fontWeight: titleWeight, fontSize: titleSize),
                    ),
                  ),
                  showEdit ? Text("Edit") : Container(),
                ],
              ),
            ),
          ),
          SizedBox(
            height: spacing,
          ),
          Container(
            child: child,
          ),
          SizedBox(
            height: spacing,
          )
        ],
      ),
    ),
  );
}