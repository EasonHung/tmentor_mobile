import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentor_app_flutter/features/guide_screen/controller/about_me_controller.dart';
import 'package:mentor_app_flutter/features/guide_screen/controller/avatar_controller.dart';
import 'package:mentor_app_flutter/features/guide_screen/controller/education_controller.dart';
import 'package:mentor_app_flutter/features/guide_screen/controller/field_controller.dart';
import 'package:mentor_app_flutter/features/guide_screen/controller/gender_controller.dart';
import 'package:mentor_app_flutter/features/guide_screen/controller/job_experience_controller.dart';
import 'package:mentor_app_flutter/features/guide_screen/controller/skill_controller.dart';
import 'package:mentor_app_flutter/request/profile_request.dart';
import 'package:get/get.dart';

import '../../../apiManager/userApiManager.dart';
import 'nickname_and_profession_controller.dart';

class UserGuideController extends GetxController {
  NicknameAndProfessionController nicknameAndProfessionController = Get.find<NicknameAndProfessionController>();
  GenderController genderController = Get.find<GenderController>();
  AvatarController avatarController = Get.find<AvatarController>();
  FieldController fieldController = Get.find<FieldController>();
  AboutMeController aboutMeController = Get.find<AboutMeController>();
  SkillController skillController = Get.find<SkillController>();
  JobExperienceController jobExperienceController = Get.find<JobExperienceController>();
  EducationController educationController = Get.find<EducationController>();
  Rx<bool> isUpdatingUserInfo = false.obs;

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> updateUserInfo() async {
    isUpdatingUserInfo.value = true;
    await userApiManager.updateAvatar(avatarController.selectedAvatar.value!);
    await userApiManager.uploadProfileToServer(new ProfileRequest(
        nickname: nicknameAndProfessionController.nicknameTextController.text,
        aboutMe: aboutMeController.aboutMeTextController.text,
        educations: educationController.educationList,
        gender: genderController.selectedGender.value,
        profession: nicknameAndProfessionController.professionTextController.text,
        fields: fieldController.selectedField,
        mentorSkills: skillController.skillList,
        jobExperience: jobExperienceController.jobExperienceList,
        userStatus: "student"));
    isUpdatingUserInfo.value = false;
  }
}
