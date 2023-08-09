import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';
import '../../../vo/mentor_item.dart';
import '../controller/edit_user_info_controller.dart';
import '../controller/user_info_controller.dart';
import '../page/education_add_page.dart';
import '../page/education_edit_page.dart';

class EducationWidget extends StatelessWidget {
  final UserInfoController userInfoController = Get.find<UserInfoController>();
  final EditUserInfoController editController = Get.find<EditUserInfoController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "教育背景",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(20),
                  fontWeight: FontWeight.bold
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
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return EducationAddPage();
                  }));
                },
              ) : SizedBox()
            ],
          ),
          userInfoController.isEditing.value? SizedBox.shrink() : SizedBox(height: 10.h),
          ...buildJobEducationItems(context)
        ]
      )
    ));
  }

  List<Widget> buildJobEducationItems(BuildContext context) {
    return userInfoController.isEditing.value?
    buildJobEducationItemsWithBorder(userInfoController.userInfo.value.educationList!, context) :
    buildJobEducationItemsWithoutBorder(userInfoController.userInfo.value.educationList!);
  }

  List<Widget> buildJobEducationItemsWithoutBorder(List<Education> educationList) {
    List<Widget> widgetList = [];
    if(educationList == null) {
      widgetList.add(SizedBox.shrink());
      return widgetList;
    }

    for(int i = 0; i < educationList.length; i++){
      widgetList.add(
        Container(
          margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(5)),
          child: Column(
            children: [
              Row(
                children:[
                  Text(
                    educationList[i].schoolName,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(18),
                        fontWeight: FontWeight.bold,
                        color: primaryDark
                    ),
                  )
                ]
              ),
              SizedBox(height: ScreenUtil().setHeight(6)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    educationList[i].subject,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(18),
                    ),
                  ),
                  Text(
                    educationList[i].startTime + " - " + educationList[i].endTime,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(18),
                    ),
                  )
                ]
              ),
              SizedBox(height: ScreenUtil().setHeight(6)),
            ],
          )
        )
      );

      // add space between items
      if(i < educationList.length - 1) {
        widgetList.add(SizedBox(height: ScreenUtil().setHeight(12)));
      }
    }

    return widgetList;
  }

  List<Widget> buildJobEducationItemsWithBorder(List<Education> educationList, BuildContext context) {
    List<Widget> widgetList = [];
    if(educationList == null) {
      widgetList.add(SizedBox.shrink());
      return widgetList;
    }

    for(int i = 0; i < educationList.length; i++) {
      widgetList.add(
          InkWell(
            onTap: () async {
              editController.initEditEducation(educationList[i]);
              await Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return EducationEditPage();
              }));
              editController.cleanEditEducation();
            },
            child: Container(
              margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(5)),
              padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border:  Border.all(
                  color: black500,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children:[
                      Text(
                        educationList[i].schoolName,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(18),
                          fontWeight: FontWeight.bold,
                          color: primaryDark
                        ),
                      )
                    ]
                  ),
                  SizedBox(height: ScreenUtil().setHeight(6)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        educationList[i].subject,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(18),
                        ),
                      ),
                      Text(
                        educationList[i].startTime + " - " + educationList[i].endTime,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(18),
                        ),
                      )
                    ]
                  ),
                ],
              )
            )
        )
      );

      // add space between items
      if(i < educationList.length - 1) {
        widgetList.add(SizedBox(height: ScreenUtil().setHeight(12)));
      }
    }

    return widgetList;
  }
}