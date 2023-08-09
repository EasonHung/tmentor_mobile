import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mentor_app_flutter/service/toast_service.dart';
import 'package:toast/toast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:intl/intl.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../color_constants.dart';
import '../../../config/server_url.dart';
import '../../../sharedPrefs/userPrefs.dart';
import '../../../vo/teacher_item.dart';
import '../pages/my_classroom_page/constraints.dart';
import '../pages/teacher_classroom_page/components/ask_class_accetion_dialog.dart';
import '../pages/teacher_classroom_page/components/reject_dialog.dart';
import '../pages/teacher_classroom_page/components/waiting_access_dialog.dart';
import '../service/ws_message_service.dart';

class TeacherClassroomController extends GetxController {
  late TeacherClassroomItem teacherClassroomItem;
  webrtc.RTCPeerConnection? pc;
  late WebSocketChannel webSocketChannel;
  late WsMessageService wsMessageService;
  late BuildContext currentContext;
  String classId = "";
  List<webrtc.RTCIceCandidate> iceCandidateList = [];
  bool remoteIsReady = false;
  Rx<webrtc.RTCVideoRenderer> localStreamRenderer = webrtc.RTCVideoRenderer().obs;
  Rx<webrtc.RTCVideoRenderer> remoteStreamRenderer = webrtc.RTCVideoRenderer().obs;
  late webrtc.MediaStream localStream;
  final Map<String, dynamic> iceServers = {
    'iceServers': [
      // {'url': 'stun:stun.l.google.com:19302'},
      // {
      //   'urls': ['turn:openrelay.metered.ca:80'],
      //   'username': 'openrelayproject',
      //   'credentials': 'openrelayproject'
      // }
      // {
      //   "urls": "stun:relay.metered.ca:80",
      // },
      {
        "url": "turn:relay1.expressturn.com:3478",
        "username": "efC2OT8W129D2ID63H",
        "credential": "6ZeChztFE4cxEmgg",
      },
    ]
  };
  Rx<Color> timerBackgroundColor = Colors.grey.obs;
  Rx<String> timerMin = "00".obs;
  Rx<String> timerSec = "00".obs;
  late Timer classTimer;
  Rx<bool> showBottomBtns = true.obs;

  @override
  void onClose() {
    debugPrint("close my classroom controller");
    webSocketChannel.sink.close();
    localStreamRenderer.value.srcObject = null;
    localStreamRenderer.value.dispose();
    remoteStreamRenderer.value.srcObject = null;
    remoteStreamRenderer.value.dispose();
    localStream.dispose();
    clearPc();
    super.onClose();
  }

  void clearPc() {
    pc?.close();
    pc = null;
    remoteIsReady = false;
    iceCandidateList = [];
  }

  void changeBottmBtnStatus() {
    showBottomBtns.value = !showBottomBtns.value;
  }

  void sendFinishClassMessage() {
    if(classId != "") {
      wsMessageService.sendFinishClassCmd(classId, teacherClassroomItem.teacherClassroomId!);
    }
  }

  Future<void> initClassroom(TeacherClassroomItem teacherClassroomItem, BuildContext context) async {
    String? userId = await UserPrefs.getUserId();
    webSocketChannel = WebSocketChannel.connect(Uri.parse(EnvSetting.CLASSROOM_WEBSOCKET_IP +
        '/?userId=' + userId! + '&applicationType=app'));
    wsMessageService = WsMessageService(webSocketChannel);
    listenAndProcessMsg();
    this.teacherClassroomItem = teacherClassroomItem;
    currentContext = context;
    await initRenderers();
    WaitingAccessDialog(context).show();
    wsMessageService.sendAskPermissionCmd(teacherClassroomItem.teacherClassroomId!);
  }

  Future<void> initRenderers() async {
    await localStreamRenderer.value.initialize();
    await remoteStreamRenderer.value.initialize();

    localStream = await webrtc.navigator.mediaDevices.getUserMedia(MyMediaConstraints.MEDIA_CONSTRAINTS);
    // 螢幕分享
    // await navigator.mediaDevices.getDisplayMedia(MyMediaConstraints.MEDIA_CONSTRAINTS):
    localStreamRenderer.value.srcObject = localStream;
    localStreamRenderer.value = localStreamRenderer.value;// 讓obx detect到
  }

  void listenAndProcessMsg()  {
    webSocketChannel.stream.listen((message) {
      // utf8.encode -> string to List<int>
      var messageJson = json.decode(message);
      processMsg(messageJson);
    });
  }

