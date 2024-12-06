import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:social_tripper_mobile/VM/app_viewmodel.dart';

import '../Services/account_service.dart';

class DataLoadingPage extends StatelessWidget {
  Future<void> _checkAccountStatus(BuildContext context) async {
    AccountService service = AccountService();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await service.getCurrentAccount();

    try {
      AppViewModel appViewModel =
      Provider.of<AppViewModel>(context, listen: false);
      print("przed chekiem");
      await appViewModel.checkActiveTrip();
      print("checking active trip");


      // Jeśli dane o koncie udało się pobrać, przechodzimy do /home
      GoRouter.of(context).go('/home');
    } catch (e) {
      // Obsługuje błąd, jeśli wystąpi
      print('Error while fetching account: $e');

      // Wylogowujemy użytkownika
      await Amplify.Auth.signOut();

      // Usuwamy zapisane UUID z SharedPreferences
      await prefs.remove('account_uuid');

      // Pokazujemy komunikat o błędzie
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wystąpił błąd podczas ładowania danych, wylogowano'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _checkAccountStatus(context),
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

        // Domyślnie zwracamy pusty widget
        return SizedBox();
      },
    );
  }
}
