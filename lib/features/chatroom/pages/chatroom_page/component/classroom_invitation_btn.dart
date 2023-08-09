import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/chatroom/pages/chatroom_page/controller/chatroom_input_controller.dart';

class ClassroomInvitationBtn extends StatelessWidget {
  final ChatroomInputController chatroomInputController = Get.find<ChatroomInputController>();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: chatroomInputController.sendClassroomInvitation,
      child: Row(
        children: [
          ImageIcon(
              AssetImage("assets/images/myclassroomIcon.png"),
              size: 20.w
          ),
          SizedBox(width: 4.w,),
          Text(
            "教室邀請",
            style: TextStyle(
              fontSize: 16.0
            )
          )
        ]
      )
    );
  }

}