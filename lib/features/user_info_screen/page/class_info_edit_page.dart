import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mentor_app_flutter/features/user_info_screen/controller/edit_user_info_controller.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';
import '../controller/edit_class_setting_controller.dart';
import '../controller/user_info_controller.dart';

class ClassInfoEditPage extends StatelessWidget {
  final EditClassSettingController editController = Get.find<EditClassSettingController>();
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
                color: Colors.grey,
                height: ScreenUtil().setHeight(1),
              ),
              preferredSize: Size.fromHeight(4.0)
          ),
          title: Text(
            "教室設定",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
          )
        ),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: ConstrainedBox(
            constraints: BoxConstraints(),
              child: IntrinsicHeight(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15), vertical: ScreenUtil().setHeight(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(height: ScreenUtil().setHeight(10),),
                            classNameInput(),
                            SizedBox(height: ScreenUtil().setHeight(20),),
                            classDescInput(),
                            SizedBox(height: ScreenUtil().setHeight(20),),
                            classTimeInput(),
                            SizedBox(height: ScreenUtil().setHeight(20),),
                            classPointsInput()
                          ],
                        )
                      ),
                      SizedBox(height: ScreenUtil().setHeight(20),),
                      buildBottomBtn(context),
                      SizedBox(height: ScreenUtil().setHeight(20),),
                    ],
                  )
              )
            )
          )
        )
      )
    );
  }

  Widget classNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "教室名稱",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(18),
            fontWeight: FontWeight.w600
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
          child: TextField(
            style: TextStyle(
              fontSize: ScreenUtil().setSp(16)
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            controller: editController.classNameController,
          )
        )
      ],
    );
  }

  Widget classDescInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "教室簡介",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(18),
            fontWeight: FontWeight.w600
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(5),),
        Container(
          padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border:  Border.all(
              color: Colors.grey,
            ),
          ),
          child: TextField(
            style: TextStyle(
              fontSize: ScreenUtil().setSp(16)
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            controller: editController.classDescController,
            maxLines: 4,
            maxLength: 50,
          )
        )
      ],
    );
  }

  Widget classTimeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "課程時間",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(18),
            fontWeight: FontWeight.w600
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(5),),
        SizedBox(
          child: DropdownButtonFormField(
            value: editController.classTime,
            items: ["15分鐘", "30分鐘", "60分鐘", "90分鐘", "120分鐘"]
                .map((item) {
              return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                        fontSize: 16
                    ),
                  )
              );
            }
            ).toList(),
            onChanged: (item) {
              editController.classTime = item as String;
            },
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.grey
                )
              )
            )
          )
        )
      ],
    );
  }

  Widget classPointsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "課程價格(點數)",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(18),
            fontWeight: FontWeight.w600
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
          child: TextField(
            style: TextStyle(
                fontSize: ScreenUtil().setSp(16)
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: editController.classPointsController,
          )
        )
      ],
    );
  }

  Widget buildBottomBtn(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: ScreenUtil().screenWidth * 0.45,
          height: ScreenUtil().setHeight(52),
          child: TextButton(
            onPressed: () {
              userInfoController.deleteClassSetting(
                  editController.editedClassSettingInfo.settingName
              );
              Navigator.of(context).pop();
            },
            child: Text(
              "刪除",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(16)
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(5)))),
            ),
          )
        ),
        Spacer(),
        SizedBox(
          width: ScreenUtil().screenWidth * 0.45,
          height: ScreenUtil().setHeight(52), // <-- Your height
          child: TextButton(
            onPressed: () {
              userInfoController.saveClassSetting(
                  editController.classNameController.text,
                  editController.classDescController.text,
                  int.parse(editController.classTime.replaceAll("分鐘", "")),
                  int.parse(editController.classPointsController.text),
                  editController.editedClassSettingInfo
              );
              Navigator.of(context).pop();
            },
            child: Text(
              "儲存",
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(16)
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: primaryDefault,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(5)))),
            ),
          )
        )
      ]
    );
  }

}