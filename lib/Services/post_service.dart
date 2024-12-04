import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:social_tripper_mobile/Models/Post/post_master_author.dart';
import 'package:social_tripper_mobile/Models/Post/post_master_model.dart';
import 'package:social_tripper_mobile/Services/account_service.dart';

import '../Pages/config/data_retrieving_config.dart';

class PostService {
  final String baseUrl = DataRetrievingConfig.sourceUrl;




  Future<bool> likePost(String userUUID, String postUUID) async {
    final url = "$baseUrl/posts/react";
    var client = http.Client();
    try {
      // Tworzenie danych JSON
      final Map<String, String> postData = {
        "userUUID": userUUID,
        "postUUID": postUUID,
      };

      // Wysyłanie żądania POST
      var response = await client.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(postData),
      );

      // Obsługa odpowiedzi
      if (response.statusCode == 200) {
        print("Reaction added successfully: ${response.body}");
        return true;
      } else {
        print("Failed to add reaction: ${response.statusCode}, ${response.body}");
        return false; // Operacja zakończona niepowodzeniem
      }
    } catch (e) {
      print("Error while reacting to post: $e");
      return false; // Obsługa błędów
    } finally {
      client.close();
    }
  }

  Future<bool> unlikePost(String userUUID, String postUUID) async {
    final url = "$baseUrl/posts/react";  // Zmienna url zawiera endpoint
    var client = http.Client();

    try {
      // Tworzenie danych JSON
      final Map<String, String> postData = {
        "userUUID": userUUID,
        "postUUID": postUUID,
      };

      // Wysyłanie zapytania DELETE
      var response = await client.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",  // Określenie formatu danych
        },
        body: jsonEncode(postData),  // Wysłanie danych w ciele żądania
      );

      // Sprawdzenie, czy odpowiedź to HTTP 204 (No Content)
      if (response.statusCode == HttpStatus.noContent) {
        print("Reaction removed successfully");
        return true;  // Reakcja została usunięta
      } else {
        print("Failed to remove reaction: ${response.statusCode}");
        return false;  // Błąd podczas usuwania reakcji
      }
    } catch (e) {
      print("Error while removing reaction: $e");
      return false;  // Błąd połączenia lub inne problemy
    } finally {
      client.close();  // Zamykanie klienta HTTP
    }
  }

  Future<bool> didUserReactToPost(String userUUID, String postUUID) async {
    final url = "$baseUrl/posts/$postUUID/user/$userUUID/did-react"; // Budowanie URL

    var client = http.Client();
    try {
      // Wysyłanie żądania GET do API
      var response = await client.get(Uri.parse(url));

      // Obsługa odpowiedzi
      if (response.statusCode == 200) {
        // Odpowiedź powinna być w postaci boolean (true/false)
        var decodedResponse = jsonDecode(response.body);
        return decodedResponse;  // Zwrócenie wyniku reakcji użytkownika
      } else {
        print("Failed to check reaction: ${response.statusCode}, ${response.body}");
        return false; // Jeśli coś poszło nie tak
      }
    } catch (e) {
      print("Error while checking reaction: $e");
      return false; // Obsługa błędów
    } finally {
      client.close();
    }
  }

}