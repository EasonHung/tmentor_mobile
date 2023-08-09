import 'package:flutter/material.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/chatroom/pages/chatroom_page/component/self_read_word_widget.dart';
import 'package:mentor_app_flutter/features/chatroom/pages/chatroom_page/component/self_word_widget.dart';
import 'package:mentor_app_flutter/features/chatroom/pages/chatroom_page/controller/chatroom_content_controller.dart';

import '../../../../../local_database/dao/chat_message_content.dart';
import '../../../constants/chat_message_state.dart';
import 'others_class_info_widget.dart';
import 'self_class_info_widget.dart';
import 'others_word_widget.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatroomContentController chatroomContentController = Get.find<ChatroomContentController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() => FlutterListView(
        reverse: true,
        controller: chatroomContentController.chatScrollController,
        delegate: FlutterListViewDelegate((context, index) {
            ChatMessageContent? nextContent;
            ChatMessageContent content = chatroomContentController.messageContentList[index];
            if(index < chatroomContentController.messageContentList.length - 1)
              nextContent = chatroomContentController.messageContentList[index + 1];
            else
              nextContent = null;

            if(chatroomContentController.getMessageState(content) == ChatMessageState.SELF_SIMPLE_MESSAGE){
              return SelfWordWidget(content);
            } else if(chatroomContentController.getMessageState(content) == ChatMessageState.OTHERS_SIMPLE_MESSAGE) {
              return OthersWordWidget(content, nextContent, chatroomContentController.remoteAvatarUrl);
            } else if(chatroomContentController.getMessageState(content) == ChatMessageState.OTHERS_READ_MESSAGE) {
              return OthersWordWidget(content, nextContent, chatroomContentController.remoteAvatarUrl);
            } else if(chatroomContentController.getMessageState(content) == ChatMessageState.SELF_READ_MESSAGE) {
              return SelfReadWordWidget(content);
            } else if(chatroomContentController.getMessageState(content) == ChatMessageState.OTHERS_CLASS_TOKEN_MESSAGE) {
              return OthersClassInfoWidget(chatroomContentController.remoteNickname, content.messageId!, content.url, false);
            } else if(chatroomContentController.getMessageState(content) == ChatMessageState.USED_CLASS_TOKEN_MESSAGE) {
              return OthersClassInfoWidget(chatroomContentController.remoteNickname, content.messageId!, null, true);
            } else if(chatroomContentController.getMessageState(content) == ChatMessageState.SELF_CLASS_TOKEN_MESSAGE) {
              return SelfClassInfoWidget(chatroomContentController.userAvatarUrl, chatroomContentController.remoteAvatarUrl, chatroomContentController.remoteId, content);
            } else {
              return SelfWordWidget(content);
            }
          },
          childCount: chatroomContentController.messageContentList.length,
          firstItemAlign: FirstItemAlign.end,
          keepPosition: true,
          initOffsetBasedOnBottom: true,
          onIsPermanent: (key) => true,
          onItemKey: (index) {return chatroomContentController.messageContentList[index].messageId.toString();}
        )
      )),
    );
  }
  
}