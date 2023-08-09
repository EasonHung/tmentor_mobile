import 'package:dio/dio.dart';
import 'package:mentor_app_flutter/apiManager/abstractApiManager.dart';
import 'package:mentor_app_flutter/apiManager/errorCode.dart';
import 'package:mentor_app_flutter/config/server_url.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../vo/chatroom_item.dart';

class ChatroomApiManager extends AbstractApiManager {
  ChatroomApiManager({required String apiUrl}) : super(apiUrl: apiUrl);

  Future<dynamic> addConversation(String targetId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userId = pref.getString("userId");
    List<String?> participants = [userId, targetId];
    var formData = {"userId": userId, "type": 0, "participants": participants};

    Response? response =
        await handelPost("/chatroom/info/conversation/new", formData);

    return response?.data ?? "";
  }

  Future<List<ChatroomItem>> getConversationList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userId = pref.getString("userId");
    Response response = await handelGet("/chatroom/info/conversation/list?userId=" + userId!);

    if (response.statusCode == 200) {
      return response.data
          .map<ChatroomItem>((v) => ChatroomItem(
              v['conversationId'],
              v["userInfo"]["avatorUrl"],
              v["userInfo"]["nickname"],
              v["unReadedCount"].toString(),
              v['type'],
              v["userInfo"]["userId"],
              v['lastMessage'],
              v['lastMessageTime']))
          .toList();
    } else {
      throw Exception('Failed to load chat list');
    }
  }

  Future<dynamic> getSyncMessages(String userId, String conversationId, String deviceId, String lastMessageId) async {
    Response? response = await handelGet(
        "/chatroom/info/conversation/sync/message?userId=$userId&conversationId=$conversationId&deviceId=$deviceId&lastMessageId=$lastMessageId");

    if(response?.data["code"] != ApiErrorCode.SUCCESS) {
      throw new Exception("error get sync message, conversationId: " + conversationId);
    }

    return response?.data["data"];
  }

  Future<void> postBatchReadedMessages(String userId, String deviceId, List<String> messageIds) async {
    var postData = {"deviceId": deviceId, "userId": userId, "readedMessageIds": messageIds};
    await handelPost("/chatroom/info/readedMessage/batch/update", postData);
  }

  Future<List<String>> getUnreadMessageIds(String conversationId, String userId) async {
    String subPath = "/chatroom/info/unreadMessage/one?userId=$userId&conversationId=$conversationId";
    Response response = await handelGet(subPath);

    return response.data.map<String>((v) => v["messageId"]).toList();
  }

  Future<String> getRemoteCursor(String conversationId) async {
    String? userId = await UserPrefs.getUserId();
    String subPath = "/chatroom/info/readCursor/another?userId=$userId&conversationId=$conversationId";
    Response response = await handelGet(subPath);

    return response.data["data"];
  }

  Future<String> getSelfCursor(String conversationId) async {
    String? userId = await UserPrefs.getUserId();
    String subPath = "/chatroom/info/readCursor/self?userId=$userId&conversationId=$conversationId";
    Response response = await handelGet(subPath);

    return response.data["data"];
  }
}

final chatroomApiManager = ChatroomApiManager(apiUrl: EnvSetting.CHATROOM_SERVER_IP);
