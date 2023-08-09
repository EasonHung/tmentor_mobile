import 'dart:convert';

import 'package:mentor_app_flutter/features/signin/constants/user_info_fill_in_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static Future<String?> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("userId");
  }

  static Future<bool> checkExistUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("userId")?.isNotEmpty ?? false;
  }

  static Future<String?> getUserToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("userToken");
  }

  static Future<String?> getUserRefreshToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("userRefreshToken");
  }

  static Future<void> putUserToken(String userToken) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("userToken", userToken);
  }

  static Future<void> putUserInfo(String userInfoJson) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("userInfo", userInfoJson);
  }

  static Future<String?> getUserAvatarUrl() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userInfoString = pref.getString("userInfo");
    Map userInfo = json.decode(userInfoString!);
    return userInfo["data"]["avatorUrl"];
  }

  static Future<String> getUserNickname() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userInfoString = pref.getString("userInfo");
    Map userInfo = json.decode(userInfoString!);
    return userInfo["Nickname"];
  }

  static Future<void> deleteUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("userId", "");
    pref.setString("userToken", "");
    pref.setString("userRefreshToken", "");
    pref.setString("userInfo", "");
  }

  static Future<void> setUserIdToken(String userId, String userToken) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("userId", userId);
    await pref.setString("userToken", userToken);
    await pref.reload();
  }

  static Future<void> setUserRefreshToken(String userId, String userRefreshToken) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("userRefreshToken", userRefreshToken);
  }

  static Future<void> setUserInfoFillInStatus(String userInfoFillInStatus) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userId = pref.getString("userId");
    await pref.setString(userId! + "userFillInStatus", userInfoFillInStatus);
  }

  static Future<String> getUserInfoFillInStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userId = pref.getString("userId");
    return pref.getString(userId! + "userFillInStatus")?? UserInfoFillInStatus.NotYet;
  }

  static Future<void> setCurrentFCMToken(String fcmToken) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("currentFCMToken", fcmToken);
  }

  static Future<String?> getCurrentFcmToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("currentFCMToken");
  }
}
