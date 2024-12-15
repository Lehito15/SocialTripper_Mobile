import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:social_tripper_mobile/VM/app_viewmodel.dart';

import '../../Models/Account/account.dart';
import '../../Services/account_service.dart';

class DataLoadingPage extends StatelessWidget {
  String? email;

  Future<void> _checkAccountStatus(BuildContext context) async {
    // await Amplify.Auth.signOut();
    AccountService service = AccountService();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (email == null) {
      final userAttributes = await Amplify.Auth.fetchUserAttributes();
      email = userAttributes[0].value;
      AccountService.email = email;
    }
    try {
      Account account = await service.getCurrentAccount(email!);
      AccountService.currentAccount ??= account;
    } catch (e) {
      print("Error fetching account: $e");
      // await Amplify.Auth.signOut();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          GoRouter.of(context).go('/complete_register', extra: email);
        }
      });
      return; // Zatrzymujemy dalsze wykonanie
    }

    try {

      AppViewModel appViewModel = Provider.of<AppViewModel>(context, listen: false);
      await appViewModel.checkActiveTrip();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        GoRouter.of(context).go('/home');
      });
    } catch (e) {
      print('Error while fetching account: $e');
      await Amplify.Auth.signOut();
      await prefs.remove('account_uuid');
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   GoRouter.of(context).go('/complete_register');
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _checkAccountStatus(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Obsługuje błędy w przypadku, gdy wystąpił wyjątek
        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            GoRouter.of(context).go('/home');
          });
        }

        return SizedBox(); // Pusta strona, gdy dane zostały załadowane poprawnie
      },
    );
  }
}