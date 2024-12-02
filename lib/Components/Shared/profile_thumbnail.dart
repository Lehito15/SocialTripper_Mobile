import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/Shared/posted_entity_author_info.dart';

import 'bordered_user_picture.dart';
import 'entity_options_default.dart';

Widget ProfileThumbnail(String url, String nickname) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      BorderedUserPicture(radius: 34, pictureURI: url),
      SizedBox(width: 8),
      PostedEntityAuthorTextInfo(
        topString: nickname,
        bottomString: "Pro tripper",
      ),
      EntityOptionsDefault(),
    ],
  );
}