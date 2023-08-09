import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/components/timer.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_classroom_btn_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_classroom_media_controller.dart';

import 'camera_switch_icon.dart';
import 'class_little_video.dart';

class ClassVideo extends StatelessWidget {
  final MyClassroomBtnController myClassroomBtnController = Get.find<MyClassroomBtnController>();
  final MyClassroomMediaController myClassroomMediaController = Get.find<MyClassroomMediaController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: () {
        myClassroomBtnController.showBottomBtns.value = !myClassroomBtnController.showBottomBtns.value;
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
        height: 675.h,
        child: Stack(
          children: [
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: RTCVideoView(
                  myClassroomMediaController.localStreamRenderer.value,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                )
              )
            ),
            CameraSwitchIcon(),
            ClassLittleVideo(),
            TimerWidget()
          ]
        )
      ),
    ));
  }
}