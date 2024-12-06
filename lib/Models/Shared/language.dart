class Language {
  String name;

  Language(this.name);

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name
    };
  }
}