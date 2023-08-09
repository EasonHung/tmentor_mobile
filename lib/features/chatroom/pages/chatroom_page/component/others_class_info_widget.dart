import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../color_constants.dart';
import '../controller/chatroom_input_controller.dart';
import 'package:get/get.dart';

class OthersClassInfoWidget extends StatelessWidget {
  final String nickname;
  final String messageId;
  final String? url;
  final bool used;
  final ChatroomInputController chatroomInputController = Get.find<ChatroomInputController>();

  OthersClassInfoWidget(this.nickname, this.messageId, this.url, this.used);

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
              Container(
                decoration: BoxDecoration(
                  color: black400.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(15)
                ),
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      nickname + "邀請您加入教室",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16.0, color: Colors.black)
                    ),
                    SizedBox(height: 4.h,),
                    used? buildUsedText() : buildBtn()
                  ]
                )
              ),
            ],
          ),
        ]
      )
    );
  }

  Widget buildUsedText() {
    return Text(
      "此申請已使用過囉",
      textAlign: TextAlign.center,
    );
  }

  Widget buildBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () {chatroomInputController.neglectInvitation(messageId);},
          style: TextButton.styleFrom(
              fixedSize: Size(118.5.w, 30.h),
              padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setHeight(5), horizontal: ScreenUtil().setWidth(10)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().radius(15)),
              ),
              backgroundColor: black500
          ),
          child: Text(
            "忽略",
            style:
            TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(16)),
          )
        ),
        SizedBox(width: 8.w,),
        TextButton(
          onPressed: () {
            chatroomInputController.enrollClassroom(url!, messageId);
          },
          style: TextButton.styleFrom(
              fixedSize: Size(118.5.w, 30.h),
              padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setHeight(5), horizontal: ScreenUtil().setWidth(10)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().radius(15)),
              ),
              backgroundColor: primaryDefault
          ),
          child: Text(
            "接受",
            style:
            TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(16)),
          )
        )
      ],
    );
  }
}