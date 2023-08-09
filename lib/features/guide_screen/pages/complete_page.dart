import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentor_app_flutter/color_constants.dart';
import '../../../sharedPrefs/userPrefs.dart';
import '../../signin/constants/user_info_fill_in_status.dart';
import '../controller/step_controller.dart';
import '../controller/user_guide_controller.dart';
import 'package:get/get.dart';

class GuideCompletePage extends StatelessWidget {
  final UserGuideController userGuideController = Get.find<UserGuideController>();
  final StepController stepController = Get.find<StepController>();


  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return Container(
      color: primaryDefault,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildImage(),
            SizedBox(height: ScreenUtil().setHeight(20),),
            buildHeader(),
            SizedBox(height: ScreenUtil().setHeight(10),),
            buildDescription(),
            SizedBox(height: ScreenUtil().setHeight(30),),
            buildCompleteBtn(context)
          ],
        )
      )
    );
  }

  Widget buildHeader() {
    return Text(
      "您準備好了!",
      style: TextStyle(
        color: Colors.white,
        fontSize: ScreenUtil().setSp(24),
        fontWeight: FontWeight.bold
      ),
    );
  }

  Widget buildDescription() {
    return Text(
      "您隨時可以在個人檔案內\n更改您的相關資訊",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: ScreenUtil().setSp(18)
      ),
    );
  }

  Widget buildImage() {
    return Image(
      image: AssetImage('assets/images/complete_guide.png')
    );
  }

  Widget buildCompleteBtn(BuildContext context) {
    return Obx( () => SizedBox(
      height: ScreenUtil().setHeight(60),
      width: ScreenUtil().screenWidth * 0.9,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(10)))),
        ),
        child: userGuideController.isUpdatingUserInfo.value? SizedBox(
          height: 25,
          width: 25,
          child: CircularProgressIndicator(),
        ) : Text(
          "開始探索",
          style: TextStyle(
            color: primaryDefault,
            fontSize: ScreenUtil().setSp(16)
          ),
        ),
        onPressed: userGuideController.isUpdatingUserInfo.value? null : () async {
          await userGuideController.updateUserInfo();
          await UserPrefs.setUserInfoFillInStatus(UserInfoFillInStatus.Done);
          stepController.gotoMainPage(context);
        },
      )
    ));
  }
}