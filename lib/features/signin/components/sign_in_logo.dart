import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../color_constants.dart';

class SignInLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: ScreenUtil().setWidth(100),
        height: ScreenUtil().setWidth(100),
        decoration: BoxDecoration(color: primaryDefault, shape: BoxShape.circle),
      )
    ]);
  }
}