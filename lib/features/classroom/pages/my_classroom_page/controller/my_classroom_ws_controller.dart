import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_classroom_btn_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_classroom_class_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/controller/my_classroom_timer_controller.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../../apiManager/classroomApiManager.dart';
import '../../../../../config/server_url.dart';
import '../../../../../service/toast_service.dart';
import '../../../../../sharedPrefs/userPrefs.dart';
import '../../../../main_page.dart';
import '../../../constants/ClassStatus.dart';
import '../components/ask_permission_dialog.dart';
import '../service/my_classroom_message_service.dart';
import 'my_class_process_controller.dart';
import 'my_classroom_media_controller.dart';
import 'my_classroom_webrtc_controller.dart';

class MyClassroomWsController extends GetxController {
  late WebSocketChannel wsChannel;
  String? classroomId;
  MyClassroomMessageService messageService;
  MyClassroomMediaController myClassroomMediaController = Get.find<MyClassroomMediaController>();
  MyClassroomBtnController myClassroomBtnController = Get.find<MyClassroomBtnController>();
  MyClassroomWebrtcController myClassroomWebrtcController = Get.find<MyClassroomWebrtcController>();
  MyClassroomClassController myClassroomClassController = Get.find<MyClassroomClassController>();
  MyClassroomTimerController myClassroomTimerController = Get.find<MyClassroomTimerController>();
  MyClassProcessController classProcessController = Get.find<MyClassProcessController>();
  BuildContext currentContext;
  Timer? heartbeatTimer;

  MyClassroomWsController(this.currentContext, this.messageService);

  @override
  onInit() async {
    super.onInit();
    String? userId = await UserPrefs.getUserId();
    classroomId = await classroomApiManager.getClassroomId(userId!);
    await initWsChannel();
    startListenMessageQueue();
    myClassroomClassController.sendOpenClassroomMessage();
  }

  @override
  onClose() async {
    stopHeartbeat();
    wsChannel.sink.close();
    messageService.closeMessageQueue();
  }

  Future<void> initWsChannel() async {
    String? userId = await UserPrefs.getUserId();
    wsChannel = WebSocketChannel.connect(
        Uri.parse(EnvSetting.CLASSROOM_WEBSOCKET_IP + '/?userId=' + userId! + '&applicationType=app'));
    listenAndProcessMsg();
    startHeartbeat();
  }

  void startHeartbeat() async {
    if(heartbeatTimer != null) {
      return;
    }

    heartbeatTimer = Timer.periodic(Duration(seconds: 30), (Timer t) {
      print("[my classroom] ping");
      wsChannel.sink.add(json.encode({
        "cmd": "ping",
      }).codeUnits);
    });
  }

  void stopHeartbeat() async {
    heartbeatTimer?.cancel();
    heartbeatTimer = null;
  }

  void listenAndProcessMsg()  {
    wsChannel.stream.listen((message) {
      // utf8.encode -> string to List<int>
      var messageJson = json.decode(message);
      switch (messageJson['cmd']) {
        case "open room":
          if(messageJson["classroomId"] != classroomId) {
            return;
          }
          myClassroomMediaController.initRenderers();
          ToastService.showSuccess("open success");
          break;
        case "ask":
          onAsk(messageJson);
          break;
        case "leave room":
          classProcessController.clearClass();
          onLeaveRoom();
          break;
        case "instant message":
          break;
        case "offer":
          onOffer(messageJson);
          classProcessController.setStudentId(messageJson["senderId"]);
          break;
        case "candidate":
          onCandidateCmd(messageJson);
          break;
        // case "pay success":
        //   ToastService.showSuccess("付款成功");
        //   break;
        case "start class":
          ToastService.showSuccess("start class!");
          classProcessController.onStartClass();
          break;
        case "finish class":
          myClassroomTimerController.clearTimer();
          myClassroomBtnController.classStatus.value = ClassStatus.FINISH;
          ToastService.showSuccess("課程結束");
          break;
        case "unexpect error":
          ToastService.showAlert(messageJson['message']);
          break;
      }
    }, onDone: () {
      Navigator.of(currentContext).pushReplacement(MaterialPageRoute(builder: (context) {
        return MainScreen();
      }));
    });
  }

  void startListenMessageQueue() {
    this.messageService.messageQueue.stream.listen((message) {
      wsChannel.sink.add(message);
    });
  }

  void onAsk(dynamic message) {
    AskPermissionDialog(messageService).show(message, currentContext);
  }

  void onLeaveRoom() {
    myClassroomMediaController.closeRemoteMedia();
    myClassroomWebrtcController.clearPc();
  }

  Future<void> onOffer(dynamic message) async {
    myClassroomMediaController.initRenderers();
    myClassroomWebrtcController.startPeerConnection(message);
  }

  Future<void> onCandidateCmd(dynamic msg) async {
    // add candidate to peer connection or add to buffer if not init yet.
    var candidateMap = msg["message"];
    var sdpMLineIndex;

    if (candidateMap['sdpMLineIndex'] == null) {
      sdpMLineIndex = 0;
    } else {
      sdpMLineIndex = candidateMap['sdpMLineIndex'];
    }
    RTCIceCandidate candidate = RTCIceCandidate(candidateMap['candidate'], candidateMap['sdpMid'], sdpMLineIndex);

    myClassroomWebrtcController.addICECandidate(candidate);
  }
}