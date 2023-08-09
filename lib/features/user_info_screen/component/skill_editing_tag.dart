import 'package:flutter/material.dart';

import '../../../color_constants.dart';
import '../controller/user_info_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SkillEditingTag extends StatelessWidget {
  final UserInfoController userInfoController = Get.find<UserInfoController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      children: [
        Text(
          "您的標籤(" + userInfoController.userInfo.value.mentorSkills!.length.toString() + "/10)",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(18),
            fontWeight: FontWeight.w600
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(5),),
        tagWithoutBorder()
      ],
    ));
  }

  Widget tagWithoutBorder() {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: ScreenUtil().setWidth(10),
            runSpacing: ScreenUtil().setWidth(5),
            children: buildSkillsItems(userInfoController.userInfo.value.mentorSkills!)
          )
        ),
      ]
    );
  }

  List<Widget> buildSkillsItems(List<String> skillStrings) {
    List<Widget> skillItems = [];
    for(int i = 0; i < skillStrings.length; i++) {
      skillItems.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
          decoration: BoxDecoration(
            color: primaryLight,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                skillStrings[i],
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(18)
                )
              ),
              SizedBox(width: ScreenUtil().setWidth(5),),
              SizedBox(
                width: ScreenUtil().setWidth(24),
                child: TextButton(
                  onPressed: () {
                    userInfoController.deleteSkill(skillStrings[i]);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(0),
                    backgroundColor: Colors.white,
                    shape: CircleBorder(),
                  ),
                  child: Text(
                    "x",
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(20),
                      color: primaryLight,
                      fontWeight: FontWeight.w600
                    ),
                  )
                )
              )
            ]
          )
        )
      );
    }
    return skillItems;
  }

}