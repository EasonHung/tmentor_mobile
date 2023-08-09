import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/controller/teacher_classroom_timer_controller.dart';

class ClassTimer extends StatelessWidget {
  final TeacherClassroomTimerController teacherClassroomTimerController = Get.find<TeacherClassroomTimerController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Positioned(
        top: ScreenUtil().setHeight(10),
        left: ScreenUtil().setWidth(5),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
          decoration: BoxDecoration(
              color: teacherClassroomTimerController.timerBackgroundColor.value,
              borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: Row(
            children: [
              Text(
                teacherClassroomTimerController.timerMin.value + " : " + teacherClassroomTimerController.timerSec.value,
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white
                ),
              )
            ],
          ),
        )
    ));
  }

}