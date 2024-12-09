import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';

class PostPhoto extends StatefulWidget {
  final String url;

  PostPhoto({required this.url});

  @override
  _PostPhotoState createState() => _PostPhotoState();
}

class _PostPhotoState extends State<PostPhoto> {
  double? imageHeight;
  double? imageWidth;
  double? imageRatio;
  late CustomVideoPlayerController _customVideoPlayerController;
  CachedVideoPlayerPlusController? _cachedVideoController;
  bool _isVideo = false;
  bool _isImageLoaded = false; // Flaga do monitorowania ładowania obrazu
  bool _isVideoReady = false;  // Flaga do monitorowania gotowości wideo

  @override
  void initState() {
    super.initState();
    _checkIfVideo();
    if (!_isVideo) {
      _getImageDimensions();
    }
  }

  void _checkIfVideo() {
    if (widget.url.endsWith('.mp4') || widget.url.contains('video')) {
      setState(() {
        _isVideo = true;
      });

      // Sprawdzamy, czy już mamy kontroler
      if (_cachedVideoController != null) {
        _disposeController();
      }

      // Inicjalizujemy nowy kontroler wideo
      _cachedVideoController = CachedVideoPlayerPlusController.networkUrl(Uri.parse(widget.url))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isVideoReady = true; // Wideo jest gotowe
            });
          }
        });

      // Tworzymy CustomVideoPlayerController z _cachedVideoController
      _customVideoPlayerController = CustomVideoPlayerController(
        context: context,
        videoPlayerController: _cachedVideoController!,
      );

      // Dodajemy nasłuchiwanie zakończenia odtwarzania
      _cachedVideoController?.addListener(() {
        if (_cachedVideoController!.value.position >= _cachedVideoController!.value.duration &&
            _cachedVideoController!.value.isPlaying) {
          _cachedVideoController?.seekTo(Duration.zero);
        }
      });
    } else {
      _isVideo = false;
    }
  }

  void _getImageDimensions() {
    final imageProvider = CachedNetworkImageProvider(widget.url);
    imageProvider.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo image, bool synchronousCall) {
        if (mounted) {
          setState(() {
            imageHeight = image.image.height.toDouble();
            imageWidth = image.image.width.toDouble();
            imageRatio = imageHeight! / imageWidth!;
            _isImageLoaded = true; // Obraz jest załadowany
          });
        }
      }),
    );
  }

  void _disposeController() async {
    if (_cachedVideoController != null) {
      final oldController = _cachedVideoController;

      // Zwalniamy stary kontroler po zakończeniu aktualnej klatki
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Upewniamy się, że widget jest nadal zamontowany przed wywołaniem dispose
        if (mounted) {
          await oldController?.dispose();
        }
      });

      // Zwalniamy kontroler i ustawiamy go na null
      if (mounted) {
        _cachedVideoController = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isVideo && _isVideoReady) {
      return AspectRatio(
        aspectRatio: 4 / 3, // Możesz dostosować proporcje wideo
        child: CustomVideoPlayer(
          customVideoPlayerController: _customVideoPlayerController,
        ),
      );
    }

    if (!_isImageLoaded) {
      return Center(child: CircularProgressIndicator()); // Czekaj na załadowanie obrazu
    }

    if (_isOddRatio(imageRatio!)) {
      return AspectRatio(
        aspectRatio: 3 / 4,
        child: CachedNetworkImage(
          imageUrl: widget.url,
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Center(child: Icon(Icons.error, color: Colors.red)),
          fadeInDuration: Duration(milliseconds: 300),
          fadeOutDuration: Duration(milliseconds: 300),
        ),
      );
    } else {
      return FittedBox(
        fit: BoxFit.cover,
        child: CachedNetworkImage(
          imageUrl: widget.url,
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Center(child: Icon(Icons.error, color: Colors.red)),
          fadeInDuration: Duration(milliseconds: 300),
          fadeOutDuration: Duration(milliseconds: 300),
        ),
      );
    }
  }

  @override
  void dispose() {
    if (_isVideo && mounted) {
      _disposeController();
      _customVideoPlayerController.dispose();
    }
    super.dispose();
  }
}

// Funkcja do sprawdzenia, czy ratio jest dziwne/szkodliwe
bool _isOddRatio(double ratio) {
  return ratio < 0.2 || ratio > 5.0;
}