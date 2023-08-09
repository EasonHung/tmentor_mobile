import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../service/google_sign_in_service.dart';
import 'network_controller.dart';

class SignInController extends GetxController {
  GoogleSignInAccount? currentGoogleUser;
  late GoogleSignInService googleSignInService;
  NetworkController networkController = Get.find<NetworkController>();

  @override
  onInit() async {
    super.onInit();
    googleSignInService = GoogleSignInService();
    googleSignInService.listenOnUserChanged();
  }

  Future<void> handleGoogleSignIn() async {
    if( !await networkController.checkNetworkAndShowAlert() ) {
      return;
    }
    await googleSignInService.signIn();
  }
}