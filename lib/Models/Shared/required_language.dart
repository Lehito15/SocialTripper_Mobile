import 'package:social_tripper_mobile/Models/Shared/language.dart';

class RequiredLanguage {
  double requiredLevel;
  Language language;

  RequiredLanguage(this.requiredLevel, this.language);


  factory RequiredLanguage.fromJson(Map<String, dynamic> json) {
    return RequiredLanguage(
      json['requiredLevel'],
      Language.fromJson(json['language']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requiredLevel': requiredLevel,
      'language': language.toJson()
    };
  }

}
