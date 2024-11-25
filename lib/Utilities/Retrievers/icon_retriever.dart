import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_tripper_mobile/Utilities/Retrievers/retriever.dart';


class IconRetriever implements SvgRetriever {
  static String iconsPath = "assets/icons/";
  @override
  SvgPicture retrieve(String name, double width) {
    return SvgPicture.asset(
      iconsPath+name,
      width: width,
    );
  }
}