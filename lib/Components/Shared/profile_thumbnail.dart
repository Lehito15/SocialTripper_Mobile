import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/Shared/posted_entity_author_info.dart';
import 'package:social_tripper_mobile/Models/Account/account_thumbnail.dart';
import 'package:social_tripper_mobile/Utilities/Converters/date_converter.dart';

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


Widget RelationProfileThumbnail(String nickname, String url, int peopleCount, DateTime startDate, DateTime endDate) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      BorderedUserPicture(radius: 34, pictureURI: url),
      SizedBox(width: 8),
      PostedEntityAuthorTextInfo(
        topString: "$nickname with $peopleCount more users",
        bottomString: "${DateConverter.convertDatetimeToString(startDate)} ➤ ${DateConverter.convertDatetimeToString(endDate)}",
      ),
      EntityOptionsDefault(),
    ],
  );
}