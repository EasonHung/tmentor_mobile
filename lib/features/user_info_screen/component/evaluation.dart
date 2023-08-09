import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';
import 'package:readmore/readmore.dart';

import '../../../color_constants.dart';
import '../../../vo/post_item.dart';
import '../../evaluation_list_screen/evaluation_list_page.dart';
import '../controller/user_info_controller.dart';

class EvaluationWidget extends StatelessWidget {
  final BuildContext currentContext;

  EvaluationWidget(this.currentContext);

  final UserInfoController userInfoController = Get.find<UserInfoController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (userInfoController.userPostInfo.value.evaluationList == null || userInfoController.userPostInfo.value.evaluationList!.length == 0) {
        return Container(
            child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "學生回饋(0則)",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(20),
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ]
            )
        );
      }
      return Container(
          child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "學生回饋(" + userInfoController.userPostInfo.value.postCount.toString() + "則)",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(20),
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(16)),
                buildEvaluationItem(userInfoController.userPostInfo.value.evaluationList!),
              ]
          )
      );
    });
  }

  Widget buildEvaluationItem(List<EvaluationItem> evaluationList) {
    if(evaluationList.length == 0) {
      return SizedBox.shrink();
    }

    return Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
        decoration: BoxDecoration(
          color: primaryTint,
          borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
        ),
        child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                      radius: 32,
                      backgroundImage: evaluationList[0].fromUserAvatar == ""? AssetImage("assets/images/null_avatar.png") as ImageProvider : NetworkImage(evaluationList[0].fromUserAvatar)
                  ),
                  SizedBox(width: ScreenUtil().setWidth(15)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        evaluationList[0].fromUserNickname,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(18),
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        evaluationList[0].fromUserProfession,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(16)
                        ),
                      ),
                      SizedBox(height: 4.h),
                      RatingBar(
                        initialRating: evaluationList[0].score / 20.0,
                        allowHalfRating: true,
                        ratingWidget: RatingWidget(
                          full: SvgPicture.asset(
                            "assets/images/fullStar.svg",
                            color: yellowDefault,
                          ),
                          half: SvgPicture.asset(
                            "assets/images/fullStar.svg",
                            color: yellowDefault,
                          ),
                          empty: SvgPicture.asset(
                            "assets/images/emptyStar.svg",
                            color: yellowDefault,
                          ),
                        ),
                        itemCount: 5,
                        itemSize: ScreenUtil().setWidth(15),
                        onRatingUpdate: (double value) {  },
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(10),),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: ReadMoreText(
                      evaluationList[0].description + "       ",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(16),
                      ),
                      trimLines: 2,
                      colorClickableText: primaryDefault,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: '顯示更多',
                      trimExpandedText: '顯示更少',
                      moreStyle: TextStyle(
                          color: primaryDefault,
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),
                      lessStyle: TextStyle(
                          color: primaryDefault,
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),
                    )
                  )
                  // Flexible(
                  //   child: Text(
                  //     evaluationList[0].description,
                  //     style: TextStyle(
                  //       fontSize: ScreenUtil().setSp(16),
                  //     ),
                  //   ),
                  // )
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              Row(
                  children: [
                    TextButton(
                        onPressed: () async {
                          String? userId = await UserPrefs.getUserId();
                          Navigator.of(currentContext).push(MaterialPageRoute(builder: (context){
                            return EvaluationListScreen(userId!);
                          }));
                        },
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
                            ),
                            backgroundColor: primaryLight
                        ),
                        child: Text(
                          "查看所有回饋",
                          style: TextStyle(
                              color: primaryDark2,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    )
                  ]
              )
            ]
        )
    );
  }

}