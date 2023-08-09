import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentor_app_flutter/color_constants.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/guide_screen/controller/about_me_controller.dart';

import '../controller/user_guide_controller.dart';

class InputAboutMePage extends StatelessWidget {
  final AboutMeController aboutMeController = Get.find<AboutMeController>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: ScreenUtil().setHeight(20),),
            buildHeader(),
            SizedBox(height: ScreenUtil().setHeight(5),),
            buildDescription(),
            SizedBox(height: ScreenUtil().setHeight(20),),
            buildAboutMeInputForm(),
          ]
        )
      )
    );
  }

  Widget buildHeader() {
    return Text(
      "簡單介紹您自己",
      style: TextStyle(
          fontSize: ScreenUtil().setSp(24),
          fontWeight: FontWeight.bold
      ),
    );
  }

  Widget buildDescription() {
    return Text(
      "介紹您自己讓大家認識吧!",
      style: TextStyle(
        fontSize: ScreenUtil().setSp(16),
        color: black600
      ),
    );
  }

  Widget buildAboutMeInputForm() {
    return Container(
      width: ScreenUtil().screenWidth * 0.9,
      child: TextField(
        controller: aboutMeController.aboutMeTextController,
        maxLines: 7,
        maxLength: 150,
        style: TextStyle(
            fontSize: 18
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(ScreenUtil().setWidth(15)),
          hintText: "簡單介紹自己的經驗，讓大家更認識您!",
          hintStyle: TextStyle(
            color: black600
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: black400
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: primaryDefault
              )
          ),
        )
      )
    );
  }
}