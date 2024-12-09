import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

PreferredSize CustomAppBar(BuildContext context) {
  return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 2)
          ]),
          child: AppBarContent(context)));
}

Future<void> signOutCurrentUser(BuildContext context) async {
  try {
    final result = await Amplify.Auth.signOut();
    if (result is CognitoCompleteSignOut) {
      safePrint('Sign out completed successfully');
      GoRouter.of(context).go('/data_loading');
    } else if (result is CognitoFailedSignOut) {
      safePrint('Error signing user out: ${result.exception.message}');
    }
  } catch (e) {
    safePrint('Error signing out: $e');
  }
}


AppBar AppBarContent(BuildContext context) {
  return AppBar(
    scrolledUnderElevation: 0.0,
    // wyłącza to zmiane koloru appbaru podczas scrollowania
    title: Container(
      decoration: BoxDecoration(),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.purple,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset("assets/icons/main_logo.svg"),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Social Tripper',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                      offset: Offset(-1, 1),
                      blurRadius: 1,
                      color: Colors.black.withOpacity(0.25))
                ]),
          ),
        ],
      ),
    ),
    backgroundColor: Colors.white,
    centerTitle: false,
    actions: [
      GestureDetector(
        onTap: () async {
          await signOutCurrentUser(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            width: 20,
            height: 20,
            child: Image.asset("assets/icons/logout.png"),
          ),
        ),
      )
    ],
  );
}
