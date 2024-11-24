import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconRetriever {
  static String iconsPath = "assets/icons/";

  static SvgPicture retrieveSvgAsset(String name) {
    return SvgPicture.asset(iconsPath+name);
  }

  static Image retrieveImageAsset(String name) {
    return Image.asset(iconsPath+name);
  }
}