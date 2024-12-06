class Activity {
  String name;

  Activity(this.name);

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(json['name']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name
    };
  }
}