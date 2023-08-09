import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentor_app_flutter/features/user_info_screen/component/stored_record.dart';
import 'package:mentor_app_flutter/features/user_info_screen/controller/user_info_controller.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';
import '../component/stored_class.dart';

class ClassInfoPage extends StatelessWidget {
  final UserInfoController userInfoController = Get.find<UserInfoController>();

  @override
  Widget build(BuildContext context) {

    return Obx(() => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                buildDropButton(),
                SizedBox(width: 14.w)
              ]
            ),
            userInfoController.showClassInfoPage.value == "已儲存教室"?
            StoredClass() : StoredRecord()
          ],
        )
    ));
  }

  Widget buildDropButton() {
    return Obx(() => Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        border: Border.all(
            color: black500,
            width: 1.w
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isDense: true,
            value: userInfoController.showClassInfoPage.value,
            elevation: 16,
            onChanged: (String? value) {
              userInfoController.showClassInfoPage.value = value!;
            },
            items: ["已儲存教室", "課程紀錄"].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                      fontSize: 16.sp
                  ),
                ),
              );
            }).toList(),
          )
      ),
    ));
  }
}