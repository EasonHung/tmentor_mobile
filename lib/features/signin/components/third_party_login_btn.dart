import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/signin/constants/login_status.dart';
import 'package:mentor_app_flutter/features/signin/controller/login_status_controller.dart';
import 'package:mentor_app_flutter/features/signin/controller/sign_in_controller.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

class ThirdPartyLoginBtn extends StatelessWidget {
  final LoginStatusController loginStatusController = Get.find<LoginStatusController>();
  final SignInController signInController = Get.find<SignInController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => loginStatusController.loginStatus.value != LoginStatus.LOADING
        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(width: MediaQuery.of(context).size.width * 0.1),
      SizedBox(
          width: ScreenUtil().setWidth(300),
          height: ScreenUtil().setHeight(65),
          child: SignInButton(
            imagePosition: ImagePosition.left, // left or right
            buttonType: ButtonType.google,
            onPressed: signInController.handleGoogleSignIn,
            btnText: '使用 Google 帳號登入',
            buttonSize: ButtonSize.large,
          )),
      SizedBox(width: MediaQuery.of(context).size.width * 0.1),
    ])
        : CircularProgressIndicator()
    );
  }
}