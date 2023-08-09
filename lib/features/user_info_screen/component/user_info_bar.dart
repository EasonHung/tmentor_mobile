import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentor_app_flutter/features/user_info_screen/constants/user_info_page.dart';

import '../../../color_constants.dart';
import '../controller/user_info_controller.dart';
import 'package:get/get.dart';

class UserInfoBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final UserInfoController userInfoController = Get.find<UserInfoController>();

  UserInfoBar(this.appBar);

  @override
  // TODO: implement preferredSize
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        "個人資訊",
        style: TextStyle(
            color: primaryDark,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

}