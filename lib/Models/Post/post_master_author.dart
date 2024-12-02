import 'dart:core';

import 'package:social_tripper_mobile/Utilities/DataGenerators/generated_user.dart';

class PostMasterAuthor {
  String nickname;
  String profilePictureUrl;
  String homePageUrl;


  PostMasterAuthor(this.nickname, this.profilePictureUrl, this.homePageUrl);

  factory PostMasterAuthor.fromGeneratedUser(
      GeneratedUser user) {
    return PostMasterAuthor(
      user.username,
      user.picture,
      ""
    );
  }

  factory PostMasterAuthor.fromJson(Map<String, dynamic> json) {
    return PostMasterAuthor(
      json['nickname'] ?? '',
      json['profilePictureUrl'] ?? '',
      json['homePageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'profilePictureUrl': profilePictureUrl,
      'homePageUrl': homePageUrl,
    };
  }
}