import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/Shared/authorization_logo_header.dart';


class CompleteAccountInformationPage extends StatefulWidget {
  const CompleteAccountInformationPage({super.key});

  @override
  State<CompleteAccountInformationPage> createState() => _CompleteAccountInformationPageState();
}

class _CompleteAccountInformationPageState extends State<CompleteAccountInformationPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 32, bottom: 32),
          child: AuthorizationLogoHeader(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 24,
                width: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "1",
                  style: TextStyle(
                    color: Color(0xffBDF271),
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  ),
                ),
              )
            ],
          ),
        )
      ],
    ));
  }
}
