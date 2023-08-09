import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/color_constants.dart';

import '../controller/user_info_controller.dart';

class StoredPointsCaseList extends StatelessWidget {
  final UserInfoController userInfoController = Get.find<UserInfoController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "儲值方案",
            style: TextStyle(
              fontSize: ScreenUtil().setSp(18),
              fontWeight: FontWeight.bold
            ),
          ),
          ...buildCases()
        ],
      )
    ));
  }

  List<Widget> buildCases() {
    List<Widget> widgets = [];
    List<Widget> row = [];
    for(int i = 0; i < userInfoController.storedCasePoints.length; i++) {
      if(i != 0 && i % 2 == 0) {
        widgets.add(
          Row(
            children: [
              row[0],
              Spacer(),
              row[1],
            ],
          )
        );
        row = [];
      }

      row.add(
        Container(
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              width: ScreenUtil().setHeight(1),
              color: Colors.grey
            )
          ),
          child: Column(
            children: [
              Container(
                height: ScreenUtil().setHeight(80),
                width: ScreenUtil().setWidth(160),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Image(
                        fit: BoxFit.fitWidth,
                        width: ScreenUtil().setWidth(36),
                        image: AssetImage('assets/images/coin.png')
                      ),
                      Text(
                        userInfoController.storedCasePoints[i],
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(24),
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                        ),
                      )
                    ]
                  ),
                )
              ),
              Container(
                decoration: BoxDecoration(
                  color: primaryLight,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)
                  )
                ),
                height: ScreenUtil().setHeight(50),
                width: ScreenUtil().setWidth(160),
                child: Center(
                  child: Text(
                    "TWD " + userInfoController.storedCasePoints[i],
                    style: TextStyle(
                      color: primaryDark,
                      fontSize: ScreenUtil().setSp(18)
                    ),
                  )
                )
              )
            ],
          )
        )
      );
    }

    if(row.length == 1) {
      widgets.add(
        Row(
          children: [
            row[0],
            Spacer(flex: 4),
          ]
        )
      );
    } else {
      widgets.add(
        Row(
          children: [
            Spacer(),
            row[0],
            Spacer(),
            row[1],
            Spacer()
          ],
        )
      );
    }

    return widgets;
  }
}