import 'package:dio/dio.dart';
import 'package:mentor_app_flutter/apiManager/abstractApiManager.dart';
import 'package:mentor_app_flutter/config/server_url.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';
import 'package:mentor_app_flutter/vo/wallet_info.dart';

import 'errorCode.dart';

class FinanceApiManager extends AbstractApiManager {
  FinanceApiManager({required String apiUrl}) : super(apiUrl: apiUrl);

  Future<WalletInfo> getUserPointsInfo() async {
    String? userId = await UserPrefs.getUserId();

    Response? response = await handelGet("/wallet/?userId=" + userId!);
    var responseBody = response?.data;

    if (responseBody["code"] != ApiErrorCode.SUCCESS) {
      throw Exception(responseBody["message"]);
    }
    return WalletInfo.fromJson(responseBody["data"]);
  }

  List<String> getStoredPointsCases() {
    return ["100", "300", "1000"];
  }
}

final financeApiManager = FinanceApiManager(apiUrl: EnvSetting.FINANCE_SERVER_IP);
