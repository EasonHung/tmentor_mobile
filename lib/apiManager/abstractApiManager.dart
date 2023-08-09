import 'package:dio/dio.dart' as pdio;
import 'package:mentor_app_flutter/service/user_service.dart';
import '../config/server_url.dart';
import '../sharedPrefs/userPrefs.dart';
import 'errorCode.dart';

abstract class AbstractApiManager {
  late String apiUrl;
  AbstractApiManager({required this.apiUrl});

  Future<dynamic> handelGet(String path) async {
    pdio.Dio newDio = new pdio.Dio();

    try {
      return await newDio.get(apiUrl + path);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<dynamic> handelGetWithUserToken(String path) async {
    pdio.Dio dio = new pdio.Dio();
    dio.options.headers["authToken"] = await UserPrefs.getUserToken();

    pdio.Response res;
    try {
      res = await dio.get(apiUrl + path);
    } catch (e) {
      print(e);
      throw e;
    }

    if(res.data["code"] == ApiErrorCode.TOKEN_EXPIRED) {
      if(await refreshUserToken()) {
        return await handelGetWithUserToken(path);
      }
    }

    return res;
  }

  Future<dynamic> handelPost(String path, dynamic body) async  {
    pdio.Dio dio = new pdio.Dio();

    try {
      return await dio.post(apiUrl + path, data: body);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<dynamic> handelPostWithUserToken(String path, dynamic body) async  {
    pdio.Dio dio = new pdio.Dio();
    dio.options.headers["authToken"] = await UserPrefs.getUserToken();

    pdio.Response res;
    try {
      res = await dio.post(apiUrl + path, data: body);
    } catch (e) {
      print(e);
      throw e;
    }

    if(res.data["code"] == ApiErrorCode.TOKEN_EXPIRED) {
      if(await refreshUserToken()) {
        return await handelPostWithUserToken(path, body);
      }
    }

    return res;
  }

  Future<bool> refreshUserToken() async {
    String? userRefreshToken = await UserPrefs.getUserRefreshToken();
    dynamic postData = {
      "userToken": userRefreshToken
    };

    // can't use specific apiUrl, so use env directly here
    pdio.Dio dio = new pdio.Dio();
    pdio.Response? res = await dio.post(EnvSetting.USER_SYSTEM_SERVER_IP + "/user/token/refresh", data: postData);

    if(res.data["code"] != "0000") {
      UserService.logout();
      return false;
    }

    String? userId = await UserPrefs.getUserId();
    await UserPrefs.setUserIdToken(userId!, res?.data["data"]["accessToken"]);
    await UserPrefs.setUserRefreshToken(userId, res?.data["data"]["refreshToken"]);
    return true;

  }
}
