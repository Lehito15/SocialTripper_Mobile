import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_multimedia.dart';
import 'package:social_tripper_mobile/Services/trip_service.dart';

import '../Models/Relation/relation.dart';
import '../Pages/config/data_retrieving_config.dart';

class RelationService {
  final String baseUrl = DataRetrievingConfig.sourceUrl;
  final TripService tripService = TripService();


  Future<RelationModel> getTripRelation(TripMaster trip) async {
    final String url = '$baseUrl/events/${trip.uuid}/multimedia';

    try {
      // Wysyłamy zapytanie GET
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {;
        List<dynamic> data = json.decode(response.body);

        List<TripMultimedia> multimediaList = data
            .map((json) => TripMultimedia.fromJson(json))  // Mapowanie na obiekt TripMultimedia
            .toList();
        return RelationModel(trip, multimediaList);
      } else {
        print('Failed to load multimedia. Status code: ${response.statusCode}');
        throw Exception('Failed to load multimedia');
      }
    } catch (e) {
      print('Error fetching multimedia: $e');
      throw Exception('Error fetching multimedia');
    }
  }


  Stream<List<RelationModel>> getAllRelationsStream() async* {
    List<RelationModel> allRelations = [];
    print("start get all relations");
    List<TripMaster> trips = await tripService.loadAllTrips();
    print("got all trips");
    for (var trip in trips) {
      if (trip.eventStatus.status == 'finished') {
        try {
          RelationModel relation = await getTripRelation(trip);
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

  Future<List<RelationModel>> getAllRelations() async {
    List<RelationModel> relations = [];
    List<TripMaster> trips = await tripService.loadAllTrips();

    for (var trip in trips) {
      if (trip.eventStatus.status == 'finished') {
        RelationModel relation = await getTripRelation(trip);
        relations.add(relation);
      }
    }
    return relations;
  }

}