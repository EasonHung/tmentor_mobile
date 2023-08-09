import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';

import '../controller/teacher_classroom_btn_controller.dart';
import '../controller/teacher_classroom_media_controller.dart';
import 'camera_switch_icon.dart';
import 'class_timer.dart';
import 'little_video.dart';

class TeacherClassVideo extends StatelessWidget {
  final TeacherClassroomMediaController teacherClassroomMediaController = Get.find<TeacherClassroomMediaController>();
  final TeacherClassroomBtnController teacherClassroomBtnController = Get.find<TeacherClassroomBtnController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: () {
        teacherClassroomBtnController.changeBottomBtnStatus();
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
          height: 675.h,
          child: Stack(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: RTCVideoView(
                    teacherClassroomMediaController.remoteStreamRenderer.value,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  )
                )
              ),
              CameraSwitchIcon(),
              LittleVideo(),
              ClassTimer()
            ]
          )
      ),
    ));
  }

  double getBottomPadding() {
    if(ScreenUtil().screenHeight > 900) {
      return ScreenUtil().setHeight(115);
    } else {
      return ScreenUtil().setHeight(75);
    }
  }
}