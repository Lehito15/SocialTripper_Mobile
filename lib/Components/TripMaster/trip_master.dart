import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/TripMaster/BuildingBlocks/trip_bottom_row_master.dart';
import 'BuildingBlocks/trip_date_title_row.dart';
import 'BuildingBlocks/trip_description_master.dart';
import 'BuildingBlocks/trip_photo_master.dart';
import 'BuildingBlocks/trip_skills_master.dart';
import 'BuildingBlocks/trip_top_bar_master.dart';

Widget TripMasterView() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
      // Padding wewnętrzny
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TripTopBarMaster(location: "Góry himalaje zapraszam"),
          SizedBox(height: 9),
          TripPhotoMaster(photoURI: "assets/MediaFiles/gora.jpg"),
          SizedBox(height: 9),
          TripDateTitleRow(
            DateTime(2000, 9, 22, 12, 12),
            DateTime(2000, 9, 22, 8, 0),
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
          ),
          SizedBox(height: 9),
          TripDescriptionMaster(),
          SizedBox(height: 9),
          TripSkillsMaster(),
          SizedBox(height: 20),
          TripBottomRowMaster(),
        ],
      ),
    ),
  );
}