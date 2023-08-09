import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_classroom_class_controller.dart';

import '../../../../../color_constants.dart';
import '../controller/my_class_process_controller.dart';

class StartClassDialog {
  BuildContext context;
  final MyClassProcessController myClassProcessController = Get.find<MyClassProcessController>();
  bool isReimburseClass;
  int classTime;
  int classPoints;

  StartClassDialog(this.context, this.isReimburseClass, this.classTime, this.classPoints);

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
                "開啟新課程",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(5),),
              Image(
                  width: ScreenUtil().setWidth(50),
                  image: AssetImage('assets/images/start_class.png')
              ),
              SizedBox(height: ScreenUtil().setHeight(5),),
              isReimburseClass? Text("由於上一堂課尚未正常結束，所以需要先補完課程") : SizedBox.shrink(),
              Text("待學生確認後即可開始上課"),
              SizedBox(height: ScreenUtil().setHeight(5),),
              Text(
                classTime.toString() + "分鐘 | " + classPoints.toString() + "點",
                style: TextStyle(
                  color: primaryDefault
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(5),),
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
                      onPressed: () {
                        myClassProcessController.startClass();
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: primaryDefault,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10)))),
                      ),
                      child: Text(
                        "確認",
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
          )
        );
      }
    );
  }
}