import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/color_constants.dart';
import 'package:mentor_app_flutter/features/classroom/pages/classroom_list_page/classroom_list_page.dart';
import 'package:mentor_app_flutter/features/classroom/pages/classroom_list_page/controller/classroom_list_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/classroom_list_page/controller/classroom_list_ws_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/classroom_setting_page/controller/class_setting_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/classroom_setting_page/classroom_setting_page.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../main.dart';
import 'controller/classroom_page_controller.dart';

class ClassroomScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return ClassroomScreenState();
  }

}

class ClassroomScreenState extends State<ClassroomScreen> with RouteAware, WidgetsBindingObserver {
  late ClassroomPageController classroomPageController;
  late ClassroomListController classroomListController;
  late ClassroomListWsController classroomListWsController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Permission.camera.request();
    Permission.microphone.request();
    Get.put<ClassSettingController>(ClassSettingController());
    classroomPageController = Get.put<ClassroomPageController>(ClassroomPageController());
    classroomListController = Get.put<ClassroomListController>(ClassroomListController());
    classroomListWsController = Get.put<ClassroomListWsController>(ClassroomListWsController());
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute); //订阅
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Get.delete<ClassroomPageController>();
    Get.delete<ClassSettingController>();
    Get.delete<ClassroomListWsController>();
    Get.delete<ClassroomListController>();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        Get.find<ClassroomListWsController>().reconnectWs();
        Get.find<ClassroomListController>().initTeacherClassroomList();
        break;
      case AppLifecycleState.inactive:
        Get.find<ClassroomListWsController>().closeWs();
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "教室",
          style: TextStyle(
              color: primaryDark,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            buildTopNavigationBar(),
            buildBody()
          ],
        )
      )
    );
  }

  Widget buildTopNavigationBar() {
    return Obx(() => Row(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              classroomPageController.pageController.animateToPage(0, duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
              classroomPageController.activePage.value = "我的教室";
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(8)),
            width: ScreenUtil().screenWidth/2,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: ScreenUtil().setHeight(3.5),
                  color: classroomPageController.activePage.value == "我的教室"? primaryDefault : Colors.white
                ),
              )
            ),
            child: Text(
              "我的教室",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(18),
                color: classroomPageController.activePage.value == "我的教室"? primaryDefault : null
              ),
            )
          )
        ),
        InkWell(
          onTap: () {
            setState(() {
              classroomPageController.pageController.animateToPage(1, duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
              classroomPageController.activePage.value = "教室列表";
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(8)),
            width: ScreenUtil().screenWidth/2,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: ScreenUtil().setHeight(3.5),
                  color: classroomPageController.activePage.value == "教室列表"? primaryDefault : Colors.white
                ),
              )
            ),
            child: Text(
              "教室列表",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(18),
                color: classroomPageController.activePage.value == "教室列表"? primaryDefault : null
              ),
            )
          )
        )
      ],
    ));
  }

  Widget buildBody() {
    return Expanded(
      child: PageView(
        controller: classroomPageController.pageController,
        onPageChanged: (index) {
          if(index == 0) {
            classroomPageController.activePage.value = "我的教室";
            classroomListWsController.closeWs();
          } else if(index == 1) {
            classroomPageController.activePage.value = "教室列表";
            classroomListController.initTeacherClassroomList();
            classroomListWsController.initWsChannel();
          }
        },
        children: [
          ClassroomSettingPage(),
          ClassroomListPage()
        ]
      ),
    );
  }

}