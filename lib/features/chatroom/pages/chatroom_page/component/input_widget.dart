import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/chatroom/pages/chatroom_page/controller/chatroom_content_controller.dart';

import '../../../../../color_constants.dart';
import '../controller/chatroom_input_controller.dart';

class InputWidget extends StatelessWidget {
  final ChatroomInputController chatroomInputController = Get.find<ChatroomInputController>();
  final ChatroomContentController chatroomContentController = Get.find<ChatroomContentController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(10),
        vertical: ScreenUtil().setHeight(10),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0,4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08)
          ),
        ]
      ),
      child: SafeArea(
        child: Row(
          children: [
            SizedBox(width: ScreenUtil().setWidth(0)),
            Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                width: 305.w,
                decoration: BoxDecoration(
                  color: primaryTint,
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        maxLines: null, // auto chang lines
                        onTap: () async {
                          chatroomContentController.scrollToEnd();
                        },
                        controller: chatroomInputController.inputTextController,
                        decoration: InputDecoration(
                          hintText: "請輸入文字內容",
                          border: InputBorder.none
                        ),
                      ),
                    ),
                  ],
                )
            ),
            TextButton(
              child: ImageIcon(
                AssetImage("assets/images/sendIcon.png"),
                size: 25.w
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                minimumSize: Size(25.w, 25.h),
                tapTargetSize: MaterialTapTargetSize.padded,
              ),
              onPressed: chatroomInputController.sendMessage,
            ),
          ],
        )
      ),
    );
  }

}