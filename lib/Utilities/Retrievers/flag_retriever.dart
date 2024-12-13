import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_tripper_mobile/Utilities/Converters/language_converter.dart';
import 'package:social_tripper_mobile/Utilities/Retrievers/retriever.dart';

class FlagRetriever implements SvgRetriever {
  static String pathCore = "assets/flags/";

  @override
  SvgPicture retrieve(String language, double width) {
    String code = LanguageConverter.convertLanguageToFlagCode(language)!;
    return SvgPicture.asset(
      "$pathCore$code.svg",
      width: width,
    );
  }

  SvgPicture retrieveByPhoneCode(String phoneCode, double width) {
    String code = LanguageConverter.convertPhoneCodeToFlagCode(phoneCode)!;
    return SvgPicture.asset(
      "$pathCore$code.svg",
      width: width,
    );
  }

  SvgPicture retrieveByCountryName(String countryName, double width) {
    String code = LanguageConverter.convertCountryToFlagCode(countryName)!;
    return SvgPicture.asset(
      "$pathCore$code.svg",
      width: width,
    );
  }
}
