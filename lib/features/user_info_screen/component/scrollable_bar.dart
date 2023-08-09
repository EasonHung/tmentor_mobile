import 'package:flutter/material.dart';

import '../../../color_constants.dart';
import '../constants/user_info_page.dart';
import '../controller/user_info_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ScrollableBar extends StatelessWidget {
  final UserInfoController userInfoController = Get.find<UserInfoController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              userInfoController.changeShowPage(UserInfoPageEnum.USER_INFO);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: ScreenUtil().setHeight(1),
                    color: Colors.white
                  ),
                )
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(8)),
                width: ScreenUtil().screenWidth/2,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: ScreenUtil().setHeight(3.5),
                      color: userInfoController.showPage.value == UserInfoPageEnum.USER_INFO? primaryDefault : Colors.white
                    ),
                  )
                ),
                child: Text(
                  "個人檔案",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(18),
                    color: userInfoController.showPage.value == UserInfoPageEnum.USER_INFO? primaryDefault : null
                  ),
                )
              )
            )
          ),
          InkWell(
            onTap: () {
              userInfoController.changeShowPage(UserInfoPageEnum.CLASS_INFO);
            },
            child: Container(
              // padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(3.5)),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: ScreenUtil().setHeight(1),
                    color: Colors.white
                  ),
                )
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(8)),
                width: ScreenUtil().screenWidth/2,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: ScreenUtil().setHeight(3.5),
                      color: userInfoController.showPage.value == UserInfoPageEnum.CLASS_INFO? primaryDefault : Colors.white
                    ),
                  )
                ),
                child: Text(
                  "課程資料",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(18),
                    color: userInfoController.showPage.value == UserInfoPageEnum.CLASS_INFO? primaryDefault : null
                  ),
                )
              )
            )
          ),
          // InkWell(
          //   onTap: () {
          //     userInfoController.changeShowPage(UserInfoPageEnum.POINTS_INFO);
          //   },
          //   child: Container(
          //     // padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(3.5)),
          //     decoration: BoxDecoration(
          //         border: Border(
          //           bottom: BorderSide(
          //             width: ScreenUtil().setHeight(1),
          //             color: Colors.white
          //           ),
          //         )
          //     ),
          //     child: Container(
          //       padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(8)),
          //       width: ScreenUtil().screenWidth/3,
          //       decoration: BoxDecoration(
          //         border: Border(
          //           bottom: BorderSide(
          //             width: ScreenUtil().setHeight(3.5),
          //             color: userInfoController.showPage.value == UserInfoPageEnum.POINTS_INFO? primaryDefault : Colors.white
          //           ),
          //         )
          //       ),
          //       child: Text(
          //         "點數儲值",
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //           fontSize: ScreenUtil().setSp(18),
          //           color: userInfoController.showPage.value == UserInfoPageEnum.POINTS_INFO? primaryDefault : null
          //         ),
          //       )
          //     )
          //   )
          // )
        ],
      )
    ));
  }

}