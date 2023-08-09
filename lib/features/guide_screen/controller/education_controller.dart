import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

import '../../../color_constants.dart';
import '../../../vo/mentor_item.dart';

class EducationController extends GetxController {
  String educationStartedMonth = "";
  String educationStartedYear = "";
  String educationEndedYear = "";
  String educationEndedMonth = "";
  TextEditingController schoolNameTextController = new TextEditingController();
  TextEditingController subjectTextController = new TextEditingController();
  TextEditingController schoolStartTimeTextController = new TextEditingController();
  TextEditingController schoolEndTimeTextController = new TextEditingController();
  Rx<bool> stillIsStudent = false.obs;
  Rx<bool> schoolNameInputFocus = false.obs;
  Rx<bool> subjectInputFocus = false.obs;
  RxList<Education> educationList = <Education>[].obs;

  void addEducation() {
    // validate input
    if(this.schoolNameTextController.text == "" || this.subjectTextController.text == "" || educationStartedMonth == "" || educationStartedYear == "") {
      Toast.show("請填寫完整", textStyle: TextStyle(fontSize: ScreenUtil().setSp(18)), backgroundColor: Colors.red[300]!);
      return;
    }
    if(!stillIsStudent.value && (educationEndedYear == "" || educationEndedMonth == "")) {
      Toast.show("請填寫完整", textStyle: TextStyle(fontSize: ScreenUtil().setSp(18)), backgroundColor: Colors.red[300]!);
      return;
    }

    NumberFormat formatter = NumberFormat("00");
    String endString = educationEndedYear == "" || educationEndedMonth == ""
        ? "迄今"
        : educationEndedYear + "/" + formatter.format(int.parse(educationEndedMonth));
    Education newEducation = Education(
      this.schoolNameTextController.text,
      this.subjectTextController.text,
      educationStartedYear + "/" + formatter.format(int.parse(educationStartedYear)),
      endString,
    );

    educationList.add(newEducation);
    this.schoolNameTextController.text = "";
    this.subjectTextController.text = "";
    Toast.show("已新增", textStyle: TextStyle(color: primaryDark, fontSize: ScreenUtil().setSp(18)), backgroundColor: primaryTint);
  }
}