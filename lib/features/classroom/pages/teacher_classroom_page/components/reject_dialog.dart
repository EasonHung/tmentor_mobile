import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../main_page.dart';

class RejectDialog {
  BuildContext context;

  RejectDialog(this.context);

  void show() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "抱歉!",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.bold
                ),
              ),
              Image(
                width: ScreenUtil().setWidth(50),
                image: AssetImage('assets/images/waiting_picture.png')
              ),
              SizedBox(height: ScreenUtil().setHeight(5),),
              Text("老師已拒絕/教室中已有學生"),
              SizedBox(height: ScreenUtil().setHeight(5),),
              Row(
                children: [
                  Spacer(),
                  SizedBox(
                    width: ScreenUtil().setWidth(90),
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                            return MainScreen();
                          }));
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  ScreenUtil().setWidth(10))),
                              side: BorderSide(
                                  color: Colors.grey,
                                  width: ScreenUtil().setWidth(1),
                                  style: BorderStyle.solid
                              )
                          ),
                        ),
                        child: Text(
                            "確認",
                            style: TextStyle(
                                color: Colors.grey
                            )
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