import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../color_constants.dart';
import '../page/class_info_edit_page.dart';
import '../controller/edit_class_setting_controller.dart';
import '../controller/user_info_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class StoredClass extends StatelessWidget {
  final UserInfoController userInfoController = Get.find<UserInfoController>();
  final EditClassSettingController editController = Get.find<EditClassSettingController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
      child: Column(
        children: [
          ...buildStoredClassList(context)
        ],
      )
    ));
  }

  List<Widget> buildStoredClassList(BuildContext context) {
    List<Widget> widgets = [];

    userInfoController.classSettingInfoList.forEach((element) {
      widgets.add(
        Container(
          margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(10)),
          padding: EdgeInsets.only(left: 12.w, bottom: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border:  Border.all(
              color: black500,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Text(
                    element.title,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(18),
                      fontWeight: FontWeight.bold,
                      color: black900
                    ),
                  ),
                  TextButton(
                    child: SvgPicture.asset(
                      "assets/images/editIcon.svg",
                      width: 20.w,
                      color: black500
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero
                    ),
                    onPressed: () {
                      editController.initClassSetting(element);
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return ClassInfoEditPage();
                      }));
                    },
                  ),
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      element.desc,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(16),
                      ),
                    )
                  )
                ]
              ),
              SizedBox(height: 12.h,),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/images/class_setting.svg",
                    width: 16.w,
                  ),
                  SizedBox(width: 4.w,),
                  Text(
                    element.classTime.toString() + "分鐘",
                    style: TextStyle(
                      color: primaryDefault,
                      fontSize: 16.sp
                    )
                  ),
                  SizedBox(width: 8.w,),
                ],
              )
            ],
          )
        )
      );
    });
    return widgets;
  }

}