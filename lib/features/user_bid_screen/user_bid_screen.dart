import 'package:flutter/material.dart';
import 'package:mentor_app_flutter/apiManager/studentCaseApiManager.dart';
import 'package:mentor_app_flutter/features/user_bid_screen/user_bid_widget.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';
import 'package:mentor_app_flutter/vo/user_bid_info_item.dart';

class UserBidScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserBidScreenState();
  }
}

class UserBidScreenState extends State<UserBidScreen> {
  List<String> bidInfoCaseIdList = [];
  Map<String, List<UserBidInfoItem>> bidInfoMap = new Map();

  @override
  void initState() {
    super.initState();
    getUserBidFromServer();
  }

  Future<void> getUserBidFromServer() async {
    List<UserBidInfoItem> totalBidInfos = await studentCaseApiManager.getBidInfsByUserId(await UserPrefs.getUserId());
    bidInfoArrangement(totalBidInfos);
    setState(() {
      bidInfoCaseIdList = bidInfoCaseIdList;
    });
  }

  void bidInfoArrangement(List<UserBidInfoItem> bidInfos) {
    for (int i = 0; i < bidInfos.length; i++) {
      if (bidInfoMap.containsKey(bidInfos[i].caseId)) {
        bidInfoMap[bidInfos[i].caseId]!.add(bidInfos[i]);
      } else {
        bidInfoMap[bidInfos[i].caseId] = [bidInfos[i]];
      }
    }

    bidInfoCaseIdList = bidInfoMap.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF5F7F5),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          centerTitle: true,
          backgroundColor: Color(0xFFF5F7F5),
          title: Text(
            "我的出價",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        body: Container(
            child: ListView.builder(
                itemCount: bidInfoCaseIdList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return UserBidInfoItemWidget(bidInfoMap[bidInfoCaseIdList[index]]!);
                })));
  }
}
