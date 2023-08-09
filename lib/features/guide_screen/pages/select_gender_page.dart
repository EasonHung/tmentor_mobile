import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/color_constants.dart';

import '../controller/gender_controller.dart';
import '../controller/user_guide_controller.dart';

class SelectGenderPage extends StatelessWidget {
  final UserGuideController userGuideController = Get.find<UserGuideController>();
  final GenderController genderController = Get.find<GenderController>();

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildHeader(),
                SizedBox(height: ScreenUtil().setHeight(25)),
                buildGenderSelection(),
                SizedBox(height: ScreenUtil().setHeight(25)),
                buildDescription()
              ]
            )
          )
        )
      ]
    );
  }

  Widget buildHeader() {
    return Text(
      "您的性別",
      style: TextStyle(
        fontSize: ScreenUtil().setSp(20),
        fontWeight: FontWeight.bold
      ),
    );
  }

  Widget buildGenderSelection() {
    return Obx(() => Row(
      children: [
        Spacer(),
        Container(
          padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
          width: ScreenUtil().screenWidth * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              width: ScreenUtil().setWidth(2),
              color: genderController.selectedGender.value == "男性"? primaryDefault : black400
            )
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Transform.scale(
                    scale: 1.3,
                    child: Radio(
                      value: "男性",
                      fillColor: MaterialStateColor.resolveWith(getBorderColor),
                      groupValue: genderController.selectedGender.value,
                      onChanged: (value) {
                        genderController.selectedGender.value = value as String;
                      },
                    ),
                  ),
                ]
              ),
              SvgPicture.asset(
                "assets/images/guide_page_male.svg",
                fit: BoxFit.fitWidth,
                width: ScreenUtil().setWidth(92),
              ),
              SizedBox(height: ScreenUtil().setHeight(10),),
              Text(
                "男性",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          )
        ),
        Spacer(),
        Container(
          padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
          width: ScreenUtil().screenWidth * 0.4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                width: ScreenUtil().setWidth(2),
                color: genderController.selectedGender.value == "女性"? primaryDefault : black400
              )
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Transform.scale(
                    scale: 1.3,
                    child: Radio(
                      value: "女性",
                      fillColor: MaterialStateColor.resolveWith(getBorderColor),
                      groupValue: genderController.selectedGender.value,
                      onChanged: (value) {
                        genderController.selectedGender.value = value as String;
                      },
                    )
                  ),
                ]
              ),
              SvgPicture.asset(
                "assets/images/guide_page_female.svg",
                fit: BoxFit.fitWidth,
                width: ScreenUtil().setWidth(92),
              ),
              SizedBox(height: ScreenUtil().setHeight(10),),
              Text(
                "女性",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          )
        ),
        Spacer(),
      ],
    ));
  }

  Color getBorderColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.selected,
    };
    if (states.any(interactiveStates.contains)) {
      return primaryDefault;
    }
    return black400;
  }

  Widget buildDescription() {
    return Text(
      "為了給您更好的使用體驗\n我們需要知道您的性別",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: ScreenUtil().setSp(14),
        color: Colors.grey
      ),
    );
  }

}