import 'package:flutter/material.dart';
import 'package:mentor_app_flutter/apiManager/studentCaseApiManager.dart';
import 'package:mentor_app_flutter/vo/bid_info_item.dart';
import 'package:mentor_app_flutter/vo/student_case_item.dart';

class UserCaseItemWidget extends StatefulWidget {
  final StudentCaseItem studentCaseItem;

  UserCaseItemWidget(this.studentCaseItem);

  @override
  State<StatefulWidget> createState() {
    return UserCaseItemWidgetState(this.studentCaseItem);
  }
}

class UserCaseItemWidgetState extends State<UserCaseItemWidget> {
  final StudentCaseItem studentCaseItem;

  List<BidInfoItem> bidInfoItems = [];

  UserCaseItemWidgetState(this.studentCaseItem);

  @override
  void initState() {
    super.initState();
    getBidInfos();
  }

  Future<void> getBidInfos() async {
    List<BidInfoItem> bidInfoRes = await studentCaseApiManager.getBidInfo(studentCaseItem.studentCaseId);

    setState(() {
      bidInfoItems = processBidInfos(bidInfoRes);
    });
  }

  List<BidInfoItem> processBidInfos(List<BidInfoItem> bidInfoRes) {
    if (bidInfoRes.length == 0) return [];

    BidInfoItem highestBid = bidInfoRes.reduce((curr, next) => curr.bidPrice > next.bidPrice ? curr : next);

    List<BidInfoItem> processedBids = [highestBid];
    for (int i = 0; i < bidInfoRes.length; i++) {
      if (bidInfoRes[i].bidInfoId != highestBid.bidInfoId) {
        processedBids.add(bidInfoRes[i]);
      }
    }

    return processedBids;
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
                studentCaseItem.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[500]),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              children: [...buildBidInfos(), buildEditBtn()],
            )));
  }

  Widget buildEditBtn() {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.005, horizontal: MediaQuery.of(context).size.width * 0.05),
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.01, horizontal: MediaQuery.of(context).size.width * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {},
            child: Text("編輯貼文"),
            style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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

    if (bidInfoItems.length == 0) {
      bidInfoWidgets.add(SizedBox.shrink());
      return bidInfoWidgets;
    }

    bidInfoWidgets.add(buildHigestBidInfo(bidInfoItems[0]));
    for (int i = 1; i < bidInfoItems.length; i++) {
      bidInfoWidgets.add(buildBidInfo(bidInfoItems[i]));
    }

    return bidInfoWidgets;
  }

  Widget buildHigestBidInfo(BidInfoItem bidInfoItem) {
    return Container(
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.005, horizontal: MediaQuery.of(context).size.width * 0.05),
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.01, horizontal: MediaQuery.of(context).size.width * 0.05),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey[300]),
        child: Row(
          children: [Text("目前最高出價:"), Spacer(), buildAvator(bidInfoItem.bidderAvatorUrl)],
        ));
  }

  Widget buildBidInfo(BidInfoItem bidInfoItem) {
    return Container(
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.005, horizontal: MediaQuery.of(context).size.width * 0.05),
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.01, horizontal: MediaQuery.of(context).size.width * 0.05),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey[300]),
        child: Row(
          children: [Text("出價:"), Spacer(), buildAvator(bidInfoItem.bidderAvatorUrl)],
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
