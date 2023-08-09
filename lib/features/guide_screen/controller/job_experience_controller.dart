import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mentor_app_flutter/service/toast_service.dart';
import 'package:toast/toast.dart';

import '../../../color_constants.dart';
import '../../../vo/mentor_item.dart';

class JobExperienceController extends GetxController {
  TextEditingController companyTextController = new TextEditingController();
  TextEditingController jobNameTextController = new TextEditingController();
  String jobStartTimeMonth = "";
  String jobStartTimeYear = "";
  String jobEndTimeMonth = "";
  String jobEndTimeYear = "";
  Rx<bool> jobExperienceIsNow = false.obs;
  Rx<bool> companyNameInputFocus = false.obs;
  Rx<bool> jobNameInputFocus = false.obs;
  RxList<JobExperience> jobExperienceList = <JobExperience>[].obs;

  void cleanFocus() {
    companyNameInputFocus.value = false;
    jobNameInputFocus.value = false;
  }

  void addJobExperience() {
    // validate input
    if(this.companyTextController.text == "" || this.jobNameTextController.text == "" || jobStartTimeYear == "" || jobStartTimeMonth == "") {
      Toast.show("請填寫完整", textStyle: TextStyle(fontSize: ScreenUtil().setSp(18)), backgroundColor: Colors.red[300]!);
      return;
    }
    if(!jobExperienceIsNow.value && (jobEndTimeYear == "" || jobEndTimeMonth == "")) {
      Toast.show("請填寫完整", textStyle: TextStyle(fontSize: ScreenUtil().setSp(18)), backgroundColor: Colors.red[300]!);
      return;
    }

    NumberFormat formatter = NumberFormat("00");
    String endString = jobEndTimeYear == "" || jobEndTimeMonth == ""
        ? "迄今"
        : jobEndTimeYear + "/" + formatter.format(int.parse(jobEndTimeMonth));
    JobExperience newJobExperience = JobExperience(
      this.companyTextController.text,
      this.jobNameTextController.text,
      jobStartTimeYear + "/" + formatter.format(int.parse(jobStartTimeMonth)),
      endString,
    );

    jobExperienceList.add(newJobExperience);
    this.companyTextController.text = "";
    this.jobNameTextController.text = "";
    ToastService.showSuccess("已添加");
  }
}