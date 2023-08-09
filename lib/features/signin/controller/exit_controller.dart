import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ExitController extends GetxController {
  DateTime timeBackPressed = DateTime.now();

  Future<bool> doubleCheckExit() async {
    final diff = DateTime.now().difference(timeBackPressed);
    final showExitWarning = diff >= Duration(seconds: 2);

    timeBackPressed = DateTime.now();
    if (showExitWarning) {
      String msg = "再按一次即可離開";
      Toast.show(msg, textStyle: TextStyle(fontSize: 18), backgroundColor: Colors.green[200]!);
      return false;
    } else {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else {
        exit(0);
      }
      return false;
    }
  }
}