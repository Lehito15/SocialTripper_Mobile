import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';
import 'package:social_tripper_mobile/Models/User/trip_owner_master.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/Trip/skills_data_source.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/lorem_ipsum.dart';
import 'package:tuple/tuple.dart';




class TripGenerator {
  static List<String> testNames = [];
  static List<String> destinations = [];
  static List<DateTime> startDates = [];
  static List<DateTime> endDates = [];
  static List<String> descriptions = [];
  static List<int> maxNumOfParticipants = [];
  static List<String> activities = SkillsDataSource.activities;
  static List<String> languages = SkillsDataSource.languages;
  static List<String> ownerNames = [];


  static Future<String> fetchRandomImage() async {
    final randomUrl = 'https://random.danielpetrica.com/api/random?${DateTime.now().microsecondsSinceEpoch}';
    return randomUrl;
  }

  static Tuple2<int, int> generateRandomMembersInfo(int max) {
    final Random random = Random();
    int maxMembers = random.nextInt(max) + 1;
    int currentMembers = random.nextInt(maxMembers);
    return Tuple2(currentMembers, maxMembers);
  }

  static DateTime generateRandomDate() {
    final Random random = Random();

    int year = random.nextInt(10) + 2020;

    int month = random.nextInt(12) + 1;

    int day = random.nextInt(31) + 1;

    int hour = random.nextInt(24);

    int minute = random.nextInt(60);

    return DateTime(year, month, day, hour, minute);
  }

  static Future<String> _fetchLoremIpsum({int maxLength = 128}) async {
    try {
      final response = await http
          .get(Uri.parse('https://lipsum.com/feed/json'))
          .timeout(Duration(milliseconds: 500)); // Limit czasu na 0.5 sekundy

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String text = (data['feed']['lipsum'] ?? '').toString();

        // Losowa długość między 1 a maxLength
        int randomLength = Random().nextInt(maxLength) + 1;

        // Przytnij tekst do losowej długości
        if (text.length > randomLength) {
          text = text.substring(0, randomLength);
        }

        return text;
      } else {
        throw Exception('Failed to load Lorem Ipsum');
      }
    } catch (e) {
      print('Błąd w _fetchLoremIpsum: $e');
      String text = LoremIpsumGenerator.generate(maxLength: maxLength);
      int randomLength = Random().nextInt(maxLength) + 1;
      if (text.length > randomLength) {
        text = text.substring(0, randomLength);
      }
      return text;
    }
  }


  static _randomLanguages(int amount) {
    if (amount > 90) {
      amount = 90;
    } else if (amount < 0) {
      amount = 0;
    }
    Random random = Random();
    List<String> randomLanguages = [];
    while (randomLanguages.length < amount) {
      String language = languages[random.nextInt(languages.length)];
      if (!randomLanguages.contains(language)) {
        randomLanguages.add(language);
      }
    }
    return randomLanguages;
  }

  static _randomActivities(int amount) {
    if (amount > 7) {
      amount = 7;
    } else if (amount < 0) {
      amount = 1;
    }
    Random random = Random();
    List<String> randomActivities = [];
    while (randomActivities.length < amount) {
      String language = activities[random.nextInt(activities.length)];
      if (!randomActivities.contains(language)) {
        randomActivities.add(language);
      }
    }
    print(randomActivities);
    return randomActivities;
  }

  static Future<TripMaster> generateTripMaster() async {
    Random random = Random();
    int amountOfActivities = random.nextInt(7) + 1;
    int amountOfLanguages = random.nextInt(91);
    String title = await _fetchLoremIpsum();
    String destination = await _fetchLoremIpsum();
    String description = await _fetchLoremIpsum(maxLength: 500);
    DateTime start = generateRandomDate();
    DateTime end = generateRandomDate();
    String tripOwnerNickname = await _fetchLoremIpsum(maxLength: 20);
    print(tripOwnerNickname);
    Tuple2<int, int> members = generateRandomMembersInfo(1000);
    String tripPicture = await fetchRandomImage();
    return TripMaster(
        title,
        destination,
        start,
        end,
        description,
        tripPicture,
        members.item1,
        members.item2,
        Set.from(_randomActivities(amountOfActivities)),
        Set.from(_randomLanguages(amountOfLanguages)),
        TripOwnerMasterModel(tripOwnerNickname, "assets/MediaFiles/zbigniew.jpg")
    );
  }
}
