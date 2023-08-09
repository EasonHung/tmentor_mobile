import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimesUpDialog {
  BuildContext context;

  TimesUpDialog(this.context);

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
              Image(
                  width: ScreenUtil().setWidth(50),
                  image: AssetImage('assets/images/waiting_picture.png')
              ),
              SizedBox(height: ScreenUtil().setHeight(5),),
              Text("時間到囉！"),
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
                            "確定",
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