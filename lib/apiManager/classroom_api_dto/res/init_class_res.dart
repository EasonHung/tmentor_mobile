import '../../errorCode.dart';

class InitClassRes {
  String? code;
  String? message;
  String? classId;

  InitClassRes(this.code, this.message);

  factory InitClassRes.fromJson(Map<String, dynamic> json) {
    InitClassRes item = InitClassRes(json["code"], json["message"]);

    if(json["code"] == ApiErrorCode.SUCCESS) {
      item.classId = json["data"]["classId"];
    }
    return item;
  }
}