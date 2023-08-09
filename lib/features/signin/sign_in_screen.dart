
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/signin/controller/exit_controller.dart';
import 'package:mentor_app_flutter/features/signin/controller/network_controller.dart';
import 'package:mentor_app_flutter/features/signin/controller/sign_in_controller.dart';
import 'package:mentor_app_flutter/features/signin/page/loading_page.dart';
import 'package:mentor_app_flutter/features/signin/page/sign_in_page.dart';
import 'package:toast/toast.dart';

import 'constants/login_status.dart';
import 'controller/login_status_controller.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignInScreenState();
  }
}

class SignInScreenState extends State<SignInScreen> {
  late LoginStatusController loginStatusController;
  late ExitController exitController;
  late NetworkController networkController;

  @override
  void initState() {
    super.initState();
    loginStatusController = Get.put<LoginStatusController>(LoginStatusController());
    exitController = Get.put<ExitController>(ExitController());
    networkController = Get.put<NetworkController>(NetworkController());
    Get.put<SignInController>(SignInController());
    networkController.checkNetworkAndShowAlert();
    loginStatusController.checkAndNavigate();
  }

  @override
  void dispose() {
    Get.delete<LoginStatusController>();
    Get.delete<ExitController>();
    Get.delete<SignInController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
      onWillPop: exitController.doubleCheckExit,
      child: loginStatusController.loginStatus.value == LoginStatus.LOADING?
        LoadingPage() : SignInPage()
    ));
  }
}