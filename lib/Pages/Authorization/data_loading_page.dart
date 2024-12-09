import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:social_tripper_mobile/VM/app_viewmodel.dart';

import '../../Services/account_service.dart';

class DataLoadingPage extends StatelessWidget {
  Future<void> _checkAccountStatus(BuildContext context) async {
    AccountService service = AccountService();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await service.getCurrentAccount();

    try {
      AppViewModel appViewModel =
      Provider.of<AppViewModel>(context, listen: false);

      await appViewModel.checkActiveTrip();

      GoRouter.of(context).go('/home');
    } catch (e) {
      print('Error while fetching account: $e');

      await Amplify.Auth.signOut();

      await prefs.remove('account_uuid');
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

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Wystąpił błąd podczas ładowania danych'),
            ),
          );
        }

        return SizedBox();
      },
    );
  }
}
