import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Utilities/Converters/date_converter.dart';
import 'package:social_tripper_mobile/Utilities/Retrievers/icon_retriever.dart';
import 'package:tuple/tuple.dart';


Row ClockTime({
  required int hour,
  required int minute,
  String iconName = "clock.svg",
  Tuple2<double, double> clockSize = const Tuple2(11.0, 11.0),
  double fontSize = 11,
  FontWeight fontWeight = FontWeight.w600,
  double spacing = 3
}) {
  IconRetriever retriever = IconRetriever();
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: clockSize.item1,
        height: clockSize.item2,
        child: retriever.retrieve(iconName, clockSize.item2),
      ),
      SizedBox(
        width: spacing,
      ),
      Text(
        DateConverter.convertClockTimeToString(hour, minute),
        style: TextStyle(fontWeight: fontWeight, fontSize: fontSize),
      )
    ],
  );
}