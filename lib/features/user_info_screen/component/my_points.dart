import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:mentor_app_flutter/color_constants.dart';
import 'package:get/get.dart';

import '../controller/user_info_controller.dart';

class MyPoints extends StatelessWidget {
  final UserInfoController userInfoController = Get.find<UserInfoController>();

  @override
  Widget build(BuildContext context) {
    userInfoController.getUserPointsInfo();
    return Obx(() => Container(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(15), horizontal: ScreenUtil().setWidth(30)),
      margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10), horizontal: ScreenUtil().setWidth(20)),
      decoration: BoxDecoration(
        color: primaryDefault,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "您的點數",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(18),
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
          Row(
            children: [
              Image(
                fit: BoxFit.fitWidth,
                width: ScreenUtil().setWidth(36),
                image: AssetImage('assets/images/coin.png')
              ),
              Text(
                userInfoController.points.value,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(18),
                  color: Colors.white
                ),
              )
            ]
          )
        ],
      )
    ));
  }

}