import 'dart:core';

import 'package:social_tripper_mobile/Models/Account/account_thumbnail.dart';
import 'package:social_tripper_mobile/Models/Comment/post_comment_author.dart';
import 'package:social_tripper_mobile/Models/Post/post_master_model.dart';

class PostComment {
  String uuid;
  String content;
  DateTime timestamp;
  int reactionsNumber;
  PostMasterModel commentedPost;
  AccountThumbnail author;
  bool isLiked;

  PostComment(
    this.uuid,
    this.content,
    this.timestamp,
    this.reactionsNumber,
    this.commentedPost,
    this.author,
  {this.isLiked = false}
  );

  factory PostComment.fromJson(Map<String, dynamic> json) {
    try {
      // Logowanie całego JSON-a

      // Sprawdzanie, czy wymagane pola istnieją
      if (json.containsKey('uuid') && json['uuid'] != null) {
        print('UUID: ${json['uuid']}');
      } else {
        throw Exception("UUID field is missing or null.");
      }

      if (json.containsKey('content') && json['content'] != null) {
        print('Content: ${json['content']}');
      } else {
        throw Exception("Content field is missing or null.");
      }

      if (json.containsKey('timestamp') && json['timestamp'] != null) {
        print('Timestamp: ${json['timestamp']}');
      } else {
        throw Exception("Timestamp field is missing or null.");
      }

      if (json.containsKey('reactionsNumber') && json['reactionsNumber'] != null) {
        print('Reactions Number: ${json['reactionsNumber']}');
      } else {
        throw Exception("ReactionsNumber field is missing or null.");
      }

      if (json.containsKey('account') && json['account'] != null) {
        print('Account: ${json['account']}');
      } else {
        throw Exception("Account field is missing or null.");
      }

      // Parsowanie danych z JSON
      return PostComment(
        json['uuid'],
        json['content'],
        DateTime.parse(json['timestamp']),
        json['reactionsNumber'],
        PostMasterModel.fromJson(json['commentedPost']),
        AccountThumbnail.fromJson(json['account']),
      );
    } catch (e) {
      print('Error while parsing PostComment: $e');
      rethrow; // Opcjonalnie można dodać obsługę błędów, jeśli nie chcesz przerywać działania
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'reactionsNumber': reactionsNumber,
      'commentedPost': commentedPost.toJson(),
      'account': author.toJson(),
      'isLiked': isLiked,
    };
  }

  @override
  String toString() {
    return 'PostComment{uuid: $uuid, content: $content, timestamp: $timestamp, reactionsNumber: $reactionsNumber, commentedPost: $commentedPost, author: $author, isLiked: $isLiked}';
  }
}
