import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_tripper_mobile/Components/BottomNavigation/bottom_navigation.dart';
import 'package:social_tripper_mobile/Repositories/trip_repository.dart';

import '../../Components/TripMaster/trip_master.dart';
import '../../Models/Trip/trip_detail.dart';
import '../../Models/Trip/trip_master.dart';
import '../../Utilities/DataGenerators/Trip/trip_generator.dart';
import '../trip_detail_page.dart';

class TripPageBuildConfig {
  static Future<void> cachingStrategy(TripMaster trip, BuildContext context) async {
    if (trip.photoUri != null && trip.photoUri!.isNotEmpty) {
      final imageProvider = CachedNetworkImageProvider(trip.photoUri!);
      await precacheImage(imageProvider, context);
    }
  }

  static Widget buildItem(TripMaster? trip, BuildContext context) {
    if (trip == null) {
      return const Center(child: Text("Error loading trip"));
    }

    Widget clickableTrip = GestureDetector(
      onTap: () {
        context.push('/trips/detail', extra: trip);
      },
      child: TripMasterView(trip),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 9.0),
      child: clickableTrip,
    );
  }

  static Future<TripMaster> retrieveGeneratedElement() {
    return TripGenerator.generateTripMaster();
  }

  static Future<TripMaster?> retrieveBackendElement() {
    print("retrieving trip");
    return TripRepository().retrieve();
  }
}