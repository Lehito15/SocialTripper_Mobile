import 'package:cached_network_image/cached_network_image.dart';
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
          TripTopBarMaster(location: trip.destination),
          const SizedBox(height: 9),
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: trip.photoUri,
                    fit: BoxFit.cover,
                  ))),
          const SizedBox(height: 9),
          TripDateTitleRow(trip.startDate, trip.endDate, trip.name),
          const SizedBox(height: 9),
          TripDescriptionMaster(description: trip.description),
          const SizedBox(height: 9),
          TripSkillsMaster(
              activities: trip.activities, languages: trip.languages),
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
