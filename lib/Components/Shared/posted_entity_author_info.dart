import 'package:flutter/material.dart';

class PostedEntityAuthorTextInfo extends StatelessWidget {
  final String topString;
  final String bottomString;
  final double spacing;
  final double topSize;
  final double bottomSize;

  PostedEntityAuthorTextInfo({
    required this.topString,
    required this.bottomString,
    this.spacing = 2,
    this.topSize = 15,
    this.bottomSize = 10,
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
              fontSize: topSize,
            ),
          ),
          SizedBox(height: spacing),
          Text(
            bottomString,
            style: TextStyle(
              height: 1,
              fontFamily: "Source Sans 3",
              fontWeight: FontWeight.w600,
              fontSize: bottomSize,
              color: Colors.black.withOpacity(0.55),
            ),
          ),
        ],
      ),
    );
  }
}