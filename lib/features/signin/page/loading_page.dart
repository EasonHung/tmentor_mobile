import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../color_constants.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDefault,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/splash_image.png", height: ScreenUtil().setWidth(150)),
            SizedBox(height: ScreenUtil().setHeight(30)),
            CircularProgressIndicator()
          ]
        )
      )
    );
  }

}