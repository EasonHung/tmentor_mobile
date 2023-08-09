import 'mentor_item.dart';

class UserInfo {
  String? avatarUrl;
  String? nickname;
  String? gender;
  String? profession;
  List<Education>? educationList;
  List<JobExperience>? jobExperiences;
  String? aboutMe;
  String? pictureUrl;
  List<String>? fields;
  List<String>? mentorSkills;

  UserInfo.withNull();

  UserInfo(this.avatarUrl, this.nickname, this.gender, this.profession, this.educationList, this.jobExperiences,
      this.aboutMe, this.pictureUrl, this.fields, this.mentorSkills);

  static newOtherUserInfo(UserInfo otherUserInfo) {
    return UserInfo(
      otherUserInfo.avatarUrl,
      otherUserInfo.nickname,
      otherUserInfo.gender,
      otherUserInfo.profession,
      otherUserInfo.educationList,
      otherUserInfo.jobExperiences,
      otherUserInfo.aboutMe,
      otherUserInfo.pictureUrl,
      otherUserInfo.fields,
      otherUserInfo.mentorSkills
    );
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      json['data']['avatorUrl'],
      json['data']['nickname'],
      json['data']['gender'],
      json['data']['profession'][0],
      (json['data']['education'] as List).map((i) => Education.fromJson(i)).toList(),
      (json['data']['jobExperiences'] as List).map((i) => JobExperience.fromJson(i)).toList(),
      json['data']['aboutMe'],
      json['data']['pictureUrl'],
      (json['data']['fields'] as List).cast<String>(),
      (json['data']['mentorSkill'] as List).cast<String>(),
    );
  }
}