import 'dart:core';

import 'package:social_tripper_mobile/Utilities/DataGenerators/generated_user.dart';

class PostMasterAuthor {
  String nickname;
  String pictureURI;

  PostMasterAuthor(this.nickname, this.pictureURI);

  factory PostMasterAuthor.fromGeneratedUser(
      GeneratedUser user) {
    return PostMasterAuthor(
      user.username, // Zakładamy, że GeneratedUser ma pole nickname
      user.picture,  // Zakładamy, że GeneratedUser ma pole picture
    );
  }
}