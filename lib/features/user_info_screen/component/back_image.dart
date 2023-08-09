import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/user_info_screen/controller/user_info_controller.dart';

import '../../../color_constants.dart';

class BackImage extends StatelessWidget {
  final UserInfoController userInfoController = Get.find<UserInfoController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
      children: [
        Container(
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().setHeight(160),
          child: userInfoController.userInfo.value.pictureUrl == ""? Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
          ): Image.network(
            userInfoController.userInfo.value.pictureUrl!,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;

              return const Center(child: Text('Loading...'));
            },
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
                      userInfoController.modifyBackgroundPicture(true);
                    },
                  ),
                )
            )
        ) : SizedBox()
      ]
    ));
  }

}