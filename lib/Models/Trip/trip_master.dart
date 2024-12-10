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
  bool isMember = false;
  bool isOwner = false;
  bool isRequested = false;

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
      // Przypisywanie zmiennych i drukowanie
      final uuid = json['uuid'];
      final name = json['name'];
      final destination = json['destination'];
      final description = json['description'];
      final rules = json['rules'];
      final isPublic = json['isPublic'];
      final dateOfCreation = DateTime.parse(json['dateOfCreation']);
      final eventStartTime = DateTime.parse(json['eventStartTime']);
      final eventEndTime = DateTime.parse(json['eventEndTime']);
      final numberOfParticipants = json['numberOfParticipants'];
      final maxNumberOfParticipants = json['maxNumberOfParticipants'];
      final startLongitude = json['startLongitude'];
      final startLatitude = json['startLatitude'];
      final stopLongitude = json['stopLongitude'];
      final stopLatitude = json['stopLatitude'];
      final destinationLongitude = json['destinationLongitude'];
      final destinationLatitude = json['destinationLatitude'];
      final homePageUrl = json['homePageUrl'];

      final eventStatus = TripStatus.fromJson(json['eventStatus']);

      final owner = AccountThumbnail.fromJson(json['owner']);

      final iconUrl = json['iconUrl'];
      final activities = (json['activities'] as List).map((activityJson) {
        final activity = RequiredActivity.fromJson(activityJson);
        return activity;
      }).toSet();

      final languages = (json['languages'] as List).map((languageJson) {
        final language = RequiredLanguage.fromJson(languageJson);
        return language;
      }).toSet();

      // Konstruktor z przetestowanymi zmiennymi
      return TripMaster(
        uuid,
        name,
        destination,
        description,
        rules,
        isPublic,
        dateOfCreation,
        eventStartTime,
        eventEndTime,
        numberOfParticipants,
        maxNumberOfParticipants,
        startLongitude,
        startLatitude,
        stopLongitude,
        stopLatitude,
        destinationLongitude,
        destinationLatitude,
        homePageUrl,
        eventStatus,
        owner,
        iconUrl,
        activities,
        languages,
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

  @override
  String toString() {
    return 'TripMaster{uuid: $uuid, name: $name, description: $description, rules: $rules, iconUrl: $iconUrl}';
  }
}
