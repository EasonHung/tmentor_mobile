import 'package:dio/dio.dart';
import 'package:mentor_app_flutter/apiManager/abstractApiManager.dart';
import 'package:mentor_app_flutter/apiManager/classroom_api_dto/res/reimburse_class_res.dart';
import 'package:mentor_app_flutter/apiManager/errorCode.dart';
import 'package:mentor_app_flutter/config/server_url.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';
import 'package:mentor_app_flutter/vo/teacher_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/toast_service.dart';
import '../vo/class_setting_info.dart';
import 'classroom_api_dto/res/enroll_classroom_res.dart';
import 'classroom_api_dto/res/get_class_record_res.dart';
import 'classroom_api_dto/res/get_classroom_status_res.dart';
import 'classroom_api_dto/res/get_last_class_info_res.dart';
import 'classroom_api_dto/res/get_start_time_res.dart';
import 'classroom_api_dto/res/init_class_res.dart';

class ClassroomApiManager extends AbstractApiManager {
  ClassroomApiManager({required String apiUrl}) : super(apiUrl: apiUrl);

  Future<EnrollClassroomRes> addClassroom(String classToken) async {
    String? userId = await UserPrefs.getUserId();
    var postData = {"classroomToken": classToken, "userId": userId};

    Response? res = await handelPostWithUserToken("/info/enroll", postData);
    return EnrollClassroomRes.fromJson(res?.data);
  }

  Future<List<TeacherClassroomItem>> getClassroomList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");

    Response response = await handelGetWithUserToken("/info/classroomList?userId=$userId");
    return response.data["data"].map<TeacherClassroomItem>((value) => TeacherClassroomItem.fromJson(value)).toList();
  }

  Future<GetClassroomStatusRes?> getClassroomStatus(String classroomId) async {
    Response response = await handelGet("/info/status?classroomId=$classroomId");

    if (response.data["code"] != ApiErrorCode.SUCCESS) {
      ToastService.showAlert(response.data["message"]);
      return null;
    }

    return GetClassroomStatusRes.fromJson(response.data["data"]);
  }

  Future<String> getClassroomId(String userId) async {
    Response response = await handelGetWithUserToken("/info/userClassroomId?userId=$userId");
    return response.data['data'];
  }

  Future<GetClassRecordRes> getClassRecord() async {
    Response response = await handelGetWithUserToken("/info/classRecord");
    return GetClassRecordRes.fromJson(response.data);
  }

  Future<void> addClassSetting(String settingName, String title, String desc, int classTime, int classPoints) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("userId");
    var postData = {
      "userId": userId,
      "settingName": settingName,
      "title": title,
      "desc": desc,
      "classTime": classTime,
      "classPoints": classPoints
    };

    Response? response = await handelPostWithUserToken("/info/classSetting/add", postData);
    if (response?.data["code"] != ApiErrorCode.SUCCESS) {
      ToastService.showAlert(response?.data["message"]);
    }
  }

  Future<void> updateClassSetting(String settingName, String title, String desc, int classTime, int classPoints) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("userId");
    var postData = {
      "userId": userId,
      "settingName": settingName,
      "title": title,
      "desc": desc,
      "classTime": classTime,
      "classPoints": classPoints
    };

    Response? response = await handelPostWithUserToken("/info/classSetting/update", postData);
    if (response?.data["code"] != ApiErrorCode.SUCCESS) {
      ToastService.showAlert(response?.data["message"]);
    }
  }

  Future<void> deleteClassSetting(String settingName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("userId");
    var postData = {
      "userId": userId,
      "settingName": settingName
    };

    Response? response = await handelPostWithUserToken("/info/classSetting/delete", postData);
    if (response?.data["code"] != ApiErrorCode.SUCCESS) {
      ToastService.showAlert(response?.data["message"]);
    }
  }

  Future<List<ClassSettingInfo>> getClassSettingList() async {
    String? userId = await UserPrefs.getUserId();

    Response? response = await handelGetWithUserToken("/info/classSetting?userId=" + userId!);
    var responseBody = response?.data;

    if (response?.statusCode == 200) {
      return (responseBody['data'] as List)
          .map<ClassSettingInfo>((element) => ClassSettingInfo.fromJson(element))
          .toList();
    }
    throw Exception('Failed to load teacher list');
  }

  Future<GetLastClassRes> getLastClassInfo(String classroomId, String studentId) async {
    Response? response = await handelGetWithUserToken("/class/info/lastClass?classroomId=" + classroomId + "&studentId=" + studentId);
    var responseBody = response?.data;

    return GetLastClassRes.fromJson(responseBody);
  }

  Future<InitClassRes> initClass(ClassSettingInfo classSettingInfo, String classroomId, String studentId) async {
    String? userId = await UserPrefs.getUserId();

    var postData = {
      "classroomId": classroomId,
      "mentorId": userId!,
      "studentId": studentId,
      "classTitle": classSettingInfo.title,
      "classDesc": classSettingInfo.desc,
      "classTime": classSettingInfo.classTime,
      "points": classSettingInfo.classPoints
    };

    Response? response = await handelPostWithUserToken("/class/info/initClass", postData);
    var responseBody = response?.data;

    return InitClassRes.fromJson(responseBody);
  }

  Future<ReimburseClassRes> reimburseClass(String classId) async {
    var postData = {
      "classId": classId
    };

    Response? response = await handelPostWithUserToken("/class/info/reimburseClass", postData);
    var responseBody = response?.data;

    return ReimburseClassRes.fromJson(responseBody);
  }

  Future<GetStartTimeRes> getStartTime(String classId) async {
    Response? response = await handelGetWithUserToken("/class/info/startTime?classId=" + classId);
    var responseBody = response?.data;

    return GetStartTimeRes.fromJson(responseBody);
  }
}

final classroomApiManager = ClassroomApiManager(apiUrl: EnvSetting.CLASSROOM_SERVER_IP);
