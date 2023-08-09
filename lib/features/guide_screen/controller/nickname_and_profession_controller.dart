import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'step_controller.dart';

class NicknameAndProfessionController extends GetxController {
  TextEditingController nicknameTextController = new TextEditingController();
  TextEditingController professionTextController = new TextEditingController();
  StepController stepController = Get.find<StepController>();

  void validateInput() {
    if(nicknameTextController.text == "" || professionTextController.text == "") {
      stepController.changeNavigationStatus(false);
    } else {
      stepController.changeNavigationStatus(true);
    }
  }
}