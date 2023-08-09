import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../color_constants.dart';
import 'component/new_class_setting_dialog.dart';
import 'component/saved_class_setting_dialog.dart';

class ClassroomSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 28.h,),
          buildClassroomPicture(),
          SizedBox(height: 5.h),
          buildOpenClassroomBtn(context),
          SizedBox(height: 10.h),
          buildOpenSavedClassBtn(context),
          SizedBox(height: 10.h),
          buildTextBox()
        ],
      ),
    );
  }

  Widget buildClassroomPicture() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
        child: SvgPicture.asset(
          "assets/images/myClassroomPicture.svg",
          width: 250.w,
          fit: BoxFit.fitWidth,
        ),
    );
  }

  Widget buildOpenClassroomBtn(BuildContext context) {
    return SizedBox(
        height: ScreenUtil().setHeight(60), // <-- Your height
        width: ScreenUtil().setWidth(327),
        child: TextButton(
          onPressed: () {
            NewClassSettingDialog(context).show();
          },
          child: Text(
            "自訂新教室",
            style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(16)
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: primaryDefault,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(5)))),
          ),
        )
    );
  }

  Widget buildOpenSavedClassBtn(BuildContext context) {
    return SizedBox(
        height: ScreenUtil().setHeight(60), // <-- Your height
        width: ScreenUtil().setWidth(327),
        child: TextButton(
          onPressed: () {
            SavedClassSettingDialog(context).show();
          },
          child: Text(
            "開啟已儲存教室",
            style: TextStyle(
                color: primaryDark2,
                fontSize: ScreenUtil().setSp(16)
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: primaryTint,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(5)))),
          ),
        )
    );
  }

  Widget buildTextBox() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(15), horizontal: ScreenUtil().setWidth(20)),
        width: ScreenUtil().setWidth(327),
        decoration: BoxDecoration(
          color: black300,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          '''
貼心提醒
1. 目前只提供計時功能，不提供金流服務
2. 上課記錄將保存於個人資訊頁面中
3. 視訊功能僅提供上課服務，請雙方保持良好的課堂禮儀''',
          textAlign: TextAlign.start,
          style: TextStyle(
            height: 1.5.h,
            fontSize: ScreenUtil().setSp(14)
          ),
        )
    );
  }
}