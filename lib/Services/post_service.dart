import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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


  Future<List<PostMasterModel>> getPostsForTrip(String tripUUID) async {
    final url = "$baseUrl/events/$tripUUID/posts";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => PostMasterModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<PostMasterModel>> loadAllPosts() async {
    String? currentUserUUID = await AccountService().getSavedAccountUUID();
    var client = http.Client();
    List<PostMasterModel> posts = [];

    try {
      var response = await client.get(Uri.parse('$baseUrl/posts'));
      if (response.statusCode == 200) {

        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

        if (decodedResponse is List) {

          for (var post in decodedResponse) {
            PostMasterModel masterModel = PostMasterModel.fromJson(post);
            await _setAdditionalInfo(masterModel, currentUserUUID);
            posts.add(masterModel);
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
    return posts.reversed.toList();
  }

  Stream<List<PostMasterModel>> loadAllPostsStream() async* {
    String? currentUserUUID = await AccountService().getSavedAccountUUID();
    var client = http.Client();
    List<PostMasterModel> posts = [];

    try {
      var response = await client.get(Uri.parse('$baseUrl/posts'));
      if (response.statusCode == 200) {
        print("got response");
        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

        if (decodedResponse is List) {
          for (var post in decodedResponse) {
            PostMasterModel masterModel = PostMasterModel.fromJson(post);
            await _setAdditionalInfo(masterModel, currentUserUUID);
            posts.add(masterModel); // Dodajemy do listy
            yield posts; // Emitujemy całą listę, ale tylko raz na iterację
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
  }

  Future<void> _setAdditionalInfo(PostMasterModel model, String? currentUserUUID) async {
    bool isLiked = await PostService().didUserReactToPost(currentUserUUID ?? "", model.uuid);
    model.isLiked = isLiked;
    model.isAuthor = currentUserUUID == model.account.uuid;
  }


  Future<PostMasterModel> createPersonalPost(PostMasterModel postDTO, List<File>? multimediaFiles) async {
    Dio dio = Dio();
    final apiUrl = "$baseUrl";
    try {
      // Tworzymy dane do wysłania w formacie multipart/form-data
      FormData formData = FormData.fromMap({
        'postDTO': jsonEncode(postDTO.toJson()), // Przesyłamy dane postDTO jako JSON
        if (multimediaFiles != null && multimediaFiles.isNotEmpty) ...{
          'multimedia': await Future.wait(multimediaFiles.map((file) async {
            return await MultipartFile.fromFile(file.path, filename: file.uri.pathSegments.last, contentType: MediaType("png", "jpeg"));
          })),
        }
      });

      // Wysyłamy POST request na endpoint "/posts"
      Response response = await dio.post('$apiUrl/posts', data: formData);

      // Sprawdzamy, czy odpowiedź była poprawna
      if (response.statusCode == HttpStatus.created) {
        // Zwracamy odpowiedź z serwera jako obiekt PostDTO
        return PostMasterModel.fromJson(response.data);
      } else {
        print('Request failed with status: ${response.statusCode}');
        throw Exception('Failed to create post');
      }
    } catch (e) {
      print('Error creating post: $e');
      throw Exception('Error creating post');
    }
  }

}