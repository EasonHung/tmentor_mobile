import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/user_info_screen/controller/edit_user_info_controller.dart';

import '../../../color_constants.dart';
import '../../../vo/mentor_item.dart';
import '../controller/user_info_controller.dart';
import '../page/job_experience_add_page.dart';
import '../page/job_experience_edit_page.dart';

class JobExperiences extends StatelessWidget {
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
                  "工作經歷",
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
                      return JobExperienceAddPage();
                    }));
                  },
                ) : SizedBox()
              ],
            ),
            userInfoController.isEditing.value? SizedBox.shrink() : SizedBox(height: 10.h),
            ...buildJobExperienceTag(context)
          ]
        )
    ));
  }

  List<Widget> buildJobExperienceTag(BuildContext context) {
    return userInfoController.isEditing.value?
    buildJobExperienceItemsWithBorder(userInfoController.userInfo.value.jobExperiences!, context) :
    buildJobExperienceItemsWithoutBorder(userInfoController.userInfo.value.jobExperiences!);
  }

  List<Widget> buildJobExperienceItemsWithoutBorder(List<JobExperience> jobExperienceList) {
    List<Widget> widgets = [];
    for(int i = 0;i < jobExperienceList.length;i++) {
      widgets.add(
        Container(
          margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(5)),
          child: Column(
            children: [
              Row(
                children:[
                  Text(
                    jobExperienceList[i].companyName,
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
                    jobExperienceList[i].jobName,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(18),
                    ),
                  ),
                  Text(
                    jobExperienceList[i].startTime + " - " + jobExperienceList[i].endTime,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(18),
                    ),
                  )
                ]
              )
            ],
          )
        )
      );

      // add space between items
      if(i < jobExperienceList.length - 1) {
        widgets.add(SizedBox(height: ScreenUtil().setHeight(12)));
      }
    }
    return widgets;
  }

  List<Widget> buildJobExperienceItemsWithBorder(List<JobExperience> jobExperienceList, BuildContext context) {
    List<Widget> widgets = [];
    for(int i = 0;i < jobExperienceList.length;i++) {
      widgets.add(
          InkWell(
            onTap: () async {
              editController.initEditJobExperience(jobExperienceList[i]);
              await Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return JobExperienceEditPage();
              }));
              editController.cleanEditJobExperience();
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
                      jobExperienceList[i].companyName,
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
                      jobExperienceList[i].jobName,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(18),
                      ),
                    ),
                    Text(
                      jobExperienceList[i].startTime + " - " + jobExperienceList[i].endTime,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(18),
                      ),
                    )
                  ]
                )
              ],
            )
          )
        )
      );

      // add space between items
      if(i < jobExperienceList.length - 1) {
        widgets.add(SizedBox(height: ScreenUtil().setHeight(12)));
      }
    }
    return widgets;
  }
}