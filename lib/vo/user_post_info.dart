import 'package:mentor_app_flutter/vo/post_item.dart';

class UserPostInfo {
  int? postCount;
  int? averageScore;
  List<EvaluationItem>? evaluationList;

  UserPostInfo.withNull();

  UserPostInfo(this.postCount, this.averageScore, this.evaluationList);

  factory UserPostInfo.fromJson(Map<String, dynamic> json) {
    return UserPostInfo(
      json['totalCount'],
      json['averageScore'],
      (json["posts"] as List).map((value) => EvaluationItem.fromJson(value)).toList(),
    );
  }
}