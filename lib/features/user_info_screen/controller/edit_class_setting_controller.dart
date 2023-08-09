import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:mentor_app_flutter/vo/class_setting_info.dart';

class EditClassSettingController extends GetxController {
  late ClassSettingInfo editedClassSettingInfo;
  TextEditingController classNameController = TextEditingController();
  TextEditingController classDescController = TextEditingController();
  TextEditingController classPointsController = TextEditingController();
  String classTime = "15分鐘";

  void initClassSetting(ClassSettingInfo originClassSetting) {
    editedClassSettingInfo = originClassSetting;
    classNameController.text = originClassSetting.title;
    classDescController.text = originClassSetting.desc;
    classTime = originClassSetting.classTime.toString() + "分鐘";
    classPointsController.text = originClassSetting.classPoints.toString();
  }
}