class CreateUserRes {
  String? code;
  String? message;

  CreateUserRes(this.code, this.message);

  factory CreateUserRes.fromJson(Map<String, dynamic> json) {
    CreateUserRes item = CreateUserRes(json["code"], json["message"]);
    return item;
  }
}