import 'dart:convert';

import '../../errorCode.dart';

class GetLastClassRes {
  String? code;
  String? message;
  ClassInfoRes? classInfoRes;

  GetLastClassRes(this.code, this.message);

  factory GetLastClassRes.fromJson(Map<String, dynamic> json) {
    GetLastClassRes item = GetLastClassRes(json["code"], json["message"]);

    if(json["code"] == ApiErrorCode.SUCCESS) {
      item.classInfoRes = ClassInfoRes.fromJson(json["data"]);
    }
    return item;
  }
}

class ClassInfoRes {
  String classId;
  String classroomId;
  String mentorId;
  String studentId;
  String status;
  int points;
  int classTime;
  int remainTime;
  String startTime;

  ClassInfoRes(this.classId, this.classroomId, this.mentorId, this.studentId, this.status,
      this.points, this.classTime, this.remainTime, this.startTime);

  factory ClassInfoRes.fromJson(Map<String, dynamic> json) {
    ClassInfoRes item = ClassInfoRes(json["classId"], json["classroomId"], json["mentorId"], json["studentId"],
        json["status"], json["points"], json["classTime"], json["remainTime"], json["startTime"]);
    return item;
  }

  factory ClassInfoRes.fromJsonString(String jsonStr) {
    Map<String, dynamic> json = jsonDecode(jsonStr);
    ClassInfoRes item = ClassInfoRes(json["classId"], json["classroomId"], json["mentorId"], json["studentId"],
        json["status"], json["points"], json["classTime"], json["remainTime"], json["startTime"]);
    return item;
  }
}