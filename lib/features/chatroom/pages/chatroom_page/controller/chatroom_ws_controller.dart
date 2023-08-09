import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/chatroom/pages/chatroom_page/controller/chatroom_content_controller.dart';
import 'package:mentor_app_flutter/features/chatroom/service/local_message_service.dart';
import 'package:mentor_app_flutter/features/chatroom/service/message_type_service.dart';
import 'package:mentor_app_flutter/service/user_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../../config/server_url.dart';
import '../../../../../service/chatroom_sync_service.dart';
import '../../../../../sharedPrefs/userPrefs.dart';
import '../service/chatroom_message_service.dart';

class ChatroomWsController extends GetxController {
  ChatroomContentController chatroomContentController = Get.find<ChatroomContentController>();
  ChatroomMessageService chatroomMessageService;
  String? conversationId;
  String? userId;
  WebSocketChannel? chatRoomChannel;
  MessageTypeService? messageTypeService;
  LocalMessageService? localMessageService;
  Timer? heartbeatTimer;

  ChatroomWsController(this.chatroomMessageService);

  @override
  onInit() async {
    super.onInit();
    await ChatroomSyncService.syncSpecificConversation(chatroomContentController.conversationId);
    await initWs();
    startHeartbeat();
    messageTypeService = MessageTypeService(userId!);
    localMessageService = LocalMessageService(userId);
    startListenMessageQueue();
  }

  @override
  onClose() {
    closeWs();
    super.onClose();
  }

  void closeWs() {
    chatRoomChannel?.sink.close();
    chatRoomChannel = null;
    heartbeatTimer?.cancel();
    heartbeatTimer = null;
  }

  Future<void> initWs() async {
    if(chatRoomChannel != null) {
      return;
    }

    userId = await UserPrefs.getUserId();
    String? deviceId = await UserService.getDeviceId();
    chatRoomChannel = WebSocketChannel.connect(
        Uri.parse(EnvSetting.CHATROOM_WEBSOCKET_IP + '/?userId=' + userId! + "&deviceId=" + deviceId!));
    chatRoomChannel!.stream.listen(
          (message) {
        var messageJson = json.decode(message);
        if(messageTypeService!.isHeartbeatMessage(messageJson['cmd'])) {
          print("[chatroom] pong");
          return;
        } else if(messageTypeService!.isSimpleMessage(messageJson['cmd']) || messageTypeService!.isClassInfoMessage(messageJson['cmd'])) {
          chatroomContentController.onNewMessage(messageJson);
          return;
        } else if(messageTypeService!.isSelfReadMessage(messageJson['cmd'], messageJson['senderId'])) {
          chatroomContentController.storeSelfCursor(messageJson['conversationId'], messageJson['messageId']);
        }else {
          chatroomContentController.changeRemoteReadCursor(messageJson['conversationId'], messageJson['messageId']);
        }
      },
    );
  }

  Future<void> startHeartbeat() async {
    if(heartbeatTimer != null) {
      return;
    }

    heartbeatTimer = Timer.periodic(Duration(seconds: 30), (Timer t) {
      print("[chatroom] ping");
      chatroomMessageService.sendHeartBeatMessage(userId!);
    });
  }

  void startListenMessageQueue() {
    this.chatroomMessageService.messageQueue.stream.listen((message) {
      chatRoomChannel?.sink.add(message);
    });
  }
}