import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../vo/teacher_item.dart';
import '../components/reject_dialog.dart';
import '../components/waiting_access_dialog.dart';
import '../service/teacher_classroom_message_service.dart';

class TeacherClassroomClassController extends GetxController {
  TeacherClassroomItem teacherClassroomItem;
  TeacherClassroomMessageService messageService;
  BuildContext currentContext;
  String? classId;

  TeacherClassroomClassController(this.teacherClassroomItem, this.messageService, this.currentContext);

  @override
  onInit() async {
    super.onInit();
  }

  String getTeacherClassroomId() {
    return teacherClassroomItem.teacherClassroomId!;
  }

  void joinRoom(dynamic message) {
    if (message["classroomId"] == teacherClassroomItem.teacherClassroomId) {
      String classroomToken = message['message'];
      messageService.sendJoinRoomCmd(classroomToken, teacherClassroomItem.teacherClassroomId!, message["senderId"]);
    }
  }

  void beingRejected() {
    Navigator.of(currentContext).pop();
    RejectDialog(currentContext).show();
  }

  Future<void> leaveClassroom() async {
    messageService.sendLeaveRoomCmd(teacherClassroomItem.teacherClassroomId!);
  }
}