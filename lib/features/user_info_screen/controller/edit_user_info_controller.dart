import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../vo/mentor_item.dart';

class EditUserInfoController extends GetxController {
  Rx<bool> isNow = true.obs;
  Rx<bool> stillIsStudent = false.obs;
  TextEditingController schoolNameController = TextEditingController();
  TextEditingController subjectNameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController professionNameController = TextEditingController();
  late JobExperience editedJobExperience;
  late Education editedEducation;
  String jobExperienceStartedMonth = "";
  String jobExperienceStartedYear = "";
  String jobExperienceEndedMonth = "";
  String jobExperienceEndedYear = "";
  String educationStartedMonth = "";
  String educationStartedYear = "";
  String educationEndedMonth = "";
  String educationEndedYear = "";

  void initEditJobExperience(JobExperience originExperience) {
    this.editedJobExperience = originExperience;
    this.companyNameController.text = originExperience.companyName;
    this.professionNameController.text = originExperience.jobName;
    this.jobExperienceStartedMonth = originExperience.startTime.split("/")[1];
    this.jobExperienceStartedYear = originExperience.startTime.split("/")[0];

    if(originExperience.endTime == "迄今") {
      this.jobExperienceEndedMonth = "";
      this.jobExperienceEndedYear = "";
      isNow.value = true;
      return;
    }
    this.jobExperienceEndedMonth = originExperience.endTime.split("/")[1];
    this.jobExperienceEndedYear = originExperience.endTime.split("/")[0];
    isNow.value = false;
  }

  void initEditEducation(Education originEducation) {
    this.editedEducation = originEducation;
    this.schoolNameController.text = originEducation.schoolName;
    this.subjectNameController.text = originEducation.subject;
    this.educationStartedMonth = originEducation.startTime.split("/")[1];
    this.educationStartedYear = originEducation.startTime.split("/")[0];

    if(originEducation.endTime == "迄今") {
      this.educationEndedMonth = "";
      this.educationEndedYear = "";
      stillIsStudent.value = true;
      return;
    }
    this.educationEndedMonth = originEducation.endTime.split("/")[1];
    this.educationEndedYear = originEducation.endTime.split("/")[0];
    stillIsStudent.value = false;
  }

  void cleanEditJobExperience() {
    this.companyNameController.text = "";
    this.professionNameController.text = "";
    this.jobExperienceStartedMonth = "";
    this.jobExperienceStartedYear = "";
    this.jobExperienceEndedMonth = "";
    this.jobExperienceEndedYear = "";
    isNow.value = true;
  }

  void cleanEditEducation() {
    this.schoolNameController.text = "";
    this.subjectNameController.text = "";
    this.educationStartedMonth = "";
    this.educationStartedYear = "";
    this.educationEndedMonth = "";
    this.educationEndedYear = "";
    stillIsStudent.value = false;
  }
}