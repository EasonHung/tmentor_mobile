import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:mentor_app_flutter/config/server_url.dart';
import 'package:mentor_app_flutter/features/classroom/classroom_screen.dart';
import 'package:mentor_app_flutter/features/search_screen/find_mentor_page/find_mentor_page.dart';
import 'package:mentor_app_flutter/features/user_info_screen/user_info_screen.dart';
import 'package:mentor_app_flutter/service/chatroom_sync_service.dart';
import 'package:mentor_app_flutter/service/toast_service.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../color_constants.dart';
import '../service/notification_service.dart';
import 'chatroom/chat_list_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
  
}

class MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _currentBottomIndex = 0;
  DateTime timeBackPressed = DateTime.now();

  @override
  void initState() {
    super.initState();
    getAndStoreUserInfo();
    initFirebaseResume();
    // initLocalNotification();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state);
    if(state == AppLifecycleState.resumed) {
      ChatroomSyncService.syncChatMessages();
    }
  }

  @override
  void dispose() {
    // stopSyncMessage = false;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  Future<void> initFirebaseResume() async {
    // onresume
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   Navigator.of(context).push(MaterialPageRoute(builder: (context){
    //     return ChatroomScreen(message.data["conversationId"], message.data["senderId"], message.data["nickName"]);
    //   }));
    // });
  }

  Future<void> initLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('notification_icon');
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin?.initialize(initializationSettings,
        // onSelectNotification: (payload) async {
        //   Map valueMap = jsonDecode(payload);
        //   Navigator.of(context).push(MaterialPageRoute(builder: (context){
        //     return ChatroomScreen(valueMap["conversationId"], valueMap["senderId"], valueMap["nickName"], true);
        //   }));
        // }
    );
  }

  Future<void> getAndStoreUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");
    Dio dio = new Dio();
    String subPath = "/userInfo/?userId=";
    Response<String>? response;
    try {
      response = await dio.get(EnvSetting.USER_SYSTEM_SERVER_IP + subPath + userId!);
    } catch(e) {
      print(e);
      return;
    }

    String? responseString = response.data;
    UserPrefs.putUserInfo(responseString!);
  }

  Future<bool> _doubleCheckExit() async {
    final diff = DateTime.now().difference(timeBackPressed);
    final showExitWarning = diff >= Duration(seconds: 2);

    timeBackPressed = DateTime.now();
    if(showExitWarning) {
      String msg = "再按一次即可離開";
      ToastService.showSuccess(msg);
      return false;
    } else {
      if(Platform.isAndroid) {
        SystemNavigator.pop();
      } else {
        exit(0);
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _doubleCheckExit,
      child: Scaffold(
        body: _currentPage(),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 0),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedFontSize: 12.sp,
            unselectedFontSize: 12.sp,
            elevation: 12,
            selectedItemColor: primaryDefault,
            unselectedItemColor: Colors.grey,
            currentIndex: _currentBottomIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (value) {
              setState(() {
                _currentBottomIndex = value;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    Svg(
                      "assets/images/findMentorIcon.svg",
                      size: Size(20.w, 20.h)
                    ),
                    size: ScreenUtil().setWidth(20)
                  ),
                  label: "尋找導師"
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                    Svg(
                      "assets/images/myclassroomIcon.svg",
                      size: Size(20.w, 20.h)
                    ),
                    size: ScreenUtil().setWidth(20)
                ),
                label: "我的教室"
              ),
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    Svg("assets/images/contactIcon.svg", size: Size(20.w, 20.h)),
                    size: ScreenUtil().setWidth(20)
                  ),
                  label: "聊天室"
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                    Svg("assets/images/userInfoIcon.svg", size: Size(20.w, 20.h)),
                    size: ScreenUtil().setWidth(20)
                ),
                label: "個人資訊"
              ),
            ]
          )
        )
      )
    );
  }

  Widget _currentPage() {
    if(_currentBottomIndex == 1) {
      return ClassroomScreen();
    } else if (_currentBottomIndex == 3) {
      return UserInfoScreen();
    } else if (_currentBottomIndex == 2){
      return ChatListScreen();
    } else {
      return FindMentorPage();
    }
  }
  
}