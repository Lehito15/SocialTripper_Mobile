import 'dart:ffi';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'dart:convert';
import 'dart:io';

import 'package:social_tripper_mobile/Models/Account/account_thumbnail.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_multimedia.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_status.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_thumbnail.dart';
import 'package:social_tripper_mobile/Models/Trip/user_trip_request.dart';
import 'package:http_parser/http_parser.dart';
import '../Pages/config/data_retrieving_config.dart';

class TripService {
  final String baseUrl = DataRetrievingConfig.sourceUrl;


  Future<List<AccountThumbnail>> getEventMembers(String eventUUID) async {
    final url = Uri.parse('$baseUrl/events/$eventUUID/members');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        return decodedResponse
            .map((accountJson) => AccountThumbnail.fromJson(accountJson))
            .toList();
      } else {
        throw Exception('Failed to load members');
      }
    } catch (e) {
      print('Error fetching event members: $e');
      throw Exception('Error: $e');
    }
  }


  Stream<List<TripMaster>> loadAllTripsStream() async* {
    var client = http.Client();
    List<TripMaster> trips = [];

    try {
      var response = await client.get(Uri.parse('$baseUrl/events'));
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        if (decodedResponse is List) {
          for (var trip in decodedResponse) {
            TripMaster masterModel = TripMaster.fromJson(trip);
            trips.add(masterModel);  // Dodajemy trip do listy
            print("jilding");
            yield List.from(trips);
          }
        } else {
          print('Odpowiedź nie jest listą!');
        }
      } else {
        print('Failed to load trips: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      client.close();
    }
  }

  Future<List<TripMaster>> loadAllTrips() async {
    var client = http.Client();
    List<TripMaster> trips = [];

    try {
      var response = await client.get(Uri.parse('$baseUrl/events'));
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        print(decodedResponse);

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

  Future<bool> isTripMember(String tripUUID, String userUUID) async {
    final url = Uri.parse("$baseUrl/events/$tripUUID/users/$userUUID/is-member");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Jeśli odpowiedź jest OK, zwróć wartość z odpowiedzi (true/false)
        return json.decode(response.body);
      } else {
        // W przypadku błędu, rzucamy wyjątek
        throw Exception('Failed to check if user is member');
      }
    } catch (e) {
      // Obsługa błędów
      print('Error: $e');
      return false;  // W przypadku błędu, zakładamy, że użytkownik nie jest członkiem
    }
  }
  Future<bool> isTripRequested(String tripUUID, String userUUID) async {
    final url = Uri.parse("$baseUrl/events/$tripUUID/users/$userUUID/is-event-requested");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Jeśli odpowiedź jest OK, zwróć wartość z odpowiedzi (true/false)
        return json.decode(response.body);
      } else {
        // W przypadku błędu, rzucamy wyjątek
        throw Exception('Failed to check if event request was sent');
      }
    } catch (e) {
      // Obsługa błędów
      print('Error: $e');
      return false;  // W przypadku błędu, zakładamy, że użytkownik nie wysłał prośby
    }
  }

  Future<UserTripRequest> userApplyForTrip(UserTripRequest request) async {
    final url = Uri.parse("$baseUrl/events/request");

    try {
      // Konwersja obiektu request na JSON
      final body = json.encode(request.toJson());

      // Wysłanie żądania POST
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Sprawdzanie kodu statusu
      if (response.statusCode == 201) {
        // Parsowanie odpowiedzi JSON do obiektu UserTripRequest
        return UserTripRequest.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to apply for the trip. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Obsługa błędów
      print('Error: $e');
      rethrow; // Rzucenie wyjątku dalej
    }
  }

  Future<UserTripRequest> userLeaveEvent(UserTripRequest request) async {
    final url = Uri.parse("$baseUrl/events/remove-member");

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return UserTripRequest.fromJson(decodedResponse);
      } else {
        throw Exception(
            'Failed to remove user from event. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error while removing user from event: $e');
    }
  }

  Future<UserTripRequest> addUserToTrip(UserTripRequest request) async {
    final url = Uri.parse("$baseUrl/events/add-member");
    try {
      // Tworzenie ciała żądania w formacie JSON
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      // Sprawdzanie statusu odpowiedzi
      if (response.statusCode == 200) {
        // Parsowanie odpowiedzi z serwera
        final data = jsonDecode(response.body);
        return UserTripRequest.fromJson(data);
      } else {
        // Obsługa błędów
        throw Exception('Failed to add user to trip: ${response.statusCode}');
      }
    } catch (e) {
      // Obsługa wyjątków
      throw Exception('An error occurred while adding user to trip: $e');
    }
  }


  Future<List<TripMaster>> getUserEvents(String userUUID) async {
    final url = Uri.parse("$baseUrl/users/$userUUID/events");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);

        return jsonResponse.map<TripMaster>((event) => TripMaster.fromJson(event)).toList();
      } else {
        throw Exception(
            "Failed to fetch user events. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching user events: $e");
    }
  }

  Future<void> setTripStatus(String tripUUID, TripStatus status) async {
    final String url = '$baseUrl/events/$tripUUID/set-status';  // URL endpointu

    // Tworzymy mapę z danymi do wysłania
    final Map<String, dynamic> requestBody = status.toJson();

    try {
      // Wykonaj zapytanie PATCH
      final response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      // Sprawdź odpowiedź serwera
      if (response.statusCode == 200) {
        print('Status updated successfully');
        // Możesz dodać tutaj logikę przetwarzania odpowiedzi, np. deserializację
      } else {
        print('Failed to update status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<TripMaster> getEventByUUID(String tripUUID) async {
    final String url = '$baseUrl/events/$tripUUID';

    try {
      // Wykonaj zapytanie HTTP
      final response = await http.get(Uri.parse(url));

      // Sprawdź, czy odpowiedź jest poprawna (status 200)
      if (response.statusCode == 200) {
        // Jeśli odpowiedź jest poprawna, sparsuj dane i zwróć TripMaster
        final Map<String, dynamic> data = json.decode(response.body);
        return TripMaster.fromJson(data);
      } else {
        // Jeśli odpowiedź nie jest poprawna, wyrzuć wyjątek
        throw Exception('Failed to load event, status code: ${response.statusCode}');
      }
    } catch (e) {
      // Obsłuż wyjątek, np. wyświetl błąd użytkownikowi
      print('Error fetching event: $e');
      throw Exception('Failed to fetch event: $e');
    }
  }

  Future<List<AccountThumbnail>> getTripRequests(String tripUUID) async {
    final String url = '$baseUrl/events/$tripUUID/requests';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Jeśli zapytanie się powiedzie, mapujemy odpowiedź na listę obiektów AccountThumbnail
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => AccountThumbnail.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load trip requests');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }

  }


  Future<Uint8List?> compressImage(File file) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 1000,  // minimalna szerokość
      minHeight: 1000, // minimalna wysokość
      quality: 85,    // jakość obrazu (0 - najniższa jakość, 100 - najwyższa)
      rotate: 0,      // kąt obrotu, jeśli chcesz obrócić obraz
    );
    return result;
  }

  Future<void> uploadEventMultimedia(String mediaPath, String metadataJson) async {
    final String url = '$baseUrl/events/multimedia';  // Wstaw swój URL

    Dio dio = Dio();

    try {
      // Tworzymy plik
      File file = File(mediaPath);

      if (await file.exists()) {
        // Kompresja obrazu
        Uint8List? compressedImage = await compressImage(file);
        if (compressedImage == null) {
          print('Failed to compress the image');
          return;
        }

        // Zapis skompresowanego obrazu do nowego pliku
        String compressedFilePath = '${file.path}_compressed.jpg';
        File compressedFile = File(compressedFilePath);
        await compressedFile.writeAsBytes(compressedImage);

        // Ustalamy metadata jako JSON
        var metadataBlob = Uint8List.fromList(utf8.encode(metadataJson));

        // Tworzymy MultipartFile dla multimediów
        FormData formData = FormData.fromMap({
          'multimedia': await MultipartFile.fromFile(compressedFile.path, contentType: MediaType('image', 'jpeg')), // MIME typ dla obrazu
          'eventMultimediaMetadataDTO': await MultipartFile.fromBytes(metadataBlob, contentType: MediaType('application', 'json')), // MIME typ dla JSON
        });

        // Wysyłanie żądania POST
        await dio.post(url, data: formData);

        // Usuwanie tymczasowego pliku skompresowanego
        await compressedFile.delete();
      } else {
        print('File does not exist');
      }
    } catch (e) {
      print('Error uploading multimedia: $e');
    }
  }
}