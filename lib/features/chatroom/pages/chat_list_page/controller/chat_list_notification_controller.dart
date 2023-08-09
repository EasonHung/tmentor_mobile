import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/chatroom/pages/chat_list_page/controller/chat_list_content_controller.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';

import '../../../../../service/notification_service.dart';

class ChatListNotificationController extends GetxController {
  final ChatListContentController chatListContentController = Get.find<ChatListContentController>();
  String? userId;

  @override
  void onInit() async {
    userId = await UserPrefs.getUserId();
    super.onInit();
  }

  void onMessage(dynamic message) {
    if (message['cmd'] == 0 && message['senderId'] != userId) {
      NotificationService.chatroomMessageHandler(message);
    }
  }
}