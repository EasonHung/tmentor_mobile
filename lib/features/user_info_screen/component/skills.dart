import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';
import '../controller/user_info_controller.dart';
import '../page/skill_edit_page.dart';

class Skills extends StatelessWidget {
  final UserInfoController userInfoController = Get.find<UserInfoController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "擅長技能",
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(20),
                    fontWeight: FontWeight.w600
                ),
              ),
              userInfoController.isEditing.value? TextButton(
                child: Text(
                  "+",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(28),
                    color: Colors.black,
                    fontWeight: FontWeight.w300
                  ),
                ),
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return SkillEditPage();
                  }));
                },
              ) : SizedBox()
            ],
          ),
          userInfoController.isEditing.value? SizedBox.shrink() : SizedBox(height: 10.h),
          userInfoController.isEditing.value? tagWithBorder() : tagWithoutBorder()
        ],
      )
    ));
  }

  Widget tagWithBorder() {
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border:  Border.all(
          color: black500,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: ScreenUtil().setWidth(10),
              runSpacing: ScreenUtil().setWidth(5),
              children: buildSkillsItems(userInfoController.userInfo.value.mentorSkills!)
            ),
          )
        ]
      )
    );
  }

  Widget tagWithoutBorder() {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: ScreenUtil().setWidth(10),
            runSpacing: ScreenUtil().setWidth(5),
            children: buildSkillsItems(userInfoController.userInfo.value.mentorSkills!)
          ),
        )
      ]
    );
  }

  List<Widget> buildSkillsItems(List<String> skillStrings) {
    List<Widget> skillItems = [];
    for(int i = 0; i < skillStrings.length; i++) {
      skillItems.add(
        Container(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10), vertical: ScreenUtil().setHeight(5)),
          decoration: BoxDecoration(
            color: primaryTint,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(5)),
          ),
          child: Text(
              skillStrings[i],
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(18)
              )
          )
        )
      );
    }
    return skillItems;
  }

}