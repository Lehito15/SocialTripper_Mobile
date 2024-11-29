import 'package:flutter/material.dart';

import '../../../Utilities/DataGenerators/generated_user.dart';
import '../../Shared/bordered_user_picture.dart';
import '../../Shared/send_component.dart';


class PostMasterBottom extends StatelessWidget {
  final String profilePictureURI;


  PostMasterBottom(this.profilePictureURI);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BorderedUserPicture(radius: 26, pictureURI: profilePictureURI),
        SizedBox(width: 9),
        SendComponent(),
      ],
    );
  }
}