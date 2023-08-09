
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mentor_app_flutter/features/search_screen/find_mentor_page/controller/mentor_card_controller.dart';
import 'package:mentor_app_flutter/features/search_screen/filter_page/filter_page.dart';
import 'package:mentor_app_flutter/features/search_screen/find_mentor_page/providers/mentor_card_provider.dart';
import 'package:mentor_app_flutter/features/search_screen/retained_mentor_page/retained_mentor_page.dart';
import '../../../color_constants.dart';
import 'component/bottom_button_group.dart';
import 'component/loading_bar.dart';
import 'component/mentor_cards.dart';

class FindMentorPage extends ConsumerStatefulWidget {
  FindMentorPage();
  @override
  ConsumerState<FindMentorPage> createState() {
    return FindMentorPageState();
  }
}

class FindMentorPageState extends ConsumerState<FindMentorPage> with SingleTickerProviderStateMixin {
  MentorCardController? mentorCardController;

  @override
  void initState() {
    mentorCardController = MentorCardController(ref);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => mentorCardController!.getMentorItemsFromServer());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mentorCardEmpty = ref.watch(mentorCardEmptyProvider);

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Container(
                child: Stack(children: [
                  LoadingBar(),
                  Column(children: [
                    buildTitle(),
                    buildCardOrEmptyPicture(mentorCardEmpty),
                  ]),
                  BottomBtnGroup()
                ]))));
  }

  Widget buildCardOrEmptyPicture(bool mentorCardEmpty) {
    return mentorCardEmpty?
    Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top:100.h),
          child: SvgPicture.asset(
            "assets/images/emptyCard.svg",
            fit: BoxFit.fitWidth,
            width: ScreenUtil().setWidth(300),
          )
        ),
        SizedBox(height: 40.h,),
        Text(
          "卡片滑完囉！",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryDark2,
            fontSize: 34.sp
          ),
        ),
        SizedBox(height: 15.h,),
        Text(
          "可點擊右上角圖標，重新篩選搜尋",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp
          ),
        )
      ]
    )
    : Align(
        alignment: Alignment.center,
        child: Container(
            height: 625.h,
            width: 335.w,
            child: MentorCards()
        )
    );
  }

  Widget buildTitle() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: ScreenUtil().setSp(38),
              icon: SvgPicture.asset("assets/images/keepIcon.svg"),
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return RetainedMentorPage();
                }));
              },
            ),
            Spacer(),
            Text(
              "T-Mentor",
              style: TextStyle(fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.w500, color: primaryDefault),
            ),
            Spacer(),
            IconButton(
              iconSize: ScreenUtil().setSp(38),
              icon: ImageIcon(
                AssetImage("assets/images/filterIcon.png"),
              ),
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return FilterPage();
                }));
                mentorCardController!.changeCards();
              },
            ),
          ],
        )
    );
  }
}
