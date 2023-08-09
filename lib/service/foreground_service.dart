import 'package:flutter_background/flutter_background.dart';

class ForegroundService {
  static Future<void> init() async {
    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: 'Title of the notification',
      notificationText: 'Text of the notification',
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon: AndroidResource(
          name: 'background_icon',
          defType: 'drawable'), // Default is ic_launcher from folder mipmap
    );
    await FlutterBackground.initialize(androidConfig: androidConfig);
  }

  static void startService() {
    FlutterBackground.enableBackgroundExecution();
  }

  static void stopService() {
    FlutterBackground.disableBackgroundExecution();
  }
}