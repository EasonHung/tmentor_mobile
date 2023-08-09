import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../color_constants.dart';
import '../controller/user_info_controller.dart';

class UserInfoEditBtn extends StatelessWidget {
  final UserInfoController userInfoController = Get.find<UserInfoController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            if(userInfoController.isEditing.value) {
              userInfoController.saveUserInfo();
            }
            userInfoController.changeEditingStatus();
          },
          style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
              ),
              backgroundColor: primaryTint
          ),
          child: Text(
            userInfoController.isEditing.value? "儲存個人檔案" : "編輯個人檔案",
            style: TextStyle(
                color: primaryDark2,
                fontWeight: FontWeight.bold
            ),
          )
        )
      ]
    ));
  }

}