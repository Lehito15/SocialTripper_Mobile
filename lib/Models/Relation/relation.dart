import 'package:latlong2/latlong.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_multimedia.dart';

class RelationModel {
  final TripMaster associatedTrip;
  final List<TripMultimedia> media;
  final List<LatLng> pathPoints;

  RelationModel(this.associatedTrip, this.media, this.pathPoints);
}