class ClassSettingInfo {
  String settingName;
  String title;
  String desc;
  int classTime;
  int classPoints;

  ClassSettingInfo(this.settingName, this.title, this.desc, this.classTime, this.classPoints);

  static ClassSettingInfo newClassSettingInfo(ClassSettingInfo originSetting) {
    return ClassSettingInfo(
      originSetting.settingName,
      originSetting.title,
      originSetting.desc,
      originSetting.classTime,
      originSetting.classPoints
    );
  }

  factory ClassSettingInfo.fromJson(Map<String, dynamic> json) {
    return ClassSettingInfo(json["settingName"], json["title"], json["desc"], json["classTime"], json["classPoints"]);
  }

  Map toJson() => {
    'settingName': settingName,
    'title': title,
    'desc': desc,
    'classTime': classTime,
    'classPoints': classPoints,
  };
}