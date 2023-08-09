import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/controller/teacher_class_process_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/controller/teacher_classroom_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/controller/teacher_classroom_timer_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/controller/teacher_classroom_webrtc_controller.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/service/teacher_classroom_message_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

import '../../../../../config/server_url.dart';
import '../../../../../service/toast_service.dart';
import '../../../../../sharedPrefs/userPrefs.dart';
import '../components/waiting_access_dialog.dart';

class TeacherClassroomWsController extends GetxController {
  late WebSocketChannel wsChannel;
  TeacherClassroomMessageService messageService;
  BuildContext currentContext;
  TeacherClassroomWebrtcController teacherClassroomWebrtcController = Get.find<TeacherClassroomWebrtcController>();
  TeacherClassroomClassController teacherClassroomClassController = Get.find<TeacherClassroomClassController>();
  TeacherClassroomTimerController teacherClassroomTimerController = Get.find<TeacherClassroomTimerController>();
  TeacherClassProcessController teacherClassProcessController = Get.find<TeacherClassProcessController>();
  Timer? heartbeatTimer;

  TeacherClassroomWsController(this.messageService, this.currentContext);

  @override
  onInit() async {
    super.onInit();
    await initWsChannel();
    startListenMessageQueue();
    WaitingAccessDialog(currentContext).show();
    messageService.sendAskPermissionCmd(teacherClassroomClassController.teacherClassroomItem.teacherClassroomId!);
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
        case "answer":
          onAnswerCmd(messageJson);
          break;
        case "candidate":
          onCandidateCmd(messageJson);
          break;
        case "accept":
          onAcceptCmd(messageJson);
          break;
        case "reject":
          onRejected();
          break;
        case "instant message":
          break;
        case "join room":
          onJoinRoom(messageJson);
          break;
        case "ask acceptance":
          teacherClassProcessController.onRequireClass(messageJson);
          break;
        // case "pay fail":
        //   Toast.show(messageJson["message"], backgroundColor: Colors.red[300]!);
        //   print(messageJson);
        //   break;
        // case "pay success":
        //   Toast.show("付款成功", backgroundColor: Colors.green[300]!);
        //   break;
        case "start class":
          ToastService.showSuccess("start class!");
          teacherClassProcessController.onStartClass();
          break;
        case "finish class":
          onFinishClass(messageJson);
          break;
        case "close room":
          Get.back();
          break;
        case "unexpect error":
          ToastService.showAlert("unExpect error");
          break;
        default:
          break;
      }
    });
  }

  void startListenMessageQueue() {
    this.messageService.messageQueue.stream.listen((message) {
      wsChannel.sink.add(message);
    });
  }

  void onAnswerCmd(dynamic message) {
    teacherClassroomWebrtcController.onAnswer(message);
  }

  void onCandidateCmd(dynamic msg) async {
    // add candidate to peer connection or add to buffer if not init yet.
    var candidateMap = msg["message"];
    var sdpMLineIndex;

    if (candidateMap['sdpMLineIndex'] == null) {
      sdpMLineIndex = 0;
    } else {
      sdpMLineIndex = candidateMap['sdpMLineIndex'];
    }
    webrtc.RTCIceCandidate candidate = webrtc.RTCIceCandidate(candidateMap['candidate'], candidateMap['sdpMid'], sdpMLineIndex);

    teacherClassroomWebrtcController.addICECandidate(candidate);
  }

  Future<void> onAcceptCmd(dynamic message) async {
    teacherClassroomClassController.joinRoom(message);
  }

  void onRejected() {
    teacherClassroomClassController.beingRejected();
  }

  void onJoinRoom(dynamic message) {
    if(message["message"] == "join class success") {
      ToastService.showSuccess(message["message"]);
      Navigator.of(currentContext).pop();
      teacherClassroomWebrtcController.startPcConnection(message);
    } else {
      ToastService.showAlert(message["message"]);
      Navigator.of(currentContext).pop();
      Navigator.of(currentContext).pop();
    }
  }

  void onFinishClass(dynamic message) {
    teacherClassroomTimerController.clearTimer();
    teacherClassProcessController.clearClass();
    ToastService.showSuccess("課程結束");
  }

}