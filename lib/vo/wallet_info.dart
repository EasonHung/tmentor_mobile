class WalletInfo {
  String walletId;
  int studentPoint;
  int teacherPoint;
  String infoJson;

  WalletInfo(this.walletId, this.studentPoint, this.teacherPoint, this.infoJson);

  factory WalletInfo.fromJson(Map<String, dynamic> json) {
    return WalletInfo(json["walletId"], json["studentPoint"], json["teacherPoint"], json["infoJson"]);
  }

  Map toJson() => {
    'walletId': walletId,
    'studentPoint': studentPoint,
    'teacherPoint': teacherPoint,
    'infoJson': infoJson,
  };
}