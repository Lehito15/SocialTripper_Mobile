
import 'dart:convert';

import 'package:social_tripper_mobile/Models/Comment/post_comment.dart';

import '../Pages/config/data_retrieving_config.dart';
import 'package:http/http.dart' as http;

class CommentService {
  final baseUrl = "${DataRetrievingConfig.sourceUrl}/comments";
  final secondaryUrl = "${DataRetrievingConfig.sourceUrl}/posts";


  Future<List<PostComment>> loadPostComments(String postUUID) async {
    final url = Uri.parse("$secondaryUrl/$postUUID/comments");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        return decodedResponse.map((commentJson) => PostComment.fromJson(commentJson)).toList();
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> likeComment(String commentUUID, String accountUUID) async {
    final url = Uri.parse('$baseUrl/$commentUUID/users/$accountUUID/react');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Obsługuje sukces, jeśli odpowiedź jest OK
        print('Successfully liked the comment.');
      } else {
        // Obsługuje błąd, jeśli status kodu jest inny niż 200
        print('Failed to like the comment: ${response.body}');
      }
    } catch (e) {
      print('Error liking the comment: $e');
    }
  }

  Future<void> unlikeComment(String commentUUID, String accountUUID) async {
    final url = Uri.parse('$baseUrl/$commentUUID/users/$accountUUID/react');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Obsługuje sukces, jeśli odpowiedź jest OK
        print('Successfully unliked the comment.');
      } else {
        // Obsługuje błąd, jeśli status kodu jest inny niż 200
        print('Failed to unlike the comment: ${response.body}');
      }
    } catch (e) {
      print('Error unliking the comment: $e');
    }
  }

  Future<bool> didUserLikeComment(String commentUUID, String accountUUID) async {
    final url = Uri.parse('$baseUrl/$commentUUID/users/$accountUUID/did-react');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parsujemy odpowiedź jako boolean
        return jsonDecode(response.body) as bool;
      } else {
        // Obsługa błędu
        throw Exception("Failed to check if user liked comment: ${response.statusCode}");
      }
    } catch (e) {
      // Obsługa wyjątku
      print("Error in didUserLikeComment: $e");
      rethrow;
    }
  }

  Future<PostComment> createPostComment(
      String postUUID, String userUUID, PostComment comment) async {
    final url = Uri.parse('$secondaryUrl/$postUUID/users/$userUUID/comment');

    try {
      // Konwersja obiektu `PostComment` na JSON
      final body = jsonEncode(comment.toJson());

      // Wysyłanie żądania POST
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      // Obsługa odpowiedzi
      if (response.statusCode == 201) {
        // Parsowanie odpowiedzi z serwera na obiekt PostComment
        final jsonResponse = jsonDecode(response.body);
        return PostComment.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to create comment: ${response.body}');
      }
    } catch (e) {
      print('Error during createPostComment: $e');
      rethrow;
    }
  }}