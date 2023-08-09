import '../apiManager/chatroomApiManager.dart';
import '../features/chatroom/pages/chat_list_page/service/chat_list_content_service.dart';
import '../local_database/dao/chat_message_content.dart';
import '../main.dart';
import '../sharedPrefs/userPrefs.dart';
import '../vo/chatroom_item.dart';

class ChatroomSyncService {
  ChatListContentService chatListContentService = ChatListContentService();

  static Future<void> syncChatMessages() async {
    // if (stopSyncMessage) return;
    userId = await UserPrefs.getUserId();
    if (userId == null) {
      return;
    }
    List<ChatroomItem> conversationList = await chatroomApiManager.getConversationList();
    for (int j = 0; j < conversationList.length; j++) {
      String? conversationId = conversationList[j].conversationId;
      String? lastMessageId;
      List<ChatMessageContent>? initChatMessageContentList = await ChatMessageContentDao.findLast(userId!, conversationId!, 1);
      if(initChatMessageContentList == null || initChatMessageContentList.isEmpty) {
        lastMessageId = "";
      } else {
        lastMessageId = initChatMessageContentList[0].messageId!;
      }

      String? deviceId = await getDeviceId();
      var response;
      try {
        response = await chatroomApiManager.getSyncMessages(userId!, conversationId, deviceId!, lastMessageId);
      } catch(e) {
        print(e);
        return;
      }

      var resultList = (response["messages"] as List);
      for (int i = 0; i < resultList.length; i++) {
        ChatMessageContent newContent = ChatMessageContent(
            null,
            userId!,
            resultList[i]['messageId'],
            resultList[i]['conversationId'],
            resultList[i]['message'],
            resultList[i]['senderId'],
            resultList[i]['time'],
            userId!,
            resultList[i]['cmd'],
            resultList[i]['url']
        );
        ChatMessageContentDao.insertNewOrUpdateCmd(store!, newContent);
      }
    }

    syncChatList();
  }

  static Future<void> syncSpecificConversation(String conversationId) async {
    userId = await UserPrefs.getUserId();
    if (userId == null) {
      return;
    }
    String? lastMessageId;
    List<ChatMessageContent>? initChatMessageContentList = await ChatMessageContentDao.findLast(userId!, conversationId!, 1);
    if(initChatMessageContentList == null || initChatMessageContentList.isEmpty) {
      lastMessageId = "";
    } else {
      lastMessageId = initChatMessageContentList[0].messageId!;
    }

    String? deviceId = await getDeviceId();
    var response;
    try {
      response = await chatroomApiManager.getSyncMessages(userId!, conversationId, deviceId!, lastMessageId);
    } catch(e) {
      throw e;
    }

    var resultList = (response["messages"] as List);
    for (int i = 0; i < resultList.length; i++) {
      ChatMessageContent newContent = ChatMessageContent(
          null,
          userId!,
          resultList[i]['messageId'],
          resultList[i]['conversationId'],
          resultList[i]['message'],
          resultList[i]['senderId'],
          resultList[i]['time'],
          userId!,
          resultList[i]['cmd'],
          resultList[i]['url']
      );
      ChatMessageContentDao.insertNewOrUpdateCmd(store!, newContent);
    }

    syncChatList();
  }

  static Future<void> syncChatList() async {
    await ChatListContentService.updateSelfCursor();
    List<ChatroomItem> newChatItemList = await ChatListContentService.loadListFromServer();
    ChatListContentService.updateConversationList(newChatItemList);
  }
}