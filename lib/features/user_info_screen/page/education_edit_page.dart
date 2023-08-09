import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mentor_app_flutter/features/user_info_screen/controller/edit_user_info_controller.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';
import '../controller/user_info_controller.dart';

class EducationEditPage extends StatelessWidget {
  final EditUserInfoController editController = Get.find<EditUserInfoController>();
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
          "教育背景",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
          ),
        )
      ),
      body: SingleChildScrollView(
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
                          schoolInput(),
                          SizedBox(height: ScreenUtil().setHeight(20),),
                          subjectNameInput(),
                          SizedBox(height: ScreenUtil().setHeight(20),),
                          fromInput(),
                          SizedBox(height: ScreenUtil().setHeight(20),),
                          toInput()
                        ],
                      )
                  ),
                  Divider(),
                  SizedBox(height: ScreenUtil().setHeight(20),),
                  buildSaveBtn(context),
                  SizedBox(height: ScreenUtil().setHeight(20),),
                ],
              )
            )
          )
        )
      )
    );
  }

  Widget schoolInput() {
    return Column(
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
                color: Colors.grey,
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              controller: editController.schoolNameController,
            )
        )
      ],
    );
  }

  Widget subjectNameInput() {
    return Column(
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
              color: Colors.grey,
            ),
          ),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            controller: editController.subjectNameController,
          )
        )
      ],
    );
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
          selectedMonth: int.parse(editController.educationStartedMonth),
          selectedYear: int.parse(editController.educationStartedYear),
          onChangedMonth: (month) {
            editController.educationStartedMonth = month!;
          },
          onChangedYear: (year) {
            editController.educationStartedYear = year!;
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
              groupValue: editController.stillIsStudent.value,
              onChanged: (value) {
                editController.stillIsStudent.value = value as bool;
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
              groupValue: editController.stillIsStudent.value,
              onChanged: (value) {
                editController.educationEndedMonth = "";
                editController.educationEndedYear = "";
                editController.stillIsStudent.value = value as bool;
              },
            ),
          ],
        ),
        editController.stillIsStudent.value? SizedBox() : Text(
          "畢業年分",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(18),
            fontWeight: FontWeight.w600
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(5),),
        editController.stillIsStudent.value? SizedBox() : DropdownDatePicker(
          selectedMonth: editController.educationEndedMonth == ""? null : int.parse(editController.educationEndedMonth),
          selectedYear: editController.educationEndedYear == ""? null : int.parse(editController.educationEndedYear),
          onChangedMonth: (month) {
            editController.educationEndedMonth = month!;
          },
          onChangedYear: (year) {
            editController.educationEndedYear = year!;
          },
          showDay: false,
          locale: 'zh_CN'
        )
      ],
    ));
  }

  Widget buildSaveBtn(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: ScreenUtil().screenWidth * 0.45,
            height: ScreenUtil().setHeight(52),
            child: TextButton(
              onPressed: () {
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
            height: ScreenUtil().setHeight(52),
            child: TextButton(
              onPressed: () {
                NumberFormat formatter = NumberFormat("00");
                String endString = editController.educationEndedMonth == "" || editController.educationEndedYear == ""?
                "迄今" : editController.educationEndedYear + "/" + formatter.format(int.parse(editController.educationEndedMonth));
                userInfoController.modifyEducation(
                    editController.schoolNameController.text,
                    editController.subjectNameController.text,
                    editController.educationStartedYear + "/" + formatter.format(int.parse(editController.educationStartedMonth)),
                    endString,
                    editController.editedEducation);
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