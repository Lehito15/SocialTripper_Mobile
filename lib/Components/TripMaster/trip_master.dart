import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/TripMaster/BuildingBlocks/trip_bottom_row_master.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';
import 'BuildingBlocks/trip_date_title_row.dart';
import 'BuildingBlocks/trip_description_master.dart';
import 'BuildingBlocks/trip_photo_master.dart';
import 'BuildingBlocks/trip_skills_master.dart';
import 'BuildingBlocks/trip_top_bar_master.dart';

Widget TripMasterView(TripMaster trip) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Jeśli TripTopBarMaster nie zmienia się, można to zrobić jako const
          TripTopBarMaster(location: trip.destination),
          const SizedBox(height: 9),
          TripPhotoMaster(photoURI: trip.photoUri, isNetworkImage: true),
          const SizedBox(height: 9),
          TripDateTitleRow(trip.startDate, trip.endDate, trip.name),
          const SizedBox(height: 9),
          TripDescriptionMaster(description: trip.description),
          const SizedBox(height: 9),
          TripSkillsMaster(
              activities: trip.activities,
              languages: trip.languages
          ),
          const SizedBox(height: 20),
          TripBottomRowMaster(
              owner: trip.tripOwner,
              currentMembers: trip.numberOfParticipants,
              maxMembers: trip.maxNumberOfParticipants),
        ],
      ),
    ),
  );
}
