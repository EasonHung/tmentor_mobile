import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentor_app_flutter/features/chatroom/chatroom_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apiManager/evaluationApiManager.dart';
import '../../apiManager/userApiManager.dart';
import '../../color_constants.dart';
import '../../config/server_url.dart';
import '../../main.dart';
import '../../vo/mentor_item.dart';
import '../../vo/post_item.dart';
import '../evaluation_list_screen/evaluation_list_page.dart';

class IntroduceScreen extends StatefulWidget {
  final String authorId;
  final bool showContactBtn;
  IntroduceScreen(this.authorId, this.showContactBtn);

  @override
  State<StatefulWidget> createState() {
    return IntroduceScreenState(authorId, showContactBtn);
  }
}

class IntroduceScreenState extends State<IntroduceScreen> {
  String authorId;
  String nickname = "";
  String education = "";
  String gender = "";
  String profession = "";
  String aboutMe = "";
  String pictureUrl = "";
  String avatarUrl = "";
  int postCount = 0;
  var averageScore;
  List<JobExperience> jobExperiences = [];
  List<Education> educationList = [];
  List<EvaluationItem> evaluationList = [];
  List<String> mentorSkills = [];
  final bool showContactBtn;

  IntroduceScreenState(this.authorId, this.showContactBtn);

  @override
  void initState() {
    super.initState();
    loadIntroduceFileFromServer();
  }

  Future<void> loadIntroduceFileFromServer() async {
    var responseBody = await userApiManager.getUserInfo(authorId);
    setState(() {
      nickname = responseBody['nickname'];
      avatarUrl = responseBody['avatorUrl'];
      gender = responseBody['gender'];
      profession = responseBody['profession'][0];
      jobExperiences = (responseBody['jobExperiences'] as List).map((i) => JobExperience.fromJson(i)).toList();
      educationList = (responseBody['education'] as List).map((i) => Education.fromJson(i)).toList();
      aboutMe = responseBody['aboutMe'];
      pictureUrl = responseBody['pictureUrl'];
      mentorSkills = (responseBody['mentorSkill'] as List).cast<String>();
    });

    dynamic postInfo = await evaluationApiManager.getUserPosts(authorId, 0);
    if (postInfo == null || postInfo["posts"].length == 0) return;
    postCount = postInfo["totalCount"];
    averageScore = postInfo["averageScore"];
    evaluationList = (postInfo["posts"] as List).map((value) => EvaluationItem.fromJson(value)).toList();
    setState(() {});
  }

  Future<String> addConversation() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userId = pref.getString("userId");
    List<String> participants = [userId!, this.authorId];
    var formData = {"userId": userId, "type": 0, "participants": participants};

