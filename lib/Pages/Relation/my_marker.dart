import 'package:flutter/material.dart';

class MyMarker extends StatelessWidget {
  final String mediaPath;
  final bool isActive;

  const MyMarker({super.key, required this.mediaPath, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.location_pin,
          color: isActive ? Color(0xFFBDF271) : Colors.grey,
          size: 50,
        ),
          Positioned(
            top: 10,
            child: CircleAvatar(
              backgroundImage: NetworkImage(mediaPath),
              radius: 10,
            ),
          ),
        if (mediaPath.endsWith('.mp4'))
          Positioned(
            top: 19,
            child: Icon(
              Icons.play_arrow_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
      ],
    );
  }
}