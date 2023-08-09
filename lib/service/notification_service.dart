import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../sharedPrefs/chatroomPrefs.dart';
import '../sharedPrefs/userPrefs.dart';
import '../utils/network_util.dart';
import 'chatroom_sync_service.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class NotificationService {
  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('notification_icon');
    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true,
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    showChatNotification(message.data["senderId"], message.data["avatarUrl"], message.data["nickname"], message.data["message"], message.data["conversationId"]);

    print('Handling a background message ${message.messageId}');
  }

  static Future<void> firebaseMessagingForegroundHandler(RemoteMessage message) async {
    showChatNotification(message.data["senderId"], message.data["avatarUrl"], message.data["nickname"], message.data["message"], message.data["conversationId"]);

    // ChatroomSyncService.syncSpecificConversation(message.data["conversationId"]);

    print('Handling a foreground message ${message.messageId}');
  }

  static Future<void> chatroomMessageHandler(dynamic messageJson) async {
    String? userId = await UserPrefs.getUserId();
    final conversationListPref = await ChatroomPrefs.getConversationListJsonStr(userId!);
    final conversationList = (jsonDecode(conversationListPref!) as List);
    conversationList.forEach((element) {
      if(element["conversationId"] == messageJson["conversationId"]) {
        showChatNotification(messageJson["senderId"], element["avatarUrl"], element["nickname"], messageJson["message"], messageJson["conversationId"]);
      }
    });
  }

  static Future<void> showChatNotification(String senderId, String avatarUrl, String nickname, String message, String conversationId) async {
    String iconPath = await NetworkUtil.downloadFileAndGetPath(senderId, avatarUrl);

    if (!kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        senderId.hashCode,
        nickname,
        message,
        NotificationDetails(
          android: AndroidNotificationDetails(
              conversationId,
              senderId,
              channelDescription: "chat message",
              icon: 'notification_icon',
              largeIcon: FilePathAndroidBitmap(iconPath),
              priority: Priority.high,
              importance: Importance.high
          ),
          iOS: DarwinNotificationDetails()
        ),
        payload: ""
      );
    }
  }
}