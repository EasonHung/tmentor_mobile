import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentor_app_flutter/features/classroom/pages/classroom_list_page/controller/classroom_list_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/classroom_list_page/controller/classroom_list_ws_controller.dart';
import 'package:get/get.dart';

import '../../../../../color_constants.dart';
import '../../../../../vo/teacher_item.dart';
import '../../../teacher_classroom_screen.dart';

class EnterClassroomDialog {
  final ClassroomListWsController classroomListWsController = Get.find<ClassroomListWsController>();
  final ClassroomListController classroomListController = Get.find<ClassroomListController>();

  void show(BuildContext context, TeacherClassroomItem teacherClassroomItem) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "您即將進入此教室",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Image(width: 50.w, image: AssetImage('assets/images/start_class.png')),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  teacherClassroomItem.classTitle!,
                  style: TextStyle(color: primaryDefault),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  teacherClassroomItem.classTime.toString() +
                      "分鐘 | " +
                      teacherClassroomItem.classPoints.toString() +
                      "點",
                  style: TextStyle(color: primaryDefault),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(90),
                  child: TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        // classroomListWsController.closeWs();
                        await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                          return TeacherClassroomScreen(teacherClassroomItem);
                        }));
                        // classroomListWsController.reconnectWs();
                        // classroomListController.initTeacherClassroomList();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: primaryDefault,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10)))),
                      ),
                      child: Text(
                        "確認進入",
                        style: TextStyle(color: Colors.white),
                      )),
                )
              ],
            ),
          );
        });
  }
}