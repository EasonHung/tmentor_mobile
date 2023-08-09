import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentor_app_flutter/color_constants.dart';

import 'component/chat_message_widget.dart';
import 'component/classroom_invitation_btn.dart';
import 'component/input_widget.dart';

class ChatroomPage extends StatelessWidget {
  final String nickname;

  ChatroomPage(this.nickname);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
              actions: [ClassroomInvitationBtn()],
              title: Text(
                nickname,
                style: TextStyle(
                    color: Colors.black
                ),
              ),
              bottom: PreferredSize(
                  child: Container(
                    color: black400,
                    height: ScreenUtil().setHeight(1),
                  ),
                  preferredSize: Size.fromHeight(4.0)
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ChatMessageWidget(),
                InputWidget()
              ],
            )
        )
    );
  }
}