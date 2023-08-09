class GetClassRecordRes {
  List<GetClassRecordResItem>? classRecordList;

  GetClassRecordRes(this.classRecordList);

  factory GetClassRecordRes.fromJson(Map<String, dynamic> json) {
    List<GetClassRecordResItem> classRecordList = json["data"].map<GetClassRecordResItem>( (json) => GetClassRecordResItem.fromJson(json) ).toList();
    return GetClassRecordRes(classRecordList);
  }
}

class GetClassRecordResItem {
  String? classId;
  String? classroomId;
  MentorInfo? mentorInfo;
  StudentInfo? studentInfo;
  String? status;
  int? points;
  String? title;
  String? desc;
  int? classTime;
  int? remainTime;
  String? startTime;

  GetClassRecordResItem(this.classId, this.classroomId, this.mentorInfo, this.studentInfo, this.status, this.points, this.title, this.desc,
      this.classTime, this.remainTime, this.startTime);

  factory GetClassRecordResItem.fromJson(Map<String, dynamic> json) {
    return GetClassRecordResItem(
      json["classId"],
      json["classroomId"],
      MentorInfo.fromJson(json["mentorInfo"]),
      StudentInfo.fromJson(json["studentInfo"]),
      json["status"],
      json["points"],
      json["title"],
      json["desc"],
      json["classTime"],
      json["remainTime"],
      json["startTime"]
    );
  }
}

class MentorInfo {
  String? mentorId;
  String? mentorNickname;
  String? mentorProfession;

  MentorInfo(this.mentorId, this.mentorNickname, this.mentorProfession);

  factory MentorInfo.fromJson(Map<String, dynamic> json) {
    return MentorInfo(json["mentorId"], json["mentorNickname"], json["mentorProfession"]);
  }
}

class StudentInfo {
  String? studentId;
  String? studentNickname;
  String? studentProfession;

  StudentInfo(this.studentId, this.studentNickname, this.studentProfession);

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(json["studentId"], json["studentNickname"], json["studentProfession"]);
  }
}