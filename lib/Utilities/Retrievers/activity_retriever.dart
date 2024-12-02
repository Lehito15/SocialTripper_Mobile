
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_tripper_mobile/Utilities/Retrievers/retriever.dart';

class ActivityRetriever implements SvgRetriever {
  static String pathCore = "assets/activities/";

  @override
  SvgPicture retrieve(String activity, double width, {Color color = Colors.black}) {
    activity = activity.toLowerCase();
    return SvgPicture.asset(
      "$pathCore$activity.svg",
      width: width,
      color: color,
    );
  }
}