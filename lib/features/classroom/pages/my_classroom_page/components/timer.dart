import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/my_classroom_timer_controller.dart';

class TimerWidget extends StatelessWidget {
  final MyClassroomTimerController myClassroomTimerController = Get.find<MyClassroomTimerController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Positioned(
      top: 10.h,
      left: ScreenUtil().setWidth(5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
        decoration: BoxDecoration(
            color: myClassroomTimerController.timerBackgroundColor.value,
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Row(
          children: [
            Text(
              myClassroomTimerController.timerMin.value + " : " + myClassroomTimerController.timerSec.value,
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