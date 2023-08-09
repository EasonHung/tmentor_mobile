import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readmore/readmore.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../../../color_constants.dart';
import '../../../../vo/mentor_item.dart';
import '../../../../vo/post_item.dart';
import '../../../evaluation_list_screen/evaluation_list_page.dart';
import '../providers/mentor_card_provider.dart';

class MentorCards extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mentorSwipeCards = ref.watch(mentorCardListProvider);
    final mentorSwipeEngine = ref.watch(mentorCardMatchEngineProvider);

    if(mentorSwipeCards.length == 0) {
      return SizedBox.shrink();
    }

    return SwipeCards(
      matchEngine: mentorSwipeEngine,
      itemBuilder: (BuildContext context, int index) {
        return buildCardItem(context, mentorSwipeCards[index].content, ref);
      },
      onStackFinished: () {
        ref.read(mentorCardEmptyProvider.notifier).state = true;
        print("stack finished");
      },
      itemChanged: (SwipeItem item, int index) {
        print("item change");
      },
    );
  }

  Widget buildCardItem(BuildContext ctx, MentorItem mentorItem, WidgetRef ref) {
    return SingleChildScrollView(
      child: GestureDetector(
        child: Listener(
          onPointerDown: (PointerDownEvent event) {
            cardAnimationVariables.cardPositionDx = event.localPosition.dx;
            cardAnimationVariables.cardPositionDy = event.localPosition.dy;
          },
          onPointerMove: (PointerMoveEvent event) {
            cardAnimationVariables.fingerUp = false;
            if (cardAnimationVariables.cardDragged && cardAnimationVariables.cardPositionDx - event.localPosition.dx < -50) {
              print("right");
            } else if (cardAnimationVariables.cardDragged && cardAnimationVariables.cardPositionDx - event.localPosition.dx > 50) {
              print("left");
            } else if (!cardAnimationVariables.cardDragged && cardAnimationVariables.cardPositionDy - event.localPosition.dy < 0) {
              cardAnimationVariables.cardPositionDy = event.localPosition.dy;
              ref.read(mentorCardShowBottomBtnProvider.notifier).state = true;
            } else if (!cardAnimationVariables.cardDragged && cardAnimationVariables.cardPositionDy - event.localPosition.dy > 0) {
              cardAnimationVariables.cardPositionDy = event.localPosition.dy;
              ref.read(mentorCardShowBottomBtnProvider.notifier).state = false;
            }
          },
          onPointerUp: (PointerUpEvent event) {
            cardAnimationVariables.fingerUp = true;
            cardAnimationVariables.cardDragged = false;
          },
          // 會有 render exception 是套件的 bug
          child: Stack(children: [
            Opacity(
              opacity: mentorItem.opacity,
              child: Center(
                child: Container(
                  child: Column(children: [
                    Container(
                      height: 160.h,
                      width: 335.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(ScreenUtil().radius(10))),
                        child: buildCardImage(mentorItem))
                      ),
                    Container(
                      width: 335.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(ScreenUtil().radius(10)),
                          bottomRight: Radius.circular(ScreenUtil().radius(10))
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 63.h,),
                          buildCardNameAndProf(mentorItem.nickname!, mentorItem.profession!),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          buildCardDivider(),
                          buildAboutMe(mentorItem.aboutMe!),
                          SizedBox(height: 24.h),
                          buildSkills(mentorItem.mentorSkill!),
                          SizedBox(height: 24.h),
                          buildJobExperiences(mentorItem.jobExperiences!),
                          SizedBox(height: 24.h),
                          buildEducation(mentorItem.education!),
                          SizedBox(height: 24.h),
                          buildEvaluation(ctx, mentorItem),
                          SizedBox(height: 24.h)
                        ],
                      )
                    )
                  ]
                )
              )
            ),
            ),
            buildMentorCardsAvatar(mentorItem),
            buildActionString(mentorItem)
          ]
          )
        )
      )
    );
  }

  Widget buildCardImage(MentorItem mentorItem) {
    bool hasPicture = mentorItem.pictureUrl != null && mentorItem.pictureUrl != "";
    return hasPicture? Image.network(
      mentorItem.pictureUrl!,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return const Center(child: Text('Loading...'));
      },
    ): Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )
      ),
    );
  }

  Widget buildCardNameAndProf(String nickname, List<String> profession) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              nickname,
              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              profession.length == 0 ? "無業游民" : profession[0],
              style: TextStyle(
                fontSize: 20.sp,
              ),
            ),
          ],
        ),
      ]
    );
  }

  Widget buildCardDivider() {
    return SizedBox(
      height: 1.w,
      width: 335.w,
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.grey[300]),
      )
    );
  }

  Widget buildAboutMe(String aboutMe) {
    return Column(
      children: [
        SizedBox(height: ScreenUtil().setHeight(20)),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text(
            "關於我",
            style: TextStyle(fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.bold),
          )
        ]),
        SizedBox(height: 10.h),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Flexible(
            child: Text(
              aboutMe,
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: ScreenUtil().setSp(18),
              ),
            )
          )
        ]),
      ],
    );
  }

  Widget buildSkills(List<String> skillString) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "擅長技能",
              style: TextStyle(fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.w600),
            )
          ],
        ),
        SizedBox(height: ScreenUtil().setHeight(10)),
        Row(children: [
          Wrap(
            spacing: ScreenUtil().setWidth(10),
            runSpacing: ScreenUtil().setWidth(5),
            children: buildSkillsItems(skillString)),
        ])
      ],
    );
  }

  List<Widget> buildSkillsItems(List<String> skillStrings) {
    List<Widget> skillItems = [];
    for (int i = 0; i < skillStrings.length; i++) {
      skillItems.add(Container(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10), vertical: ScreenUtil().setHeight(5)),
          decoration: BoxDecoration(
            color: primaryTint,
            borderRadius: BorderRadius.circular(ScreenUtil().radius(5)),
          ),
          child: Text(skillStrings[i], style: TextStyle(fontSize: ScreenUtil().setSp(18)))));
    }
    return skillItems;
  }

  Widget buildJobExperiences(List<JobExperience> jobExperienceList) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "工作經歷",
            style: TextStyle(fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.bold),
          ),
        ],
      ),
      SizedBox(height: ScreenUtil().setHeight(10)),
      ...buildJobExperienceItems(jobExperienceList)
    ]);
  }

  List<Widget> buildJobExperienceItems(List<JobExperience> jobExperienceList) {
    List<Widget> widgets = [];
    for (int i = 0; i < jobExperienceList.length; i++) {
      widgets.add(Column(
        children: [
          Row(children: [
            Text(
              jobExperienceList[i].companyName,
              style: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold, color: primaryDark),
            )
          ]),
          SizedBox(height: ScreenUtil().setHeight(6)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              jobExperienceList[i].jobName,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(18),
              ),
            ),
            Text(
              jobExperienceList[i].startTime + " - " + jobExperienceList[i].endTime,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(18),
              ),
            )
          ])
        ],
      ));

      // add space between items
      if(i < jobExperienceList.length - 1) {
        widgets.add(SizedBox(height: ScreenUtil().setHeight(12)));
      }
    }
    return widgets;
  }

  Widget buildEducation(List<Education> educationList) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "教育背景",
            style: TextStyle(fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.bold),
          ),
        ],
      ),
      SizedBox(height: ScreenUtil().setHeight(10)),
      ...buildJobEducationItems(educationList)
    ]);
  }

  List<Widget> buildJobEducationItems(List<Education> educationList) {
    List<Widget> widgetList = [];
    if (educationList == null) {
      widgetList.add(SizedBox.shrink());
      return widgetList;
    }

    for(int i = 0; i < educationList.length; i++) {
      widgetList.add(Column(
        children: [
          Row(children: [
            Text(
              educationList[i].schoolName,
              style: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold, color: primaryDark),
            )
          ]),
          SizedBox(height: ScreenUtil().setHeight(6)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              educationList[i].subject,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(18),
              ),
            ),
            Text(
              educationList[i].startTime + " - " + educationList[i].endTime,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
              ),
            )
          ]),
          SizedBox(height: ScreenUtil().setHeight(6)),
        ],
      ));

      // add space between items
      if(i < educationList.length - 1) {
        widgetList.add(SizedBox(height: ScreenUtil().setHeight(12)));
      }
    }
    return widgetList;
  }

  Widget buildEvaluation(BuildContext context, MentorItem mentorItem) {
    if (mentorItem.postList == null) {
      return Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "學生回饋(0則)",
                  style: TextStyle(fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.bold),
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
                "學生回饋(" + mentorItem.postCount.toString() + "則)",
                style: TextStyle(fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: ScreenUtil().setHeight(16)),
          buildEvaluationItem(context, mentorItem.postList!, mentorItem.userId!),
        ]
      )
    );
  }

  Widget buildEvaluationItem(BuildContext context, List<EvaluationItem> postList, String cardUserId) {
    if (postList.length == 0) {
      return SizedBox.shrink();
    }

    return Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
        decoration: BoxDecoration(
          color: primaryTint,
          borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
        ),
        child: Column(children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: postList[0].fromUserAvatar == ""
                    ? AssetImage("assets/images/null_avatar.png") as ImageProvider
                    : NetworkImage(postList[0].fromUserAvatar)),
              SizedBox(width: ScreenUtil().setWidth(15)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    postList[0].fromUserNickname,
                    style: TextStyle(fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    postList[0].fromUserProfession,
                    style: TextStyle(fontSize: ScreenUtil().setSp(16)),
                  ),
                  SizedBox(height: 4.h),
                  RatingBar(
                    initialRating: postList[0].score / 20.0,
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
                    onRatingUpdate: (double value) {},
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: ReadMoreText(
                  postList[0].description + "  ",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                  ),
                  trimLines: 2,
                  colorClickableText: primaryDefault,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: '顯示更多',
                  trimExpandedText: '顯示更少',
                  moreStyle: TextStyle(
                    color: primaryDark2,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),
                  lessStyle: TextStyle(
                      color: primaryDark2,
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                  ),
                )
              )
            ]
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          Row(children: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return EvaluationListScreen(cardUserId);
                  }));
                },
                style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ScreenUtil().radius(20)),
                    ),
                    backgroundColor: primaryLight),
                child: Text(
                  "查看所有回饋",
                  style: TextStyle(color: primaryDark2, fontWeight: FontWeight.bold),
                ))
          ])
        ]
        )
    );
  }

  Widget buildMentorCardsAvatar(MentorItem mentorItem) {
    return Positioned(
      left: ScreenUtil().setWidth(107.5),
      top: ScreenUtil().setHeight(87),
      child: Opacity(
        opacity: mentorItem.opacity,
        child: CircleAvatar(
          radius: ScreenUtil().setWidth(60),
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: ScreenUtil().setWidth(57),
            backgroundImage: mentorItem.avatarUrl == ""
                ? AssetImage("assets/images/null_avatar.png") as ImageProvider
                : NetworkImage(mentorItem.avatarUrl!)
          )
        ),
      )
    );
  }

  Widget buildActionString(MentorItem mentorItem) {
    return Center(
      child: Text(
        mentorItem.actionString,
        style: TextStyle(color: Colors.deepOrange, fontSize: 50, fontWeight: FontWeight.bold),
      )
    );
  }
}