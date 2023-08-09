import 'package:dio/dio.dart';
import 'package:mentor_app_flutter/apiManager/abstractApiManager.dart';
import 'package:mentor_app_flutter/config/server_url.dart';

class EvaluationApiManager extends AbstractApiManager {
  EvaluationApiManager({required String apiUrl}) : super(apiUrl: apiUrl);

  Future<dynamic> getUserPosts(String userId, int page) async {
    Response? response =
        await handelGet("/post/user?userId=" + userId + "&page=" + page.toString());

    return response?.data["data"];
  }
}

final evaluationApiManager = EvaluationApiManager(apiUrl: EnvSetting.EVALUATION_SYSTEM_SERVER_IP);
