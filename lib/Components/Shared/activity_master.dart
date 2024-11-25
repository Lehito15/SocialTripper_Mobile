import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_tripper_mobile/Utilities/Retrievers/flag_retriever.dart';
import 'package:social_tripper_mobile/Utilities/Retrievers/icon_retriever.dart';
import 'package:tuple/tuple.dart';

import '../../Models/Activity/activity_thumbnail.dart';

Container ActivityMaster(
  SvgPicture child,
) {
  return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
          color: const Color(0xffF0F2F5),
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 2)
          ]),
      child: Padding(
        padding: EdgeInsets.all(3.13),
        child: child,
      ));
}