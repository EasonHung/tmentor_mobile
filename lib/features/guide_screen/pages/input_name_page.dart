import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../color_constants.dart';
import '../controller/nickname_and_profession_controller.dart';

class InputNamePage extends StatelessWidget {
  final NicknameAndProfessionController nicknameAndProfessionController = Get.find<NicknameAndProfessionController>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildLogo(),
              SizedBox(height: ScreenUtil().setHeight(20),),
              buildHeader("如何稱呼您?"),
              SizedBox(height: ScreenUtil().setHeight(5),),
              buildDescription(),
              SizedBox(height: ScreenUtil().setHeight(15),),
              buildInputName(),
              SizedBox(height: ScreenUtil().setHeight(15),),
              buildHeader("您現在的職業?"),
              SizedBox(height: ScreenUtil().setHeight(15),),
              buildInputProfession(),
            ]
          )
        )
      )
    );
  }

  Widget buildLogo() {
    return Container(
      width: ScreenUtil().setWidth(100),
      height: ScreenUtil().setWidth(100),
      decoration: BoxDecoration(
        color: primaryDefault,
        shape: BoxShape.circle
      ),
    );
  }

  Widget buildHeader(String str) {
    return Text(
      str,
      style: TextStyle(
        fontSize: ScreenUtil().setSp(20),
        fontWeight: FontWeight.bold
      ),
    );
  }

  Widget buildDescription() {
    return Text(
      "您未來的導師與導生將會這樣稱呼您",
      style: TextStyle(
        fontSize: ScreenUtil().setSp(14),
        color: Colors.grey
      ),
    );
  }

  Widget buildInputName() {
    return TextField(
      decoration: InputDecoration(
        focusedBorder:OutlineInputBorder(
          borderSide: const BorderSide(color: primaryDefault, width: 2.0),
          borderRadius: BorderRadius.circular(5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: black400, width: 2.0),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      textAlign: TextAlign.center,
      controller: nicknameAndProfessionController.nicknameTextController,
      onChanged: (text) {
        nicknameAndProfessionController.validateInput();
      },
    );
  }

  Widget buildInputProfession() {
    return TextField(
      decoration: InputDecoration(
        focusedBorder:OutlineInputBorder(
          borderSide: const BorderSide(color: primaryDefault, width: 2.0),
          borderRadius: BorderRadius.circular(5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: black400, width: 2.0),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      textAlign: TextAlign.center,
      controller: nicknameAndProfessionController.professionTextController,
      onChanged: (text) {
        nicknameAndProfessionController.validateInput();
      },
    );
  }

}