import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/guide_screen/controller/avatar_controller.dart';
import '../../../color_constants.dart';
import '../controller/step_controller.dart';

class UploadAvatarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UploadAvatarPageState();
  }

}

class UploadAvatarPageState extends State<UploadAvatarPage> {
  final StepController stepController = Get.find<StepController>();
  final AvatarController avatarController = Get.find<AvatarController>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      stepController.changeNavigationStatus(avatarController.checkAvatarFile());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildAvatar(),
                SizedBox(height: ScreenUtil().setHeight(10),),
                buildHeader(),
                SizedBox(height: ScreenUtil().setHeight(20),),
                buildUploadBtn()
              ]
            )
          )
        )
      ]
    );
  }
  
  Widget buildAvatar() {
    return Obx(() => avatarController.selectedAvatar.value.path == ""?
    CircleAvatar(
      radius: ScreenUtil().setWidth(60),
      backgroundImage: AssetImage("assets/images/null_avatar.png")
    ):
    CircleAvatar(
        radius: ScreenUtil().setWidth(60),
        backgroundImage: FileImage(avatarController.selectedAvatar.value)
    ));
  }

  Widget buildHeader() {
    return Text(
      "上傳大頭照",
      style: TextStyle(
          fontSize: ScreenUtil().setSp(20),
          fontWeight: FontWeight.bold
      ),
    );
  }

  Widget buildUploadBtn() {
    return SizedBox(
      width: ScreenUtil().screenWidth * 0.6,
      height: ScreenUtil().setHeight(50),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: primaryDefault,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(5)))),
        ),
        child: Text(
          "上傳大頭照",
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(14)
          ),
        ),
        onPressed: () {
          avatarController.selectAvatar(true);
        },
      )
    );
  }

}