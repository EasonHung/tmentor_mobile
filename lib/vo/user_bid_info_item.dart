class UserBidInfoItem {
  String bidInfoId;

  String caseId;

  String bidClassTime;

  int bidPrice;

  UserBidInfoItem(
    this.bidInfoId,
    this.caseId,
    this.bidClassTime,
    this.bidPrice
  );

  factory UserBidInfoItem.fromJson(Map<String, dynamic> json) {
    return UserBidInfoItem(
      json["bidInfoId"],
      json["caseId"],
      json["bidClassTime"],
      json["bidPrice"]
    );
  }
}