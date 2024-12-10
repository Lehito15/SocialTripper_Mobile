
import 'package:latlong2/latlong.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_multimedia.dart';

class UserJourney {
  List<LatLng> pathPoints;
  List<TripMultimedia> tripMultimedia;

  UserJourney(this.pathPoints, this.tripMultimedia);
}