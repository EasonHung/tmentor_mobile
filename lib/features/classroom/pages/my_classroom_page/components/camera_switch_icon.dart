import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_classroom_media_controller.dart';

class CameraSwitchIcon extends StatelessWidget {
  final MyClassroomMediaController myClassroomMediaController = Get.find<MyClassroomMediaController>();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10.h,
      right: 15.w,
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
    Helper.switchCamera(myClassroomMediaController.localStream!.getVideoTracks()[0]);
  }
}