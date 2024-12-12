import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dio/dio.dart';
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
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
        Account account = Account.fromJson(decodedResponse);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('account_uuid', account!.uuid!);
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
        print("koment tutaj");
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


  Future<void> createAccount(Account account, String? profilePicture) async {
    final String url = '$baseUrl'; // URL do endpointa

    Dio dio = Dio();

    // Serializowanie obiektu Account do JSON
    String accountMetadata = jsonEncode(account.toJson()); // Zakładając, że masz metodę toJson w klasie Account

    print(account);
    print(profilePicture);

    // Tworzenie danych do wysłania w formacie multipart
    FormData formData = FormData.fromMap({
      'accountDTO': MultipartFile.fromBytes(
          Uint8List.fromList(accountMetadata.codeUnits),
          contentType: MediaType('application', 'json')
      ),
      'profilePicture': profilePicture != null
          ? await MultipartFile.fromFile(profilePicture, contentType: MediaType('image', 'jpeg'))
          : null
    });

    print("Sending account data to server...");

    try {
      // Wysyłanie żądania POST
      Response response = await dio.post(url, data: formData);

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  Future<void> updateAccount(String uuid, Account account) async {
    final url = Uri.parse('$baseUrl/$uuid'); // Zmień na rzeczywisty URL API

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(account.toJson()),
      );
      print("zobaczmy: ${jsonEncode(account.toJson())}");
      if (response.statusCode == 200) {
        print('Account updated successfully: ${response.body}');
      } else {
        print('Failed to update account. Status code: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to update account.');
      }
    } catch (e) {
      print('Error while updating account: $e');
      throw e;
    }
  }
}