import 'package:flutter_svg/flutter_svg.dart';

class FlagRetriever {
  static String pathCore = "assets/flags/";

  static SvgPicture retrieveFlag({required String? code, double width = 25}) {
    return SvgPicture.asset(
        "$pathCore$code.svg",
      width: width,
    );
  }
}
