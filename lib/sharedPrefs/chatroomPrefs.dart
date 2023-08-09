import 'dart:convert';

import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dto/conversation_info.dart';

class ChatroomPrefs {
  static const CONVERSATION_LIST_PREFIX = "conversation-list-";
  static const REMOTE_CURSOR_PREFIX = "remote-cursor-";
  static const SELF_CURSOR_PREFIX = "self-cursor-";

  static Future<String?> getConversationListJsonStr(String userId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(CONVERSATION_LIST_PREFIX + userId);
  }

  static Future<ConversationInfo?> getConversationInfo(String userId, String remoteId) async {
    String? conversationListJsonStr = await getConversationListJsonStr(userId);
    if(conversationListJsonStr == null) {
      return null;
    }

    var resultList = (jsonDecode(conversationListJsonStr) as List);
    for (var i = 0; i < resultList.length; i++) {
      if(resultList[i]['remoteId'] == remoteId) {
        return ConversationInfo(resultList[i]['conversationId'], remoteId, resultList[i]["nickname"], resultList[i]["avatarUrl"]);
      }
    }
    return null;
  }

  static Future<void> putConversationListJsonStr(String userId, String jsonStr) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(CONVERSATION_LIST_PREFIX + userId, jsonStr);
  }

  static Future<void> setRemoteReadCursor(String conversationId, String messageId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userId = await UserPrefs.getUserId();
    pref.setString(REMOTE_CURSOR_PREFIX + userId! + conversationId, messageId);
  }

  static Future<String> getRemoteReadCursor(String conversationId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userId = await UserPrefs.getUserId();
    return pref.getString(REMOTE_CURSOR_PREFIX + userId! + conversationId)?? "";
  }

  static Future<void> setSelfReadCursor(String conversationId, String messageId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userId = await UserPrefs.getUserId();
    pref.setString(SELF_CURSOR_PREFIX + userId! + conversationId, messageId);
  }

  static Future<String> getSelfReadCursor(String conversationId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userId = await UserPrefs.getUserId();
    return pref.getString(SELF_CURSOR_PREFIX + userId! + conversationId)?? "";
  }
}
