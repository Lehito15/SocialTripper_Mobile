import 'package:flutter/material.dart';

class PostedEntityAuthorTextInfo extends StatelessWidget {
  final String topString;
  final String bottomString;

  PostedEntityAuthorTextInfo({
    required this.topString,
    required this.bottomString,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topString,
            style: TextStyle(
              height: 1,
              fontFamily: "Source Sans 3",
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 2),
          Text(
            bottomString,
            style: TextStyle(
              height: 1,
              fontFamily: "Source Sans 3",
              fontWeight: FontWeight.w600,
              fontSize: 10,
              color: Colors.black.withOpacity(0.55),
            ),
          ),
        ],
      ),
    );
  }
}