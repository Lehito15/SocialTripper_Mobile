import 'package:latlong2/latlong.dart';
import 'package:social_tripper_mobile/Models/Activity/trip_detail_activity.dart';
import 'package:social_tripper_mobile/Models/Language/trip_detail_language.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/Trip/requirements_generator.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/location_generator.dart';

class TripDetail {
  TripMaster tripMaster;
  String rules;
  bool isPublic;
  DateTime dateOfCreation;
  double startLongitude;
  double startLatitude;
  double stopLongitude;
  double stopLatitude;
  String status;
  List<TripDetailActivity> activities;
  List<TripDetailLanguage> languages;

  TripDetail(
      this.tripMaster,
      this.rules,
      this.isPublic,
      this.dateOfCreation,
      this.startLongitude,
      this.startLatitude,
      this.stopLongitude,
      this.stopLatitude,
      this.status,
      this.activities,
      this.languages);

  factory TripDetail.fromTripMaster(TripMaster tripMaster) {
    LatLng locStart = LocationGenerator.generateRandomLocation();
    LatLng locEnd = LocationGenerator.generateRandomLocation();
    List<TripDetailActivity> ac_reqs =
        RequirementsGenerator.generateAcitivityRequirements(
            tripMaster.activities);
    List<TripDetailLanguage> lang_reqs =
    RequirementsGenerator.generateLanguageRequirements(
        tripMaster.languages);
    return TripDetail(
      tripMaster,
      "rules",
      true,
      DateTime(2020, 1, 1, 1, 1),
      locStart.longitude,
      locStart.latitude,
      locEnd.longitude,
      locEnd.latitude,
      "Planned",
      ac_reqs,
      lang_reqs,
    );
  }
}
