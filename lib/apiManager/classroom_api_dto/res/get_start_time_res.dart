import 'package:intl/intl.dart';

import '../../errorCode.dart';

class GetStartTimeRes {
  String? code;
  String? message;
  DateTime? startTime;

  GetStartTimeRes(this.code, this.message);

  factory GetStartTimeRes.fromJson(Map<String, dynamic> json) {
    GetStartTimeRes item = GetStartTimeRes(json["code"], json["message"]);

    if(json["code"] == ApiErrorCode.SUCCESS) {
      item.startTime = new DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(json["data"]["startTime"]).toLocal();
    }
    return item;
  }
}