import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mentor_app_flutter/features/classroom/dto/clock_on_request.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/service/my_classroom_message_service.dart';

import '../../../../../apiManager/classroomApiManager.dart';
import '../../../../../apiManager/classroom_api_dto/res/get_start_time_res.dart';
import '../../../../../apiManager/errorCode.dart';
import '../../../../../service/toast_service.dart';
import '../components/times_up_dialog.dart';

class MyClassroomTimerController extends GetxController {
  MyClassroomMessageService messageService;
  Timer? clockOnTimer;
  Timer? classTimer;
  DateTime? startTime;
  Rx<Color> timerBackgroundColor = Colors.grey.obs;
  Rx<String> timerMin = "00".obs;
  Rx<String> timerSec = "00".obs;
  BuildContext currentContext;

  MyClassroomTimerController(this.messageService, this.currentContext);

  @override
  void onClose() {
    classTimer?.cancel();
    clockOnTimer?.cancel();
    classTimer = null;
    clockOnTimer = null;
    super.onClose();
  }

  void clearTimer() {
    classTimer?.cancel();
    clockOnTimer?.cancel();
    classTimer = null;
    clockOnTimer = null;
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