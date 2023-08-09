import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/apiManager/chatroomApiManager.dart';
import 'package:mentor_app_flutter/features/classroom/constants/ClassStatus.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/components/start_class_dialog.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_classroom_btn_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_classroom_class_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_classroom_media_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_classroom_webrtc_controller.dart';

import '../../../../../color_constants.dart';
import '../../../../../components/text_icon_button.dart';
import '../controller/my_class_process_controller.dart';
import 'ending_class_dialog.dart';

class BottomBtns extends StatelessWidget {
  final MyClassroomBtnController myClassroomBtnController = Get.find<MyClassroomBtnController>();
  final MyClassProcessController myClassProcessController = Get.find<MyClassProcessController>();
  final MyClassroomMediaController myClassroomMediaController = Get.find<MyClassroomMediaController>();
  final MyClassroomWebrtcController myClassroomWebrtcController = Get.find<MyClassroomWebrtcController>();
  final MyClassroomClassController myClassroomClassController = Get.find<MyClassroomClassController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => myClassroomBtnController.showBottomBtns.value? Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
        TextButton(
          onPressed: () {
            EndingClassDialog(context).show();
          },
          child: Text(
            "結束",
            style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setWidth(15)
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: redDefault,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setWidth(20)))),
          ),
        ),
        Spacer(),
        IconTextButton(
            image: Image.asset(
                myClassroomMediaController.microphoneSwitch.value?  "assets/images/closed_microphone.png" : "assets/images/opened_microphone.png",
                height: 30,
                color: Colors.white
            ),
            label: myClassroomMediaController.microphoneSwitch.value? '關閉麥克風':"開啟麥克風",
            labelStyle: TextStyle(
                color: Colors.white
            ),
            onTap: () {
              myClassroomMediaController.switchMicroPhoneStatus();
            },
            toolTip: myClassroomMediaController.microphoneSwitch.value? '關閉麥克風':"開啟麥克風"
        ),
        Spacer(),
        IconTextButton(
          image: Image.asset(
              myClassroomMediaController.cameraSwitch.value? "assets/images/closed_video.png" : "assets/images/open_video.png",
              height: 30,
              color: Colors.white
          ),
          label: myClassroomMediaController.cameraSwitch.value? '關閉鏡頭':"開啟鏡頭",
          labelStyle: TextStyle(
              color: Colors.white
          ),
          onTap: () {
            myClassroomMediaController.switchCameraStatus();
          },
          toolTip: myClassroomMediaController.cameraSwitch.value? '關閉鏡頭':"開啟鏡頭",
        ),
        Spacer(),
        IconTextButton(
          image: Image.asset(
            myClassroomMediaController.screenSharing.value? "assets/images/stop_sharing.png" : "assets/images/shared_screen.png",
            height: 30,
            color: Colors.white,
          ),
          label: myClassroomMediaController.screenSharing.value? '停止分享':"分享畫面",
          labelStyle: TextStyle(
              color: Colors.white
          ),
          onTap: () {
            if(myClassroomMediaController.screenSharing.value) {
              myClassroomWebrtcController.stopScreenSharing();
            } else {
              myClassroomWebrtcController.screenSharing();
            }
          },
          toolTip: myClassroomMediaController.screenSharing.value? '停止分享':"分享畫面",
        ),
        Spacer(),
        buildClassTimer(context),
        Spacer(),
      ],
    ) : SizedBox.shrink());
  }

  Widget buildClassTimer(BuildContext context) {
    switch (myClassroomBtnController.classStatus.value) {
      case ClassStatus.INIT:
        return IconTextButton(
          image: Image.asset(
              "assets/images/started_timing.png",
              height: 30,
              color: Colors.white
          ),
          label: '開始計費',
          labelStyle: TextStyle(
              color: Colors.white
          ),
          onTap: () async {
            if(!await myClassProcessController.initClass()) {
              return;
            }
            StartClassDialog(context, false, myClassroomClassController.classSettingInfo.classTime, myClassroomClassController.classSettingInfo.classPoints).show();
          },
          toolTip: '點擊開始上課',
        );
      case ClassStatus.INITIALING:
        return IconTextButton(
          image: Image.asset(
              "assets/images/started_timing.png",
              height: 30,
              color: Colors.white
          ),
          label: '開始計費',
          labelStyle: TextStyle(
              color: Colors.white
          ),
          onTap: null,
          toolTip: '點擊開始上課',
        );
      case ClassStatus.IN_CLASS:
        return IconTextButton(
          image: Image.asset(
              "assets/images/stoped_timing.png",
              height: 30,
              color: Colors.white
          ),
          label: '下課',
          labelStyle: TextStyle(
              color: Colors.white
          ),
          onTap: () async {
            myClassProcessController.finishClass();
          },
          toolTip: '點擊下課',
        );
      default:
        return IconTextButton(
          image: Image.asset(
              "assets/images/started_timing.png",
              height: 30,
              color: Colors.white
          ),
          label: '開始計費',
          labelStyle: TextStyle(
              color: Colors.white
          ),
          onTap: () async {
            if(!await myClassProcessController.initClass()) {
              return;
            }
            StartClassDialog(context, false, myClassroomClassController.classSettingInfo.classTime, myClassroomClassController.classSettingInfo.classPoints).show();
          },
          toolTip: '點擊開始上課',
        );
    }
  }

}