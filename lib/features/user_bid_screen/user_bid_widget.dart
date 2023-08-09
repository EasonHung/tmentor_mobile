import 'package:flutter/material.dart';
import 'package:mentor_app_flutter/apiManager/studentCaseApiManager.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';
import 'package:mentor_app_flutter/vo/bid_info_item.dart';
import 'package:mentor_app_flutter/vo/student_case_item.dart';
import 'package:mentor_app_flutter/vo/user_bid_info_item.dart';

class UserBidInfoItemWidget extends StatefulWidget {
  final List<UserBidInfoItem> bidInfoList;

  UserBidInfoItemWidget(this.bidInfoList);

  @override
  State<StatefulWidget> createState() {
    return UserBidInfoItemWidgetState(this.bidInfoList);
  }
}

class UserBidInfoItemWidgetState extends State<UserBidInfoItemWidget> {
  final List<UserBidInfoItem> bidInfoList;
  String userAvatar = "";
  BidInfoItem? higestBidInfo;
  StudentCaseItem? caseItem;

  UserBidInfoItemWidgetState(this.bidInfoList);

  @override
  void initState() {
    super.initState();
    getCaseItem();
    getUserAvatar();
    getHighestBidInfo();
  }

  Future<void> getCaseItem() async {
    caseItem = await studentCaseApiManager.getOneStudentCase(bidInfoList[0].caseId);
    setState(() {
      caseItem = caseItem;
    });
  }

  Future<void> getUserAvatar() async {
    userAvatar = (await UserPrefs.getUserAvatarUrl())!;
    setState(() {
      userAvatar = userAvatar;
    });
  }

  Future<void> getHighestBidInfo() async {
    List<BidInfoItem> bidInfoRes = await studentCaseApiManager.getBidInfo(bidInfoList[0].caseId);
    setState(() {
      higestBidInfo = bidInfoRes.reduce((curr, next) => curr.bidPrice > next.bidPrice ? curr : next);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
        contentPadding: EdgeInsets.symmetric(horizontal: 30),
        dense: true, //removes additional space vertically
        horizontalTitleGap: 0.0,
        minLeadingWidth: 0,
        child: Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              iconColor: Color(0xff71c57d),
              title: Text(
                caseItem == null ? "loading..." : caseItem!.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[500]),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              children: [...buildBidInfos(), buildBidAgainBtn()],
            )));
  }

  Widget buildBidAgainBtn() {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.005, horizontal: MediaQuery.of(context).size.width * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {},
            child: Text("再次出價"),
            style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 50),
                primary: Colors.white,
                backgroundColor: Color(0xff71c57d),
                onSurface: Colors.grey,
                elevation: 5,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)))),
          )
        ],
      ),
    );
  }

  List<Widget> buildBidInfos() {
    List<Widget> bidInfoWidgets = [];

    if (bidInfoList.length == 0) {
      bidInfoWidgets.add(SizedBox.shrink());
      return bidInfoWidgets;
    }

    for (int i = 0; i < bidInfoList.length; i++) {
      setState(() {
        bidInfoWidgets.add(buildBidInfo(bidInfoList[i]));
      });
    }
    bidInfoWidgets.add(buildHigestBidInfo(higestBidInfo!));

    return bidInfoWidgets;
  }

  Widget buildHigestBidInfo(BidInfoItem bidInfoItem) {
    if (bidInfoItem == null) {
      return SizedBox.shrink();
    }

    return Container(
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.005, horizontal: MediaQuery.of(context).size.width * 0.05),
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.01, horizontal: MediaQuery.of(context).size.width * 0.05),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey[300]),
        child: Row(
          children: [
            Text("目前最高出價:" + bidInfoItem.bidPrice.toString()),
            Spacer(),
            buildAvator(bidInfoItem.bidderAvatorUrl)
          ],
        ));
  }

  Widget buildBidInfo(UserBidInfoItem bidInfoItem) {
    return Container(
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.005, horizontal: MediaQuery.of(context).size.width * 0.05),
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.01, horizontal: MediaQuery.of(context).size.width * 0.05),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey[300]),
        child: Row(
          children: [Text("出價:"), Spacer(), buildAvator(userAvatar)],
        ));
  }

  Widget buildAvator(String url) {
    return url == null || url == ""
        ? CircleAvatar(
            backgroundColor: Colors.grey[300],
            radius: MediaQuery.of(context).size.width * 0.08,
            child: ClipOval(
              child: Image.asset("assets/images/null_avatar.png", fit: BoxFit.cover),
            ),
          )
        : CircleAvatar(
            backgroundColor: Colors.grey[300],
            radius: MediaQuery.of(context).size.width * 0.08,
            child: ClipOval(
              child: Image.network(
                url,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return ClipOval(
                    child: Image.asset("assets/images/null_avatar.png", fit: BoxFit.cover),
                  );
                },
              ),
            ),
          );
  }
}
