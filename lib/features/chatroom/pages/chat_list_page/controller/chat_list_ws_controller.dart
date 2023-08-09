import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/chatroom/pages/chat_list_page/controller/chat_list_content_controller.dart';
import 'package:mentor_app_flutter/features/chatroom/pages/chat_list_page/controller/chat_list_notification_controller.dart';
import 'package:mentor_app_flutter/features/chatroom/service/local_message_service.dart';
import 'package:mentor_app_flutter/features/chatroom/service/message_type_service.dart';
import 'package:mentor_app_flutter/service/chatroom_sync_service.dart';
import 'package:mentor_app_flutter/service/user_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../../config/server_url.dart';
import '../../../../../sharedPrefs/userPrefs.dart';

class ChatListWsController extends GetxController {
  WebSocketChannel? channel;
  Timer? heartbeatTimer;
  String? userId;
  MessageTypeService? messageTypeService;
  LocalMessageService? localMessageService;
  final ChatListContentController chatListContentController = Get.find<ChatListContentController>();
  final ChatListNotificationController chatListNotificationController = Get.find<ChatListNotificationController>();

  @override
  onInit() async {
    super.onInit();
    userId = await UserPrefs.getUserId();
    messageTypeService = MessageTypeService(userId!);
    localMessageService = LocalMessageService(userId);
    await ChatroomSyncService.syncChatMessages();
    initWs();
  }

  @override
  onClose() {
    heartbeatTimer?.cancel();
    channel?.sink.close();
    closeWs();
    channel = null;
    heartbeatTimer = null;
    super.onClose();
  }

  void closeWs() {
    heartbeatTimer?.cancel();
    channel?.sink.close();
    channel = null;
    heartbeatTimer = null;
  }

  Future<void> initWs() async {
    if(channel != null) {
      return;
    }

    String? userId = await UserPrefs.getUserId();
    String? deviceId = await UserService.getDeviceId();
    channel = WebSocketChannel.connect(Uri.parse(EnvSetting.CHATROOM_WEBSOCKET_IP + '/?userId=' + userId! + "&deviceId=" + deviceId!));

    channel?.stream.listen((message) {
      var messageJson = json.decode(message);
      chatListNotificationController.onMessage(messageJson);
      chatListContentController.changeContent(messageJson);
      if(messageTypeService != null && (messageTypeService!.isSimpleMessage(messageJson['cmd']) || messageTypeService!.isClassInfoMessage(messageJson['cmd']))) {
        ChatroomSyncService.syncSpecificConversation(messageJson['conversationId']);
      }
    });
    startHeartbeat();
  }

  Future<void> startHeartbeat() async {
    if(heartbeatTimer != null) {
      return;
    }

    heartbeatTimer = Timer.periodic(Duration(seconds: 30), (Timer t) {
      print("[chat list] ping");
      channel?.sink.add(
          json.encode({
            "cmd": 5,
            "messageId": "",
            "senderId": userId,
            "conversationId": "",
            "recieverId": "",
            "message": "ping"
          }).codeUnits
      );
    });
  }
}