import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/guide_screen/controller/education_controller.dart';
import '../../../color_constants.dart';
import '../controller/user_guide_controller.dart';

class AddEducationPage extends StatelessWidget {
  final UserGuideController userGuideController = Get.find<UserGuideController>();
  final EducationController educationController = Get.find<EducationController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(20)),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: ScreenUtil().setHeight(20),),
                      buildHeader(),
                      SizedBox(height: ScreenUtil().setHeight(10),),
                      buildDescription(),
                      SizedBox(height: ScreenUtil().setHeight(10),),
                      schoolInput(),
                      SizedBox(height: ScreenUtil().setHeight(20),),
                      subjectNameInput(),
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
      "教育背景",
      style: TextStyle(
          fontSize: ScreenUtil().setSp(24),
          fontWeight: FontWeight.bold
      ),
    );
  }

  Widget buildDescription() {
    return Text(
      "請輸入您的教育背景!",
      style: TextStyle(
          fontSize: ScreenUtil().setSp(18),
          color: Colors.grey
      ),
    );
  }

  Widget schoolInput() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "學校名稱",
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
                color: educationController.schoolNameInputFocus.value? primaryDefault : Colors.grey,
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              onTap: () {
                educationController.schoolNameInputFocus.value = true;
                educationController.subjectInputFocus.value = false;
              },
              controller: educationController.schoolNameTextController,
            )
        )
      ],
    ));
  }

  Widget subjectNameInput() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "系所名稱",
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
                color: educationController.subjectInputFocus.value? primaryDefault : Colors.grey,
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              onTap: () {
                educationController.subjectInputFocus.value = true;
                educationController.schoolNameInputFocus.value = false;
              },
              controller: educationController.subjectTextController,
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
          "入學年分",
          style: TextStyle(
              fontSize: ScreenUtil().setSp(18),
              fontWeight: FontWeight.w600
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(5),),
        DropdownDatePicker(
            onChangedMonth: (month) {
              educationController.educationStartedMonth = month!;
            },
            onChangedYear: (year) {
              educationController.educationStartedYear = year!;
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
            Text(
              "已畢業：",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(16)
              ),
            ),
            Radio(
              value: false,
              groupValue: educationController.stillIsStudent.value,
              onChanged: (value) {
                educationController.stillIsStudent.value = value as bool;
              },
            ),
            Text(
              "在學/肄業：",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(16)
              ),
            ),
            Radio(
              value: true,
              groupValue: educationController.stillIsStudent.value,
              onChanged: (value) {
                educationController.stillIsStudent.value = value as bool;
              },
            ),
          ],
        ),
        educationController.stillIsStudent.value? SizedBox() : Text(
          "畢業年分",
          style: TextStyle(
              fontSize: ScreenUtil().setSp(18),
              fontWeight: FontWeight.w600
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(5),),
        educationController.stillIsStudent.value? SizedBox() : DropdownDatePicker(
            onChangedMonth: (month) {
              educationController.educationEndedMonth = month!;
            },
            onChangedYear: (year) {
              educationController.educationEndedYear = year!;
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
        educationController.addEducation();
      },
    );
  }
}