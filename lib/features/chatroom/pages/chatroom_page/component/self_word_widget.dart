import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mentor_app_flutter/color_constants.dart';
import 'package:mentor_app_flutter/local_database/dao/chat_message_content.dart';

class SelfWordWidget extends StatelessWidget {
  final ChatMessageContent chatMessageContent;

  SelfWordWidget(this.chatMessageContent);

  @override
  Widget build(BuildContext context) {
    DateTime localTime = DateTime.parse(chatMessageContent.time!).toLocal();
    NumberFormat formatter = NumberFormat("00");

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            alignment:Alignment.bottomRight,
            child: Text(formatter.format(localTime.hour) + ":" + formatter.format(localTime.minute)),// hh:mm
          ),
          SizedBox(width: 4.w),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                  color: primaryDefault,
                  borderRadius: BorderRadius.circular(15)
              ),
              padding: EdgeInsets.all(10.0),
              child: SelectableText(chatMessageContent.messageText!,
                  style: TextStyle(fontSize: 18.0, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

}