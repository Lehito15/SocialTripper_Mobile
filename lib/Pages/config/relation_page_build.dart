import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../Models/Trip/trip_multimedia.dart';
import '../Relation/relations_page.dart';

class RelationPageBuildConfig {
  static Widget buildItem(List<TripMultimedia> multimediaList, BuildContext context) {
    return Relation(relation: multimediaList);
  }

  static bool _isImage(String uri) {
    final imageExtensions = ['.png', '.jpg', '.jpeg', '.gif', '.bmp', '.webp'];
    return imageExtensions.any((ext) => uri.toLowerCase().endsWith(ext));
  }

  static bool _isVideo(String uri) {
    final videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm'];
    return videoExtensions.any((ext) => uri.toLowerCase().endsWith(ext));
  }

  static Future<void> cachingStrategy(List<TripMultimedia> relation, BuildContext context) async {
    if (relation.isNotEmpty) {
      await Future.wait(relation.map((tm) async {
        final url = tm.multimediaUrl; // Pobranie URL multimediów
        if (url.isNotEmpty) {
          if (_isImage(url)) {
            print("Caching image: $url");
            final image = CachedNetworkImageProvider(url);
            await image.resolve(ImageConfiguration());
          } else if (_isVideo(url)) {
            print("Caching video: $url");
            final controller = VideoPlayerController.network(url);
            await controller.initialize();
            controller.dispose(); // Zwolnienie pamięci po wideo
          } else {
            print("Unsupported format: $url");
          }
        } else {
          print("Empty or null multimedia URL for: $tm");
        }
      }));
    }
  }
}