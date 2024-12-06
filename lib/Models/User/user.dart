class Country {
  final String name;

  Country(this.name);

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(json['name']);
  }

  // Dodajemy metodę toJson
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class Language {
  final double level;
  final String name;

  Language(this.level, this.name);

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      json['level'],
      json['language']['name'],
    );
  }

  // Dodajemy metodę toJson
  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'language': {'name': name},  // Zakładając, że w JSON język jest zagnieżdżony
    };
  }

  @override
  String toString() {
    return 'Language{level: $level, name: $name}';
  }
}

class Activity {
  final double experience;
  final String name;

  Activity(this.experience, this.name);

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      json['experience'],
      json['activity']['name'],
    );
  }

  // Dodajemy metodę toJson
  Map<String, dynamic> toJson() {
    return {
      'experience': experience,
      'activity': {'name': name},  // Zakładając, że w JSON aktywność jest zagnieżdżona
    };
  }

  @override
  String toString() {
    return 'Activity{experience: $experience, name: $name}';
  }
}

class UserThumbnail {
  final String uuid;
  final String name;
  final String surname;
  final String gender;
  final DateTime dateOfBirth;
  final double weight;
  final double height;
  final double physicality;
  final Country country;
  final Set<Language> languages;
  final Set<Activity> activities;

  UserThumbnail(
      this.uuid,
      this.name,
      this.surname,
      this.gender,
      this.dateOfBirth,
      this.weight,
      this.height,
      this.physicality,
      this.country,
      this.languages,
      this.activities,
      );

  factory UserThumbnail.fromJson(Map<String, dynamic> json) {
    return UserThumbnail(
      json['uuid'],
      json['name'],
      json['surname'],
      json['gender'],
      DateTime.parse(json['dateOfBirth']),
      (json['weight'] as num).toDouble(),
      (json['height'] as num).toDouble(),
      (json['physicality'] as num).toDouble(),
      Country.fromJson(json['country']),
      (json['languages'] as List)
          .map((lang) => Language.fromJson(lang))
          .toSet(),
      (json['activities'] as List)
          .map((activity) => Activity.fromJson(activity))
          .toSet(),
    );
  }

  // Dodajemy metodę toJson
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'name': name,
      'surname': surname,
      'gender': gender,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'weight': weight,
      'height': height,
      'physicality': physicality,
      'country': country.toJson(),
      'languages': languages.map((lang) => lang.toJson()).toList(),
      'activities': activities.map((activity) => activity.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'User{uuid: $uuid, name: $name, surname: $surname, gender: $gender, dateOfBirth: $dateOfBirth, weight: $weight, height: $height, physicality: $physicality, country: $country, languages: $languages, activities: $activities}';
  }
}
