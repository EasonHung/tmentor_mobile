import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/chatroom/pages/chatroom_page/controller/chatroom_content_controller.dart';
import 'package:mentor_app_flutter/features/chatroom/pages/chatroom_page/controller/chatroom_input_controller.dart';
import 'package:mentor_app_flutter/features/chatroom/pages/chatroom_page/controller/chatroom_ws_controller.dart';
import 'package:mentor_app_flutter/features/chatroom/pages/chatroom_page/service/chatroom_message_service.dart';
import 'package:mentor_app_flutter/features/chatroom/pages/chatroom_page/chatroom_page.dart';

import '../../service/chatroom_sync_service.dart';

class ChatroomScreen extends StatefulWidget {
  final String conversationId;
  final String remoteId;
  final String nickname;
  final String remoteAvatarUrl;


  ChatroomScreen(this.conversationId, this.remoteId, this.nickname, this.remoteAvatarUrl);

  @override
  State<StatefulWidget> createState() {
    return ChatroomScreenState(conversationId, remoteId, nickname, remoteAvatarUrl);
  }
}

class ChatroomScreenState extends State<ChatroomScreen> with WidgetsBindingObserver {
  ChatroomMessageService chatroomMessageService = ChatroomMessageService();
  String conversationId;
  String nickname;
  String? remoteId;
  String remoteAvatarUrl;

  ChatroomScreenState(this.conversationId, this.remoteId, this.nickname, this.remoteAvatarUrl);

  @override
  void initState() {
    super.initState();
    // stopSyncMessage = true;// static value
    WidgetsBinding.instance.addObserver(this);
    Get.put<ChatroomContentController>(ChatroomContentController(conversationId, remoteId!, chatroomMessageService, nickname, remoteAvatarUrl));
    Get.put<ChatroomInputController>(ChatroomInputController(chatroomMessageService, conversationId, remoteId!));
    Get.put<ChatroomWsController>(ChatroomWsController(chatroomMessageService));
  }

  @override
  void deactivate() {
    // stopSyncMessage = false;
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    Get.delete<ChatroomContentController>();
    Get.delete<ChatroomInputController>();
    Get.delete<ChatroomWsController>();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        onResumeFromBackground();
        break;
      case AppLifecycleState.inactive:
        print('inactive');
        break;
      case AppLifecycleState.paused:
        Get.find<ChatroomWsController>().closeWs();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  Future<void> onResumeFromBackground() async {
    Get.find<ChatroomContentController>().initMessageContent();
    await ChatroomSyncService.syncSpecificConversation(conversationId);
    await Get.find<ChatroomWsController>().initWs();
    Get.find<ChatroomContentController>().refreshReadCursor();
    Get.find<ChatroomContentController>().sendRemoteReadCursor();
    Get.find<ChatroomWsController>().startHeartbeat();
  }

  @override
  Widget build(BuildContext context) {
    return ChatroomPage(nickname);
  }
}