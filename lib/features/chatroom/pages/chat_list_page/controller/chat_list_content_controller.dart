import 'package:get/get.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';

import '../../../../../service/chatroom_sync_service.dart';
import '../../../../../utils/date_util.dart';
import '../../../../../vo/chatroom_item.dart';
import '../service/chat_list_content_service.dart';

class ChatListContentController extends GetxController {
  ChatListContentService chatListContentService = ChatListContentService();
  RxList<ChatroomItem> chatItemList = <ChatroomItem>[].obs;
  String? userId;

  @override
  onInit() async {
    super.onInit();
    userId = await UserPrefs.getUserId();
    chatItemList.value = await chatListContentService.loadListFromLocal();
    await ChatListContentService.updateSelfCursor();
    List<ChatroomItem> newChatItemList = await ChatListContentService.loadListFromServer();
    chatItemList.value = newChatItemList;
    ChatListContentService.updateConversationList(chatItemList);
  }

  Future<void> reloadChatList() async {
    chatItemList.value = await ChatListContentService.loadListFromServer();
    ChatListContentService.updateConversationList(chatItemList);
  }

  void changeContent(dynamic messageJson) {
    if (messageJson['cmd'] == 0) {
      int index = chatItemList.indexWhere((chatroom) => chatroom.conversationId == messageJson["conversationId"]);
      ChatroomItem item = chatItemList.elementAt(index);
      if(messageJson['senderId'] != userId) {
        item.unReadedCount = (int.parse(item.unReadedCount!) + 1).toString();
      }
      item.lastMessage = messageJson["message"];
      item.lastMessageTime = messageJson["time"];
      chatItemList.removeAt(index);
      chatItemList.insert(0, item);
      ChatListContentService.updateConversationList(chatItemList);
    } else if (messageJson['cmd'] == 4) {
      int index = chatItemList.indexWhere((chatroom) => chatroom.conversationId == messageJson["conversationId"]);
      ChatroomItem item = chatItemList.elementAt(index);
      item.unReadedCount = (int.parse(item.unReadedCount!) + 1).toString();
      item.lastMessage = messageJson["message"];
      item.lastMessageTime = messageJson["time"];
      chatItemList.removeAt(index);
      chatItemList.insert(0, item);
      ChatListContentService.updateConversationList(chatItemList);
    }
  }
}