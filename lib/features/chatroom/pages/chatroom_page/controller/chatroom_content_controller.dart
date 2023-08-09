import 'dart:async';

import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/apiManager/chatroomApiManager.dart';
import 'package:mentor_app_flutter/service/chatroom_sync_service.dart';
import 'package:mentor_app_flutter/sharedPrefs/chatroomPrefs.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';

import '../../../../../local_database/dao/chat_message_content.dart';
import '../../../../../objectbox.g.dart';
import '../../../../../service/notification_service.dart';
import '../../../constants/chat_message_state.dart';
import '../../../constants/chatroom_cmd.dart';
import '../../../service/local_message_service.dart';
import '../service/chatroom_message_service.dart';

class ChatroomContentController extends GetxController {
  final int loadSize = 15;
  ChatroomMessageService chatroomMessageService;
  FlutterListViewController chatScrollController = FlutterListViewController();
  RxList<ChatMessageContent> messageContentList = <ChatMessageContent>[].obs;
  Rx<String> remoteReadCursor = "".obs;
  String? contentCursor = "";
  String conversationId;
  String remoteId;
  String? userId;
  String? userAvatarUrl;
  String remoteAvatarUrl;
  LocalMessageService? localMessageService;
  StreamSubscription<Query<ChatMessageContent>>? contentSubscription;
  String remoteNickname;


  ChatroomContentController(this.conversationId, this.remoteId, this.chatroomMessageService, this.remoteNickname, this.remoteAvatarUrl);

  @override
  onInit() async {
    super.onInit();
    userId = await UserPrefs.getUserId();
    userAvatarUrl = await UserPrefs.getUserAvatarUrl();
    localMessageService = LocalMessageService(userId!);
    await initCursors();
    initMessageContent();
    sendRemoteReadCursor();
    initScrollListener();
    refreshReadCursor();
  }

  @override
  void onClose() {
    contentSubscription?.cancel();
    super.onClose();
  }

  Future<void> initCursors() async {
    remoteReadCursor.value = await ChatroomPrefs.getRemoteReadCursor(conversationId);
    contentCursor = ChatMessageContentDao.findLastMessageIdWithLimit(userId!, conversationId, loadSize);
  }

  Future<void> refreshReadCursor() async {
    String newCursor = await chatroomApiManager.getRemoteCursor(conversationId);
    remoteReadCursor.value = newCursor;
    messageContentList.refresh();
    await ChatroomPrefs.setRemoteReadCursor(conversationId, newCursor);
  }

  void initScrollListener() {
    chatScrollController
    ..addListener(() {
      if(chatScrollController.position.pixels == chatScrollController.position.maxScrollExtent) {
        getMoreMessages();
      }
    });
  }

  void sendRemoteReadCursor() {
    if(messageContentList.isNotEmpty) {
      chatroomMessageService.sendReadMessage(userId!, messageContentList.first.messageId!, conversationId, remoteId);
    }
  }

  void initMessageContent() {
    messageContentList.value = ChatMessageContentDao.findAfterMessageId(conversationId, userId!, contentCursor)!;
    contentSubscription = ChatMessageContentDao.getChatroomContentStream(conversationId, userId!, contentCursor!)?.listen((query) {
      messageContentList.value = query.find();
      if(chatScrollController.hasClients) {
        if(chatScrollController.offset == 0) {
          scrollToEnd();
        }
      }
    });
  }

  Future<void> onNewMessage(dynamic message) async {
    localMessageService!.upsertMessage(message);

    chatroomMessageService.sendReadMessage(userId!, message['messageId'], conversationId, remoteId);

    if(message['conversationId'] != conversationId) {
      NotificationService.chatroomMessageHandler(message);
      return;
    }
  }

  // 全部的 conversation 都可以更新 不只有目前的 chatroom
  Future<void> changeRemoteReadCursor(String conversationId, String messageId) async {
    // check if send cursor is behind current cursor
    String currentCursor = await ChatroomPrefs.getRemoteReadCursor(conversationId);
    if(currentCursor.compareTo(messageId) > 0) {
      return;
    }

    if(conversationId == this.conversationId) {
      this.remoteReadCursor.value = messageId;
      messageContentList.refresh();
    }

    ChatroomPrefs.setRemoteReadCursor(conversationId, messageId);
  }

  Future<void> storeSelfCursor(String conversationId, String messageId) async {
    // check if send cursor is behind current cursor
    String currentCursor = await ChatroomPrefs.getRemoteReadCursor(conversationId);
    if(currentCursor.compareTo(messageId) > 0) {
      return;
    }

    ChatroomPrefs.setSelfReadCursor(conversationId, messageId);
  }

  void getMoreMessages() {
    contentCursor = ChatMessageContentDao.findLastMessageIdBeforeMessageWithLimit(userId!, conversationId, messageContentList.last.messageId!, loadSize);
    messageContentList.value = ChatMessageContentDao.findAfterMessageId(conversationId, userId!, contentCursor)!;
  }

  Future<void> scrollToEnd() async {
    Future.delayed(Duration(milliseconds: 200), () {
      if(chatScrollController.hasClients) {
        chatScrollController.jumpTo(
          chatScrollController.position.minScrollExtent,
        );
      }
    });
  }

  ChatMessageState getMessageState(ChatMessageContent messageContent) {
    if(messageContent.cmd! == ChatroomCmd.CLASS_INFO) {
      if(messageContent.senderId! == userId) {
        return ChatMessageState.SELF_CLASS_TOKEN_MESSAGE;
      } else {
        return ChatMessageState.OTHERS_CLASS_TOKEN_MESSAGE;
      }
    }
    if(messageContent.cmd! == ChatroomCmd.USED_CLASS_INFO) {
      return ChatMessageState.USED_CLASS_TOKEN_MESSAGE;
    }

    if(messageContent.senderId! == userId) {
      if(remoteReadCursor.compareTo(messageContent.messageId!) >= 0) {
        return ChatMessageState.SELF_READ_MESSAGE;
      }
      return ChatMessageState.SELF_SIMPLE_MESSAGE;
    } else {
      if(remoteReadCursor.compareTo(messageContent.messageId!) >= 0) {
        return ChatMessageState.OTHERS_READ_MESSAGE;
      }
      return ChatMessageState.OTHERS_SIMPLE_MESSAGE;
    }
  }
}