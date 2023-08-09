import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/color_constants.dart';
import 'package:mentor_app_flutter/features/guide_screen/controller/job_experience_controller.dart';
import '../controller/user_guide_controller.dart';

class AddJobExperiencePage extends StatelessWidget {
  final UserGuideController userGuideController = Get.find<UserGuideController>();
  final JobExperienceController jobExperienceController = Get.find<JobExperienceController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: ScreenUtil().setHeight(20),),
              buildHeader(),
              SizedBox(height: ScreenUtil().setHeight(10),),
              buildDescription(),
              SizedBox(height: ScreenUtil().setHeight(10),),
              companyInput(),
              SizedBox(height: ScreenUtil().setHeight(20),),
              professionNameInput(),
              SizedBox(height: ScreenUtil().setHeight(20),),
              fromInput(),
              SizedBox(height: ScreenUtil().setHeight(20),),
              toInput(),
              SizedBox(height: ScreenUtil().setHeight(20),),
              buildAddBtn()
            ]
          )
        )
      )
    );
  }

  Widget buildHeader() {
    return Text(
      "工作經驗",
      style: TextStyle(
        fontSize: ScreenUtil().setSp(24),
        fontWeight: FontWeight.bold
      ),
    );
  }

  Widget buildDescription() {
    return Text(
      "請輸入您過往的工作經驗!",
      style: TextStyle(
        fontSize: ScreenUtil().setSp(18),
        color: Colors.grey
      ),
    );
  }

  Widget companyInput() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "公司名稱",
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
                color: jobExperienceController.companyNameInputFocus.value? primaryDefault : Colors.grey,
              ),
            ),
            child: TextField(
              onTap: () {
                jobExperienceController.companyNameInputFocus.value = true;
                jobExperienceController.jobNameInputFocus.value = false;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              controller: jobExperienceController.companyTextController,
            )
        )
      ],
    ));
  }

  Widget professionNameInput() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "職稱",
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
                color: jobExperienceController.jobNameInputFocus.value? primaryDefault : Colors.grey,
              ),
            ),
            child: TextField(
              onTap: () {
                jobExperienceController.jobNameInputFocus.value = true;
                jobExperienceController.companyNameInputFocus.value = false;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              controller: jobExperienceController.jobNameTextController,
            )
        )
      ],
    ));
  }

  Widget fromInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "任職日期",
          style: TextStyle(
              fontSize: ScreenUtil().setSp(18),
              fontWeight: FontWeight.w600
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(5),),
        DropdownDatePicker(
            onChangedMonth: (month) {
              jobExperienceController.jobStartTimeMonth = month!;
            },
            onChangedYear: (year) {
              jobExperienceController.jobStartTimeYear = year!;
            },
            showDay: false,
            locale: 'zh_CN'
        )
      ],
    );
  }

  Widget toInput() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Radio(
              value: true,
              groupValue: jobExperienceController.jobExperienceIsNow.value,
              onChanged: (value) {
                jobExperienceController.jobEndTimeMonth = "";
                jobExperienceController.jobEndTimeYear = "";
                jobExperienceController.jobExperienceIsNow.value = value as bool;
              },
            ),
            Text(
              "在職",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(16)
              ),
            ),
            Radio(
              value: false,
              groupValue: jobExperienceController.jobExperienceIsNow.value,
              onChanged: (value) {
                jobExperienceController.jobExperienceIsNow.value = value as bool;
              },
            ),
            Text(
              "離職",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(16)
              ),
            ),
          ],
        ),
        jobExperienceController.jobExperienceIsNow.value? SizedBox() : Text(
          "離職日期",
          style: TextStyle(
              fontSize: ScreenUtil().setSp(18),
              fontWeight: FontWeight.w600
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(5),),
        jobExperienceController.jobExperienceIsNow.value? SizedBox() : DropdownDatePicker(
            selectedMonth: jobExperienceController.jobEndTimeMonth == ""? null : int.parse(jobExperienceController.jobEndTimeMonth),
            selectedYear: jobExperienceController.jobEndTimeYear == ""? null : int.parse(jobExperienceController.jobEndTimeYear),
            onChangedMonth: (month) {
              jobExperienceController.jobEndTimeMonth = month!;
            },
            onChangedYear: (year) {
              jobExperienceController.jobEndTimeYear = year!;
            },
            showDay: false,
            locale: 'zh_CN'
        )
      ],
    ));
  }

  Widget buildAddBtn() {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: primaryDefault,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(10)))),
      ),
      child: Text("添加", style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(18)),),
      onPressed: () {
        jobExperienceController.addJobExperience();
      },
    );
  }
  
}