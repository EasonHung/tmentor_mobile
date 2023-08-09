class EnrollClassroomRes {
  String? code;
  String? message;

  EnrollClassroomRes(this.code, this.message);

  factory EnrollClassroomRes.fromJson(Map<String, dynamic> json) {
    EnrollClassroomRes item = EnrollClassroomRes(json["code"], json["message"]);
    return item;
  }
}