class TeacherClassroomItem {
  String? teacherClassroomId;
  String? teacherId;
  String? subject;
  String? status;
  String? teacherNickname;
  String? teacherProfession;
  String? teacherAvatar;
  String? classTitle;
  String? classDesc;
  int? classTime;
  int? classPoints;

  TeacherClassroomItem(String teacherClassroomId, String teacherId, String subject,
      String status, String teacherNickname, String teacherProfession, String teacherAvatar) {
    this.teacherClassroomId = teacherClassroomId;
    this.teacherId = teacherId;
    this.subject = subject;
    this.status = status;
    this.teacherNickname = teacherNickname;
    this.teacherProfession = teacherProfession;
    this.teacherAvatar = teacherAvatar;
  }

  factory TeacherClassroomItem.fromJson(Map<String, dynamic> json) {
    TeacherClassroomItem item = TeacherClassroomItem(json["classroomId"], json["teacherId"], json["title"],
        json["status"], json["teacherNickname"], json["teacherProfession"][0], json["teacherAvatar"]);
    item.classTitle = json["classTitle"];
    item.classDesc = json["classDesc"];
    item.classTime = json["classTime"];
    item.classPoints = json["classPoints"];
    return item;
  }
}