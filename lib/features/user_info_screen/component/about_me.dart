import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';
import '../controller/user_info_controller.dart';

class AboutMe extends StatelessWidget {
  final UserInfoController userInfoController = Get.find<UserInfoController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "關於我",
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(20),
                    fontWeight: FontWeight.bold
                ),
              )
            ]
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          userInfoController.isEditing.value?
          TextField(
            controller: userInfoController.aboutMeTextController,
            maxLines: 7,
            maxLength: 150,
            style: TextStyle(
              fontSize: 18
            ),
            decoration: InputDecoration(
              hintText: "自我介紹",
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1,
                    color: black500
                )
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1,
                    color: Colors.grey
                )
              ),
            ),
            onChanged: (String newAboutMe) {
              userInfoController.saveAboutMe(newAboutMe);
            },
          ):
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  userInfoController.userInfo.value.aboutMe!,
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: ScreenUtil().setSp(18),
                  ),
                )
              )
            ]
          ),
        ],
      )
    ));
  }

}