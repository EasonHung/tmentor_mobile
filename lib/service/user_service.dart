import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';

import '../apiManager/userApiManager.dart';
import '../main.dart';
import '../features/signin/service/google_sign_in_service.dart';
import '../features/signin/sign_in_screen.dart';
import '../sharedPrefs/userPrefs.dart';

class UserService {
  static Future<void> logout() async {
    await googleSignIn.signOut();
    await userApiManager.deleteFcmToken(await firebaseMessaging.getToken());
    await UserPrefs.deleteUser();
    hasLoggedIn = false;
    Get.to(SignInScreen());
  }

  static Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return "";
  }
}