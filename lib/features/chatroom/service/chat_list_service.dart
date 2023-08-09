import 'dart:convert';

import 'package:mentor_app_flutter/apiManager/chatroomApiManager.dart';
import 'package:mentor_app_flutter/sharedPrefs/chatroomPrefs.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';
import 'package:mentor_app_flutter/utils/date_util.dart';
import 'package:mentor_app_flutter/vo/chatroom_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatListService {
  WebSocketChannel channel;
  ChatListService(this.channel);

  Future<List<ChatroomItem>> loadListFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("userId");

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

  Future<List<ChatroomItem>> loadListFromServer() async {
    List<ChatroomItem> conversationList = await chatroomApiManager.getConversationList();
    return conversationList;
  }

  Future<void> updateConversationList(List<ChatroomItem> chatroomItemList) async {
    String? userId = await UserPrefs.getUserId();
    ChatroomPrefs.putConversationListJsonStr(userId!, jsonEncode(chatroomItemList));
  }

  List<ChatroomItem> changeContent(dynamic messageJson, List<ChatroomItem> chatItemList) {
    if (messageJson['cmd'] == 0) {
      ChatroomItem item =
          chatItemList.firstWhere((chatroom) => chatroom.conversationId == messageJson["conversationId"]);
      item.unReadedCount = (int.parse(item.unReadedCount!) + 1).toString();
      item.lastMessage = messageJson["message"];
      item.lastMessageTime = MentorDateUtil.getNowString("00000000000HH:mm");
    } else if (messageJson['cmd'] == 4) {
      ChatroomItem item =
          chatItemList.firstWhere((chatroom) => chatroom.conversationId == messageJson["conversationId"]);
      item.unReadedCount = int.parse(item.unReadedCount!).toString();
      item.lastMessage = "傳送了teacher token，快來領取吧!";
      item.lastMessageTime = MentorDateUtil.getNowString("00000000000HH:mm");
    }

    return chatItemList;
  }

  void sendHeartBeatMessage(WebSocketChannel channel, String userId) {
    channel.sink.add(json.encode({
      "cmd": 5,
      "messageId": "",
      "senderId": userId,
      "conversationId": "",
      "recieverId": "",
      "message": "ping"
    }).codeUnits);
  }
}