import 'dart:convert';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_tripper_mobile/Models/Account/account.dart';
import 'package:social_tripper_mobile/Models/Account/account_thumbnail.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_thumbnail.dart';
import 'package:social_tripper_mobile/Models/User/current_user.dart';
import 'package:social_tripper_mobile/Services/trip_service.dart';

import '../Models/User/user.dart';
import '../Pages/config/data_retrieving_config.dart';


class AccountService {
  final baseUrl = "${DataRetrievingConfig.sourceUrl}/accounts";


  Future<AccountThumbnail> getMyAccount() async {
    try {
      final userAttributes = await Amplify.Auth.fetchUserAttributes();
      final email = userAttributes[0].value;
      final url = "$baseUrl/email?email=$email";
      var client = http.Client();
      var response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Przetwórz odpowiedź JSON
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        AccountThumbnail account = AccountThumbnail.fromJson(decodedResponse);
        return account;
      } else {
        throw Exception('Failed to load account: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching account: $e');
      throw Exception('Error fetching account: $e');
    }
  }


  Future<Account> getCurrentAccount() async {
    try {
      // Pobierz atrybuty użytkownika (np. email)
      final userAttributes = await Amplify.Auth.fetchUserAttributes();
      final email = userAttributes[0]
          .value; // Zakładamy, że email jest na pierwszej pozycji
      final url = "$baseUrl/email?email=$email";
      var client = http.Client();
      var response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Przetwórz odpowiedź JSON
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        Account account = Account.fromJson(decodedResponse);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('account_uuid', account.uuid);
        return account;
      } else {
        throw Exception('Failed to load account: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching account: $e');
      throw Exception('Error fetching account: $e');
    }
  }

  Future<String?> getSavedAccountUUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uuid = prefs.getString('account_uuid');
    return prefs.getString('account_uuid');
  }

  Future<AccountThumbnail> getAccountByUUID(String uuid) async {
    final url = Uri.parse('$baseUrl/$uuid');

    try {
      // Wysłanie żądania GET
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Obsługa odpowiedzi
      if (response.statusCode == 200) {
        // Parsowanie odpowiedzi na obiekt AccountThumbnail
        final jsonResponse = jsonDecode(response.body);
        return AccountThumbnail.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to fetch account: ${response.body}');
      }
    } catch (e) {
      print('Error during getAccountByUUID: $e');
      rethrow;
    }
  }


  Future<String?> getActiveTrip() async {
    String? uuid = await getSavedAccountUUID();
    TripService service = TripService();
    List<TripMaster> userTrips = await service.getUserEvents(uuid!);
    if (userTrips.isEmpty) {
      return null;
    }
    for (var trip in userTrips) {
      if (trip.eventStatus.status == "in progress") {
        return trip.uuid;
      }
    }
    return null;
  }


  Future<void> createAccount(Account accountDTO, File? profilePicture) async {
    final uri = Uri.parse('http://yourapiurl.com/accounts');

    var request = http.MultipartRequest('POST', uri);

    // Kodowanie obiektu Account do JSON i dodanie go do zapytania jako część formularza
    request.fields['accountDTO'] = jsonEncode(accountDTO
        .toJson()); // zakładając, że masz metodę toJson w klasie Account

    // Dodanie pliku zdjęcia profilowego, jeśli jest dostępny
    if (profilePicture != null) {
      String? mimeType = lookupMimeType(profilePicture.path);
      var imageStream = http.ByteStream(profilePicture.openRead());
      var imageLength = await profilePicture.length();

      var multipartFile = http.MultipartFile(
        'profilePicture',
        imageStream,
        imageLength,
        filename: profilePicture.uri.pathSegments.last,
        contentType: MediaType.parse(mimeType ?? 'application/octet-stream'),
      );

      request.files.add(multipartFile);
    }

    // Wysłanie zapytania
    try {
      var response = await request.send();

      if (response.statusCode == HttpStatus.created) {
        print('Account created successfully');
      } else {
        print('Failed to create account: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}