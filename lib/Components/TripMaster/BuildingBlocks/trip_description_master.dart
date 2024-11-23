import 'package:flutter/material.dart';

Column TripDescriptionMaster() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Description",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
      Text(
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaini",
        style: TextStyle(
            fontFamily: "Source Sans 3",
            fontWeight: FontWeight.w300,
            fontSize: 12),
      )
    ],
  );
}