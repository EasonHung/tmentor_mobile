class StudentCaseItem {
  String studentCaseId;

  List<dynamic> bidInfoIds;

  String avatarUrl;

  String userId;

  String nickname;

  String postTime;

  String title;

  String content;

  List<String> pictureUrl;

  StudentCaseItem(
    this.studentCaseId, 
    this.bidInfoIds, 
    this.avatarUrl, 
    this.userId, 
    this.nickname,
    this.postTime,
    this.title,
    this.content,
    this.pictureUrl,
  );

  factory StudentCaseItem.fromJson(Map<String, dynamic> json) {
    return StudentCaseItem(
      json["studentCaseId"], 
      json["bidInfoIds"], 
      json["avatarUrl"],
      json["userId"],
      json["nickname"],
      json["postTime"],
      json["title"],
      json["content"],
      [...json["pictureUrl"]]
    );
  }
}