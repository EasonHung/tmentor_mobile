import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/controller/teacher_classroom_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/controller/teacher_classroom_media_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/controller/teacher_classroom_webrtc_controller.dart';

import '../../../../../color_constants.dart';
import '../../../../../components/text_icon_button.dart';
import '../controller/teacher_classroom_btn_controller.dart';
import 'leave_classroom_dialog.dart';

class BottomBtns extends StatelessWidget {
  final TeacherClassroomBtnController teacherClassroomBtnController = Get.find<TeacherClassroomBtnController>();
  final TeacherClassroomClassController teacherClassroomClassController = Get.find<TeacherClassroomClassController>();
  final TeacherClassroomMediaController teacherClassroomMediaController = Get.find<TeacherClassroomMediaController>();
  final TeacherClassroomWebrtcController teacherClassroomWebrtcController = Get.find<TeacherClassroomWebrtcController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => teacherClassroomBtnController.showBottomBtns.value? Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Spacer(),
        TextButton(
          onPressed: () async {
            LeaveClassroomDialog(context).show();
          },
          child: Text(
            "退出",
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil().setWidth(15)
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: redDefault,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(20)))),
          ),
        ),
        Spacer(),
        IconTextButton(
            image: Image.asset(
                teacherClassroomMediaController.microphoneSwitch.value? "assets/images/closed_microphone.png" : "assets/images/opened_microphone.png",
                height: 30.h,
                color: Colors.white
            ),
            label: teacherClassroomMediaController.microphoneSwitch.value? '關閉麥克風':"開啟麥克風",
            labelStyle: TextStyle(
                color: Colors.white
            ),
            onTap: () {
              teacherClassroomMediaController.switchMicroPhoneStatus();
            },
            toolTip: teacherClassroomMediaController.microphoneSwitch.value? '關閉麥克風':"開啟麥克風",
        ),
        Spacer(),
        IconTextButton(
          image: Image.asset(
              teacherClassroomMediaController.cameraSwitch.value? "assets/images/closed_video.png" : "assets/images/open_video.png",
              height: 30.h,
              color: Colors.white
          ),
          label: teacherClassroomMediaController.cameraSwitch.value? '關閉鏡頭':"開啟鏡頭",
          labelStyle: TextStyle(
              color: Colors.white
          ),
          onTap: () {
            teacherClassroomMediaController.switchCameraStatus();
          },
          toolTip: teacherClassroomMediaController.cameraSwitch.value? '關閉鏡頭':"開啟鏡頭",
        ),
        Spacer(),
        IconTextButton(
          image: Image.asset(
            teacherClassroomMediaController.screenSharing.value? "assets/images/stop_sharing.png" : "assets/images/shared_screen.png",
            height: 30.h,
            color: Colors.white,
          ),
          label: teacherClassroomMediaController.screenSharing.value? '停止分享':"分享畫面",
          labelStyle: TextStyle(
              color: Colors.white
          ),
          onTap: () {
            if(teacherClassroomMediaController.screenSharing.value) {
              teacherClassroomWebrtcController.stopScreenSharing();
            } else {
              teacherClassroomWebrtcController.screenSharing();
            }
          },
          toolTip: teacherClassroomMediaController.screenSharing.value? '停止分享':"分享畫面",
        ),
        Spacer()
      ],
    ) : SizedBox.shrink());
  }

}