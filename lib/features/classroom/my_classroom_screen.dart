import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_class_process_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_classroom_btn_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_classroom_class_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_classroom_media_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_classroom_timer_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_classroom_webrtc_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_classroom_ws_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/service/my_classroom_message_service.dart';
import 'package:mentor_app_flutter/vo/class_setting_info.dart';
import 'package:wakelock/wakelock.dart';

import 'pages/my_classroom_page/components/bottom_btns.dart';
import 'pages/my_classroom_page/components/class_video.dart';

class MyClassroomScreen extends StatefulWidget {
  final ClassSettingInfo classSettingInfo;

  MyClassroomScreen(this.classSettingInfo);

  @override
  State<StatefulWidget> createState() {
    return ClassroomScreenState(classSettingInfo);
  }

}

class ClassroomScreenState extends State<MyClassroomScreen> {
  ClassSettingInfo classSettingInfo;
  MyClassroomMessageService messageService = MyClassroomMessageService();

  ClassroomScreenState(this.classSettingInfo);

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    Get.put<MyClassroomTimerController>(MyClassroomTimerController(messageService, context));
    Get.put<MyClassroomMediaController>(MyClassroomMediaController());
    Get.put<MyClassroomBtnController>(MyClassroomBtnController());
    Get.put<MyClassroomWebrtcController>(MyClassroomWebrtcController(messageService));
    Get.put<MyClassroomClassController>(MyClassroomClassController(messageService, classSettingInfo));
    Get.put<MyClassProcessController>(MyClassProcessController(messageService, context));
    Get.put<MyClassroomWsController>(MyClassroomWsController(context, messageService));
  }

  @override
  void dispose() {
    Wakelock.disable();
    Get.delete<MyClassroomTimerController>();
    Get.delete<MyClassroomMediaController>();
    Get.delete<MyClassroomBtnController>();
    Get.delete<MyClassroomWebrtcController>();
    Get.delete<MyClassroomClassController>();
    Get.delete<MyClassProcessController>();
    Get.delete<MyClassroomWsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
                ClassVideo(),
                BottomBtns()
              ]
          )
      ),
    );
  }
}