import 'dart:convert';

import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';

import '../../../../../apiManager/chatroomApiManager.dart';
import '../../../../../local_database/dao/chat_message_content.dart';
import '../../../../../sharedPrefs/chatroomPrefs.dart';
import '../../../../../vo/chatroom_item.dart';

class ChatListContentService {
  Future<List<ChatroomItem>> loadListFromLocal() async {
    String? userId = await UserPrefs.getUserId();

    final getConversationListRes = await ChatroomPrefs.getConversationListJsonStr(userId!);
    if (getConversationListRes != null && getConversationListRes != "") {
      List<ChatroomItem> conversationList = [];
      var resultList = (jsonDecode(getConversationListRes) as List);
      for (var i = 0; i < resultList.length; i++) {
        int count = int.parse(resultList[i]['unReadedCount']);
        conversationList.add(ChatroomItem(
            resultList[i]['conversationId'],
            resultList[i]["avatarUrl"],
            resultList[i]["nickname"],
            count.toString(),
            resultList[i]['type'],
            resultList[i]["remoteId"],
            resultList[i]['lastMessage'],
            resultList[i]['lastMessageTime']));
      }
      return conversationList;
    }

    return [];
  }

  static Future<List<ChatroomItem>> loadListFromServer() async {
    String? userId = await UserPrefs.getUserId();
    List<ChatroomItem> conversationList = await chatroomApiManager.getConversationList();

    List<ChatroomItem> chatroomItemList = [];
    for(ChatroomItem chatroomItem in conversationList) {
      String readCursor = await ChatroomPrefs.getSelfReadCursor(chatroomItem.conversationId!);
      List<ChatMessageContent>? chatMessageList = ChatMessageContentDao.findAfterMessageId(chatroomItem.conversationId!, userId!, readCursor);
      ChatMessageContent? lastMessage = ChatMessageContentDao.findLastOne(userId, chatroomItem.conversationId!);
      chatroomItemList.add(ChatroomItem(
          chatroomItem.conversationId!,
          chatroomItem.avatarUrl!,
          chatroomItem.nickname!,
          chatMessageList == null? "0" : chatMessageList.length.toString(),
          chatroomItem.type!,
          chatroomItem.remoteId!,
          lastMessage == null? "" : lastMessage.messageText!,
          lastMessage == null? "" : lastMessage.time!));
    }

    chatroomItemList.sort((chatroomItemA, chatroomItemB) {
      return chatroomItemB.lastMessageTime!.compareTo(chatroomItemA.lastMessageTime!);
    });
    return chatroomItemList;
  }

  static Future<void> updateConversationList(List<ChatroomItem> chatroomItemList) async {
    String? userId = await UserPrefs.getUserId();
    ChatroomPrefs.putConversationListJsonStr(userId!, jsonEncode(chatroomItemList));
  }

  static Future<void> updateSelfCursor() async {
    List<ChatroomItem> conversationList = await chatroomApiManager.getConversationList();

    for(ChatroomItem chatroomItem in conversationList) {
      String selfCursor = await chatroomApiManager.getSelfCursor(chatroomItem.conversationId!);
      ChatroomPrefs.setSelfReadCursor(chatroomItem.conversationId!, selfCursor);
    }
  }
}