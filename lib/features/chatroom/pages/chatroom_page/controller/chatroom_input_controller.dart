import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/chatroom/pages/chatroom_page/service/chatroom_message_service.dart';
import 'package:mentor_app_flutter/service/toast_service.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';

import '../../../../../apiManager/classroomApiManager.dart';
import '../../../../../apiManager/classroom_api_dto/res/enroll_classroom_res.dart';
import '../../../../../apiManager/errorCode.dart';
import '../../../../../local_database/dao/chat_message_content.dart';
import '../../../../../main.dart';
import '../../../constants/chatroom_cmd.dart';

class ChatroomInputController extends GetxController {
  String? userId;
  String conversationId;
  String remoteId;
  ChatroomMessageService chatroomMessageService;
  TextEditingController inputTextController = TextEditingController();

  ChatroomInputController(this.chatroomMessageService, this.conversationId, this.remoteId);

  @override
  void onInit() async {
    userId = await UserPrefs.getUserId();
    super.onInit();
  }

  void sendMessage() {
    if (inputTextController.text == "") {
      return;
    }
    chatroomMessageService.sendSimpleMessage(userId!, inputTextController.text, conversationId, remoteId);
    inputTextController.text = "";
  }

  void sendClassroomInvitation() {
    chatroomMessageService.sendClassroomInvitationMessage(userId!, remoteId, conversationId);
  }

  void neglectInvitation(String messageId) {
    ChatMessageContent? invitation = ChatMessageContentDao.findByMessageId(store!, userId!, messageId);
    invitation?.cmd = ChatroomCmd.USED_CLASS_INFO;
    if(invitation != null) {
      ChatMessageContentDao.insertNewOrUpdateCmd(store!, invitation);
    }
  }
  
  Future<void> enrollClassroom(String classroomToken, String messageId) async {
    // invalidate button first
    ChatMessageContent? invitation = ChatMessageContentDao.findByMessageId(store!, userId!, messageId);
    invitation?.cmd = ChatroomCmd.USED_CLASS_INFO;
    if(invitation != null) {
      ChatMessageContentDao.insertNewOrUpdateCmd(store!, invitation);
    }
    
    // enroll classroom
    EnrollClassroomRes res = await classroomApiManager.addClassroom(classroomToken);
    if(res.code == ApiErrorCode.SUCCESS) {
      ToastService.showSuccess("成功加入教室");
    } else {
      ToastService.showAlert(res.message!);
    }
  }
}