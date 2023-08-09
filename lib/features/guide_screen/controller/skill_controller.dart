import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SkillController extends GetxController {
  TextEditingController skillTextController = new TextEditingController();
  Rx<int> inputCount = 0.obs;
  Rx<bool> skillInputFocus = false.obs;
  RxList<String> skillList = <String>[].obs;

  @override
  void onInit() {
    skillTextController.addListener(() {
      inputCount.value = skillTextController.text.length;
    });
    super.onInit();
  }

  void addSkill(String skill) {
    if (skillList.length >= 10 || skill == "") return;
    skillList.add(skill);
  }

  void deleteSkill(String skill) {
    skillList.removeWhere((element) => element == skill);
  }
}