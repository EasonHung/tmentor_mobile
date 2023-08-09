class ReimburseClassRes {
  String? code;
  String? message;

  ReimburseClassRes(this.code, this.message);

  factory ReimburseClassRes.fromJson(Map<String, dynamic> json) {
    ReimburseClassRes item = ReimburseClassRes(json["code"], json["message"]);
    return item;
  }
}