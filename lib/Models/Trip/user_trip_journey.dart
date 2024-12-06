
import 'dart:math';

import 'package:latlong2/latlong.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_multimedia.dart';

class UserTripJourney {
  List<LatLng> pathPoints;
  List<TripMultimedia> multimedia;

  UserTripJourney(this.pathPoints, this.multimedia);

  // From JSON
  factory UserTripJourney.fromJson(Map<String, dynamic> json) {
    // Deserializacja listy 'pathPoints'
    var pathPointsFromJson = (json['pathPoints'] as List)
        .map((pointJson) => LatLng.fromJson(pointJson)) // Zakładając, że Point ma metodę fromJson
        .toList();

    // Deserializacja listy 'multimedia'
    var multimediaFromJson = (json['multimedia'] as List)
        .map((mediaJson) => TripMultimedia.fromJson(mediaJson)) // Zakładając, że TripMultimedia ma metodę fromJson
        .toList();

    return UserTripJourney(pathPointsFromJson, multimediaFromJson);
  }
}