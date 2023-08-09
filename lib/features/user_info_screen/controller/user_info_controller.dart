import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';
import 'package:mentor_app_flutter/vo/class_setting_info.dart';
import 'package:mentor_app_flutter/vo/wallet_info.dart';

import '../../../apiManager/classroomApiManager.dart';
import '../../../apiManager/classroom_api_dto/res/get_class_record_res.dart';
import '../../../apiManager/evaluationApiManager.dart';
import '../../../apiManager/financeApiManager.dart';
import '../../../apiManager/userApiManager.dart';
import '../../../request/profile_request.dart';
import '../../../utils/date_util.dart';
import '../../../vo/mentor_item.dart';
import '../../../vo/user_info.dart';
import '../../../vo/user_post_info.dart';
import '../constants/user_info_page.dart';

class UserInfoController extends GetxController {
  Rx<UserInfo> userInfo = UserInfo.withNull().obs;
  Rx<UserPostInfo> userPostInfo = UserPostInfo.withNull().obs;
  RxList<ClassSettingInfo> classSettingInfoList = <ClassSettingInfo>[].obs;
  RxList<GetClassRecordResItem> classRecordList = <GetClassRecordResItem>[].obs;
  Rx<String> showPage = UserInfoPageEnum.USER_INFO.obs;
  Rx<String> showClassInfoPage = "已儲存教室".obs;
  Rx<bool> isEditing = false.obs;
  TextEditingController aboutMeTextController = TextEditingController();
  Rx<String> points = "".obs;
  RxList<String> storedCasePoints = <String>[].obs;
  String? classroomId;

