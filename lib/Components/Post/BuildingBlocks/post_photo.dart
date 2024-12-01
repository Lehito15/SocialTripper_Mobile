import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

AspectRatio PostPhoto(
  String url,
) {
  return AspectRatio(
    aspectRatio: 3 / 4,
    child: CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Center(
        child: Icon(Icons.error, color: Colors.red),
      ),
      fadeInDuration: Duration(milliseconds: 300),
      fadeOutDuration: Duration(milliseconds: 300),
    ),
  );
}
