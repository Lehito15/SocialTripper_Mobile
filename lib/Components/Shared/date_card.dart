import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Utilities/Converters/date_converter.dart';
import 'package:tuple/tuple.dart';

Container DateCard(
    {required int month,
    required int day,
    Color boxColor = const Color(0xffF0F2F5),
    double borderRadius = 10.0,
    Tuple2<double, double> verticalPadding = const Tuple2(4.0, 4.0),
    Tuple2<double, double> horizontalPadding = const Tuple2(11.0, 11.0),
    TextStyle dayStyle = const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    TextStyle monthStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    double spacing = 9.0,
    }) {
  return Container(
    decoration: BoxDecoration(
      color: boxColor,
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    child: Padding(
      padding: EdgeInsets.only(
          left: horizontalPadding.item1,
          right: horizontalPadding.item2,
          top: verticalPadding.item1,
          bottom: verticalPadding.item2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateConverter.convertMonthNumberToShortenedText(month),
            style: monthStyle,
          ),
          SizedBox(
            height: spacing,
          ),
          Text(
            day.toString(),
            style: dayStyle,
          ),
        ],
      ),
    ),
  );
}
