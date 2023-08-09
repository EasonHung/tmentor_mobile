import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../color_constants.dart';
import '../../../../../local_database/dao/chat_message_content.dart';
import '../../../constants/chatroom_cmd.dart';

class OthersWordWidget extends StatelessWidget {
  final ChatMessageContent content;
  final ChatMessageContent? nextContent;
  final String? remoteAvatarUrl;

  OthersWordWidget(this.content, this.nextContent, this.remoteAvatarUrl);

  @override
  Widget build(BuildContext context) {
    DateTime localTime = DateTime.parse(content.time!).toLocal(); // 本來就是 local date time format
    NumberFormat formatter = NumberFormat("00");

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          showAvatar(content, nextContent)? buildAvatar(remoteAvatarUrl) : SizedBox(width: ScreenUtil().setWidth(46)),
          SizedBox(width: 8),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: black400.withOpacity(0.7),
                borderRadius: BorderRadius.circular(15)
              ),
              padding: EdgeInsets.all(10.0),
              child: SelectableText(content.messageText!,
                style: TextStyle(fontSize: 18.0, color: Colors.black)),
            ),
          ),
          SizedBox(width: 4.w,),
          Container(
            alignment:Alignment.bottomRight,
            child: Text(formatter.format(localTime.hour) + ":" + formatter.format(localTime.minute)),// hh:mm
          ),
        ],
      ),
    );
  }

  bool showAvatar(ChatMessageContent content, ChatMessageContent? nextContent) {
    // nextContent: 上方的對話框
    if(nextContent == null)
      return true;
    if(nextContent.senderId != content.senderId)
      return true;
    if(nextContent.cmd == ChatroomCmd.CLASS_INFO || nextContent.cmd == ChatroomCmd.USED_CLASS_INFO)
      return true;
    DateTime contentTime = DateTime.parse(content.time!.substring(0, 19));
    DateTime nextContentTime = DateTime.parse(nextContent.time!.substring(0, 19));
    return !(contentTime.difference(nextContentTime).inMinutes < 1);
  }

  Widget buildAvatar(String? avatorUrl) {
    if(avatorUrl == "" || avatorUrl == null)
      return Icon(Icons.person, size: 32);
    else
      return CircleAvatar(
        radius: ScreenUtil().setWidth(23),
        backgroundImage: NetworkImage(avatorUrl),
      );
  }
}