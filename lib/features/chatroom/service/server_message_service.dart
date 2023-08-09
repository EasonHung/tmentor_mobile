
import 'package:mentor_app_flutter/features/chatroom/service/message_type_service.dart';

import '../../../apiManager/chatroomApiManager.dart';
import '../../../local_database/dao/chat_message_content.dart';
import '../constants/chat_message_state.dart';

class ServerMessageService {
  late String userId;
  late MessageTypeService messageTypeService;

  ServerMessageService(userId, channel) {
    this.userId = userId;
    this.messageTypeService = MessageTypeService(userId);
  }

  Future<List<String>> getUnreadMessageIds(String conversationId, String remoteId) async {
    return await chatroomApiManager.getUnreadMessageIds(conversationId, remoteId);
  }
}