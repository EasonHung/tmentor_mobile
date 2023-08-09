import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PcDisconnectDialog {
  BuildContext context;

  PcDisconnectDialog(this.context);

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
              "非常抱歉",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  fontWeight: FontWeight.bold
              ),
            ),
            Image(
                width: ScreenUtil().setWidth(50),
                image: AssetImage('assets/images/pc_disconnect.png')
            ),
            SizedBox(height: ScreenUtil().setHeight(5),),
            Text("連線已中斷，我們將會保留您剩餘的課程時間，待下次課程使用。"),
            SizedBox(height: ScreenUtil().setHeight(5),),
            Row(
              children: [
                Spacer(),
                SizedBox(
                  width: ScreenUtil().setWidth(90),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
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