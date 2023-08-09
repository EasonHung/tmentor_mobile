class GetClassroomStatusRes {
  String? classroomStatus;
  GetClassroomStatusResClassSettingInfo? classSettingInfo;

  GetClassroomStatusRes(String classroomStatus, GetClassroomStatusResClassSettingInfo? classSettingInfo) {
    this.classroomStatus = classroomStatus;
    this.classSettingInfo = classSettingInfo;
  }

  factory GetClassroomStatusRes.fromJson(Map<String, dynamic> json) {
    GetClassroomStatusRes item = GetClassroomStatusRes(json["status"], GetClassroomStatusResClassSettingInfo.fromJson(json["classSettingInfo"]));
    return item;
  }
}

class GetClassroomStatusResClassSettingInfo {
  String? title;
  String? desc;
  int? classTime;
  int? classPoints;

  GetClassroomStatusResClassSettingInfo(this.title, this.desc, this.classTime, this.classPoints);

  factory GetClassroomStatusResClassSettingInfo.fromJson(Map<String, dynamic> json) {
    return GetClassroomStatusResClassSettingInfo(json["title"], json["desc"], json["classTime"], json["classPoints"]);
  }
}