import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
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


  Future<void> getCurrentAccount() async {
    try {
      // Pobierz atrybuty użytkownika (np. email)
      final userAttributes = await Amplify.Auth.fetchUserAttributes();
      final email = userAttributes[0].value; // Zakładamy, że email jest na pierwszej pozycji
      final url = "$baseUrl/email?email=$email";
      var client = http.Client();
      var response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Przetwórz odpowiedź JSON
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        Account account = Account.fromJson(decodedResponse);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('account_uuid', account.uuid);

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


}