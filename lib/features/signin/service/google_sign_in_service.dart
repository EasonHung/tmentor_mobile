import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mentor_app_flutter/features/signin/service/tmentor_sign_in_service.dart';

import '../../../main.dart';
import '../../guide_screen/guide_screen.dart';
import '../../main_page.dart';
import '../controller/login_status_controller.dart';

final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: ['email']
);
class GoogleSignInService {
  final LoginStatusController loginStatusController = Get.find<LoginStatusController>();
  final TMentorSignInService tMentorSignInService = TMentorSignInService();

  Future<void> signIn() async {
    // when want to login again, if don't signOut first selection window will not pop out
    // even though i have logout in the logout page
    await googleSignIn.signOut();
    await googleSignIn.signIn();
  }

  void listenOnUserChanged() {
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) async {
      if (account != null) {
        if (!hasLoggedIn) {
          bool isFirstTimeLoggedIn = await tMentorSignInService.loginToUserSystemAndCheckIsFirstLogin(account);
          if(isFirstTimeLoggedIn) {
            Get.to(GuideScreen());
          } else {
            Get.to(MainScreen());
          }
          loginStatusController.changeToLogin();
        }
      } else {
        loginStatusController.changeToLogout();
      }
    });
  }
}