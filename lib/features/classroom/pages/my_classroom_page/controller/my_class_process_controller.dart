import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/apiManager/classroomApiManager.dart';
import 'package:mentor_app_flutter/apiManager/classroom_api_dto/res/reimburse_class_res.dart';
import 'package:mentor_app_flutter/apiManager/errorCode.dart';
import 'package:mentor_app_flutter/features/classroom/constants/ClassStatus.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_classroom_btn_controller.dart';
import 'package:mentor_app_flutter/service/toast_service.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';

import '../../../../../apiManager/classroom_api_dto/res/get_last_class_info_res.dart';
import '../../../../../apiManager/classroom_api_dto/res/init_class_res.dart';
import '../components/start_class_dialog.dart';
import '../service/my_classroom_message_service.dart';
import 'my_classroom_class_controller.dart';
import 'my_classroom_timer_controller.dart';

class MyClassProcessController extends GetxController {
  BuildContext currentContext;
  MyClassroomMessageService messageService;
  String? studentId;
  String? classroomId;
  String? classId;
  MyClassroomClassController classroomClassController = Get.find<MyClassroomClassController>();
  MyClassroomBtnController classroomBtnController = Get.find<MyClassroomBtnController>();
  MyClassroomTimerController myClassroomTimerController = Get.find<MyClassroomTimerController>();
  ClassInfoRes? lastClassInfo;

  MyClassProcessController(this.messageService, this.currentContext);

  @override
  onInit() async {
    super.onInit();
    String? userId = await UserPrefs.getUserId();
    classroomId = await classroomApiManager.getClassroomId(userId!);
  }

  void clearClass() {
    studentId = null;
    classId = null;
    lastClassInfo = null;
  }

  void setStudentId(String studentId) {
    this.studentId = studentId;
  }

  Future<bool> initClass() async {
    classroomBtnController.classStatus.value = ClassStatus.INIT;
    if(studentId == null) {
      ToastService.showAlert("沒有學生");
      return false;
    }

    classroomBtnController.classStatus.value = ClassStatus.INITIALING;
    GetLastClassRes lastClassRes = await classroomApiManager.getLastClassInfo(classroomId!, studentId!);
    switch(lastClassRes.code) {
      case ApiErrorCode.SUCCESS:
        lastClassInfo = lastClassRes.classInfoRes;
        classId = lastClassInfo?.classId;
        classroomBtnController.classStatus.value = ClassStatus.INIT;

        // 上一堂課是 init 代表沒有開始過，不用補課
        if(lastClassInfo?.status == "init") {
          return true;
        }

        ReimburseClassRes res = await classroomApiManager.reimburseClass(classId!);
        if(res.code != ApiErrorCode.SUCCESS) {
          ToastService.showAlert(res.message!);
          return false;
        }

        if(lastClassInfo == null) {
          ToastService.showAlert("unexpected error");
          return false;
        }
        // 補課不用收費
        classroomClassController.startClassTime = lastClassInfo!.classTime;  
        classroomClassController.startClassPoints = 0;
        StartClassDialog(currentContext, true, lastClassInfo!.classTime, 0).show();
        return false;
      case ApiErrorCode.CS_DATA_NOT_FOUND:
        break;
      default:
        ToastService.showAlert(lastClassRes.message!);
        classroomBtnController.classStatus.value = ClassStatus.INIT;
        return false;
    }

    InitClassRes initClassRes = await classroomApiManager.initClass(classroomClassController.classSettingInfo, classroomId!, studentId!);
    if(initClassRes.code != ApiErrorCode.SUCCESS) {
      ToastService.showAlert(initClassRes.message!);
      classroomBtnController.classStatus.value = ClassStatus.INIT;
      return false;
    }
    classId = initClassRes.classId;
    classroomClassController.startClassTime = classroomClassController.classSettingInfo.classTime;
    classroomClassController.startClassPoints = classroomClassController.classSettingInfo.classPoints;
    classroomBtnController.classStatus.value = ClassStatus.INIT;
    return true;
  }

  Future<void> startClass() async {
    if(studentId == null || classId == null || classroomId == null) {
      ToastService.showAlert("沒有學生或是尚未完成初始化課堂無法開始上課");
      return;
    }

    messageService.sendClassRequestCmd(classId!, classroomId!, studentId!);
    ToastService.showSuccess("已為您送出上課訊息");
  }

  void onStartClass() {
    myClassroomTimerController.startTimer(classId!, classroomClassController.startClassTime!);
    classroomBtnController.classStatus.value = ClassStatus.IN_CLASS;
  }

  Future<void> finishClass() async {
    if(studentId == null || classId == null || classroomId == null) {
      ToastService.showAlert("沒有在課堂中");
      return;
    }

    await messageService.sendFinishClassCmd(classId!);
  }
}