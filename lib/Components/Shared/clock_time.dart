import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Utilities/Converters/date_converter.dart';
import 'package:tuple/tuple.dart';


Row ClockTime({
  required int hour,
  required int minute,
  Tuple2<double, double> clockSize = const Tuple2(11.0, 11.0),
  double fontSize = 11,
  FontWeight fontWeight = FontWeight.w600,
  double spacing = 3
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: clockSize.item1,
        height: clockSize.item2,
        child: Image.asset("assets/icons/clock.png"),
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