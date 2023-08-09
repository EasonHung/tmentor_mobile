import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/guide_screen/controller/field_controller.dart';

import '../../../color_constants.dart';
import '../controller/user_guide_controller.dart';

class FieldSelectionPage extends StatelessWidget {
  final UserGuideController userGuideController = Get.find<UserGuideController>();
  final FieldController fieldController = Get.find<FieldController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: ScreenUtil().setHeight(20),),
            buildHeader(),
            SizedBox(height: ScreenUtil().setHeight(5),),
            buildDescription(),
            SizedBox(height: ScreenUtil().setHeight(10),),
            ...buildFieldOptions(fieldController.fieldsOptions),
          ]
        )
      )
    );
  }

  Widget buildHeader() {
    return Text(
      "您的專業領域",
      style: TextStyle(
          fontSize: ScreenUtil().setSp(24 ),
          fontWeight: FontWeight.bold
      ),
    );
  }

  Widget buildDescription() {
    return Text(
      "請根據您的專業選擇\n您最多可以選擇3種領域",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: ScreenUtil().setSp(14),
          color: Colors.grey
      ),
    );
  }

  Widget buildFieldsSelection() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...buildFieldOptions(fieldController.fieldsOptions)
        ],
      )
    );
  }

  List<Widget> buildFieldOptions(List<String> options) {
    List<Widget> widgets = [];

    for(int i = 0; i < options.length; i++) {
      widgets.add(
        Obx(() => InkWell(
          onTap: () {
            if(fieldController.fieldsChecks[i] == false && !fieldController.checkSelectedFieldLength()) {
              return;
            }

            fieldController.fieldsChecks[i] = !fieldController.fieldsChecks[i];
            if(fieldController.fieldsChecks[i]) {
              fieldController.addSelectField(fieldController.fieldsOptions[i]);
            } else {
              fieldController.removeSelectField(fieldController.fieldsOptions[i]);
            }
          },
          child: Container(
            width: ScreenUtil().screenWidth * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: fieldController.fieldsChecks[i]? primaryDefault : black400,
                width: fieldController.fieldsChecks[i]? ScreenUtil().setWidth(2) : ScreenUtil().setWidth(2),
              )
            ),
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10), vertical: ScreenUtil().setWidth(5)),
            margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10), vertical: ScreenUtil().setWidth(6)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    options[i],
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getCheckboxColor),
                      shape: CircleBorder(),
                      value: fieldController.fieldsChecks[i],
                      onChanged: (value) {
                        if(fieldController.fieldsChecks[i] == false && !fieldController.checkSelectedFieldLength()) {
                          return;
                        }

                        fieldController.fieldsChecks[i] = !fieldController.fieldsChecks[i];
                        if(fieldController.fieldsChecks[i]) {
                          fieldController.addSelectField(fieldController.fieldsOptions[i]);
                        } else {
                          fieldController.removeSelectField(fieldController.fieldsOptions[i]);
                        }
                      },
                    ),
                  ),
                ]
            ),
          ),
        ))
      );
    }

    return widgets;
  }

  Color getCheckboxColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
      MaterialState.selected
    };
    if (states.any(interactiveStates.contains)) {
      return primaryDefault;
    }
    return black400;
  }

}