  @override
  onInit() async {
    super.onInit();
    initUserInfo();
    initUserPostInfo();
    initClassSettingInfo();
    initClassRecord();
    getStorePointsCases();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initUserInfo() async {
    userInfo.value = await userApiManager.loadUserInfo();
    aboutMeTextController.text = userInfo.value.aboutMe!;
    String? userId = await UserPrefs.getUserId();
    classroomId = await classroomApiManager.getClassroomId(userId!);
  }

  Future<void> initUserPostInfo() async {
    String? userId = await UserPrefs.getUserId();
    dynamic postInfo = await evaluationApiManager.getUserPosts(userId!, 0);
    if (postInfo == null || postInfo["posts"].length == 0) return;
    userPostInfo.value = UserPostInfo.fromJson(postInfo);
  }

  Future<void> initClassSettingInfo() async {
    List<ClassSettingInfo> response = await classroomApiManager.getClassSettingList();
    response.forEach((element) {
      classSettingInfoList.add(element);
    });
  }

  Future<void> initClassRecord() async {
    GetClassRecordRes recordRes = await classroomApiManager.getClassRecord();
    recordRes.classRecordList?.forEach((element) {
      classRecordList.add(element);
    });
  }

  Future<void> getUserPointsInfo() async {
    WalletInfo walletInfo = await financeApiManager.getUserPointsInfo();
    points.value = walletInfo.studentPoint.toString();
  }

  Future<void> getStorePointsCases() async {
    List<String> cases = financeApiManager.getStoredPointsCases();
    cases.forEach((element) {
      storedCasePoints.add(element);
    });
  }

  void saveClassSetting(String title, String desc, int time, int points, ClassSettingInfo originClassSetting) {
    ClassSettingInfo newClassSettingInfo = ClassSettingInfo(title, title, desc, time, points);

    classroomApiManager.updateClassSetting(title, title, desc, time, points);

    int index = classSettingInfoList.indexWhere((element) => element.settingName == originClassSetting.settingName);
    classSettingInfoList[index] = newClassSettingInfo;
  }

  void deleteClassSetting(String settingName) {
    classroomApiManager.deleteClassSetting(settingName);

    classSettingInfoList.removeWhere((element) => element.settingName == settingName);
  }

  Future<void> changeShowPage(String showPage) async {
    this.showPage.value = showPage;
  }

  void changeEditingStatus() {
    isEditing.value = !isEditing.value;
  }

  void deleteSkill(String deleteSkill) {
    UserInfo newUserInfo = UserInfo.newOtherUserInfo(this.userInfo.value);
    if (userInfo.value.mentorSkills != null) newUserInfo.mentorSkills!.removeWhere((skill) => skill == deleteSkill);
    userInfo.value = newUserInfo;
  }

  void addSkill(String addSkill) {
    UserInfo newUserInfo = UserInfo.newOtherUserInfo(this.userInfo.value);
    if (userInfo.value.mentorSkills != null) newUserInfo.mentorSkills!.add(addSkill);
    userInfo.value = newUserInfo;
  }

  bool saveJobExperience(String companyName, String jobName, String start, String end) {
    if (companyName == "" || jobName == "" || start == "" || end == "") return false;
    UserInfo newUserInfo = UserInfo.newOtherUserInfo(this.userInfo.value);
    JobExperience newJobExperience = JobExperience(companyName, jobName, start, end);

    if (userInfo.value.jobExperiences != null) newUserInfo.jobExperiences!.add(newJobExperience);
    userInfo.value = newUserInfo;
    return true;
  }

  bool modifyJobExperience(
      String companyName, String jobName, String start, String end, JobExperience originExperience) {
    if (companyName == "" || jobName == "" || start == "" || end == "") return false;
    UserInfo newUserInfo = UserInfo.newOtherUserInfo(this.userInfo.value);
    JobExperience newJobExperience = JobExperience(companyName, jobName, start, end);

    if (userInfo.value.jobExperiences != null) {
      int index = newUserInfo.jobExperiences!.indexWhere((element) =>
          element.companyName == originExperience.companyName &&
          element.jobName == originExperience.jobName &&
          element.startTime == originExperience.startTime &&
          element.endTime == originExperience.endTime);
      newUserInfo.jobExperiences![index] = newJobExperience;
    }
    userInfo.value = newUserInfo;
    return true;
  }

  bool saveEducation(String schoolName, String subjectName, String start, String end) {
    if (schoolName == "" || subjectName == "" || start == "" || end == "") return false;
    UserInfo newUserInfo = UserInfo.newOtherUserInfo(this.userInfo.value);
    Education newEducation = Education(schoolName, subjectName, start, end);

    if (userInfo.value.jobExperiences != null) newUserInfo.educationList!.add(newEducation);
    userInfo.value = newUserInfo;
    return true;
  }

  bool modifyEducation(String schoolName, String subjectName, String start, String end, Education originEducation) {
    if (schoolName == "" || subjectName == "" || start == "" || end == "") return false;
    UserInfo newUserInfo = UserInfo.newOtherUserInfo(this.userInfo.value);
    Education newEducation = Education(schoolName, subjectName, start, end);

    if (userInfo.value.educationList != null) {
      int index = newUserInfo.educationList!.indexWhere((element) =>
          element.schoolName == originEducation.schoolName &&
          element.subject == originEducation.subject &&
          element.startTime == originEducation.startTime &&
          element.endTime == originEducation.endTime);
      newUserInfo.educationList![index] = newEducation;
    }
    userInfo.value = newUserInfo;
    return true;
  }

  void saveAboutMe(String aboutMe) {
    UserInfo newUserInfo = UserInfo.newOtherUserInfo(this.userInfo.value);
    newUserInfo.aboutMe = aboutMe;
    userInfo.value = newUserInfo;
  }

  Future<void> modifyAvatar(bool fromGallery) async {
    File selectedAvatar =
        (await MentorImageUtils.pickMedia(fromGallery, (file) => MentorImageUtils.cropImageFunc(file))) as File;
    await userApiManager.updateAvatar(selectedAvatar!);
    this.userInfo.value.avatarUrl = "";
    this.userInfo.refresh();
    await reloadPicture();
  }

  Future<void> modifyBackgroundPicture(bool fromGallery) async {
    File selectedPicture =
        (await MentorImageUtils.pickMedia(fromGallery, (file) => MentorImageUtils.cropImageFunc(file))) as File;
    await userApiManager.updatePicture(selectedPicture!);
    this.userInfo.value.pictureUrl = "";
    this.userInfo.refresh();
    await reloadPicture();
  }

  Future<void> reloadPicture() async {
    UserInfo userInfo = await userApiManager.loadUserInfo();
    this.userInfo.value.avatarUrl = userInfo.avatarUrl!;
    this.userInfo.value.pictureUrl = userInfo.pictureUrl!;
    this.userInfo.value = UserInfo.newOtherUserInfo(this.userInfo.value);
  }

  Future<void> saveUserInfo() async {
    await userApiManager.uploadProfileToServer(ProfileRequest(
        nickname: this.userInfo.value.nickname!,
        aboutMe: this.userInfo.value.aboutMe!,
        educations: this.userInfo.value.educationList!,
        gender: this.userInfo.value.gender!,
        profession: this.userInfo.value.profession!,
        fields: this.userInfo.value.fields!,
        mentorSkills: this.userInfo.value.mentorSkills!,
        jobExperience: this.userInfo.value.jobExperiences!,
        userStatus: "student"));
  }
}
