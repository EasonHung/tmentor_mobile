import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/sign_in_image.dart';
import '../components/sign_in_logo.dart';
import '../components/sign_in_subtitile.dart';
import '../components/sign_in_title.dart';
import '../components/third_party_login_btn.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: ScreenUtil().setHeight(100)),
            SignInLogo(),
            SignInTitle(),
            SizedBox(height: MediaQuery.of(context).size.width * 0.01),
            SignInSubtitle(),
            SizedBox(height: MediaQuery.of(context).size.width * 0.03),
            SignInImage(),
            SizedBox(height: MediaQuery.of(context).size.width * 0.01),
            ThirdPartyLoginBtn(),
            SizedBox(height: MediaQuery.of(context).size.width * 0.03),
          ]
        )
      )
    );
  }

}