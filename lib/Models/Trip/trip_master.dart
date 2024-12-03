import 'package:social_tripper_mobile/Models/User/trip_owner_master.dart';

class TripMaster {
  String uuid;
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
      this.uuid,
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



  factory TripMaster.fromJson(Map<String, dynamic> json) {
    // Debugowanie danych przed ich użyciem
    

    Set<String> parseActivities(List<dynamic> activities) {
      var x = <String>{};
      for (var activity in activities) {
        x.add(activity['activity']['name']);
      }
      return x;
    }

    Set<String> parseLanguages(List<dynamic> languages) {
      var x = <String>{};
      for (var language in languages) {
        x.add(language['language']['name']);
      }
      return x;
    }

    print('Parsing JSON: $json');

    String uuid = json['uuid'] ?? 'default_uuid';  // Zakładając, że uuid jest wymagane

    String name = json['name'] ?? 'default_name';  // Zakładając, że name jest wymagane

    String destination = json['destination'] ?? 'default_destination';  // Jeśli jest null, podstaw wartość domyślną

    DateTime eventStartTime = DateTime.parse(json['eventStartTime']);

    DateTime eventEndTime = DateTime.parse(json['eventEndTime']);

    String description = json['description'] ?? 'default_description';

    String iconUrl = json['iconUrl'] ?? 'assets/icons/main_logo.svg';


    int numberOfParticipants = json['numberOfParticipants'] ?? 0;

    int maxNumberOfParticipants = json['maxNumberOfParticipants'] ?? 0;

    Set<String> activities = parseActivities(json['activities']);

    Set<String> languages = parseLanguages(json['languages']);

    // Debugowanie "owner"
    var ownerJson = json["owner"];
    if (ownerJson == null) {
      print('Warning: owner is null');
    } else {
      print('owner: $ownerJson');
    }

    // Tworzymy obiekt TripOwnerMasterModel, tylko jeśli json["owner"] nie jest null
    TripOwnerMasterModel owner = TripOwnerMasterModel.fromJson(ownerJson);
    print('owner model: $owner');

    // Zwrot utworzonego obiektu
    return TripMaster(
        uuid,
        name,
        destination,
        eventStartTime,
        eventEndTime,
        description,
        iconUrl,
        numberOfParticipants,
        maxNumberOfParticipants,
        activities,
        languages,
        owner
    );
  }
}
