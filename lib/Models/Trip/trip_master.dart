
import 'package:social_tripper_mobile/Models/User/trip_owner_master.dart';

class TripMaster {
  String name;
  String destination;
  DateTime startDate;
  DateTime endDate;
  String description;
  String photoUri;
  int numberOfParticipants;
  int maxNumberOfParticipants;
  Set<String> activities;
  Set<String> languages;
  TripOwnerMasterModel tripOwner;

  TripMaster(
      this.name,
      this.destination,
      this.startDate,
      this.endDate,
      this.description,
      this.photoUri,
      this.numberOfParticipants,
      this.maxNumberOfParticipants,
      this.activities,
      this.languages,
      this.tripOwner);
}