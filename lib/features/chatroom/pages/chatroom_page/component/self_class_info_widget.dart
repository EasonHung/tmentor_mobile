import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../color_constants.dart';
import '../../../../../local_database/dao/chat_message_content.dart';

class SelfClassInfoWidget extends StatelessWidget {
  final String? userAvatarUrl;
  final String? remoteAvatarUrl;
  final String? remoteId;
  final ChatMessageContent content;

  SelfClassInfoWidget(this.userAvatarUrl, this.remoteAvatarUrl, this.remoteId, this.content);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Column(
        children:[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: black400.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "已為您送出教室邀請",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: TextStyle(fontSize: 16.0, color: Colors.black)
                  ),
                ),
              ),
            ],
          ),
        ]
      )
    );
  }

  Widget buildAvatar(String? avatarUrl) {
    if(avatarUrl == "" || avatarUrl == null)
      return Icon(Icons.person, size: 32);
    else
      return CircleAvatar(
        radius: ScreenUtil().setWidth(23),
        backgroundImage: NetworkImage(avatarUrl),
      );
  }

}