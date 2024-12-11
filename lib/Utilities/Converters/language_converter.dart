import 'dart:collection';
import 'dart:convert';
import 'package:flutter/services.dart';

class LanguageConverter {
  static final HashMap<String, String> languageToCodeMap = HashMap();
  static final HashMap<String, String> phoneCodeToCodeMap = HashMap();
  static final HashMap<String, String> countryToCodeMap = HashMap();

  static Future<void> initialize() async {
    if (languageToCodeMap.isEmpty) {
      String jsonString = await _loadJsonFromAssets("language_to_country_code");
      _populateLanguageToCodeMap(jsonString);
    }

    if (countryToCodeMap.isEmpty) {
      String jsonString = await _loadJsonFromAssets("country_to_code");
      _populateCountryToCodeMap(jsonString);
    }

    if (phoneCodeToCodeMap.isEmpty) {
      String jsonString = await _loadJsonFromAssets("phone_codes_to_countries");
      _populatePhoneCodeToCodeMap(jsonString);
    }
  }

  static Future<String> _loadJsonFromAssets(String filename) async {
    return await rootBundle.loadString('assets/countries/$filename.json');
  }

  static void _populateLanguageToCodeMap(String jsonString) {
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    jsonData.forEach((key, value) {
      languageToCodeMap[key] = value.toString();
    });
  }

  static void _populatePhoneCodeToCodeMap(String jsonString) {
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    jsonData.forEach((key, value) {
      phoneCodeToCodeMap[key] = countryToCodeMap[value.toString()]!;
    });
  }

  static void _populateCountryToCodeMap(String jsonString) {
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    jsonData.forEach((key, value) {
      countryToCodeMap[key] = value.toString();
    });
  }

  static String? convertLanguageToFlagCode(String language) {
    return languageToCodeMap[language];
  }

  static String? convertPhoneCodeToFlagCode(String language) {
    return phoneCodeToCodeMap[language];
  }

  static String? convertCountryToFlagCode(String language) {
    return countryToCodeMap[language];
  }

  static List<String> getAllPhoneCodes() {
    List<String> phoneCodes = phoneCodeToCodeMap.keys.toList();

    phoneCodes.sort((a, b) {
      int aValue = int.parse(a.replaceAll(RegExp(r'[+-]'), ''));
      int bValue = int.parse(b.replaceAll(RegExp(r'[+-]'), ''));
      return aValue.compareTo(bValue);
    });

    return phoneCodes;
  }
  
  static List<String> getAllCountries() {
    List<String> countries = countryToCodeMap.keys.toList();
    countries.sort();
    return countries;
  }
}