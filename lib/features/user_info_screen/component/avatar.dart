import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';
import '../controller/user_info_controller.dart';

class AvatarWidget extends StatelessWidget {
  final UserInfoController userInfoController = Get.find<UserInfoController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() => Positioned(
        left: ScreenUtil().setWidth(110),
        top: ScreenUtil().setHeight(100),
        child: Container(
            width: ScreenUtil().setWidth(120),
            height: ScreenUtil().setHeight(120),
            child: Stack(
              children: [
                CircleAvatar(
                    radius: ScreenUtil().setWidth(60),
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: ScreenUtil().setWidth(55),
                      child: ClipOval(
                        child: userInfoController.userInfo.value.avatarUrl == ""?
                          Image.asset("assets/images/null_avatar.png")
                            :
                          Image.network(userInfoController.userInfo.value.avatarUrl!)
                      )
                      // backgroundImage: userInfoController.userInfo.value.avatarUrl == ""? AssetImage("assets/images/null_avatar.png") as ImageProvider : NetworkImage(userInfoController.userInfo.value.avatarUrl!)
                    )
                ),
                userInfoController.isEditing.value? Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: ScreenUtil().setWidth(16),
                    child: CircleAvatar(
                      backgroundColor: black200,
                      radius: ScreenUtil().setWidth(15),
                      child: IconButton(
                        color: primaryDark,
                        icon: ImageIcon(
                          AssetImage("assets/images/camaraIcon.png"),
                        ),
                        onPressed: () {
                          userInfoController.modifyAvatar(true);
                        },
                      ),
                    )
                  )
                ) : SizedBox()
              ],
            )
        )
    ));
  }

}