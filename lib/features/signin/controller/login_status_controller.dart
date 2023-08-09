
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/guide_screen/guide_screen.dart';
import 'package:mentor_app_flutter/features/signin/service/user_status_service.dart';

import '../../main_page.dart';
import '../constants/login_status.dart';

class LoginStatusController extends GetxController {
  Rx<int> loginStatus = LoginStatus.LOGOUT.obs;
  UserStatusService userStatusService = UserStatusService();

  @override
  onInit() async {
    super.onInit();
  }

  Future<void> checkAndNavigate() async {
    if (await userStatusService.isLoggedIn()) {
      changeToLoading();

      if(!await userStatusService.hasFillInInfo()) {
        Get.to(GuideScreen());
      } else {
        Get.to(MainScreen());
      }
      changeToLogin();
    } else {
      loginStatus.value = LoginStatus.LOGOUT;
    }
  }

  void changeToLoading() {
    loginStatus.value = LoginStatus.LOADING;
  }

  void changeToLogin() {
    loginStatus.value = LoginStatus.LOGIN;
  }

  void changeToLogout() {
    loginStatus.value = LoginStatus.LOGOUT;
  }
}