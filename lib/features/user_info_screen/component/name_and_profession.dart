import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/user_info_controller.dart';

class NameAndProfession extends StatelessWidget {
  final UserInfoController userInfoController = Get.find<UserInfoController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userInfoController.userInfo.value.nickname!,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                fontWeight: FontWeight.w600
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userInfoController.userInfo.value.profession!,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(20),
              ),
            ),
          ],
        ),
      ]
    ));
  }
}