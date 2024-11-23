import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/Shared/trip_date_time.dart';


Container TripDateTitleRow(DateTime start, DateTime end, title) {
  return Container(
    padding: EdgeInsets.only(bottom: 9), // Dodajemy padding od dołu
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.black.withOpacity(0.1),
          width: 1.0,
        ),
      ),
    ),
    child: IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TripDateTime(start),
          SizedBox(width: 9),
          TripDateTime(end),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Source Sans 3",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}