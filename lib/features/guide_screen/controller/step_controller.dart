import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../main_page.dart';

class StepController extends GetxController {
  Rx<bool> canNavigateToNextPage = false.obs;
  PageController pageController = new PageController();
  Rx<bool> showSkipBtn = false.obs;
  Rx<bool> showBottomBtn = true.obs;
  Rx<bool> isLastPage = false.obs;
  static const int LAST_PAGE_INDEX = 7;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void changeNavigationStatus(bool validation) {
    canNavigateToNextPage.value = validation;
  }

  void gotoNextPage() {
    pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void goBackLastPage() {
    pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);

    // navigate status must be true, if is go back from the next page.
    changeNavigationStatus(true);
  }

  void gotoMainPage(BuildContext context) {
    Get.to(MainScreen());
  }

  void changeShowSkipBtnStatus(bool status) {
    showSkipBtn.value = status;
  }

  void changeSkipBtnStatusByPage(int index) {
    showSkipBtn.value = index >= 3 && index < 7;
  }

  void changeBottomBtnStatusByPage(int index) {
    showBottomBtn.value = index != 8;
  }

  void checkIsLastPage(int index) {
    isLastPage.value = index == LAST_PAGE_INDEX;
  }
}