import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mentor_app_flutter/apiManager/classroomApiManager.dart';
import 'package:mentor_app_flutter/apiManager/classroom_api_dto/res/get_start_time_res.dart';
import 'package:mentor_app_flutter/apiManager/errorCode.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/components/times_up_dialog.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/service/teacher_classroom_message_service.dart';
import 'package:mentor_app_flutter/service/toast_service.dart';

import '../../../dto/clock_on_request.dart';

class TeacherClassroomTimerController extends GetxController {
  TeacherClassroomMessageService messageService;
  Timer? clockOnTimer;
  Timer? classTimer;
  DateTime? startTime;
  Rx<Color> timerBackgroundColor = Colors.grey.obs;
  Rx<String> timerMin = "00".obs;
  Rx<String> timerSec = "00".obs;
  BuildContext currentContext;

  TeacherClassroomTimerController(this.messageService, this.currentContext);

  @override
  void onClose() {
    classTimer?.cancel();
    classTimer = null;
    clockOnTimer?.cancel();
    clockOnTimer = null;
    super.onClose();
  }

  void clearTimer() {
    classTimer?.cancel();
    clockOnTimer?.cancel();
    timerSec.value = "00";
    timerMin.value = "00";
  }

  Future<void> startTimer(String classId, int classTime) async {
    GetStartTimeRes getStartTimeRes = await classroomApiManager.getStartTime(classId);
    if(getStartTimeRes.code != ApiErrorCode.SUCCESS) {
      ToastService.showAlert("計時器出現錯誤，建議重新開始課堂");
      return;
    }
    startTime = getStartTimeRes.startTime!;

    classTimer = Timer.periodic(Duration(seconds: 1), (Timer t)
    {
      DateTime now = DateTime.now();
      Duration passTime = now.difference(startTime!);
      NumberFormat formatter = NumberFormat("00");

      if(classTime - passTime.inMinutes - 1 < 0) {
        timerSec.value = "00";
        timerMin.value = "00";
        TimesUpDialog(currentContext).show();
        clearTimer();
      }

      timerMin.value = formatter.format(classTime - passTime.inMinutes - 1);
      timerSec.value = formatter.format(60 - (passTime.inSeconds % 60));
    });

    ClockOnRequest req = ClockOnRequest(classId, 1);
    clockOnTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      messageService.sendClockOnCmd(jsonEncode(req));
    });
  }
}