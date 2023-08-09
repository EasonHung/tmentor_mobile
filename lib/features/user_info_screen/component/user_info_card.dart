import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/user_info_screen/component/skills.dart';
import 'package:mentor_app_flutter/features/user_info_screen/component/user_info_edit_btn.dart';

import '../../../color_constants.dart';
import '../controller/user_info_controller.dart';
import 'about_me.dart';
import 'avatar.dart';
import 'back_image.dart';
import 'education.dart';
import 'evaluation.dart';
import 'job_experiences.dart';
import 'name_and_profession.dart';

class UserInfoCard extends StatelessWidget {
  final UserInfoController userInfoController = Get.find<UserInfoController>();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 335.w,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Column(
              children: [
                BackImage(),
                SizedBox(height: 63.h,),
                NameAndProfession(),
                UserInfoEditBtn(),
                Divider(),
                SizedBox(height: ScreenUtil().setHeight(10)),
                AboutMe(),
                SizedBox(height: ScreenUtil().setHeight(24)),
                Skills(),
                SizedBox(height: ScreenUtil().setHeight(24)),
                JobExperiences(),
                SizedBox(height: ScreenUtil().setHeight(24)),
                EducationWidget(),
                SizedBox(height: ScreenUtil().setHeight(12)),
                Obx(() => userInfoController.isEditing.value? SizedBox.shrink() : EvaluationWidget(context)),
              ],
            )
          )
        ),
        AvatarWidget(),
      ]
    );
  }

}