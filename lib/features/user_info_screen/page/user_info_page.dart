import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../component/logout_btn.dart';
import '../component/user_info_card.dart';

class UserInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserInfoCard(),
        LogoutBtn(),
        SizedBox(height: ScreenUtil().setHeight(15)),
      ],
    );
  }

}