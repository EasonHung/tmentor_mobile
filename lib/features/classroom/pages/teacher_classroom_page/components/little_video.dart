import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';

import '../controller/teacher_classroom_media_controller.dart';

class LittleVideo extends StatelessWidget {
  final TeacherClassroomMediaController teacherClassroomMediaController = Get.find<TeacherClassroomMediaController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() =>Positioned(
      bottom: ScreenUtil().setHeight(10),
      right: ScreenUtil().setWidth(0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
        width: ScreenUtil().setWidth(110),
        height: ScreenUtil().setHeight(180),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20)),
          child: RTCVideoView(
            teacherClassroomMediaController.localStreamRenderer.value,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
          )
        ),
      )
    ));
  }

}