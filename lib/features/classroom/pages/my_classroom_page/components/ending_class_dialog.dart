import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/classroom/classroom_screen.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_class_process_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_classroom_class_controller.dart';
import 'package:mentor_app_flutter/features/main_page.dart';

import '../../../../../color_constants.dart';

class EndingClassDialog {
  BuildContext context;
  EndingClassDialog(this.context);

  final MyClassroomClassController myClassroomClassController = Get.find<MyClassroomClassController>();

  void show() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "你確定要結束教室嗎?",
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(5),),
              Text("學生將被強制退出\n若有課堂正在進行中，將會視為不正常結束"),
              Row(
                children: [
                  Spacer(),
                  SizedBox(
                    width: ScreenUtil().setWidth(90),
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10))),
                              side: BorderSide(
                                  color: Colors.grey,
                                  width: ScreenUtil().setWidth(1),
                                  style: BorderStyle.solid
                              )
                          ),
                        ),
                        child: Text(
                            "取消",
                            style: TextStyle(
                                color: Colors.grey
                            )
                        )
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: ScreenUtil().setWidth(90),
                    child: TextButton(
                      onPressed: () async {
                        await myClassroomClassController.closeRoom();
                        Navigator.pop(context);
                        await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                          return MainScreen();
                        }));
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: primaryDefault,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10)))),
                      ),
                      child: Text(
                        "確定退出",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      )
                    ),
                  ),
                  Spacer(),
                ],
              )
            ],
          ),
        );
      }
    );
  }
}