    Response response;
    try {
      response = await Dio().post(EnvSetting.CHATROOM_SERVER_IP + "/chatroom/info/conversation/new", data: formData);
    } catch (e) {
      print(e);
      return "";
    }

    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "導師資訊",
            style: TextStyle(color: primaryDark, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
            child: Stack(children: [
              Column(
                children: [
                  buildBackImage(),
                  SizedBox(height: ScreenUtil().setHeight(60)),
                  buildCardNameAndProf(),
                  Divider(),
                  SizedBox(height: ScreenUtil().setHeight(10)),
                  buildAboutMe(),
                  SizedBox(height: ScreenUtil().setHeight(10)),
                  buildSkills(),
                  SizedBox(height: ScreenUtil().setHeight(15)),
                  buildJobExperiences(),
                  SizedBox(height: ScreenUtil().setHeight(15)),
                  buildEducation(),
                  SizedBox(height: ScreenUtil().setHeight(15)),
                  buildEvaluation(),
                  SizedBox(height: ScreenUtil().setHeight(15)),
                ],
              ),
            buildAvatar(),
        ])));
  }

  Widget buildEvaluation() {
    if (evaluationList == null || evaluationList.length == 0) {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "學生回饋(0則)",
                  style: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ]));
    }
    return Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "學生回饋(" + postCount.toString() + "則)",
                style: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: ScreenUtil().setHeight(16)),
          buildEvaluationItem(),
        ]));
  }

  Widget buildEvaluationItem() {
    if (evaluationList.length == 0) {
      return SizedBox.shrink();
    }

    return Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
        decoration: BoxDecoration(
          color: primaryTint,
          borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
        ),
        child: Column(children: [
          Row(
            children: [
              CircleAvatar(
                  radius: 32,
                  backgroundImage: evaluationList[0].fromUserAvatar == ""
                      ? AssetImage("assets/images/null_avatar.png") as ImageProvider
                      : NetworkImage(evaluationList[0].fromUserAvatar)),
              SizedBox(width: ScreenUtil().setWidth(15)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    evaluationList[0].fromUserNickname,
                    style: TextStyle(fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.bold),
                  ),
                  Text(
                    evaluationList[0].fromUserProfession,
                    style: TextStyle(fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.bold),
                  ),
                  RatingBar(
                    initialRating: evaluationList[0].score / 20.0,
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
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          Text(
            evaluationList[0].description,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(14),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(15)),
          Row(children: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return EvaluationListScreen(authorId);
                  }));
                },
                style: TextButton.styleFrom(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
                    ),
                    backgroundColor: primaryLight),
                child: Text(
                  "查看所有回饋",
                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                ))
          ])
        ]));
  }

  Widget buildEducation() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "教育背景",
                style: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: ScreenUtil().setHeight(16)),
          ...buildJobEducationItems(educationList)
        ]));
  }

  List<Widget> buildJobEducationItems(List<Education> education) {
    List<Widget> widgetList = [];
    if (education == null) {
      widgetList.add(SizedBox.shrink());
      return widgetList;
    }

    education.forEach((element) {
      widgetList.add(Column(
        children: [
          Row(children: [
            Text(
              element.schoolName,
              style: TextStyle(fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.bold, color: primaryDark),
            )
          ]),
          SizedBox(height: ScreenUtil().setHeight(6)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              element.subject,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
              ),
            ),
            Text(
              element.startTime + " - " + element.endTime,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
              ),
            )
          ]),
          SizedBox(height: ScreenUtil().setHeight(6)),
        ],
      ));
    });

    return widgetList;
  }

  Widget buildJobExperiences() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "工作經歷",
                style: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: ScreenUtil().setHeight(16)),
          ...buildJobExperienceItems(jobExperiences)
        ]));
  }

  List<Widget> buildJobExperienceItems(List<JobExperience> jobExperienceList) {
    List<Widget> widgets = [];
    for (int i = 0; i < jobExperienceList.length; i++) {
      widgets.add(Column(
        children: [
          Row(children: [
            Text(
              jobExperienceList[i].companyName,
              style: TextStyle(fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.bold, color: primaryDark),
            )
          ]),
          SizedBox(height: ScreenUtil().setHeight(6)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              jobExperienceList[i].jobName,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
              ),
            ),
            Text(
              jobExperienceList[i].startTime + " - " + jobExperienceList[i].endTime,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
              ),
            )
          ])
        ],
      ));
    }
    return widgets;
  }

  Widget buildSkills() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "擅長技能",
                  style: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.w600),
                )
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(10)),
            Row(children: [
              Wrap(
                  spacing: ScreenUtil().setWidth(10),
                  runSpacing: ScreenUtil().setWidth(5),
                  children: buildSkillsItems(mentorSkills)),
            ])
          ],
        ));
  }

  List<Widget> buildSkillsItems(List<String> skillStrings) {
    List<Widget> skillItems = [];
    for (int i = 0; i < skillStrings.length; i++) {
      skillItems.add(Container(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10), vertical: ScreenUtil().setHeight(5)),
          decoration: BoxDecoration(
            color: primaryLight,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
          ),
          child: Text(skillStrings[i], style: TextStyle(fontSize: ScreenUtil().setSp(18)))));
    }
    return skillItems;
  }

  Widget buildAboutMe() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                "關於我",
                style: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold),
              )
            ]),
            SizedBox(height: ScreenUtil().setHeight(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    aboutMe,
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: ScreenUtil().setSp(16),
                    ),
                  )
                )
              ]
            ),
          ],
        ));
  }

  Widget buildAvatar() {
    return Positioned(
        left: ScreenUtil().setWidth(127.5),
        top: ScreenUtil().setHeight(100),
        child: Container(
            width: ScreenUtil().setWidth(120),
            height: ScreenUtil().setHeight(120),
            child: Stack(
              children: [
                CircleAvatar(
                    radius: ScreenUtil().setWidth(60),
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                        backgroundColor: black200,
                        radius: 59,
                        backgroundImage: avatarUrl == ""
                            ? AssetImage("assets/images/null_avatar.png") as ImageProvider
                            : NetworkImage(avatarUrl))),
              ],
            )));
  }

  Widget buildCardNameAndProf() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            nickname,
            style: TextStyle(fontSize: ScreenUtil().setSp(30), fontWeight: FontWeight.w600),
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            profession.length == 0 ? "" : profession,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(22),
            ),
          ),
        ],
      ),
    ]);
  }

  Widget buildBackImage() {
    return Container(
      width: ScreenUtil().screenWidth,
      height: ScreenUtil().setHeight(160),
      child: pictureUrl == ""
          ? Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [Colors.grey, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
            )
          : Image.network(
              pictureUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;

                return const Center(child: Text('Loading...'));
              },
            ));
  }
}
