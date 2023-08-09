import 'dart:core';

import 'package:intl/intl.dart';

class EvaluationItem {
  String postId;
  String fromUserId;
  String fromUserAvatar;
  String fromUserNickname;
  String fromUserProfession;
  int score;
  String description;
  String createTime;

  EvaluationItem(this.postId, this.fromUserId, this.fromUserAvatar, this.fromUserNickname,
      this.fromUserProfession, this.score, this.description, this.createTime);

  Map toJson() => {
    'postId': postId,
    'fromUserId': fromUserId,
    'fromUserAvatar': fromUserAvatar,
    'fromUserNickname': fromUserNickname,
    'fromUserProfession': fromUserProfession,
    'score': score,
    'description': description,
    'createTime': createTime,
  };

  factory EvaluationItem.fromJson(Map<String, dynamic> json) {
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    return EvaluationItem(
      json['postId'],
      json['fromUserId'],
      json['fromUserAvatar'],
      json['fromUserNickname'],
      json['fromUserProfession'],
      json['score'],
      json['description'],
      formatter.format(DateTime.parse(json['createTime'])),
    );
  }
}