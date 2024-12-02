import 'package:flutter/material.dart';

import '../../../Models/Post/post_master_author.dart';
import '../../../Utilities/Converters/date_converter.dart';
import '../../Shared/bordered_user_picture.dart';
import '../../Shared/entity_options_default.dart';
import '../../Shared/posted_entity_author_info.dart';

class TripMasterTopBar extends StatelessWidget {
  final PostMasterAuthor author;
  final DateTime postedDate;


  TripMasterTopBar(this.author, this.postedDate);

  @override
  Widget build(BuildContext context) {
    String convertedDt =
    DateConverter.convertDatetimeToString(postedDate);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BorderedUserPicture(radius: 34, pictureURI: author.profilePictureUrl),
        SizedBox(width: 8),
        PostedEntityAuthorTextInfo(
          topString: author.nickname,
          bottomString: convertedDt,
        ),
        EntityOptionsDefault(),
      ],
    );
  }
}