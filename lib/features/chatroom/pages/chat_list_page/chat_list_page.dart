import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';
import 'component/chat_item_widget.dart';
import 'controller/chat_list_content_controller.dart';

class ChatListPage extends StatelessWidget {
  final ChatListContentController chatListContentController = Get.find<ChatListContentController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => SafeArea(
      child: Column(
        children: [
          buildTitle(),
          buildDivider(),
          Expanded(
            child: ListView.builder(
              itemCount: chatListContentController.chatItemList.length,
              itemBuilder: (context, index) {
                return ChatItemWidget(chatListContentController.chatItemList[index].avatarUrl!, chatListContentController.chatItemList[index].nickname!, chatListContentController.chatItemList[index].lastMessage,
                    chatListContentController.chatItemList[index].unReadedCount!, chatListContentController.chatItemList[index].conversationId!, chatListContentController.chatItemList[index].remoteId!, chatListContentController.chatItemList[index].lastMessageTime!);
              },
            )
          )
        ]
      )
    ));
  }

  Widget buildTitle() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "聊天室",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(20),
              fontWeight: FontWeight.bold,
              color: primaryDark
            ),
          )
        ],
      )
    );
  }

  Widget buildDivider() {
    return SizedBox(
      height: ScreenUtil().setHeight(1),
      width: ScreenUtil().screenWidth,
      child: DecoratedBox(
        decoration: BoxDecoration(color: black400),
      )
    );
  }

}