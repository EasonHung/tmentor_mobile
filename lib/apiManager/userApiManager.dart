import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mentor_app_flutter/apiManager/user_api_dto/res/create_user_res.dart';
import 'package:mentor_app_flutter/config/server_url.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';

import '../request/profile_request.dart';
import '../vo/mentor_item.dart';
import '../vo/user_info.dart';
import 'abstractApiManager.dart';

class UserApiManager extends AbstractApiManager {
  static var userIdKey = Symbol('userId');
  static var tokenKey = Symbol('token');
  static var userStatus = Symbol('userStatus');

  UserApiManager({required String apiUrl}) : super(apiUrl: apiUrl);

  Future<dynamic> loginByThirdParty(String thirdPartyId, String thirdPartyAccessToken) async {
    dynamic thirdPartyData = {"thirdPartyId": thirdPartyId, "thirdPartyAccessToken": thirdPartyAccessToken};
    Response res = await handelPost("/user/thirdParty/login", thirdPartyData);

    return res.data;
  }

  Future<CreateUserRes> createNewUser(String? displayName, String email, String? photoUrl, String thirdPartyId) async {
    var thirdPartyInfo = {"displayName": displayName, "email": email, "photoUrl": photoUrl};
    var postData = {"thirdPartyId": thirdPartyId, "thirdPartyInfo": thirdPartyInfo.toString()};

    Response? res = await handelPost("/user/thirdParty", postData);
    return CreateUserRes.fromJson(res?.data);
  }

  Future<void> updateUserToken() async {
    String? userToken = await UserPrefs.getUserToken();
    // todo: if userToken is null then ...

    Response? res =
        await handelPost("/user/token/refresh", {"userToken": userToken});
    String newToken = res?.data["data"]["token"];
    await UserPrefs.putUserToken(newToken);
  }

  Future<String> getAvatarUrl(String userId) async {
    // todo: fix typo (avatar)
    Response? res = await handelGet("/userInfo/avatorUrl?userId=" + userId);
    return res?.data;
  }

  Future<void> insertFcmToken(String? fcmToken) async {
    String? userId = await UserPrefs.getUserId();

    var postData = {"userId": userId, "fcmToken": fcmToken};
    try {
      handelPost("/userInfo/fcmToken/insert", postData);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteFcmToken(String? fcmToken) async {
    String? userId = await UserPrefs.getUserId();

    var postData = {"userId": userId, "fcmToken": fcmToken};
    try {
      handelPost("/userInfo/fcmToken/delete", postData);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateFcmToken(String? originFcmToken, String newFcmToken) async {
    String? userId = await UserPrefs.getUserId();

    var postData = {"userId": userId, "originFcmToken": originFcmToken, "newFcmToken": newFcmToken};
    try {
      handelPost("/userInfo/fcmToken/update", postData);
    } catch (e) {
      print(e);
    }
  }

  Future<List<MentorItem>> getUserCards(int page) async {
    String? userId = await UserPrefs.getUserId();

    Response? response = await handelGet("/userInfo/cards?page=" + page.toString());

    var responseBody = response?.data["data"];
    return responseBody
        .map<MentorItem>((value) => MentorItem.fromJson(value))
        .where((element) => element.userId != userId)
        .toList();
  }

  Future<List<MentorItem>> getUserCardsWithFilter(int page, List<String> fields, List<String> genders) async {
    String? userId = await UserPrefs.getUserId();
    String fieldsQuery = fields.isNotEmpty ? "&fields=" + fields.join("&fields=") : "";
    String genderQuery = genders.isNotEmpty ? "&gender=" + genders.join("&gender=") : "";

    Response? response = await handelGet("/userInfo/cards?page=" + page.toString() + fieldsQuery + genderQuery);

    var responseBody = response?.data["data"];
    return responseBody
        .map<MentorItem>((value) => MentorItem.fromJson(value))
        .where((element) => element.userId != userId)
        .toList();
  }

  Future<void> updateAvatar(File imageFile) async {

    // typo
    var formData = FormData.fromMap({"userAvator": await MultipartFile.fromFile(imageFile.path)});
    await handelPostWithUserToken("/userInfo/avatar/update", formData);
  }

  Future<void> updatePicture(File imageFile) async {
    // typo
    var formData = FormData.fromMap({"userPicture": await MultipartFile.fromFile(imageFile.path)});
    await handelPostWithUserToken("/userInfo/picture/update", formData);
  }

  Future<void> uploadProfileToServer(ProfileRequest request) async {
    await handelPostWithUserToken("/userInfo/update", request.toMap());
  }

  Future<dynamic> getUserInfo(String userId) async {
    Response? response = await handelGet("/userInfo/?userId=$userId");
    return response?.data['data'];
  }

  Future<UserInfo> loadUserInfo() async {
    String? userId = await UserPrefs.getUserId();
    Response? response = await handelGet("/userInfo/?userId=$userId");
    if (response == null || response.data['code'] == "9999") return UserInfo.withNull();
    return UserInfo.fromJson(response.data);
  }
}

final userApiManager = UserApiManager(apiUrl: EnvSetting.USER_SYSTEM_SERVER_IP);
