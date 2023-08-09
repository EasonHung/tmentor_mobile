import 'package:dio/dio.dart';
import 'package:mentor_app_flutter/apiManager/abstractApiManager.dart';
import 'package:mentor_app_flutter/config/server_url.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';
import 'package:mentor_app_flutter/vo/bid_info_item.dart';
import 'package:mentor_app_flutter/vo/user_bid_info_item.dart';

import '../vo/student_case_item.dart';

class StudentCaseApiManager extends AbstractApiManager {
  StudentCaseApiManager({required String apiUrl}) : super(apiUrl: apiUrl);

  Future<int?> addBid(String studentCaseId, int bidPrice, String classTime) async {
    var postData = {"studentCaseId": studentCaseId, "bidPrice": bidPrice, "classTime": classTime};

    Response? res = await handelPostWithUserToken("/studentCase/bid/add", postData);
    return res?.statusCode;
  }

  Future<List<BidInfoItem>> getBidInfo(String studentCaseId) async {
    Response? response =
        await handelGet("/studentCase/bids/info?studentCaseId=" + studentCaseId);
    return (response?.data?['data'] ?? []).map<BidInfoItem>((value) => BidInfoItem.fromJson(value)).toList();
  }

  Future<List<StudentCaseItem>> getStudentCase(int page) async {
    String? userId = await UserPrefs.getUserId();
    Response? response = await handelGet("/studentCase/?page=" + page.toString());

    return (response?.data?['data'] ?? [])
        .map<StudentCaseItem>((value) => StudentCaseItem.fromJson(value))
        .where((element) => element.userId != userId)
        .toList();
  }

  Future<StudentCaseItem> getOneStudentCase(String studentCaseId) async {
    Response? response =
        await handelGet("/studentCase/one?studentCaseId=" + studentCaseId);
    var responseBody = response?.data;

    return StudentCaseItem.fromJson(responseBody);
  }

  Future<List<StudentCaseItem>> getUserStudentCase() async {
    Response? response = await handelGetWithUserToken("/studentCase/user");
    return (response?.data?['data'] ?? []).map<StudentCaseItem>((value) => StudentCaseItem.fromJson(value)).toList();
  }

  Future<List<UserBidInfoItem>> getBidInfsByUserId(String? userId) async {
    Response? response = await handelGet("/bidInfo/user?userId=" + userId!);
    return (response?.data?['data'] ?? []).map<UserBidInfoItem>((value) => UserBidInfoItem.fromJson(value)).toList();
  }
}

final studentCaseApiManager = StudentCaseApiManager(apiUrl: EnvSetting.CASE_SYSTEM_SERVER_IP);
