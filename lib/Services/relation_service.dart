import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_multimedia.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_status.dart';
import 'package:social_tripper_mobile/Models/Trip/user_journey.dart';
import 'package:social_tripper_mobile/Models/Trip/user_path_points.dart';
import 'package:social_tripper_mobile/Services/trip_service.dart';

import '../Models/Relation/relation.dart';
import '../Pages/config/data_retrieving_config.dart';

class RelationService {
  final String baseUrl = DataRetrievingConfig.sourceUrl;
  final TripService tripService = TripService();


  Future<RelationModel> getTripRelation(TripMaster trip) async {
    try {
      UserJourney? journey = await getUserJourneyInEvent(trip.uuid, trip.owner.uuid);
      return RelationModel(trip, journey?.tripMultimedia ?? [], journey?.pathPoints ?? []);
    } catch (e) {
      print('Error fetching multimedia: $e');
      throw Exception('Error fetching multimedia');
    }
  }

  //
  Stream<List<RelationModel>> getAllRelationsStream() async* {
    List<RelationModel> allRelations = [];
    List<TripMaster> trips = await tripService.loadAllTrips();

    for (var trip in trips) {
      if (trip.eventStatus.status == 'finished') {
        try {
          UserJourney? journey = await getUserJourneyInEvent(trip.uuid, trip.owner.uuid);

          RelationModel relation = RelationModel(trip, journey?.tripMultimedia ?? [], journey?.pathPoints ?? []);

          allRelations.add(relation);

          yield allRelations;
        } catch (e) {
          print('Error fetching multimedia for trip ${trip.name}: $e');
          // Opcjonalnie emituj pustą listę, jeśli wystąpił błąd
          yield [];
        }
      }
    }
  }

  // Future<List<RelationModel>> getAllRelations() async {
  //   List<RelationModel> relations = [];
  //   List<TripMaster> trips = await tripService.loadAllTrips();
  //
  //   for (var trip in trips) {
  //     if (trip.eventStatus.status == 'finished') {
  //       RelationModel relation = await getTripRelation(trip);
  //       relations.add(relation);
  //     }
  //   }
  //   return relations;
  // }


  Future<void> addUserPathPoints(UserPathPoints points) async {
    // Konwertujemy UserPathPoints na DTO
    List<PointDTO> pathPointsDTO = points.pathPoints
        .map((latLng) => PointDTO(latitude: latLng.latitude, longitude: latLng.longitude))
        .toList();

    UserPathPoints userPathPointsDTO = UserPathPoints(
      userUUID: points.userUUID,
      eventUUID: points.eventUUID,
      pathPoints: pathPointsDTO,
    );

    print(points);
    // Wysyłamy dane do API
    final url = Uri.parse('$baseUrl/events/path-points'); // Zmień na odpowiednią URL
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userPathPointsDTO.toJson()),
    );

    if (response.statusCode == 201) {
      // Sukces - Zasób został utworzony
      print('User path points added successfully');
    } else {
      // Błąd
      print('Failed to add user path points: ${response.statusCode}');
    }
  }

  Future<UserJourney?> getUserJourneyInEvent(String eventUUID, String userUUID) async {
    final String url = '$baseUrl/events/$eventUUID/users/$userUUID';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);

        // Konwertowanie 'pathPoints' na listę LatLng
        final List<LatLng> points = (decodedResponse['pathPoints'] as List<dynamic>)
            .map((point) => LatLng(point['latitude'], point['longitude']))
            .toList();

        // Konwertowanie 'multimedia' na listę TripMultimedia
        final List<dynamic> multimediaJsonList = decodedResponse['multimedia'];
        final List<TripMultimedia> multimediaList = multimediaJsonList
            .map((mediaJson) => TripMultimedia.fromJson(mediaJson))
            .toList();

        // Tworzenie obiektu UserJourney
        return UserJourney(points, multimediaList);
      } else {
        print("Request failed with status: ${response.statusCode}");
        return null; // Zwróć null, gdy status nie jest 200
      }
    } catch (error) {
      // Obsługa błędów np. związanych z siecią
      print("Error occurred during request: $error");
      return null; // Zwróć null w przypadku błędu
    }
  }


}

class PointDTO {
  final double latitude;
  final double longitude;

  PointDTO({required this.latitude, required this.longitude});

  // Deserializacja z JSON
  factory PointDTO.fromJson(Map<String, dynamic> json) {
    return PointDTO(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  // Zamiana na JSON
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  String toString() {
    return 'PointDTO{latitude: $latitude, longitude: $longitude}';
  }
}