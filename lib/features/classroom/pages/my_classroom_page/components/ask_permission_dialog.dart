import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_classroom_ws_controller.dart';
import '../../../../../color_constants.dart';
import '../service/my_classroom_message_service.dart';

class AskPermissionDialog {
  final MyClassroomMessageService messageService;

  AskPermissionDialog(this.messageService);

  void show(dynamic msg, BuildContext context) {
      String askerId = msg["senderId"];
      Map<String, dynamic> userInfo = jsonDecode(msg["message"]);

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, filterSetState)
              {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "有學生想加入教室",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(5),),
                      CircleAvatar(
                          radius: ScreenUtil().setWidth(30),
                          backgroundImage: NetworkImage(userInfo["userAvatar"])
                      ),
                      SizedBox(height: ScreenUtil().setHeight(5),),
                      Text(userInfo["userNickname"]),
                      Row(
                        children: [
                          Spacer(),
                          SizedBox(
                            width: ScreenUtil().setWidth(90),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  messageService.sendRejectCmd(askerId, msg["applicationType"]);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10))),
                                      side: BorderSide(
                                          color: Colors.grey,
                                          width: ScreenUtil().setWidth(1),
                                          style: BorderStyle.solid
                                      )
                                  ),
                                ),
                                child: Text(
                                    "拒絕加入",
                                    style: TextStyle(
                                        color: Colors.grey
                                    )
                                )
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: ScreenUtil().setWidth(90),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  messageService.sendAcceptCmd(askerId, msg["applicationType"]);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: primaryDefault,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10)))),
                                ),
                                child: Text(
                                  "允許",
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                )
                            ),
                          ),
                          Spacer(),
                        ],
                      )
                    ],
                  ),
                );
              }
            );
          }
      );
    }
}