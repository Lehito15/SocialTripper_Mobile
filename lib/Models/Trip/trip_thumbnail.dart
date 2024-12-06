
import 'package:social_tripper_mobile/Models/Shared/required_activity.dart';
import 'package:social_tripper_mobile/Models/Shared/required_language.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_status.dart';

class TripThumbnail {
  String uuid;
  String name;
  String description;
  int numberOfParticipants;
  String homePageUrl;
  TripStatus eventStatusDTO;
  String iconUrl;
  Set<RequiredActivity> eventActivitiesDTO;
  Set<RequiredLanguage> eventLanguagesDTO;

  TripThumbnail(
      this.uuid,
      this.name,
      this.description,
      this.numberOfParticipants,
      this.homePageUrl,
      this.eventStatusDTO,
      this.iconUrl,
      this.eventActivitiesDTO,
      this.eventLanguagesDTO);


  factory TripThumbnail.fromJson(Map<String, dynamic> json) {
    print(json);
    return TripThumbnail(
      json['uuid'] as String,
      json['name'] as String,
      json['description'] as String,
      json['numberOfParticipants'] as int,
      json['homePageUrl'] as String,
      TripStatus.fromJson(json['eventStatusDTO']),
      json['iconUrl'] as String,
      (json['eventActivitiesDTO'] as List<dynamic>)
          .map((e) => RequiredActivity.fromJson(e))
          .toSet(),
      (json['eventLanguagesDTO'] as List<dynamic>)
          .map((e) => RequiredLanguage.fromJson(e))
          .toSet(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'description': description,
      'numberOfParticipants': numberOfParticipants,
      'homePageUrl': homePageUrl,
      'eventStatusDTO': eventStatusDTO.toJson(),
      'iconUrl': iconUrl,
      'eventActivitiesDTO': eventActivitiesDTO.map((e) => e.toJson()).toList(),
      'eventLanguagesDTO': eventLanguagesDTO.map((e) => e.toJson()).toList(),
    };
  }


}