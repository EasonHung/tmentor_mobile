import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../color_constants.dart';
import '../controller/teacher_class_process_controller.dart';

class AskClassAcceptionDialog {
  BuildContext context;
  dynamic wsMessage;
  String classroomId;
  final TeacherClassProcessController teacherClassProcessController = Get.find<TeacherClassProcessController>();

  AskClassAcceptionDialog(this.context, this.wsMessage, this.classroomId);

  void show() {
    Map classInfo = json.decode(wsMessage["message"]);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "課程即將開始",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(5),),
              Image(
                width: ScreenUtil().setWidth(50),
                image: AssetImage('assets/images/start_class.png')
              ),
              SizedBox(height: ScreenUtil().setHeight(5),),
              Text("我們將扣除你的點數"),
              SizedBox(height: ScreenUtil().setHeight(5),),
              Text(
                classInfo["classTime"].toString() + "分鐘 | " + classInfo["points"].toString() + "點",
                style: TextStyle(
                  color: primaryDefault
                ),
              ),
              Row(
                children: [
                  Spacer(),
                  SizedBox(
                    width: ScreenUtil().setWidth(90),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
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
                        "拒絕",
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
                          teacherClassProcessController.acceptClass();
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: primaryDefault,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10)))),
                        ),
                        child: Text(
                          "接受",
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
}