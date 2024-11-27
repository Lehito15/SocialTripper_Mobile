import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class UserGenerator {
  // Statyczna lista użytkowników, która będzie przechowywać dane pobranych użytkowników
  static List<Map<String, dynamic>> users = [];

  // Adres API, z którego będziemy pobierać dane
  static final String _apiUrl = 'https://randomuser.me/api/';

  /// Inicjalizuje listę użytkowników poprzez pobranie ich z API.
  static Future<void> fetchRandomUsers(int count) async {
    try {
      final response = await http.get(Uri.parse('$_apiUrl?results=$count'));

      if (response.statusCode == 200) {
        print("Użytkownicy pobrani pomyślnie");
        final data = jsonDecode(response.body);

        // Przypisanie pobranych użytkowników do listy
        users = (data['results'] as List).map((user) {
          return {
            'name': '${user['name']['first']} ${user['name']['last']}',
            'email': user['email'],
            'picture': user['picture']['large'],
            'username': user['login']['username'],
            'gender': user['gender'],
          };
        }).toList();
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      print('Error in fetchRandomUsers: $e');
      // Można dodać domyślnych użytkowników w razie błędu
      users = [
        {
          'name': 'John Doe',
          'email': 'johndoe@example.com',
          'picture': 'https://via.placeholder.com/150',
          'username': 'johndoe',
          'gender': 'unknown',
        },
      ];
    }
    finally {
      print(users.length);
    }
  }

  /// Metoda pomocnicza do pobrania konkretnego użytkownika
  static Map<String, dynamic>? getRandomUser() {
    if (users.isNotEmpty) {
      // Tworzymy losowy indeks w zakresie od 0 do (users.length - 1)
      Random random = Random();
      int randomIndex = random.nextInt(users.length);

      // Zwracamy losowego użytkownika
      return users[randomIndex];
    }
    return null; // Zwraca null, jeśli lista użytkowników jest pusta
  }

  /// Metoda do pobrania liczby użytkowników
  static int getUsersCount() {
    return users.length;
  }
}