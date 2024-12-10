import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_multimedia.dart';

class RelationModel {
  final TripMaster associatedTrip;
  final List<TripMultimedia> media;

  RelationModel(this.associatedTrip, this.media);
}