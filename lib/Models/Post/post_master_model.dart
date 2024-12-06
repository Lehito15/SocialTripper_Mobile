import 'package:social_tripper_mobile/Models/Account/account_thumbnail.dart';
import 'package:social_tripper_mobile/Models/Post/post_master_author.dart';

class PostMasterModel {
  final String uuid;
  String content;
  final DateTime dateOfPost;
  final bool isExpired;
  final bool isLocked;
  int commentsNumber;
  int reactionsNumber;
  final AccountThumbnail account;
  final Set<String> postMultimediaUrls;
  bool isLiked = false;

  // Konstruktor klasy
  PostMasterModel({
    required this.uuid,
    required this.content,
    required this.dateOfPost,
    required this.isExpired,
    required this.isLocked,
    required this.commentsNumber,
    required this.reactionsNumber,
    required this.account,
    required this.postMultimediaUrls,
  });

  // Możesz dodać metodę z konwersją z Map (np. z JSON), jeśli otrzymujesz dane z API
  factory PostMasterModel.fromJson(Map<String, dynamic> json) {
    return PostMasterModel(
      uuid: json['uuid'],
      content: json['content'],
      dateOfPost: DateTime.parse(json['dateOfPost']),
      isExpired: json['isExpired'],
      isLocked: json['isLocked'],
      commentsNumber: json['commentsNumber'],
      reactionsNumber: json['reactionsNumber'],
      account: AccountThumbnail.fromJson(json['account']), // Zakładając, że masz metodę z klasy AccountThumbnailDTO
      postMultimediaUrls: Set<String>.from(json['postMultimediaUrls']),
    );
  }

  // Możesz dodać metodę do konwersji do Map, np. do wysyłania JSON
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'content': content,
      'dateOfPost': dateOfPost.toIso8601String(),
      'isExpired': isExpired,
      'isLocked': isLocked,
      'commentsNumber': commentsNumber,
      'reactionsNumber': reactionsNumber,
      'account': account.toJson(), // Zakładając, że masz metodę toJson w klasie PostMasterAuthor
      'postMultimediaUrls': postMultimediaUrls.toList(),
    };
  }

  @override
  String toString() {
    return 'PostMasterModel{reactionsNumber: $reactionsNumber}';
  }
}
