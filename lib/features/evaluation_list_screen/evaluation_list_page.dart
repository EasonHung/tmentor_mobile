import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../apiManager/evaluationApiManager.dart';
import '../../color_constants.dart';
import '../../vo/post_item.dart';

class EvaluationListScreen extends StatefulWidget {
  final String userId;

  EvaluationListScreen(this.userId);

  @override
  State<StatefulWidget> createState() {
    return EvaluationListScreenState(userId);
  }
}

class EvaluationListScreenState extends State<EvaluationListScreen> {
  String userId;
  List<EvaluationItem> evaluationList = [];
  var averageScore = 0;
  int totalCount = 0;

  EvaluationListScreenState(this.userId);

  @override
  void initState() {
    loadEvaluationList();
    super.initState();
  }

  Future<void> loadEvaluationList() async {
    dynamic evaluationInfo = await evaluationApiManager.getUserPosts(userId, 0);
    if (evaluationInfo == null || evaluationInfo["posts"].length == 0) return;
    totalCount = evaluationInfo["totalCount"];
    averageScore = evaluationInfo["averageScore"];
    evaluationList = (evaluationInfo["posts"] as List).map((value) => EvaluationItem.fromJson(value)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            centerTitle: true,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              "學生回饋",
              style: TextStyle(color: Colors.black),
            )),
        body: Column(children: [
          Expanded(
              child: ListView.builder(
            itemCount: evaluationList.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return buildTotalAverageItem();
              return buildEvaluationItem(evaluationList[index - 1]);
            },
          ))
        ]));
  }

  Widget buildTotalAverageItem() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide(width: 0.25, color: Colors.grey),
        )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (averageScore / 20.0).toString(),
              style: TextStyle(fontWeight: FontWeight.bold, color: redDefault, fontSize: ScreenUtil().setSp(32)),
            ),
            SizedBox(width: ScreenUtil().setWidth(8)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildRatingBar(averageScore),
                Text(
                  totalCount.toString() + "則回饋",
                  style: TextStyle(color: black800, fontSize: ScreenUtil().setSp(16)),
                ),
              ],
            )
          ],
        ));
  }

  Widget buildEvaluationItem(EvaluationItem evaluation) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20), vertical: ScreenUtil().setHeight(20)),
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide(width: 0.25, color: Colors.grey),
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              buildAvatar(evaluation.fromUserAvatar),
              SizedBox(width: ScreenUtil().setWidth(16)),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(
                      evaluation.fromUserNickname,
                      style: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold),
                    ),
                    Text(
                      evaluation.createTime,
                      style: TextStyle(fontSize: ScreenUtil().setSp(16)),
                    ),
                  ]),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        evaluation.fromUserProfession,
                        style: TextStyle(fontSize: ScreenUtil().setSp(16)),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  buildRatingBar(evaluation.score)
                ],
              ))
            ]),
            SizedBox(height: ScreenUtil().setHeight(15)),
            Text(
              evaluation.description,
              style: TextStyle(fontSize: ScreenUtil().setSp(16)),
            )
          ],
        ));
  }

  Widget buildRatingBar(dynamic score) {
    return RatingBar(
      initialRating: score / 20.0,
      allowHalfRating: true,
      ratingWidget: RatingWidget(
        full: SvgPicture.asset(
          "assets/images/fullStar.svg",
          height: ScreenUtil().setWidth(14),
          width: ScreenUtil().setWidth(14),
          color: yellowDefault,
        ),
        half: SvgPicture.asset(
          "assets/images/fullStar.svg",
          height: ScreenUtil().setWidth(14),
          width: ScreenUtil().setWidth(14),
          color: yellowDefault,
        ),
        empty: SvgPicture.asset(
          "assets/images/emptyStar.svg",
          height: ScreenUtil().setWidth(14),
          width: ScreenUtil().setWidth(14),
          color: yellowDefault,
        ),
      ),
      itemCount: 5,
      itemSize: ScreenUtil().setWidth(15),
      onRatingUpdate: (double value) {},
    );
  }

  Widget buildAvatar(String? avatarUrl) {
    return CircleAvatar(
        radius: ScreenUtil().setWidth(32),
        backgroundImage: avatarUrl == "" || avatarUrl == null
            ? AssetImage("assets/images/null_avatar.png") as ImageProvider
            : NetworkImage(avatarUrl));
  }
}
