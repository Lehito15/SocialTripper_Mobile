
import 'dart:convert';

import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';
import '../Pages/config/data_retrieving_config.dart';
import 'package:http/http.dart' as http;

class TripRepository {
  static int index = 0;
  static List<TripMaster> trips = [];
  static final String baseUrl = DataRetrievingConfig.sourceUrl;

  static Future<List<TripMaster>> _loadAllTrips() async {
    var client = http.Client();
    List<TripMaster> trips = [];

    try {
      var response = await client.get(Uri.parse('$baseUrl/events'));
      if (response.statusCode == 200) {

        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

        if (decodedResponse is List) {
          for (var trip in decodedResponse) {
            TripMaster masterModel = TripMaster.fromJson(trip);
            trips.add(masterModel);
          }
        } else {
          print('Odpowiedź nie jest listą!');
        }
      } else {
        print('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      client.close();
    }
    return trips;
  }

  static Future<void> initialize() async {
    index = 0;
    trips = await _loadAllTrips();
    trips = trips.reversed.toList();
  }

  Future<TripMaster?> retrieve() {
    if (index < trips.length) {
      Future<TripMaster> item = Future.value(trips[index]);
      index ++;
      return item;
    } else {
      return Future.value(null);
    }
  }

}