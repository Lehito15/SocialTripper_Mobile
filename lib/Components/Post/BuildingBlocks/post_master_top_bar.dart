import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Models/Account/account_thumbnail.dart';
import 'package:social_tripper_mobile/Models/Post/post_master_model.dart';
import 'package:social_tripper_mobile/Models/Shared/entity_option.dart';

import '../../../Models/Post/post_master_author.dart';
import '../../../Utilities/Converters/date_converter.dart';
import '../../Shared/bordered_user_picture.dart';
import '../../Shared/entity_options_default.dart';
import '../../Shared/posted_entity_author_info.dart';

class PostMasterTopBar extends StatelessWidget {
  final PostMasterModel model;

  PostMasterTopBar(this.model);

  @override
  Widget build(BuildContext context) {
    String convertedDt = DateConverter.convertDatetimeToString(model.dateOfPost);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BorderedUserPicture(radius: 34, pictureURI: model.account.profilePictureUrl),
        SizedBox(width: 8),
        PostedEntityAuthorTextInfo(
          topString: model.account.nickname,
          bottomString: convertedDt,
          redirect: () {},
        ),
        EntityOptionsDefault(options: [
    EntityOption("Report post", () async {
      print("Post ${model.uuid} by ${model.account.nickname} reported.");
    }),
        ]),
      ],
    );
  }
}
