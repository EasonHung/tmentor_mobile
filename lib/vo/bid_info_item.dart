class BidInfoItem {
  String bidInfoId;

  String bidderId;

  String studentCaseId;

  String bidderAvatorUrl;

  String bidderNickname;

  String bidderJob;

  String bidderEducation;

  String bidderGender;

  int bidPrice;

  BidInfoItem(
    this.bidInfoId,
    this.bidderId,
    this.studentCaseId, 
    this.bidderAvatorUrl, 
    this.bidderNickname, 
    this.bidderJob, 
    this.bidderEducation,
    this.bidderGender,
    this.bidPrice
  );

  factory BidInfoItem.fromJson(Map<String, dynamic> json) {
    return BidInfoItem(
      json["bidInfoId"],
      json["bidderId"],
      json["studentCaseId"], 
      json["bidderAvatorUrl"], 
      json["bidderNickname"],
      json["bidderJob"],
      json["bidderEducation"],
      json["bidderGender"],
      json["bidPrice"],
    );
  }
}