  Future<void> checkResultAndStartPc(dynamic message) async {
    if(message["message"] == "join class success") {
      ToastService.showSuccess(message["message"]);
      Navigator.of(currentContext).pop();
      startPcConnection(message);
    } else {
      ToastService.showAlert(message["message"]);
      Navigator.of(currentContext).pop();
      Navigator.of(currentContext).pop();
    }
  }

  Future<void> startPcConnection(dynamic msg) async {
    pc = await webrtc.createPeerConnection(iceServers, MyMediaConstraints.PC_CONSTRAINTS);

    pc!.onIceCandidate = (candidate) {
      wsMessageService.sendCandidateCmd(candidate, msg, teacherClassroomItem.teacherClassroomId!);
    };

    pc!.onConnectionState = (connectionState) {
      // !!嘗試連線中的 fail 也會被算在內
      if(connectionState == webrtc.RTCPeerConnectionState.RTCPeerConnectionStateDisconnected ||
          connectionState == webrtc.RTCPeerConnectionState.RTCPeerConnectionStateClosed ||
          connectionState == webrtc.RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
        // print("[peer connection] connection state: " + connectionState.name);
        // PcDisconnectDialog(currentContext).show();
      }
    };

    localStream = await webrtc.navigator.mediaDevices.getUserMedia(MyMediaConstraints.MEDIA_CONSTRAINTS);
    localStreamRenderer.value.srcObject = localStream;
    localStreamRenderer.value = localStreamRenderer.value;
    localStream.getTracks().forEach((track) async {
      pc!.addTrack(track, localStream);
    });
    // pc!.addStream(localStream!);
    pc!.onAddStream = (stream) {
      print("[peer connection] on add stream");
      remoteStreamRenderer.value.srcObject = stream;
      remoteStreamRenderer.value = remoteStreamRenderer.value;
    };

    webrtc.RTCSessionDescription localSdp = await pc!.createOffer(MyMediaConstraints.SDP_CONSTRAINTS);
    await pc!.setLocalDescription(localSdp);
    wsMessageService.sendOfferCmd(msg, localSdp, teacherClassroomItem.teacherClassroomId!);

    remoteIsReady = true;
    for (var candidate in iceCandidateList) {
      await pc!.addCandidate(candidate);
    }
  }

  Future<void> startClass(dynamic message) async {
    Map classInfo = json.decode(message["message"]);
    classId = classInfo["classId"];
    DateTime startTime = DateTime.parse(message["time"]);
    timerBackgroundColor.value = primaryDefault;
    classTimer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      DateTime now = DateTime.now();
      Duration classTime = now.difference(startTime);
      NumberFormat formatter = NumberFormat("00");
      timerMin.value = formatter.format(teacherClassroomItem!.classTime! - classTime.inMinutes - 1);
      timerSec.value = formatter.format(60 - (classTime.inSeconds % 60));
    });
  }

  Future<void> finishClass(dynamic message) async {
    classTimer.cancel();
    timerSec.value = "00";
    timerMin.value = "00";
    Toast.show("課程結束", backgroundColor: Colors.green[300]!);
  }

  Future<void> leaveClassroom() async {
    wsMessageService.sendLeaveRoomCmd(teacherClassroomItem.teacherClassroomId!);
  }

  void processMsg(dynamic messageJson) async {
    switch (messageJson['cmd']) {
      case "answer":
        wsMessageService.onAnswerCmd(messageJson, pc);
        break;
      case "candidate":
        wsMessageService.onCandidateCmd(messageJson, pc, remoteIsReady, iceCandidateList);
        break;
      case "accept":
        wsMessageService.onAcceptCmd(messageJson, teacherClassroomItem.teacherClassroomId!);
        break;
      case "reject":
        Navigator.of(currentContext).pop();
        RejectDialog(currentContext).show();
        break;
      case "instant message":
        break;
      case "join room":
        checkResultAndStartPc(messageJson);
        break;
      case "ask acception":
        // AskClassAcceptionDialog(currentContext, messageJson, Mess, teacherClassroomItem.teacherClassroomId!);
        break;
      case "pay fail":
        Toast.show(messageJson["message"], backgroundColor: Colors.red[300]!);
        print(messageJson);
        break;
      case "pay success":
        Toast.show("付款成功", backgroundColor: Colors.green[300]!);
        break;
      case "start class":
        startClass(messageJson);
        break;
      case "finish class":
        finishClass(messageJson);
        break;
      case "close room":
        Get.back();
        break;
      case "unexpect error":
        Toast.show("unExpect error", backgroundColor: Colors.red[300]!);
        break;
      default:
        break;
    }
  }
}