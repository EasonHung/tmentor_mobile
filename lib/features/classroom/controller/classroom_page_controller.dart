import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassroomPageController extends GetxController {
  PageController pageController = new PageController(initialPage: 0);
  Rx<String> activePage = "我的教室".obs;

  @override
  void onClose() {
    pageController.dispose();
  }
}