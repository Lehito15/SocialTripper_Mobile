import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Repositories/trip_repository.dart';
import '../../Components/TripMaster/trip_master.dart';
import '../../Models/Trip/trip_master.dart';


class TripPageBuildConfig {
  static Future<void> cachingStrategy(TripMaster trip, BuildContext context) async {
    if (trip.iconUrl != null && trip.iconUrl!.isNotEmpty) {
      final imageProvider = CachedNetworkImageProvider(trip.iconUrl!);
      await precacheImage(imageProvider, context);
    }
  }

  static Widget buildItem(TripMaster? trip, BuildContext context) {
    if (trip == null) {
      return const Center(child: Text("Error loading trip"));
    }

    Widget clickableTrip = Container(
      child: TripMasterView(trip: trip),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: clickableTrip,
    );
  }

  static Future<TripMaster?> retrieveBackendElement() {
    print("retrieving trip");
    return TripRepository().retrieve();
  }
}