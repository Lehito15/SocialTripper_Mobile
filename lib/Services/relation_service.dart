import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_multimedia.dart';
import 'package:social_tripper_mobile/Services/trip_service.dart';

import '../Pages/config/data_retrieving_config.dart';

class RelationService {
  final String baseUrl = DataRetrievingConfig.sourceUrl;
  final TripService tripService = TripService();


  Future<List<TripMultimedia>> getTripRelation(String tripUUID) async {
    final String url = '$baseUrl/events/$tripUUID/multimedia';

    try {
      // Wysyłamy zapytanie GET
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {;
        List<dynamic> data = json.decode(response.body);

        List<TripMultimedia> multimediaList = data
            .map((json) => TripMultimedia.fromJson(json))  // Mapowanie na obiekt TripMultimedia
            .toList();
        return multimediaList;
      } else {
        print('Failed to load multimedia. Status code: ${response.statusCode}');
        throw Exception('Failed to load multimedia');
      }
    } catch (e) {
      print('Error fetching multimedia: $e');
      throw Exception('Error fetching multimedia');
    }
  }


  Stream<List<List<TripMultimedia>>> getAllRelationsStream() async* {
    List<List<TripMultimedia>> allRelations = [];
    print("start get all relations");
    List<TripMaster> trips = await tripService.loadAllTrips();
    print("got all trips");
    for (var trip in trips) {
      if (trip.eventStatus.status == 'finished') {
        try {
          List<TripMultimedia> relation = await getTripRelation(trip.uuid);
          allRelations.add(relation);

          yield allRelations;
        } catch (e) {
          print('Error fetching multimedia for trip ${trip.name}: $e');
          // Opcjonalnie emituj pustą listę, jeśli wystąpił błąd
          yield [];
        }
      }
    }
    print("end get all relations");
  }

  Future<List<List<TripMultimedia>>> getAllRelations() async {
    List<List<TripMultimedia>> relations = [];
    List<TripMaster> trips = await tripService.loadAllTrips();

    for (var trip in trips) {
      if (trip.eventStatus.status == 'finished') {
        List<TripMultimedia> multimedia = await getTripRelation(trip.uuid);
        relations.add(multimedia);
      }
    }
    return relations;
  }

}