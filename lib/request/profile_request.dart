import '../vo/mentor_item.dart';

class ProfileRequest {
  final String nickname;
  final String aboutMe;
  final List<Education> educations;
  final String gender;
  final String profession;
  final List<String> fields;
  final List<String> mentorSkills;
  final List<JobExperience> jobExperience;
  final String userStatus;

  ProfileRequest({
    required this.nickname,
    required this.aboutMe,
    required this.educations,
    required this.gender,
    required this.profession,
    required this.fields,
    required this.mentorSkills,
    required this.jobExperience,
    required this.userStatus,
  });

  Map<String, dynamic> toMap() {
    // todo: sync the variable names (add s or not)
    return {
      "nickname": nickname,
      "aboutMe": aboutMe,
      "education": educations,
      "gender": whichGender(gender),
      "profession": [profession],
      "fields": fields,
      "mentorSkill": mentorSkills,
      "jobExperiences": jobExperience,
      "userStatus": userStatus,
    };
  }

  String whichGender(String gender) {
    if (gender == "男性") {
      return "male";
    } else if (gender == "女性") {
      return "male";
    } else {
      return "bi";
    }
  }
}
