import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_tripper_mobile/Models/Language/language_thumbnail.dart';
import 'package:social_tripper_mobile/Utilities/Converters/language_converter.dart';
import 'package:social_tripper_mobile/Utilities/Retrievers/flag_retriever.dart';

Container LanguageMaster({
  required LanguageThumbnail language
}) {
  print(LanguageConverter.convertLanguageToFlagCode(language.name));
  return Container(
    decoration: BoxDecoration(color: Colors.greenAccent, boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 2)
    ]),
    child: FlagRetriever.retrieveFlag(code: LanguageConverter.convertLanguageToFlagCode(language.name)),
  );
}