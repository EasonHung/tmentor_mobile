import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';
import 'package:mentor_app_flutter/features/user_info_screen/controller/edit_user_info_controller.dart';

import '../../../color_constants.dart';
import '../controller/user_info_controller.dart';
import 'package:get/get.dart';

class JobExperienceAddPage extends StatelessWidget {
  final UserInfoController userInfoController = Get.find<UserInfoController>();
  final EditUserInfoController editController = Get.find<EditUserInfoController>();

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
          "工作經驗",
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
                          companyInput(),
                          SizedBox(height: ScreenUtil().setHeight(20),),
                          professionNameInput(),
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

  Widget buildSaveBtn(BuildContext context) {
    return SizedBox(
      height: ScreenUtil().setHeight(60), // <-- Your height
      width: ScreenUtil().screenWidth * 0.9,
      child: TextButton(
        onPressed: () {
          NumberFormat formatter = NumberFormat("00");
          String endString = editController.jobExperienceEndedMonth == "" || editController.jobExperienceEndedYear == ""?
            "迄今" : editController.jobExperienceEndedYear + "/" + formatter.format(int.parse(editController.jobExperienceEndedMonth));
          if(userInfoController.saveJobExperience(
              editController.companyNameController.text,
              editController.professionNameController.text,
              editController.jobExperienceStartedYear + "/" + formatter.format(int.parse(editController.jobExperienceStartedMonth)),
              endString)) {
            Navigator.of(context).pop();
          } else {
            Toast.show("輸入錯誤", backgroundColor: Colors.red[300]!);
          }
        },
        child: Text(
          "新增",
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(16)
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: primaryDefault,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(15)))),
        ),
      )
    );
  }

  Widget companyInput() {
    return Column(
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
              color: Colors.grey,
            ),
          ),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            controller: editController.companyNameController,
          )
        )
      ],
    );
  }

  Widget professionNameInput() {
    return Column(
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
              color: Colors.grey,
            ),
          ),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            controller: editController.professionNameController,
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
          "任職日期",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(18),
            fontWeight: FontWeight.w600
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(5),),
        DropdownDatePicker(
          onChangedMonth: (month) {
            editController.jobExperienceStartedMonth = month!;
          },
          onChangedYear: (year) {
            editController.jobExperienceStartedYear = year!;
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
              "在職：",
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16)
              ),
            ),
            Radio(
              value: true,
              groupValue: editController.isNow.value,
              onChanged: (value) {
                editController.jobExperienceEndedMonth = "";
                editController.jobExperienceEndedYear = "";
                editController.isNow.value = value as bool;
              },
            ),
            Text(
              "離職：",
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16)
              ),
            ),
            Radio(
              value: false,
              groupValue: editController.isNow.value,
              onChanged: (value) {
                editController.isNow.value = value as bool;
              },
            ),
          ],
        ),
        editController.isNow.value? SizedBox() : Text(
          "離職日期",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(18),
            fontWeight: FontWeight.w600
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(5),),
        editController.isNow.value? SizedBox() : DropdownDatePicker(
          selectedMonth: editController.jobExperienceEndedMonth == ""? null : int.parse(editController.jobExperienceEndedMonth),
          selectedYear: editController.jobExperienceEndedYear == ""? null : int.parse(editController.jobExperienceEndedYear),
          onChangedMonth: (month) {
            editController.jobExperienceEndedMonth = month!;
          },
          onChangedYear: (year) {
            editController.jobExperienceEndedYear = year!;
          },
          showDay: false,
          locale: 'zh_CN'
        )
      ],
    ));
  }
}