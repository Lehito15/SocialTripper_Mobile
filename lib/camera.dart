import 'dart:io';

// import 'package:better_open_file/better_open_file.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'video.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  void _showMedia(BuildContext context, String mediaPath) {
    if (mediaPath.endsWith('.jpg') || mediaPath.endsWith('.png')) {
      showDialog(
        context: context,
        builder: (_) =>
            Dialog(
              child: Image.file(File(mediaPath)),
            ),
      );
    } else if (mediaPath.endsWith('.mp4')) {
      showDialog(
          context: context,
          builder: (_) =>
              Dialog(
                child: VideoScreen(videoPath: mediaPath),
              )
      );
    }
  }

  Future<void> _openPreview(context, mediaPath) async {
    final bool added = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewPage(mediaPath: mediaPath),
        )
    );
    if (added) Navigator.of(context).pop(mediaPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: CameraAwesomeBuilder.awesome(
          onMediaCaptureEvent: (event) {
            if (event.status == MediaCaptureStatus.success) {
              event.captureRequest.when(
                single: (single) {
                  final String? mediaPath = single.file?.path;
                  if (mediaPath != null) {
                    _openPreview(context, mediaPath);
                  }
                },
                //   multiple: (multiple) {
                //     multiple.fileBySensor.forEach((sensor, file) {
                //       final String? mediaPath = file?.path;
                //       if (mediaPath != null) {
                //         Navigator.of(context).pop(mediaPath);
                //       }
                //     });
                //   },
              );

            }
            switch ((event.status, event.isPicture, event.isVideo)) {
              case (MediaCaptureStatus.capturing, true, false):
                debugPrint('Capturing picture...');
              case (MediaCaptureStatus.success, true, false):
                event.captureRequest.when(
                  single: (single) {
                    debugPrint('Picture saved: ${single.file?.path}');
                  },
                  multiple: (multiple) {
                    multiple.fileBySensor.forEach((key, value) {
                      debugPrint('multiple image taken: $key ${value?.path}');
                    });
                  },
                );
              case (MediaCaptureStatus.failure, true, false):
                debugPrint('Failed to capture picture: ${event.exception}');
              case (MediaCaptureStatus.capturing, false, true):
                debugPrint('Capturing video...');
              case (MediaCaptureStatus.success, false, true):
                event.captureRequest.when(
                  single: (single) {
                    debugPrint('Video saved: ${single.file?.path}');
                  },
                  multiple: (multiple) {
                    multiple.fileBySensor.forEach((key, value) {
                      debugPrint('multiple video taken: $key ${value?.path}');
                    });
                  },
                );
              case (MediaCaptureStatus.failure, false, true):
                debugPrint('Failed to capture video: ${event.exception}');
              default:
                debugPrint('Unknown event: $event');
            }
          },
          saveConfig: SaveConfig.photoAndVideo(
            initialCaptureMode: CaptureMode.photo,
            photoPathBuilder: (sensors) async {
              final Directory extDir = await getTemporaryDirectory();
              final testDir = await Directory(
                '${extDir.path}/camerawesome',
              ).create(recursive: true);
              if (sensors.length == 1) {
                final String filePath =
                    '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
                return SingleCaptureRequest(filePath, sensors.first);
              }
              // Separate pictures taken with front and back camera
              return MultipleCaptureRequest(
                {
                  for (final sensor in sensors)
                    sensor:
                    '${testDir.path}/${sensor.position == SensorPosition.front ? 'front_' : "back_"}${DateTime.now().millisecondsSinceEpoch}.jpg',
                },
              );
            },
            videoOptions: VideoOptions(
              enableAudio: true,
              ios: CupertinoVideoOptions(
                fps: 30,
              ),
              android: AndroidVideoOptions(
                bitrate: 6000000,
                fallbackStrategy: QualityFallbackStrategy.lower,
              ),
            ),
            exifPreferences: ExifPreferences(saveGPSLocation: true),
          ),
          sensorConfig: SensorConfig.single(
            sensor: Sensor.position(SensorPosition.back),
            flashMode: FlashMode.auto,
            aspectRatio: CameraAspectRatios.ratio_4_3,
            zoom: 0.0,
          ),
          enablePhysicalButton: true,
          //filter: AwesomeFilter.AddictiveRed,
          previewAlignment: Alignment.center,
          previewFit: CameraPreviewFit.contain,
          onMediaTap: (mediaCapture) {
            mediaCapture.captureRequest.when(
              single: (single) async {
                debugPrint('single: ${single.file?.path}');
                if (single.file != null) {
                  //await OpenFile.open(single.file!.path);
                  _openPreview(context, single.file!.path);
                }
              },
              multiple: (multiple) async {
                for (final value in multiple.fileBySensor.values) {
                  debugPrint('multiple file taken: ${value?.path}');
                  if (value != null) {
                    //await OpenFile.open(value.path);
                    _openPreview(context, value.path);
                  }
                }
              },
            );
          },
          availableFilters: awesomePresetFiltersList,
        ),
      ),
    );
  }
}

class PreviewPage extends StatelessWidget {
  final String mediaPath;

  const PreviewPage({super.key, required this.mediaPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: mediaPath.endsWith('.jpg') || mediaPath.endsWith('.png')
                  ? Image.file(File(mediaPath))
                  : VideoScreen(videoPath: mediaPath),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0), // margines na dole
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
