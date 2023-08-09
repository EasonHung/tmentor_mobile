import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentor_app_flutter/color_constants.dart';
import 'package:get/get.dart';

import '../controller/user_info_controller.dart';

class SkillInput extends StatelessWidget {
  final TextEditingController skillController = TextEditingController();
  final UserInfoController userInfoController = Get.find<UserInfoController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "輸入關鍵字",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(18),
            fontWeight: FontWeight.w600
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(5),),
        Text(
          "根據個人技能輸入關鍵字，讓他人更認識您!",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(16),
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(5),),
        Container(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border:  Border.all(
              color: Colors.grey,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  controller: skillController,
                )
              ),
              TextButton(
                onPressed: () {
                  userInfoController.addSkill(skillController.text);
                  skillController.text = "";
                },
                style: TextButton.styleFrom(
                  backgroundColor: primaryLight,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(2),
                ),
                child: Text(
                  "+",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(24),
                    color: Colors.white,
                    fontWeight: FontWeight.w300
                  ),
                )
              )
            ],
          )
        )
      ]
    );
  }
  
}