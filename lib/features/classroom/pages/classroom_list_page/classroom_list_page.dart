import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentor_app_flutter/features/classroom/pages/classroom_list_page/component/enter_classroom_dialog.dart';
import 'package:mentor_app_flutter/features/classroom/pages/classroom_list_page/controller/classroom_list_controller.dart';
import 'package:mentor_app_flutter/service/toast_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mentor_app_flutter/sharedPrefs/chatroomPrefs.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';
import 'package:toast/toast.dart';
import 'package:mentor_app_flutter/vo/teacher_item.dart';
import 'package:get/get.dart';

import '../../../../color_constants.dart';
import '../../../../sharedPrefs/dto/conversation_info.dart';
import '../../../chatroom/chatroom_screen.dart';

class ClassroomListPage extends StatelessWidget {
  final ClassroomListController classroomListController = Get.find<ClassroomListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _classroomList());
  }

  Widget _classroomList() {
    return Column(children: [
      Expanded(
          child: Obx( () => ListView.builder(
        itemCount: classroomListController.teacherClassroomList.length,
        itemBuilder: (context, index) {
          return buildItemWidget(context, classroomListController.teacherClassroomList[index]);
        },
      )))
    ]);
  }

  Widget buildItemWidget(BuildContext context, TeacherClassroomItem classroomItem) {
    return InkWell(
        onTap: () {
          if (classroomItem.status == "online") {
            EnterClassroomDialog().show(context, classroomItem);
          } else if (classroomItem.status == "in class") {
            Toast.show("老師正在上課中，無法進入教室喔~~", backgroundColor: Colors.red[300]!);
          } else {
            ToastService.showAlert("老師不在教室中，無法進入教室喔~~");
          }
        },
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: ScreenUtil().radius(40),
                          backgroundImage: NetworkImage(classroomItem.teacherAvatar!),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: ScreenUtil().setHeight(23),
                            width: ScreenUtil().setWidth(23),
                            decoration: BoxDecoration(
                                color: getStatusColor(classroomItem.status!),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  width: ScreenUtil().setWidth(2),
                                )
                              ),
                            )
                        )
                      ],
                    ),
                    SizedBox(width: ScreenUtil().setWidth(15.w)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classroomItem.teacherNickname! + " | " + classroomItem.teacherProfession!,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        Text(
                          classroomItem.status == "online" || classroomItem.status == "in class" ? classroomItem.classTitle! : classroomItem.teacherNickname! + "的教室",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ]
                ),
                SizedBox(height: 8.h,),
                buildDesc(classroomItem),
                SizedBox(height: 8.h,),
                buildClassTime(classroomItem),
                classroomItem.status == "offline"? SizedBox(height: 0.h,) : SizedBox(height: 12.h,),
                buildBottomBtns(context, classroomItem),
              ]
            )
        )
    );
              // Expanded(
              //     child: Column(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     // Text(
              //     //   classroomItem.status == "online" ? classroomItem.classTitle! : classroomItem.teacherNickname!,
              //     //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              //     // ),
              //     Opacity(
              //         opacity: 0.64,
              //         child: Text(
              //           classroomItem.status == "online" ? classroomItem.classDesc! : classroomItem.teacherProfession!,
              //           maxLines: 1,
              //           overflow: TextOverflow.ellipsis,
              //           style: TextStyle(fontSize: ScreenUtil().setSp(14)),
              //         )),
              //     Row(
              //       children: [
              //         Text(
              //           classroomItem.status == "online" ? classroomItem.classTime.toString() + "分" : "",
              //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              //         ),
              //         Text(
              //           classroomItem.status == "online" ? classroomItem.classPoints.toString() + "點" : "",
              //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              //         ),
              //       ],
              //     ),
              //     SizedBox(
              //       height: ScreenUtil().setHeight(5),
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         buildAccessBtn(context, classroomItem),
              //         SizedBox(
              //           width: ScreenUtil().setWidth(10),
              //         ),
              //         SizedBox(
              //           width: ScreenUtil().setWidth(110),
              //           height: ScreenUtil().setHeight(45),
              //           child: TextButton(
              //             onPressed: () async {
              //               String? userId = await UserPrefs.getUserId();
              //               ConversationInfo? conversationInfo = await ChatroomPrefs.getConversationInfo(userId!, classroomItem.teacherId!);
              //               if(conversationInfo == null) {
              //                 ToastService.showAlert("找不到聊天訊息，請至聊天室確認");
              //                 return;
              //               }
              //
              //               Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              //                 return ChatroomScreen(
              //                     conversationInfo.conversationId, conversationInfo.remoteId, conversationInfo.remoteNickname, conversationInfo.remoteAvatarUrl);
              //               }));
              //             },
              //             style: TextButton.styleFrom(
              //               shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(ScreenUtil().radius(10)),
              //               ),
              //               backgroundColor: primaryLight),
              //             child: Text(
              //               "導師聊天",
              //               style: TextStyle(
              //                   color: primaryDark, fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.bold),
              //             )
              //           )
              //         )
              //       ],
              //     ),
              //     Divider()
              //   ],
              // )
                // )
            // ])));
  }

  Color getStatusColor(String status) {
    if (status == "online") {
      return Colors.green;
    } else if (status == "in class") {
      return Colors.red;
    } else {
      return black500;
    }
  }

  Widget buildDesc(TeacherClassroomItem classroomItem) {
    return classroomItem.status == "online" || classroomItem.status == "in class"?
      Text(
        classroomItem.classDesc!,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(16)),
      )
      : SizedBox.shrink();
  }

  Widget buildClassTime(TeacherClassroomItem classroomItem) {
    return classroomItem.status == "online" || classroomItem.status == "in class"?
    Row(
      children: [
        SvgPicture.asset(
          "assets/images/class_setting.svg",
          width: 15.w,
          color: primaryDefault,
          fit: BoxFit.fitWidth,
        ),
        SizedBox(width: 5.w,),
        Text(
          classroomItem.classTime.toString() + "分鐘",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(16),
            color: primaryDefault
          ),
        )
      ]
    ):
    SizedBox.shrink();
  }

  Widget buildBottomBtns(BuildContext context, TeacherClassroomItem classroomItem) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildAccessBtn(context, classroomItem),
        SizedBox(
          width: ScreenUtil().setWidth(10),
        ),
        SizedBox(
            width: ScreenUtil().setWidth(160),
            height: ScreenUtil().setHeight(45),
            child: TextButton(
                onPressed: () async {
                  String? userId = await UserPrefs.getUserId();
                  ConversationInfo? conversationInfo = await ChatroomPrefs.getConversationInfo(userId!, classroomItem.teacherId!);
                  if(conversationInfo == null) {
                    ToastService.showAlert("找不到聊天訊息，請至聊天室確認");
                    return;
                  }

                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return ChatroomScreen(
                        conversationInfo.conversationId, conversationInfo.remoteId, conversationInfo.remoteNickname, conversationInfo.remoteAvatarUrl);
                  }));
                },
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ScreenUtil().radius(5)),
                    ),
                    backgroundColor: primaryTint),
                child: Text(
                  "導師聊天",
                  style: TextStyle(
                      color: primaryDark, fontSize: ScreenUtil().setSp(16)),
                )
            )
        )
      ],
    );
  }

  Widget buildAccessBtn(BuildContext context, TeacherClassroomItem teacherClassroomItem) {
    String statusString;
    Color textColor;
    Color backgroundColor;

    if (teacherClassroomItem.status == "offline") {
      statusString = "離線";
      textColor = black600;
      backgroundColor = black400;
    } else if (teacherClassroomItem.status == "online") {
      statusString = "進入教室";
      textColor = Colors.white;
      backgroundColor = primaryDefault;
    } else if (teacherClassroomItem.status == "in class") {
      statusString = "上課中";
      textColor = primaryDark;
      backgroundColor = black300;
    } else {
      statusString = "離線";
      textColor = black600;
      backgroundColor = black400;
    }

    return SizedBox(
        width: ScreenUtil().setWidth(160),
        height: ScreenUtil().setHeight(45),
        child: TextButton(
            onPressed: () async {
              if (teacherClassroomItem.status == "offline") {
                ToastService.showAlert("老師不在線上，無法進入教室");
              } else if (teacherClassroomItem.status == "online") {
                EnterClassroomDialog().show(context, teacherClassroomItem);
              } else if (teacherClassroomItem.status == "in class") {
                Toast.show("老師正在上課，無法進入教室", backgroundColor: Colors.red[300]!);
              } else {
                Toast.show("老師不在線上，無法進入教室", backgroundColor: Colors.red[300]!);
              }
            },
            style: TextButton.styleFrom(
                padding:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10), horizontal: ScreenUtil().setWidth(25)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ScreenUtil().radius(5)),
                ),
                backgroundColor: backgroundColor),
            child: Text(
              statusString,
              style: TextStyle(color: textColor, fontSize: ScreenUtil().setSp(16)),
            )));
  }
}
