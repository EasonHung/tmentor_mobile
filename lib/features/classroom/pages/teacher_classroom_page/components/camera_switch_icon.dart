import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/controller/teacher_classroom_media_controller.dart';


class CameraSwitchIcon extends StatelessWidget {
  final TeacherClassroomMediaController classroomMediaController = Get.find<TeacherClassroomMediaController>();

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: ScreenUtil().setHeight(20),
        right: ScreenUtil().setWidth(15),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: ImageIcon(
                  AssetImage("assets/images/switch_camera.png"),
                  color: Colors.black,
                ),
                onPressed: () {
                  switchCamera();
                },
              ),
            ),
          ],
        )
    );
  }

  switchCamera() {
    Helper.switchCamera(classroomMediaController.localStream!.getVideoTracks()[0]);
  }

}