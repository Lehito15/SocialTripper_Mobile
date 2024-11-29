
import 'date_generator.dart';

class GeneratedUser {
  final String name;
  final String email;
  final String picture;
  final String username;
  final String gender;
  final DateTime date;

  GeneratedUser({
    required this.name,
    required this.email,
    required this.picture,
    required this.username,
    required this.gender,
    required this.date,
  });

  // Opcjonalnie: Konstruktor fabryczny do tworzenia obiektów z JSON-a
  factory GeneratedUser.fromJson(Map<String, dynamic> json) {
    return GeneratedUser(
      name: '${json['name']['first']} ${json['name']['last']}',
      email: json['email'],
      picture: json['picture']['large'],
      username: json['login']['username'],
      gender: json['gender'],
      date: DateGenerator.generateRandomDate(),
    );
  }
}