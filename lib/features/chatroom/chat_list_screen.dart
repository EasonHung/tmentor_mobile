import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/chatroom/pages/chat_list_page/chat_list_page.dart';
import 'package:mentor_app_flutter/features/chatroom/pages/chat_list_page/controller/chat_list_content_controller.dart';
import 'package:mentor_app_flutter/features/chatroom/pages/chat_list_page/controller/chat_list_notification_controller.dart';
import 'package:mentor_app_flutter/features/chatroom/pages/chat_list_page/controller/chat_list_ws_controller.dart';
import 'package:mentor_app_flutter/features/chatroom/pages/chatroom_page/controller/chatroom_ws_controller.dart';

import '../../service/chatroom_sync_service.dart';

class ChatListScreen extends StatefulWidget {

  @override
  State<ChatListScreen> createState() {
    return ChatListScreenState();
  }
  
}

class ChatListScreenState extends State<ChatListScreen> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Get.put<ChatListContentController>(ChatListContentController());
    Get.put<ChatListNotificationController>(ChatListNotificationController());
    Get.put<ChatListWsController>(ChatListWsController());
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Get.delete<ChatListContentController>();
    Get.delete<ChatListNotificationController>();
    Get.delete<ChatListWsController>();
    super.dispose();
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
        if(Get.isRegistered<ChatroomWsController>())
          return;
        Get.find<ChatListWsController>().closeWs();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  Future<void> onResumeFromBackground() async {
    await ChatroomSyncService.syncChatMessages();
    if(Get.isRegistered<ChatroomWsController>())
      return;
    Get.find<ChatListWsController>().initWs();
    Get.find<ChatListContentController>().reloadChatList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ChatListPage()
    );
  }
}