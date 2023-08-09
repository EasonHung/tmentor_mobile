import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../local_database/dao/chat_message_content.dart';
import '../../../main.dart';
import '../constants/constants.dart';

class LocalMessageService {
  late String userId;

  LocalMessageService(userId) {
    this.userId = userId;
  }

  Future<void> initMessages(RxList<ChatMessageContent> chatMessageContent, String conversationId) async {
    List<ChatMessageContent>? initChatMessageContentList = await ChatMessageContentDao.findLast(userId, conversationId, initMessageSize);
    for(int i = 0;i < initChatMessageContentList!.length;i++) {
      chatMessageContent.add(initChatMessageContentList[i]);
    }
  }

  void insertMessage(ChatMessageContent newContent) {
    ChatMessageContentDao.insert(store!, newContent);
  }

  Future<void> upsertMessage(dynamic messageJson) async {
    ChatMessageContent newContent = ChatMessageContent(
        null,
        userId,
        messageJson['messageId'],
        messageJson['conversationId'],
        messageJson['message'],
        messageJson['senderId'],
        messageJson['time'],
        userId,
        messageJson['cmd'],
        messageJson['url']);
    ChatMessageContentDao.insertNewOrUpdateCmd(store!, newContent);
  }

  Future<List<ChatMessageContent>> getUnreadMessages(String conversationId, String senderId) async {
    return ChatMessageContentDao.findUnReadByConversationId(store!, userId, conversationId, senderId);
  }

  List<ChatMessageContent> filterOutReadMessage(List<ChatMessageContent> chatMessageContentList, List<String> unreadMessageIds) {
    return chatMessageContentList.where((message) => !unreadMessageIds.contains(message.messageId)).toList();
  }

  void changeToReadStatusByMessageId(String messageId) {
    ChatMessageContent? message;
    try {
      message = ChatMessageContentDao.findByMessageId(store!, userId, messageId);
    } catch(e) {
      print(e);
      return;
    }

    // 教室邀請碼不要變成已讀
    if(message == null || message.cmd == 4)
      return;

    message.cmd = 1;
    ChatMessageContentDao.insertNewOrUpdateCmd(store!, message);
  }
}