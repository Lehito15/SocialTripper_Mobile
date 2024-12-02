import 'package:social_tripper_mobile/Models/Post/post_master_author.dart';

class PostMasterModel {
  String uuid;
  String content;
  DateTime postedDate;
  PostMasterAuthor author;
  List<String>? postMultimediaUrls;
  int numLikes;
  int commentsNumber;
  bool isLiked;
  bool isExpired;
  bool isLocked;

  PostMasterModel(
    this.author,
    this.postedDate,
    this.content,
    this.postMultimediaUrls,
    this.numLikes,
    this.commentsNumber, {
    this.uuid = "",
    this.isLiked = false,
    this.isExpired = false,
    this.isLocked = false,
  });
  // Fabryczna metoda do tworzenia obiektu z JSON
  factory PostMasterModel.fromJson(Map<String, dynamic> json) {
    return PostMasterModel(
      PostMasterAuthor.fromJson(json['account']),
      DateTime.parse(json['dateOfPost']),
      json['content'] ?? '',
      json['postMultimediaUrls'] != null
          ? List<String>.from(json['postMultimediaUrls'])
          : null,
      json['reactionsNumber'] ?? 0,
      json['commentsNumber'] ?? 0,
      uuid: json['uuid'] ?? '',
      isLiked: false,
      isExpired: json['isExpired'] ?? false,
      isLocked: json['isLocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'content': content,
      'postedDate': postedDate.toIso8601String(),
      'author': author.toJson(),  // Przekształcamy autora na JSON
      'postMultimediaUrls': postMultimediaUrls,
      'numLikes': numLikes,
      'commentsNumber': commentsNumber,
      'isLiked': isLiked,
      'isExpired': isExpired,
      'isLocked': isLocked,
    };
  }
}
