
import 'dart:io';
import 'package:get/get.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mentor_app_flutter/apiManager/userApiManager.dart';
import 'package:mentor_app_flutter/features/guide_screen/guide_screen.dart';
import 'package:mentor_app_flutter/features/main_page.dart';
import 'package:mentor_app_flutter/features/signin/sign_in_screen.dart';
import 'package:mentor_app_flutter/service/chatroom_sync_service.dart';
import 'package:mentor_app_flutter/service/foreground_service.dart';
import 'package:mentor_app_flutter/service/init_service.dart';
import 'package:mentor_app_flutter/service/notification_service.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';
import 'package:toast/toast.dart';

import 'local_database/dao/object_box_singleton.dart';
import 'objectbox.g.dart';

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel? channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.high,
  enableVibration: true,
);

Store? store;
String? userId;
String firstPath = "/";
bool hasLoggedIn = false;
bool hasRunMain = false;

// /// Initialize the [FlutterLocalNotificationsPlugin] package.
// FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();
//
//   RemoteNotification? notification = message.notification;
//   AndroidNotification? android = message.notification?.android;
//   String iconPath = await NetworkUtil.downloadFileAndGetPath(message.data["senderId"], message.data["avatarUrl"]);
//
//   flutterLocalNotificationsPlugin.show(
//       message.data["senderId"].hashCode,
//       message.data["nickName"],
//       message.data["messageId"],
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//             message.data["senderId"],
//             message.data["conversationId"],
//             channelDescription: channel!.description,
//             icon: 'notification_icon',
//             largeIcon: FilePathAndroidBitmap(iconPath),
//             priority: Priority.high,
//             importance: Importance.high
//         ),
//       ),
//       payload: jsonEncode(message.data)
//   );
//
//   ChatroomSyncService.syncSpecificConversation(message.data["conversationId"]);
//
//   print('Handling a background message ${message.messageId}');
// }

Future<String?> getDeviceId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.id; // unique ID on Android
  }
  return "";
}

final firebaseMessaging = FirebaseMessaging.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  try {
    store = await ObjectBox.getStore();
  } catch (e) {
    print(e.toString());
  }

  firstPath = await InitService.checkLoginStatusAndDecideRootPath();

  if (!kIsWeb) {
    // channel = const AndroidNotificationChannel(
    //   'high_importance_channel', // id
    //   'High Importance Notifications', // title
    //   description: 'This channel is used for important notifications.', // description
    //   importance: Importance.high,
    //   enableVibration: true,
    // );
    //
    // await flutterLocalNotificationsPlugin
    //     ?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(channel!);

    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  FirebaseMessaging.onBackgroundMessage(NotificationService.firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(NotificationService.firebaseMessagingForegroundHandler);

  ChatroomSyncService.syncChatMessages();

  if(Platform.isAndroid) {
    ForegroundService.init();
  }

  _onRefreshFcmToken();


  runApp(ProviderScope(child: MyApp()));
}

void _onRefreshFcmToken() {
  firebaseMessaging.onTokenRefresh.listen((token) async {
    String? currentFcm = await UserPrefs.getCurrentFcmToken();
    userApiManager.updateFcmToken(currentFcm, token);
    UserPrefs.setCurrentFCMToken(token);
  });
}

// Future<void> _listenFcm() async {
//   // foreground
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//     String iconPath = await NetworkUtil.downloadFileAndGetPath(message.data["senderId"], message.data["avatarUrl"]);
//
//     flutterLocalNotificationsPlugin?.show(
//       message.data["senderId"].hashCode,
//       message.data["nickName"],
//       message.data["messageId"],
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           message.data["senderId"],
//           message.data["conversationId"],
//           channelDescription: "chat message",
//           icon: 'notification_icon',
//           largeIcon: FilePathAndroidBitmap(iconPath),
//           priority: Priority.high,
//           importance: Importance.high
//         ),
//       ),
//       payload: jsonEncode(message.data)
//     );
//
//     ChatroomSyncService.syncSpecificConversation(message.data["conversationId"]);
//   });
// }

final RouteObserver<Route<dynamic>> routeObserver = RouteObserver();

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child)
      {
        return GetMaterialApp(
          initialRoute: firstPath,
          debugShowCheckedModeBanner: false,
          navigatorObservers: [routeObserver],
          home: MainScreen(),
          routes: {
            '/login': (context) {
              return SignInScreen();
            },
            '/guide': (context) {
              return GuideScreen();
            }
          },
        );
      }
    );
  }
}
