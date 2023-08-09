import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../color_constants.dart';
import '../../../../../local_database/dao/chat_message_content.dart';

class SelfReadWordWidget extends StatelessWidget {
  final ChatMessageContent chatMessageContent;

  SelfReadWordWidget(this.chatMessageContent);

  @override
  Widget build(BuildContext context) {
    DateTime localTime = DateTime.parse(chatMessageContent.time!).toLocal(); // 本來就是 local date time format
    NumberFormat formatter = NumberFormat("00");

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Column(
            children: [
              Text(
                "已讀",
                style: TextStyle(
                  color: Colors.grey
                ),
              ),
              Container(
                alignment:Alignment.bottomRight,
                child: Text(formatter.format(localTime.hour) + ":" + formatter.format(localTime.minute)),
              ),
            ]
          ),
          SizedBox(width: 4.w),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(15)
              ),
              child: SelectableText(
                chatMessageContent.messageText!,
                style: TextStyle(fontSize: 18.0, color: Colors.white)
              ),
            ),
          ),
        ],
      ),
    );
  }
}