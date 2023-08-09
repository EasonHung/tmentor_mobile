import 'package:mentor_app_flutter/vo/post_item.dart';

class MentorItem {
  String? userId;

  String? nickname;

  String? avatarUrl;

  String? aboutMe;

  List<Education>? education;

  int? postCount;

  int? studentCount;

  List<String>? profession;

  List<JobExperience>? jobExperiences;

  String? pictureUrl;

  List<String>? mentorSkill;

  List<EvaluationItem>? postList;

  var evaluationScore; // 有可能是double也可能是int

  // 元件要使用
  double opacity = 1;
  String actionString = "";

  MentorItem(
    this.userId,
    this.nickname,
    this.avatarUrl,
    this.aboutMe,
    this.education,
    this.studentCount,
    this.profession,
    this.jobExperiences,
    this.pictureUrl,
    this.mentorSkill,
    this.postList,
    this.evaluationScore
  );

  Map toJson() => {
    'userId': userId,
    'nickname': nickname,
    'avatorUrl': avatarUrl,
    'aboutMe': aboutMe,
    'education': education,
    'studentCount': studentCount,
    'profession': profession,
    'jobExperiences': jobExperiences,
    'pictureUrl': pictureUrl,
    'mentorSkill': mentorSkill,
    'postList': postList,
    'evaluationScore': evaluationScore
  };

  factory MentorItem.fromJson(Map<String, dynamic> json) {
    var jobExperienceJson = (json['jobExperiences'] as List);
    List<JobExperience> jobExperienceList = jobExperienceJson == null?
      [] : jobExperienceJson.map((i) => JobExperience.fromJson(i)).toList();
    var educationJson = (json['education'] as List);
    List<Education> educationList = educationJson == null?
    [] : educationJson.map((i) => Education.fromJson(i)).toList();

    return MentorItem(
      json['userId'],
      json['nickname'],
      json['avatorUrl'],
      json['aboutMe'],
      educationList,
      json['studentCount'],
      json['profession'] == null? [] : (json['profession'] as List).cast<String>(),
      jobExperienceList,
      json['pictureUrl'],
      (json['mentorSkill'] as List).cast<String>(),
      json['postList'] == null? null : (json['postList'] as List).cast<EvaluationItem>(),
      json['evaluationScore']
    );
  }
}

class JobExperience {
  String companyName;
  String jobName;
  String startTime;
  String endTime;

  JobExperience(this.companyName, this.jobName, this.startTime, this.endTime);

  Map toJson() => {
    'companyName': companyName,
    'jobName': jobName,
    'startTime': startTime,
    'endTime': endTime
  };

  factory JobExperience.fromJson(Map<String, dynamic> json) {
    return JobExperience(
      json['companyName'],
      json['jobName'],
      json['startTime'],
      json['endTime']
    );
  }
}

class Education {
  String schoolName;
  String subject;
  String startTime;
  String endTime;

  Education(this.schoolName, this.subject, this.startTime, this.endTime);

  Map toJson() => {
    'schoolName': schoolName,
    'subject': subject,
    'startTime': startTime,
    'endTime': endTime
  };

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
        json['schoolName'],
        json['subject'],
        json['startTime'],
        json['endTime']
    );
  }
}