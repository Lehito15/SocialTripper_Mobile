import 'package:social_tripper_mobile/Models/Account/account_thumbnail.dart';
import 'package:social_tripper_mobile/Models/Shared/required_activity.dart';
import 'package:social_tripper_mobile/Models/Shared/required_language.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_status.dart';
import 'package:social_tripper_mobile/Models/User/trip_owner_master.dart';

class TripMaster {
  String uuid;
  String name;
  String destination;
  String description;
  String rules;
  bool isPublic;
  DateTime dateOfCreation;
  DateTime eventStartTime;
  DateTime eventEndTime;
  int numberOfParticipants;
  int actualNumberOfParticipants;
  int maxNumberOfParticipants;
  double startLongitude;
  double startLatitude;
  double stopLongitude;
  double stopLatitude;
  double? destinationLongitude;
  double? destinationLatitude;
  String homePageUrl;
  TripStatus eventStatus;
  AccountThumbnail owner;
  String? iconUrl;
  Set<RequiredActivity> activities;
  Set<RequiredLanguage> languages;

  TripMaster(this.uuid,
      this.name,
      this.destination,
      this.description,
      this.rules,
      this.isPublic,
      this.dateOfCreation,
      this.eventStartTime,
      this.eventEndTime,
      this.numberOfParticipants,
      this.actualNumberOfParticipants,
      this.maxNumberOfParticipants,
      this.startLongitude,
      this.startLatitude,
      this.stopLongitude,
      this.stopLatitude,
      this.destinationLongitude,
      this.destinationLatitude,
      this.homePageUrl,
      this.eventStatus,
      this.owner,
      this.iconUrl,
      this.activities,
      this.languages,);

  factory TripMaster.fromJson(Map<String, dynamic> json) {
    try {
      print("Parsing TripMaster from JSON: $json");

      // Debugowanie wszystkich pól w JSON
      print('UUID: ${json['uuid']}');
      print('Name: ${json['name']}');
      print('Destination: ${json['destination']}');
      print('Description: ${json['description']}');
      print('Rules: ${json['rules']}');
      print('isPublic: ${json['isPublic']}');
      print('Date of Creation: ${json['dateOfCreation']}');
      print('Event Start Time: ${json['eventStartTime']}');
      print('Event End Time: ${json['eventEndTime']}');
      print('Number of Participants: ${json['numberOfParticipants']}');
      print('Actual Number of Participants: ${json['actualNumberOfParticipants']}');
      print('Max Number of Participants: ${json['maxNumberOfParticipants']}');
      print('Start Longitude: ${json['startLongitude']}');
      print('Start Latitude: ${json['startLatitude']}');
      print('Stop Longitude: ${json['stopLongitude']}');
      print('Stop Latitude: ${json['stopLatitude']}');
      print('Destination Longitude: ${json['destinationLongitude']}');
      print('Destination Latitude: ${json['destinationLatitude']}');
      print('HomePageUrl: ${json['homePageUrl']}');
      print('Event Status: ${json['eventStatus']}');
      print('Owner: ${json['owner']}');
      print('Icon Url: ${json['iconUrl']}');
      print('Activities: ${json['activities']}');
      print('Languages: ${json['languages']}');

      return TripMaster(
        json['uuid'],
        json['name'],
        json['destination'],
        json['description'],  // Dodano dla zgodności z backendem
        json['rules'],
        json['isPublic'],
        DateTime.parse(json['dateOfCreation']),
        DateTime.parse(json['eventStartTime']),
        DateTime.parse(json['eventEndTime']),
        json['numberOfParticipants'],
        json['actualNumberOfParticipants'],
        json['maxNumberOfParticipants'],
        json['startLongitude'],
        json['startLatitude'],
        json['stopLongitude'],
        json['stopLatitude'],
        json['destinationLongitude'],
        json['destinationLatitude'],
        json['homePageUrl'],
        TripStatus.fromJson(json['eventStatus']),
        AccountThumbnail.fromJson(json['owner']),
        json['iconUrl'],
        // Parsowanie activities
        (json['activities'] as List).map((activityJson) {
          print('Parsing activity: $activityJson');
          return RequiredActivity.fromJson(activityJson);
        }).toSet(),
        // Parsowanie languages
        (json['languages'] as List).map((languageJson) {
          print('Parsing language: $languageJson');
          return RequiredLanguage.fromJson(languageJson);
        }).toSet(),
      );
    } catch (e) {
      print('Error during parsing: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'destination': destination,
      'rules': rules,
      'isPublic': isPublic,
      'dateOfCreation': dateOfCreation.toIso8601String(),
      'eventStartTime': eventStartTime.toIso8601String(),
      'eventEndTime': eventEndTime.toIso8601String(),
      'numberOfParticipants': numberOfParticipants,
      'actualNumberOfParticipants': actualNumberOfParticipants,
      'maxNumberOfParticipants': maxNumberOfParticipants,
      'startLongitude': startLongitude,
      'startLatitude': startLatitude,
      'stopLongitude': stopLongitude,
      'stopLatitude': stopLatitude,
      'destinationLongitude': destinationLongitude,
      'destinationLatitude': destinationLatitude,
      'homePageUrl': homePageUrl,
      'eventStatus': eventStatus.toJson(), // Zakładając, że EventStatus ma metodę toJson()
      'owner': owner.toJson(), // Zakładając, że AccountThumbnail ma metodę toJson()
      'iconUrl': iconUrl,
      // Konwersja activities i languages na listy z zestawów (Set)
      'activities': activities.map((activity) => activity.toJson()).toList(),
      'languages': languages.map((language) => language.toJson()).toList(),
    };
  }
}
