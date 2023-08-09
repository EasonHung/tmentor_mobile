import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';
import 'package:mentor_app_flutter/color_constants.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';

import '../../../apiManager/chatroomApiManager.dart';
import '../../../sharedPrefs/cardPrefs.dart';
import '../../../vo/mentor_item.dart';
import '../../chatroom/chatroom_screen.dart';
import '../../introduce_screen/introduce_screen.dart';

class RetainedMentorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RetainedMentorPageState();
  }
}

class RetainedMentorPageState extends State<RetainedMentorPage> {
  List<MentorItem> retainedCards = [];
  String? userId;

  @override
  void initState() {
    super.initState();
    getRetainedCards();
  }

  Future<void> getRetainedCards() async {
    userId = await UserPrefs.getUserId();
    retainedCards = await CardPrefs.getRetainCards(userId!);
    setState(() {
      retainedCards = retainedCards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            "收藏導師",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          bottom: PreferredSize(
            child: Container(
              color: black400,
              height: ScreenUtil().setHeight(1),
            ),
            preferredSize: Size.fromHeight(4.0)
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(height: 8,),
            Expanded(
              child: ListView.builder(
              itemCount: retainedCards.length,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return IntroduceScreen(retainedCards[index].userId!, true);
                      }));
                    },
                    onLongPress: () async {
                      retainedCards = await CardPrefs.deleteRetainCardsByIndex(userId!, index);
                      setState(() {
                        retainedCards = retainedCards;
                      });
                    },
                    child: buildListItem(retainedCards[index]));
              },
            )
          )
        ]
      )
    );
  }

  Widget buildListItem(MentorItem mentorItem) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(8), horizontal: ScreenUtil().setWidth(15)),
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10), vertical: ScreenUtil().setHeight(10)),
        width: ScreenUtil().setWidth(335),
        height: ScreenUtil().setHeight(160),
        decoration: BoxDecoration(
          borderRadius:
            BorderRadius.all(Radius.circular(ScreenUtil().radius(10)) //                 <--- border radius here
                ),
          color: primaryTint,
        ),
        child: Row(
          children: [
          buildAvatar(mentorItem.avatarUrl),
          SizedBox(
            width: ScreenUtil().setWidth(15),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h,),
              Text(
                mentorItem.nickname?? "",
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(20),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h,),
              Text(
                mentorItem.profession == null || mentorItem.profession!.length == 0? "" : mentorItem.profession![0],
                style: TextStyle(fontSize: ScreenUtil().setSp(16), color: Colors.black54),
              ),
              SizedBox(height: 2.h,),
              Row(children: [
                buildEvaluationScore(mentorItem.evaluationScore),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: () async {
                        dynamic response = await chatroomApiManager.addConversation(mentorItem.userId!);
                        if (response["code"] == "9999") {
                          Toast.show(response["message"], backgroundColor: Colors.red[300]!);
                          return;
                        }
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return ChatroomScreen(
                            response["data"]["conversationId"], mentorItem.userId!, mentorItem.nickname!, mentorItem.avatarUrl!);
                        }));
                      },
                      style: TextButton.styleFrom(
                        fixedSize: Size(100.w, 30.h),
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(5), horizontal: ScreenUtil().setWidth(10)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ScreenUtil().radius(5)),
                        ),
                        backgroundColor: primaryDefault),
                      child: Text(
                        "導師聊天",
                        style:
                            TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(16)),
                      )),
                  SizedBox(
                    width: ScreenUtil().setWidth(10),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return IntroduceScreen(mentorItem.userId!, true);
                        }));
                      },
                      style: TextButton.styleFrom(
                          fixedSize: Size(100.w, 30.h),
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(5), horizontal: ScreenUtil().setWidth(10)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ScreenUtil().radius(5)),
                          ),
                          backgroundColor: primaryLight),
                      child: Text(
                        "查看資訊",
                        style:
                            TextStyle(color: primaryDark, fontSize: ScreenUtil().setSp(16)),
                      ))
                ],
              ),
              Spacer(),
            ]
          )
        ]));
  }

  // average score can be int or double
  Widget buildEvaluationScore(var averageScore) {
    if (averageScore == null) {
      return Text("尚無評分", style: TextStyle(color: Colors.grey, fontSize: ScreenUtil().setSp(14)));
    }

    return RatingBar(
      initialRating: averageScore / 20.0,
      allowHalfRating: true,
      ratingWidget: RatingWidget(
        full: Image.asset(
          "assets/images/fullStar.png",
          height: ScreenUtil().setWidth(14),
          width: ScreenUtil().setWidth(14),
          color: yellowDefault,
        ),
        half: Image.asset(
          "assets/images/halfStar.png",
          height: ScreenUtil().setWidth(14),
          width: ScreenUtil().setWidth(14),
          color: yellowDefault,
        ),
        empty: Image.asset(
          "assets/images/emptyStar.png",
          height: ScreenUtil().setWidth(14),
          width: ScreenUtil().setWidth(14),
          color: yellowDefault,
        ),
      ),
      itemCount: 5,
      itemSize: ScreenUtil().setWidth(20),
      onRatingUpdate: (double value) {},
    );
  }

  Widget buildAvatar(String? avatarUrl) {
    return avatarUrl == "" || avatarUrl == null?
      CircleAvatar(
          radius: ScreenUtil().setWidth(48),
          backgroundImage: AssetImage("assets/images/null_avatar.png")
      ):
      CircleAvatar(
      radius: ScreenUtil().setWidth(48),
      backgroundImage: NetworkImage(avatarUrl)
      );
    // return Container(
    //   height: ScreenUtil().setHeight(120),
    //   width: ScreenUtil().setWidth(120),
    //   decoration: BoxDecoration(
    //     image: DecorationImage(
    //         image: avatarUrl == "" || avatarUrl == null
    //             ? AssetImage("assets/images/null_avatar.png") as ImageProvider
    //             : NetworkImage(avatarUrl),
    //         fit: BoxFit.fill),
    //     color: Colors.white,
    //     borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(5))),
    //   ),
    // );
  }
}
