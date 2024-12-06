import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'video.dart';

class CustomMarker extends StatelessWidget {
  final String mediaPath;
  final Uint8List? thumbnail;

  const CustomMarker({super.key, required this.mediaPath, required this.thumbnail});

  String get getMediaPath => mediaPath;
  Uint8List? get getThumbnail => thumbnail;

  void _showMedia(BuildContext context) {
    if (mediaPath.endsWith('.jpg') || mediaPath.endsWith('.png')) {
      showDialog(
        context: context,
        builder: (_) => InteractiveViewer(
          panEnabled: true,
          minScale: 1,
          maxScale: 2.5,
          child: GestureDetector(
            onTap: () => GoRouter.of(context).pop(),
            child: Image.file(File(mediaPath)),
          ),
        ),
      );
    } else if (mediaPath.endsWith('.mp4')) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: VideoScreen(videoPath: mediaPath),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.location_pin,
          color: Colors.lightGreenAccent,
          size: 75,
        ),
        if (thumbnail != null)
          Positioned(
            top: 10,
            child: CircleAvatar(
              backgroundImage: MemoryImage(thumbnail!),
              radius: 19,
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
        GestureDetector(
          onTap: () => _showMedia(context),
        ),
      ],
    );
  }
}