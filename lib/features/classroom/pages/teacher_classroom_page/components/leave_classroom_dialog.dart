import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentor_app_flutter/features/classroom/classroom_screen.dart';
import 'package:mentor_app_flutter/features/classroom/controller/teacher_classroom_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/controller/teacher_class_process_controller.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/controller/teacher_classroom_controller.dart';
import 'package:mentor_app_flutter/features/main_page.dart';
import '../../../../../color_constants.dart';

class LeaveClassroomDialog {
  BuildContext context;

  LeaveClassroomDialog(this.context);

  final TeacherClassProcessController classProcessController = Get.find<TeacherClassProcessController>();
  final TeacherClassroomClassController classroomController = Get.find<TeacherClassroomClassController>();

  void show() {
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
                  "確定要離開教室嗎？\n若有課程進行中，則會視為結束課堂",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(5),),
                Text("我們將扣除你的點數"),
                SizedBox(height: ScreenUtil().setHeight(5),),
                Row(
                  children: [
                    Spacer(),
                    SizedBox(
                      width: ScreenUtil().setWidth(90),
                      child: TextButton(
                          onPressed: () async {
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
                              "取消",
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
                          onPressed: () async {
                            Navigator.pop(context);
                            await classProcessController.finishClass();
                            await classroomController.leaveClassroom();
                            await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                              return MainScreen();
                            }));
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: primaryDefault,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10)))),
                          ),
                          child: Text(
                            "確定",
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