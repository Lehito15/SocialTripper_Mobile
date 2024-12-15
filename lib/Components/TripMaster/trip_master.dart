import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:social_tripper_mobile/Components/TripMaster/BuildingBlocks/trip_bottom_row_master.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_thumbnail.dart';
import 'package:social_tripper_mobile/Models/Trip/user_trip_request.dart';
import '../../Services/account_service.dart';
import '../../Services/trip_service.dart';
import 'BuildingBlocks/trip_date_title_row.dart';
import 'BuildingBlocks/trip_description_master.dart';
import 'BuildingBlocks/trip_photo_master.dart';
import 'BuildingBlocks/trip_skills_master.dart';
import 'BuildingBlocks/trip_top_bar_master.dart';

class TripMasterView extends StatefulWidget {
  final TripMaster trip;

  const TripMasterView({super.key, required this.trip});

  @override
  _TripMasterViewState createState() => _TripMasterViewState();
}

class _TripMasterViewState extends State<TripMasterView> {
  late TripMaster trip;

  @override
  void initState() {
    super.initState();
    trip = widget.trip;
  }

  void onRemoveFromTrip() {
    setState(() {
      trip.numberOfParticipants--;
    });
  }

  void onAcceptToTrip() {
    setState(() {
      trip.numberOfParticipants++;
    });
  }

  void onLeaveTrip() {
    setState(() {
      trip.numberOfParticipants--;
      trip.isMember = false;
    });
  }

  void goTripDetail() {
    context.push('/trips/detail', extra: {
      'trip': trip,
      'onRemoveFromTrip': onRemoveFromTrip,
      'onAcceptToTrip': onAcceptToTrip,
      'onLeaveTrip': onLeaveTrip,
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        goTripDetail();
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TripTopBarMaster(trip: trip),
              const SizedBox(height: 9),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: trip.iconUrl != null &&
                      Uri.tryParse(trip.iconUrl!)?.hasAbsolutePath == true
                      ? CachedNetworkImage(
                    imageUrl: trip.iconUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                  )
                      : Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SvgPicture.asset(
                      'assets/icons/main_logo.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 9),
              TripDateTitleRow(
                  trip.eventStartTime, trip.eventEndTime, trip.name),
              const SizedBox(height: 9),
              TripDescriptionMaster(description: trip.description),
              const SizedBox(height: 9),
              TripSkillsMaster(
                  activities: trip.activities, languages: trip.languages),
              const SizedBox(height: 20),
              TripBottomRowMaster(
                owner: trip.owner,
                currentMembers: trip.numberOfParticipants,
                maxMembers: trip.maxNumberOfParticipants,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
