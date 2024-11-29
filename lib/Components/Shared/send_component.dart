import 'package:flutter/material.dart';

import '../../Utilities/Retrievers/icon_retriever.dart';

class SendComponent extends StatelessWidget {
  final String title;

  SendComponent({this.title = "Write your comment"});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 26,
        decoration: BoxDecoration(
          color: Color(0xffF0F2F5).withOpacity(0.6),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontFamily: "Source Sans 3",
                ),
              ),
            ),
            Opacity(
              opacity: 0.7,
              child: IconRetriever().retrieve("send.svg", 16),
            ),
          ],
        ),
      ),
    );
  }
}