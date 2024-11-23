import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/Shared/clock_time.dart';
import 'package:social_tripper_mobile/Components/Shared/date_card.dart';

Column TripDateTime(DateTime dateTime) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      DateCard(month: dateTime.month, day: dateTime.day),
      SizedBox(
        height: 4,
      ),
      ClockTime(hour: dateTime.hour, minute: dateTime.minute)
    ],
  );
}
