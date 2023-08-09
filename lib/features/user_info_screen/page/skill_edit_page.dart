import 'package:flutter/material.dart';

import '../../../color_constants.dart';
import '../component/skill_editing_input.dart';
import '../component/skill_editing_tag.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/user_info_controller.dart';

class SkillEditPage extends StatelessWidget {
  final UserInfoController userInfoController = Get.find<UserInfoController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          child: Container(
            color: black400,
            height: ScreenUtil().setHeight(1),
          ),
          preferredSize: Size.fromHeight(4.0)
        ),
        title: Text(
          "擅長技能",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        )
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15), vertical: ScreenUtil().setHeight(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkillInput(),
            SizedBox(height: ScreenUtil().setHeight(20),),
            SkillEditingTag()
          ],
        )
      )
    );
  }

}