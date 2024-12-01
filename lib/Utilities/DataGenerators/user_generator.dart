import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'date_generator.dart';
import 'generated_user.dart';

class UserGenerator {
  // Statyczna lista użytkowników, która będzie przechowywać dane pobranych użytkowników
  static List<GeneratedUser> users = [];

  // Adres API, z którego będziemy pobierać dane
  static final String _apiUrl = 'https://randomuser.me/api/';

  /// Inicjalizuje listę użytkowników poprzez pobranie ich z API.
  static Future<void> fetchRandomUsers(int count) async {
    try {
      final response = await http.get(Uri.parse('$_apiUrl?results=$count'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Sprawdzenie czy odpowiedź zawiera wszystkie wymagane dane
        if (data['results'] != null && data['results'].isNotEmpty) {
          users = (data['results'] as List).map((user) {
            return GeneratedUser.fromJson(user);
          }).toList();
        } else {
          throw Exception('No users found in the API response');
        }
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      print('Error in fetchRandomUsers: $e');
      // Można dodać domyślnych użytkowników w razie błędu
      users = [
        GeneratedUser(
          name: 'John Doe',
          email: 'johndoe@example.com',
          picture: 'https://via.placeholder.com/150',
          username: 'johndoe',
          gender: 'unknown',
          date: DateGenerator.generateRandomDate(),
        ),
      ];
    }
  }

  /// Metoda pomocnicza do pobrania konkretnego użytkownika
  static GeneratedUser getRandomUser() {
    if (users.isNotEmpty) {
      // Tworzymy losowy indeks w zakresie od 0 do (users.length - 1)
      Random random = Random();
      int randomIndex = random.nextInt(users.length);

      // Zwracamy losowego użytkownika
      return users[randomIndex];
    } else {
      // Jeśli lista jest pusta, zwracamy domyślnego użytkownika
      return GeneratedUser(
        name: 'John Doe',
        email: 'johndoe@example.com',
        picture: 'https://via.placeholder.com/150',
        username: 'johndoe',
        gender: 'unknown',
        date: DateGenerator.generateRandomDate(),
      );
    }
  }

  /// Metoda do pobrania liczby użytkowników
  static int getUsersCount() {
    return users.length;
  }
}