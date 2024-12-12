import 'package:social_tripper_mobile/Models/Account/account.dart';
import 'package:social_tripper_mobile/Models/User/user.dart';

class UserDTO {
  String? uuid;
  String name;
  String surname;
  String gender;
  DateTime dateOfBirth;
  double weight;
  double height;
  double? bmi;
  double physicality;
  Account account;
  Country country;
  Set<Language> languages;
  Set<Activity> activities;

  UserDTO(
      this.uuid,
      this.name,
      this.surname,
      this.gender,
      this.dateOfBirth,
      this.weight,
      this.height,
      this.bmi,
      this.physicality,
      this.account,
      this.country,
      this.languages,
      this.activities,
      );

  // fromJson
  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      json['uuid'] ?? '',
      json['name'] ?? '',
      json['surname'] ?? '',
      json['gender'] ?? '',
      json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth']) : DateTime(0),
      (json['weight'] ?? 0).toDouble(),
      (json['height'] ?? 0).toDouble(),
      (json['bmi'] ?? 0).toDouble(),
      (json['physicality'] ?? 0).toDouble(),
      Account.fromJson(json['account']),
      Country.fromJson(json['country']),
      (json['languages'] as List<dynamic>?)
          ?.map((lang) => Language.fromJson(lang))
          .toSet() ??
          {},
      (json['activities'] as List<dynamic>?)
          ?.map((act) => Activity.fromJson(act))
          .toSet() ??
          {},
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'surname': surname,
      'gender': gender,
      'dateOfBirth': dateOfBirth.toIso8601String(), // Formatowanie DateTime do ISO
      'weight': weight.toString(), // Konwersja do BigDecimal w backendzie
      'height': height.toString(), // Konwersja do BigDecimal w backendzie
      'bmi': bmi.toString(), // Konwersja do BigDecimal w backendzie
      'physicality': physicality.toString(), // Konwersja do BigDecimal w backendzie
      'account': account?.toJson(),
      'country': country?.toJson(),
      'languages': languages.map((lang) => lang.toJson()).toList(),
      'activities': activities.map((act) => act.toJson()).toList(),
    };
  }
}
