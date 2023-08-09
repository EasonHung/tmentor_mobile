class TeacherCaseItem {
  String teacherCaseId;

  List<dynamic> applyIds;

  String avatarUrl;

  String userId;

  String nickname;

  String postTime;

  String title;

  String content;

  String pictureUrl;

  TeacherCaseItem(
    this.teacherCaseId, 
    this.applyIds, 
    this.avatarUrl, 
    this.userId, 
    this.nickname,
    this.postTime,
    this.title,
    this.content,
    this.pictureUrl,
  );

  factory TeacherCaseItem.fromJson(Map<String, dynamic> json) {
    return TeacherCaseItem(
      json["teacherCaseId"], 
      json["applyIds"], 
      json["avatarUrl"],
      json["userId"],
      json["nickname"],
      json["postTime"],
      json["title"],
      json["content"],
      json["pictureUrl"],
    );
  }
}