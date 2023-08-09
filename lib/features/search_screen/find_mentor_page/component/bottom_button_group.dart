import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mentor_app_flutter/service/toast_service.dart';

import '../../../../apiManager/chatroomApiManager.dart';
import '../../../../color_constants.dart';
import '../../../chatroom/chatroom_screen.dart';
import '../providers/mentor_card_provider.dart';

class BottomBtnGroup extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showChosenWidget = ref.watch(mentorCardShowBottomBtnProvider);
    final cardEngine = ref.watch(mentorCardMatchEngineProvider);

    return AnimatedPositioned(
      duration: Duration(milliseconds: 400),
      bottom: showChosenWidget ? ScreenUtil().setHeight(15) : ScreenUtil().setHeight(-100),
      left: ScreenUtil().setWidth(20),
      child: Container(
        height: ScreenUtil().setHeight(100),
        width: 335.w,
        decoration: BoxDecoration(
          color: primaryTint,
          borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
              minWidth: 30.w,
              height: 30.h,
              onPressed: () {
                cardEngine.currentItem?.nope();
              },
              color: Colors.white,
              child: SvgPicture.asset(
                "assets/images/skipIcon.svg",
                color: primaryDark2,
                width: 30.w,
                height: 30.h,
              ),
              padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
              shape: CircleBorder(),
              elevation: 0,
            ),
            MaterialButton(
              minWidth: 30.w,
              height: 30.h,
              onPressed: () async {
                dynamic response =
                await chatroomApiManager.addConversation(cardEngine.currentItem?.content.userId);
                if (response["code"] == "9999") {
                  print(response["message"]);
                  ToastService.showAlert(response["message"]);
                  return;
                }
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return ChatroomScreen(
                    response["data"]["conversationId"],
                    cardEngine.currentItem?.content.userId,
                    cardEngine.currentItem?.content.nickname,
                    cardEngine.currentItem?.content.avatarUrl,
                  );
                }));
              },
              color: Colors.white,
              child: SvgPicture.asset(
                "assets/images/contactIcon.svg",
                color: primaryDark2,
                width: 23.w,
                height: 23.h,
              ),
              padding: EdgeInsets.all(ScreenUtil().setWidth(14)),
              shape: CircleBorder(),
              elevation: 0,
            ),
            MaterialButton(
              minWidth: 32.w,
              height: 32.h,
              onPressed: () {
                cardEngine.currentItem?.like();
              },
              color: Colors.white,
              child: SvgPicture.asset(
                "assets/images/keepIcon.svg",
                width: 35.w,
                height: 35.h,
              ),
              padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
              shape: CircleBorder(),
              elevation: 0,
            ),
          ],
        )
      )
    );
  }
}