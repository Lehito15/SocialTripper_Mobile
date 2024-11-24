import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class LocationTask extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter? sendPort) async {
    print('onStart(starter: ${sendPort?.name})');
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    print("Tracking location...");
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    // Czyszczenie zasobów
  }

  @override
  void onButtonPressed(String id) {
    // Kliknięcie przycisku powiadomienia
  }

  @override
  void onNotificationPressed() {
    print("notification was pressed");
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // Powtórzenie zdarzenia
  }
}

Future<void> initService() async {
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'foreground_service',
      channelName: 'Foreground Service Notification',
      channelDescription:
      'This notification appears when the foreground service is running.',
      onlyAlertOnce: true,
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: false,
      playSound: false,
    ),
    foregroundTaskOptions: ForegroundTaskOptions(
      eventAction: ForegroundTaskEventAction.repeat(5000),
      autoRunOnBoot: true,
      autoRunOnMyPackageReplaced: true,
      allowWakeLock: true,
      allowWifiLock: true,
    ),
  );
}