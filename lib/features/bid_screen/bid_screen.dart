import 'package:flutter/material.dart';
import 'package:mentor_app_flutter/apiManager/studentCaseApiManager.dart';
import 'package:mentor_app_flutter/features/bid_screen/bid_item_widget.dart';
import 'package:mentor_app_flutter/vo/bid_info_item.dart';

class BidScreen extends StatefulWidget {
  final String studentCaseId;

  BidScreen(this.studentCaseId);

  @override
  State<StatefulWidget> createState() {
    return BidScreenState(studentCaseId);
  }
}

class BidScreenState extends State<BidScreen> {
  TextEditingController attractWordTextController = TextEditingController();
  TextEditingController bidTextController = TextEditingController();
  final String studentCaseId;
  List<BidInfoItem> bidInfos = [];

  BidScreenState(this.studentCaseId);

  @override
  void initState() {
    super.initState();
    getBidInfoFromServer();
  }

  Future<void> getBidInfoFromServer() async {
    List<BidInfoItem> res = await studentCaseApiManager.getBidInfo(studentCaseId);
    setState(() {
      bidInfos = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white70,
          title: Text(
            "bid",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
            child: ListView.builder(
                itemCount: bidInfos.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return BidInfoItemWidget(bidInfos[index]);
                })));
  }
}
