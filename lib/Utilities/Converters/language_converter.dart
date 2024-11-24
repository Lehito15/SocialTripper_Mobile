import 'dart:collection';
import 'dart:convert';
import 'package:flutter/services.dart';

class LanguageConverter {
  static final HashMap<String, String> languageToCodeMap = HashMap();

  static Future<void> initialize() async {
    if (languageToCodeMap.isEmpty) {
      String jsonString = await _loadJsonFromAssets();
      _populateLanguageToCodeMap(jsonString);
    }
  }

  static Future<String> _loadJsonFromAssets() async {
    return await rootBundle.loadString('assets/countries/language_to_country_code.json');
  }

  static void _populateLanguageToCodeMap(String jsonString) {
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    jsonData.forEach((key, value) {
      languageToCodeMap[key] = value.toString();
    });
  }

  static String? convertLanguageToFlagCode(String language) {
    return languageToCodeMap[language];
  }
}