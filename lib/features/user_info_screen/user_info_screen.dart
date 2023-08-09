import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/user_info_screen/controller/edit_class_setting_controller.dart';
import 'package:mentor_app_flutter/features/user_info_screen/page/points_info_page.dart';
import 'package:mentor_app_flutter/features/user_info_screen/page/user_info_page.dart';
import 'page/class_info_page.dart';
import 'component/scrollable_bar.dart';
import 'component/user_info_bar.dart';
import 'constants/user_info_page.dart';
import 'controller/edit_user_info_controller.dart';
import 'controller/user_info_controller.dart';

class UserInfoScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return UserInfoScreenState();
  }
}

class UserInfoScreenState extends State<UserInfoScreen> {
  late UserInfoController userInfoController;

  @override
  void initState() {
    super.initState();
    userInfoController = Get.put<UserInfoController>(UserInfoController());
    Get.put<EditUserInfoController>(EditUserInfoController());
    Get.put<EditClassSettingController>(EditClassSettingController());
  }

  @override
  void dispose() {
    Get.delete<UserInfoController>();
    Get.delete<EditUserInfoController>();
    Get.delete<EditClassSettingController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => userInfoController.userInfo.value.avatarUrl == null? Center(
      child: SizedBox(
        width: ScreenUtil().setWidth(50),
        height: ScreenUtil().setWidth(50),
        child: CircularProgressIndicator(
          strokeWidth: ScreenUtil().setWidth(7),
        )
      )
    ) : Scaffold(
      backgroundColor: Colors.white,
      appBar: UserInfoBar(AppBar()),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              ScrollableBar(),
              SizedBox(height: ScreenUtil().setHeight(15)),
              getPage()
            ]
          )
        )
      )
    ));
  }

  Widget getPage() {
    if(userInfoController.showPage.value == UserInfoPageEnum.USER_INFO) {
      return UserInfoPage();
    } else if (userInfoController.showPage.value == UserInfoPageEnum.CLASS_INFO) {
      return ClassInfoPage();
    // } else if (userInfoController.showPage.value == UserInfoPageEnum.POINTS_INFO) {
    //   return PointsInfoPage();
    } else {
      return UserInfoPage();
    }
  }

}