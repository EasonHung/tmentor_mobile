import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../color_constants.dart';
import '../page/class_info_edit_page.dart';
import '../controller/edit_class_setting_controller.dart';
import '../controller/user_info_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class StoredRecord extends StatelessWidget {
  final UserInfoController userInfoController = Get.find<UserInfoController>();
  final EditClassSettingController editController = Get.find<EditClassSettingController>();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
        child: Column(
          children: [
            ...buildStoredRecordList(context)
          ],
        )
    );
  }

  Widget buildStoredRecord(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(10)),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border:  Border.all(
          color: black500,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "藤永婕 | 後端工程師",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(16),
              color: black900
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Text(
                "教室名稱",
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(18),
                    fontWeight: FontWeight.bold,
                    color: black900
                ),
              )
            ]
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  "教室簡介ㄎㄨㄤdjal;sdlfkjal;sdfklaj;sdkf;javios;dvnio;envionrfio;vnkj;ndkfvnaqiwodevnioqwejifojiodvnjk;afvjn",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    color: black900
                  ),
                )
              )
            ]
          ),
          SizedBox(height: 12.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/images/class_setting.svg",
                    width: 16.w,
                  ),
                  SizedBox(width: 4.w,),
                  Text(
                    "45分鐘",
                    style: TextStyle(
                      color: primaryDefault,
                      fontSize: 16.sp
                    )
                  ),
                  SizedBox(width: 8.w,),
                ]
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.h),
                color: primaryTint,
                child: Text(
                  "導師紀錄",
                  style: TextStyle(
                    color: primaryDark
                  ),
                )
              )
            ],
          )
        ],
      )
    );
  }

  List<Widget> buildStoredRecordList(BuildContext context) {
    List<Widget> widgets = [];

    userInfoController.classRecordList.forEach((classRecord) {
      widgets.add(
          Container(
            margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(10)),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border:  Border.all(
                color: black500,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // "藤永婕 | 後端工程師",
                  classRecord.mentorInfo!.mentorNickname! + " | " + classRecord.mentorInfo!.mentorProfession!,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      color: black900
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Text(
                        // "教室名稱",
                        classRecord.title!,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(18),
                            fontWeight: FontWeight.bold,
                            color: black900
                        ),
                      )
                    ]
                ),
                SizedBox(height: 4.h),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                          child: Text(
                            // "教室簡介",
                            classRecord.desc!,
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(16),
                                color: black900
                            ),
                          )
                      )
                    ]
                ),
                SizedBox(height: 12.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        children: [
                          SvgPicture.asset(
                            "assets/images/class_setting.svg",
                            width: 16.w,
                          ),
                          SizedBox(width: 4.w,),
                          Text(
                              classRecord.classTime!.toString(),
                              style: TextStyle(
                                  color: primaryDefault,
                                  fontSize: 16.sp
                              )
                          ),
                          SizedBox(width: 8.w,),
                        ]
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.h),
                        color: primaryTint,
                        child: Text(
                          classRecord.classroomId == userInfoController.classroomId? "導師紀錄" : "學生紀錄",
                          style: TextStyle(
                              color: primaryDark
                          ),
                        )
                    )
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