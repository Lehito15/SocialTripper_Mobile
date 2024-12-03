import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_tripper_mobile/Models/User/current_user.dart';

class DataLoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadUserData(), // Funkcja asynchroniczna, która ładuje dane użytkownika
      builder: (context, snapshot) {
        // Jeśli dane są w trakcie ładowania, wyświetlamy ekran ładowania
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // Pokazuje ładowanie
            ),
          );
        }

        // Jeśli wystąpił błąd podczas ładowania, pokazujemy błąd
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Wystąpił błąd podczas ładowania danych'),
            ),
          );
        }

        // Kiedy dane są gotowe, przekierowujemy użytkownika na stronę główną
        if (snapshot.connectionState == ConnectionState.done) {
          // Używamy GoRouter do przejścia na stronę /home
          Future.microtask(() {
            GoRouter.of(context).go('/home'); // Przechodzi na HomePage
          });
          return SizedBox(); // Zwracamy pusty widget, bo wszystko odbywa się już w przyszłym kroku
        }

        return SizedBox(); // Domyślnie nic nie wyświetlamy
      },
    );
  }

  // Funkcja asynchroniczna do pobierania danych użytkownika
  Future<void> _loadUserData() async {
    try {
      // Przykładowe pobranie danych użytkownika (np. z AWS Amplify)
      final user = await Amplify.Auth.getCurrentUser();
      final userAttributes = await Amplify.Auth.fetchUserAttributes();
      print("User is logged in: ${user.username}");
      print("User attributes: $userAttributes");
      CurrentUser.email = userAttributes[0].value;
      print("Email uzytkownika to: ${CurrentUser.email}");
    } catch (e) {
      print("Error getting user data: $e");
      throw e; // Jeśli wystąpi błąd, rzucamy go dalej
    }
  }
}