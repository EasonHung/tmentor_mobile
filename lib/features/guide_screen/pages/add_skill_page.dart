import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/guide_screen/controller/skill_controller.dart';

import '../../../color_constants.dart';

class AddSkillPage extends StatelessWidget {
  final SkillController skillController = Get.find<SkillController>();
  final int skillTextLength = 20;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: ScreenUtil().setHeight(20),),
            buildHeader(),
            SizedBox(height: ScreenUtil().setHeight(5),),
            buildDescription(),
            SizedBox(height: ScreenUtil().setHeight(15),),
            buildInputForm(),
            SizedBox(height: ScreenUtil().setHeight(15),),
            buildTagArea(),
          ]
        )
      )
    );
  }

  Widget buildHeader() {
    return Text(
      "擅長技能",
      style: TextStyle(
          fontSize: ScreenUtil().setSp(24),
          fontWeight: FontWeight.bold
      ),
    );
  }

  Widget buildDescription() {
    return Text(
      "請根據您的技能輸入關鍵字\n讓大家更好找到您!",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: ScreenUtil().setSp(16),
        color: Colors.grey
      ),
    );
  }

  Widget buildInputForm() {
    return Obx(() => Container(
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(10), top: ScreenUtil().setHeight(5), bottom: ScreenUtil().setHeight(5)),
      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border:  Border.all(
          width: ScreenUtil().setWidth(2),
          color: skillController.skillInputFocus.value? primaryDefault : Colors.grey,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16)
              ),
              onTap: () {skillController.skillInputFocus.value = true;},
              decoration: InputDecoration(
                counterText: "",
                border: InputBorder.none
              ),
              controller: skillController.skillTextController,
              maxLength: skillTextLength,
            )
          ),
          Text(
            skillController.inputCount.toString() + "/" + skillTextLength.toString(),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14.sp
            ),
          ),
          TextButton(
            onPressed: () {
              skillController.addSkill(skillController.skillTextController.text);
              skillController.skillTextController.text = "";
            },
            style: TextButton.styleFrom(
              minimumSize: Size(ScreenUtil().setWidth(24),ScreenUtil().setWidth(24)),
              backgroundColor: primaryDefault,
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
    ));
  }

  Widget buildTagArea() {
    return Obx(() => Container(
      width: ScreenUtil().screenWidth * 0.9,
      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
      decoration: BoxDecoration(
        color: primaryTint,
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Text(
            "您的標籤(" + skillController.skillList.length.toString() + "/10)",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(16)
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(10),),
          Wrap(
            spacing: ScreenUtil().setWidth(10),
            runSpacing: ScreenUtil().setWidth(5),
            children: buildSkillsItems(skillController.skillList)
          )
        ]
      )
    ));
  }

  List<Widget> buildSkillsItems(List<String> skillStrings) {
    List<Widget> skillItems = [];
    for(int i = 0; i < skillStrings.length; i++) {
      skillItems.add(
        Container(
          margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(2)),
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
          decoration: BoxDecoration(
            color: primaryDefault,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  skillStrings[i],
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    color: Colors.white
                  )
              ),
              SizedBox(width: ScreenUtil().setWidth(5),),
              Padding(
                padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(10)),
                child: ClipOval(
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {skillController.deleteSkill(skillStrings[i]);},
                      child: SizedBox(width: 20, height: 20, child: Icon(Icons.close_outlined, size: 18, color: primaryDefault)),
                    ),
                  ),
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