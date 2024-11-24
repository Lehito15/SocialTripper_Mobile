
import 'package:social_tripper_mobile/models/Activity/activity_thumbnail.dart';
import 'package:social_tripper_mobile/models/Language/language_thumbnail.dart';

class TripMaster {
  String name;
  String destination;
  DateTime startDate;
  DateTime endDate;
  String description;
  String photoUrl;
  int numberOfParticipants;
  int maxNumberOfParticipants;
  Set<ActivityThumbnail> activities;
  Set<LanguageThumbnail> languages;

  TripMaster(
      this.name,
      this.destination,
      this.startDate,
      this.endDate,
      this.description,
      this.photoUrl,
      this.numberOfParticipants,
      this.maxNumberOfParticipants,
      this.activities,
      this.languages);
}