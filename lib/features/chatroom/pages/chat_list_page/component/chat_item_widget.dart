import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mentor_app_flutter/features/chatroom/pages/chat_list_page/controller/chat_list_content_controller.dart';

import '../../../../../color_constants.dart';
import '../../../chatroom_screen.dart';
import '../controller/chat_list_notification_controller.dart';
import '../controller/chat_list_ws_controller.dart';

class ChatItemWidget extends StatelessWidget {
  final String avator;
  final String nickName;
  final String? lastMessage;
  final String unReadedCount;
  final String conversationId;
  final String remoteId;
  final String lastMessageTime;

  ChatItemWidget(
      this.avator,
      this.nickName,
      this.lastMessage,
      this.unReadedCount,
      this.conversationId,
      this.remoteId,
      this.lastMessageTime,
      );

  @override
  Widget build(BuildContext context) {
    DateTime? localTime = lastMessageTime == ""? null : DateTime.parse(lastMessageTime).toLocal();
    String lastMessageStr = lastMessage == null? "" : lastMessage!;
    NumberFormat formatter = NumberFormat("00");

    return InkWell(
      onTap: () async {
        Get.find<ChatListWsController>().closeWs();
        await Get.to(
          ChatroomScreen(conversationId, remoteId, nickName, avator),
        );
        Get.find<ChatListWsController>().initWs();
        Get.find<ChatListContentController>().reloadChatList();
      },
      child:Padding(
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: ScreenUtil().radius(35),
              backgroundImage: avator == null? AssetImage("assets/images/null_avatar.png") as ImageProvider : NetworkImage(avator)
            ),
            SizedBox(width: ScreenUtil().setWidth(10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nickName,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(18),
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  SizedBox(height: 8),
                  Opacity(
                    opacity: 0.64,
                    child: Text(
                      lastMessageStr,
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(16)
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  )
                ],
              )
            ),
            SizedBox(width: 10.w,),
            Column(
              children: [
                Opacity(
                    opacity: 0.64,
                    child: Text(localTime == null? "" : formatter.format(localTime.hour) + ":" + formatter.format(localTime.minute))
                ),
                SizedBox(height: 12.h),
                buildUnreadedCountWidget()
              ],
            )

          ]
        )
      )
    );
  }

  Widget buildUnreadedCountWidget() {
    return unReadedCount == "0"? SizedBox.shrink():Container(
      // width: ScreenUtil().setWidth(22),
      // height: ScreenUtil().setWidth(22),
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(7), vertical: ScreenUtil().setHeight(3)),
      child: Center(
        child: Text(this.unReadedCount,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(16),
            color: Colors.white
          ),
        )
      ),
      decoration: BoxDecoration(
        color: primaryLight,
        shape: int.parse(unReadedCount) > 9? BoxShape.rectangle : BoxShape.circle,
        borderRadius: int.parse(unReadedCount) > 9? BorderRadius.all(Radius.circular(ScreenUtil().setWidth(13))) : null,
      ),
    );
  }

}