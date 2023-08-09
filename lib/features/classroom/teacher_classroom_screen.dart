import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/controller/teacher_class_process_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/controller/teacher_classroom_btn_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/controller/teacher_classroom_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/controller/teacher_classroom_media_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/controller/teacher_classroom_timer_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/controller/teacher_classroom_webrtc_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/controller/teacher_classroom_ws_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/service/teacher_classroom_message_service.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/teacher_classroom_page.dart';
import 'package:wakelock/wakelock.dart';

import '../../vo/teacher_item.dart';

class TeacherClassroomScreen extends StatefulWidget {
  final TeacherClassroomItem teacherClassroomItem;

  TeacherClassroomScreen(this.teacherClassroomItem);

  @override
  State<StatefulWidget> createState() {
    return TeacherClassroomScreenState(teacherClassroomItem);
  }
}

class TeacherClassroomScreenState extends State<TeacherClassroomScreen> {
  final TeacherClassroomItem teacherClassroomItem;
  final TeacherClassroomMessageService teacherClassroomMessageService = TeacherClassroomMessageService();

  TeacherClassroomScreenState(this.teacherClassroomItem);

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    Get.put<TeacherClassroomTimerController>(TeacherClassroomTimerController(teacherClassroomMessageService, context));
    Get.put<TeacherClassroomMediaController>(TeacherClassroomMediaController());
    Get.put<TeacherClassroomBtnController>(TeacherClassroomBtnController());
    Get.put<TeacherClassroomWebrtcController>(TeacherClassroomWebrtcController(teacherClassroomMessageService, teacherClassroomItem.teacherClassroomId!));
    Get.put<TeacherClassroomClassController>(TeacherClassroomClassController(teacherClassroomItem, teacherClassroomMessageService, context));
    Get.put<TeacherClassProcessController>(TeacherClassProcessController(teacherClassroomMessageService, context));
    Get.put<TeacherClassroomWsController>(TeacherClassroomWsController(teacherClassroomMessageService, context));
  }

  @override
  void dispose() {
    Wakelock.disable();
    Get.delete<TeacherClassroomTimerController>();
    Get.delete<TeacherClassroomMediaController>();
    Get.delete<TeacherClassroomBtnController>();
    Get.delete<TeacherClassroomWebrtcController>();
    Get.delete<TeacherClassroomClassController>();
    Get.delete<TeacherClassProcessController>();
    Get.delete<TeacherClassroomWsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: TeacherClassroomPage()
    );
  }
}
