import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/controller/teacher_classroom_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/controller/teacher_classroom_timer_controller.dart';

import '../../../../../apiManager/classroom_api_dto/res/get_last_class_info_res.dart';
import '../components/ask_class_accetion_dialog.dart';
import '../service/teacher_classroom_message_service.dart';

class TeacherClassProcessController extends GetxController {
  TeacherClassroomMessageService messageService;
  TeacherClassroomClassController teacherClassroomClassController = Get.find<TeacherClassroomClassController>();
  TeacherClassroomTimerController teacherClassroomTimerController = Get.find<TeacherClassroomTimerController>();
  String? classId;
  String? mentorId;
  BuildContext context;
  ClassInfoRes? classInfo;

  TeacherClassProcessController(this.messageService, this.context);

  void clearClass() {
    mentorId = null;
    classId = null;
    classInfo = null;
  }

  void onRequireClass(dynamic message) {
    // show require dialog
    AskClassAcceptionDialog(context, message, teacherClassroomClassController.teacherClassroomItem.teacherClassroomId!).show();

    classInfo = ClassInfoRes.fromJsonString(message["message"]);
    classId = classInfo?.classId;
    mentorId = message["senderId"];
  }

  Future<void> acceptClass() async {
    messageService.sendAcceptClassCmd(classId!, teacherClassroomClassController.teacherClassroomItem.teacherClassroomId!, mentorId!);
  }

  Future<void> onStartClass() async {
    teacherClassroomTimerController.startTimer(classId!, classInfo!.classTime);
  }

  Future<void> finishClass() async {
    if(classId == null) {
      return;
    }
    await messageService.sendFinishClassCmd(classId!, teacherClassroomClassController.teacherClassroomItem.teacherClassroomId!);
  }
}