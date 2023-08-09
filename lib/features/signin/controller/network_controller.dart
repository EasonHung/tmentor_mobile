import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../utils/network_util.dart';

class NetworkController extends GetxController {
  Future<bool> checkNetworkAndShowAlert() async {
    if( !await NetworkUtil.hasConnectedToNetwork() ) {
      Toast.show("請檢察網路訊號", backgroundColor: Colors.red[300]!);
      return false;
    }
    return true;
  }
}