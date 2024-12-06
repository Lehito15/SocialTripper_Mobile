
import 'dart:core';

class PostCommentAuthor {
  String uuid;
  String nickname;
  String profilePictureUrl;

  PostCommentAuthor(this.uuid, this.nickname, this.profilePictureUrl);


  factory PostCommentAuthor.fromJson(Map<String, dynamic> json) {
    return PostCommentAuthor(json['uuid'], json['nickname'], json['profilePictureUrl']);
  }
}