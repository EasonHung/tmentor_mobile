import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';
import '../controller/step_controller.dart';
import '../controller/user_guide_controller.dart';

class NextStepBtn extends StatelessWidget {
  final StepController stepController = Get.find<StepController>();
  final UserGuideController userGuideController = Get.find<UserGuideController>();
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil().setHeight(52),
      width: ScreenUtil().screenWidth * 0.9,
      child: Obx(() => stepController.isLastPage.value?
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: primaryDefault,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(5)))),
          ),
          child: Text(
            "完成填寫",
            style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(16)),
          ),
          onPressed: () {
            stepController.gotoNextPage();
          },
        ) :
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: stepController.canNavigateToNextPage.value? primaryDefault : black600,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(5)))),
          ),
          child: Text("下一步", style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(16)),),
          onPressed: stepController.canNavigateToNextPage.value? stepController.gotoNextPage : null,
      ))
    );
  }

}