import 'dart:convert';

import 'package:social_tripper_mobile/Models/Post/post_master_model.dart';
import 'package:social_tripper_mobile/Pages/config/data_retrieving_config.dart';
import 'package:http/http.dart' as http;
import 'package:social_tripper_mobile/Services/account_service.dart';
import 'package:social_tripper_mobile/Services/post_service.dart';

class PostRepository {
  static int index = 0;
  static List<PostMasterModel> posts = [];
  static final String baseUrl = DataRetrievingConfig.sourceUrl;

  static Future<List<PostMasterModel>> _loadAllPosts() async {
    String? currentUserUUID = await AccountService().getSavedAccountUUID();
    var client = http.Client();
    List<PostMasterModel> posts = [];

    try {
      var response = await client.get(Uri.parse('$baseUrl/posts'));
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');

        var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

        if (decodedResponse is List) {
          // Tworzymy listę futures
          List<Future<void>> futures = [];

          for (var post in decodedResponse) {
            PostMasterModel masterModel = PostMasterModel.fromJson(post);

            // Dodajemy operację asynchroniczną do listy
            futures.add(setLikeStatus(masterModel, currentUserUUID));

            // Dodajemy post do listy
            posts.add(masterModel);
          }

          // Czekamy, aż wszystkie operacje asynchroniczne się zakończą
          await Future.wait(futures);
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

    return posts;
  }

  static Future<void> setLikeStatus(PostMasterModel model, String? currentUserUUID) async {
    bool isLiked = await PostService().didUserReactToPost(currentUserUUID ?? "", model.uuid);
    model.isLiked = isLiked;
  }

  static Future<void> initialize() async {
    index = 0;
    posts = await _loadAllPosts();
    posts = posts.reversed.toList();
  }

  // Symulacja pobrania kolejnej porcji / kolejnej pozycji dopóki backend nie ma takiej funkcjonalności
  Future<PostMasterModel?> retrieve() {
    if (index < posts.length) {
      Future<PostMasterModel> item = Future.value(posts[index]);
      print(index);
      index ++;
      return item;
    } else {
      return Future.value(null);
    }
  }
}