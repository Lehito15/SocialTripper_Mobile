
import 'dart:math';

import 'package:social_tripper_mobile/Models/Activity/trip_detail_activity.dart';
import 'package:social_tripper_mobile/Models/Language/trip_detail_language.dart';
import 'package:social_tripper_mobile/Models/Shared/required_activity.dart';
import 'package:social_tripper_mobile/Models/Shared/required_language.dart';

class RequirementsGenerator {

  static double _generateRandomValue() {
    Random random = Random();
    // Generowanie losowej liczby w przedziale 0.0 do 100
    int randomValue = random.nextInt(101);
    // Podzielenie przez 10, aby uzyskać wartość w przedziale 0.0 do 10.0 z krokiem 0.1
    return randomValue / 10.0;
  }

  static Set<TripDetailActivity> generateAcitivityRequirements(
      Set<RequiredActivity> activities) {
    Set<TripDetailActivity> result = Set();
    for (var activity in activities) {
      final value = _generateRandomValue();
      result.add(TripDetailActivity(activity.activity.name, value));
    }

    return result;
  }


  static Set<TripDetailLanguage> generateLanguageRequirements(
      Set<RequiredLanguage> languages) {
    Set<TripDetailLanguage> result = Set();
    for (var language in languages) {
      final value = _generateRandomValue();
      result.add(TripDetailLanguage(language.language.name, value));
    }
    return result;
  }
}