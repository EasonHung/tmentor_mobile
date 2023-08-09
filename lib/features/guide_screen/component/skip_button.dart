import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';
import '../controller/step_controller.dart';
import '../controller/user_guide_controller.dart';

class SkipBtn extends StatelessWidget {
  final UserGuideController userGuideController = Get.find<UserGuideController>();
  final StepController stepController = Get.find<StepController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => stepController.showSkipBtn.value? SizedBox(
      height: ScreenUtil().setHeight(60),
      width: ScreenUtil().screenWidth * 0.9,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(10)))),
        ),
        child: Text(
          "略過",
          style: TextStyle(
            color: black800,
            fontSize: ScreenUtil().setSp(16)
          )
        ),
        onPressed: () {
          stepController.gotoNextPage();
        },
      )
    ):
    SizedBox.shrink());
  }

}