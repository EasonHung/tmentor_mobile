import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/classroom/pages/classroom_list_page/controller/classroom_list_ws_controller.dart';
import 'package:mentor_app_flutter/service/toast_service.dart';

import '../../../../../color_constants.dart';
import '../../../../../vo/class_setting_info.dart';
import '../../../my_classroom_screen.dart';
import '../controller/class_setting_controller.dart';

class NewClassSettingDialog {
  ClassroomListWsController classListWsController = Get.find<ClassroomListWsController>();
  ClassSettingController classSettingController = Get.find<ClassSettingController>();
  BuildContext context;
  NewClassSettingDialog(this.context);

  void show() {
    classSettingController.cleanSelected();
    showModalBottomSheet(
      backgroundColor: black200,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20)
        )
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, classSettingSetState) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildSettingClassTitle(context),
                    buildClassInfoInput(context),
                    buildDivider(),
                    buildConfirmClassInfo(context)
                  ],
                )
              );
            }
          )
        );
      }
    );
  }

  Widget buildSaveCheckBox() {
    return Obx(() => Row(
      children: [
        SizedBox(
          height: 24.h,
          width: 24.w,
          child: Checkbox(
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.resolveWith(getColor),
            value: classSettingController.wantToSave.value,
            onChanged: (bool? value) {
              classSettingController.setSaveStatus(value!);
            },
          ),
        ),
        Text(
          "儲存教室設定",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(16),
            color: black800
          )
        )
      ]
    ));
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return primaryDefault;
    }
    return primaryDefault;
  }

  Widget buildConfirmClassInfo(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(4), right: ScreenUtil().setWidth(20), top: ScreenUtil().setWidth(8), bottom: ScreenUtil().setHeight(16)),
        child: Row(
          children: [
            // Image(
            //     width: ScreenUtil().setWidth(50),
            //     image: AssetImage('assets/images/class_setting.png')
            // ),
            SizedBox(width: ScreenUtil().setWidth(15),),
            SizedBox(
              width: ScreenUtil().setWidth(220),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                    classSettingController.confirmedTitle.value == ""?
                    "(教室名稱)" : classSettingController.confirmedTitle.value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black
                    ),
                  )
                  ),
                  Obx(() => Text(
                    classSettingController.selectedClassTime.value + "  ",
                    // classSettingController.selectedClassTime.value + "  " + classSettingController.confirmedClassPoints.value + "點",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black
                    ),
                  ))
                ]
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () async {
                if(classSettingController.titleTextController.text == "" || classSettingController.descTextController.text == "") {
                  ToastService.showAlert("請輸入完整");
                  return;
                }

                classSettingController.saveClassSetting();
                Navigator.of(context).pop();
                await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                  return MyClassroomScreen(ClassSettingInfo(
                    classSettingController.titleTextController.text,
                    classSettingController.titleTextController.value.text,
                    classSettingController.descTextController.text,
                    int.parse(classSettingController.selectedClassTime.replaceAll("分鐘", "")),
                    int.parse(classSettingController.classPointsTextController.text)
                  ));
                }));
              },
              style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(15), horizontal: ScreenUtil().setWidth(25)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ScreenUtil().radius(5)),
                  ),
                  backgroundColor: primaryDefault
              ),
              child: Text(
                "確認課程",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(16),
                ),
              )
            )
          ],
        )
    );
  }

  Widget buildDivider() {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            Divider(),
          ],
        )
    );
  }

  Widget buildSettingClassTitle(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10), vertical: ScreenUtil().setHeight(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 24.0,
                  color: Colors.black,
                ),
                onPressed: (){
                  Navigator.of(context).pop();
                }
            ),
            Text(
              "確認課程",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(18)
              ),
            ),
            SizedBox(width: 32.w,),
          ],
        )
    );
  }

  Widget buildClassInfoInput(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20), vertical: ScreenUtil().setHeight(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "教室名稱",
                style: TextStyle(
                  color: black800,
                  fontSize: 16.sp
                )
            ),
            SizedBox(height: 8.h,),
            TextField(
              controller: classSettingController.titleTextController,
              style: TextStyle(
                  fontSize: 18
              ),
              maxLength: 12,
              decoration: InputDecoration(
                  hintText: "教室名稱",
                  hintStyle: TextStyle(
                    color: black500
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: black500
                      )
                  ),
              ),
              onChanged: (item) {
                classSettingController.confirmedTitle.value = item;
              },
            ),
            SizedBox(height: ScreenUtil().setHeight(15),),
            Text(
                "教室簡介",
                style: TextStyle(
                  color: black800,
                  fontSize: 16.sp
                )
            ),
            SizedBox(height: 8.h,),
            TextField(
              controller: classSettingController.descTextController,
              maxLines: 4,
              maxLength: 50,
              style: TextStyle(
                  fontSize: 18
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                hintText: "教室簡介",
                hintStyle: TextStyle(
                  color: black500
                ),
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
            ),
            Text(
                "課程時間",
                style: TextStyle(
                    color: black800,
                    fontSize: 16.sp
                )
            ),
            SizedBox(height: 8.h,),
            Listener( // 修復跑板問題
              onPointerDown: (_) => FocusScope.of(context).requestFocus(FocusNode()),
              child: DropdownButtonFormField(
                value: classSettingController.selectedClassTime.value,
                items: ["15分鐘", "30分鐘", "60分鐘", "90分鐘", "120分鐘"]
                    .map((item) {
                  return DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(
                            fontSize: 18
                        ),
                      )
                  );
                }
                ).toList(),
                onChanged: (item) {
                  classSettingController.selectedClassTime.value = item as String;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: black500
                    )
                  )
                )
              )
            ),
            SizedBox(height: 15.h,),
            // SizedBox(height: ScreenUtil().setHeight(15),),
            // const Text(
            //     "課程價格(點數/15分鐘)",
            //     style: TextStyle(
            //         color: Colors.grey
            //     )
            // ),
            // TextField(
            //   keyboardType: TextInputType.number,
            //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            //   controller: classSettingController.classPointsTextController,
            //   style: TextStyle(
            //       fontSize: 18
            //   ),
            //   decoration: InputDecoration(
            //       hintText: "課程價格(點數/15分鐘)",
            //       enabledBorder: OutlineInputBorder(
            //           borderSide: BorderSide(
            //               width: 1,
            //               color: Colors.grey
            //           )
            //       )
            //   ),
            //   onChanged: (item) {
            //     classSettingController.confirmedClassPoints.value = item;
            //   },
            // ),
            buildSaveCheckBox()
          ],
        )
    );
  }
}