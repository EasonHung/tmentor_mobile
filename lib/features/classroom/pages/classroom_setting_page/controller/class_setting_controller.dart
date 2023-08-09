import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/vo/class_setting_info.dart';

import '../../../../../apiManager/classroomApiManager.dart';

class ClassSettingController extends GetxController {
  RxList<ClassSettingInfo> classSettingList = <ClassSettingInfo>[].obs;
  TextEditingController titleTextController = TextEditingController();
  TextEditingController classPointsTextController = TextEditingController();
  TextEditingController descTextController = TextEditingController();
  Rx<bool> wantToSave = false.obs;
  Rx<String> selectedClassTime = "15分鐘".obs;
  // ignore: unnecessary_cast
  Rx<ClassSettingInfo?> selectedClassSetting = (null as ClassSettingInfo?).obs;
  RxList<String> classSettingNameList = <String>[].obs;
  Rx<String> confirmedTitle = "".obs;
  Rx<String> confirmedClassPoints = "".obs;
  Rx<String> confirmedDescText = "".obs;

  @override
  onInit() async {
    super.onInit();
    initClassSetting();
  }

  Future<void> initClassSetting() async {
    selectedClassSetting.value = null;
    classSettingList.value = await classroomApiManager.getClassSettingList();
    classSettingList.forEach((element) {
      classSettingNameList.add(element.settingName);
    });
  }

  void deleteSetting(ClassSettingInfo classSettingInfo) {
    classSettingList.removeWhere((element) => element.settingName == classSettingInfo.settingName);
  }

  void cleanSelected() {
    selectedClassSetting.value = null;
    titleTextController.text = "";
    descTextController.text = "";
    selectedClassTime.value = "15分鐘";
    classPointsTextController.text = "0";
    confirmedTitle.value = "";
    confirmedClassPoints.value = "0";
  }

  void onChangeSelectedSetting(ClassSettingInfo classSetting) {
    selectedClassSetting.value = classSetting;
    titleTextController.text = classSetting.title?? "";
    descTextController.text = classSetting.desc?? "";
    selectedClassTime.value = (classSetting.classTime?? 0).toString() + "分鐘";
    classPointsTextController.text = (classSetting.classPoints?? 0).toString();
    confirmedTitle.value = classSetting.title?? "";
    confirmedClassPoints.value = (classSetting.classPoints?? 0).toString();
  }

  void setSaveStatus(bool save) {
    this.wantToSave.value = save;
  }

  void saveClassSetting() {
    if (wantToSave.value) {
      try {
        classroomApiManager.addClassSetting(titleTextController.text, titleTextController.text, descTextController.text,
            int.parse(selectedClassTime.replaceAll("分鐘", "")), int.parse(classPointsTextController.text));
      } catch (e) {
        Toast.show(e.toString(), backgroundColor: Colors.red[300]!);
        return;
      }
      classSettingList.add(ClassSettingInfo(titleTextController.text, titleTextController.text, descTextController.text,
          int.parse(selectedClassTime.replaceAll("分鐘", "")), int.parse(classPointsTextController.text)));
      classSettingNameList.add(titleTextController.text);
    }
  }
}
