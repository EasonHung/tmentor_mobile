import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../color_constants.dart';

class BottomConfirmBtn extends StatelessWidget {
  final Function onPress;
  final String text;

  BottomConfirmBtn(this.onPress, this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenUtil().setHeight(52),
      width: ScreenUtil().screenWidth * 0.9,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: primaryDefault,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(5)))),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(16)),
        ),
        onPressed: () {
          onPress();
        },
      )
    );
  }

}