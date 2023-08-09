import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:mentor_app_flutter/service/toast_service.dart';
import 'package:toast/toast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mentor_app_flutter/features/classroom/service/ws_message_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../color_constants.dart';
import '../../../config/server_url.dart';
import '../../../sharedPrefs/userPrefs.dart';
import '../../../vo/class_setting_info.dart';
import '../pages/my_classroom_page/constraints.dart';

class MyClassroomController extends GetxController {
  Rx<bool> showBottomBtns = true.obs;
  webrtc.RTCPeerConnection? pc;
  String remoteId = "";
  late String remoteApplicationType;
  late String classroomId;
  String classId = "";
  late ClassSettingInfo classSettingInfo;
  bool pcOpened = false;
  late BuildContext currentContext;
  late WebSocketChannel webSocketChannel;
  late WsMessageService wsMessageService;
  webrtc.MediaStream? localStream;
  Rx<webrtc.RTCVideoRenderer> localStreamRenderer = webrtc.RTCVideoRenderer().obs;
  Rx<bool> showRemoteVideo = false.obs;
  Rx<webrtc.RTCVideoRenderer> remoteStreamRenderer = webrtc.RTCVideoRenderer().obs;
  late Timer heartbeatTimer;
  late Timer classTimer;
  Rx<Color> timerBackgroundColor = Colors.grey.obs;
  Rx<String> timerMin = "00".obs;
  Rx<String> timerSec = "00".obs;
  bool remoteIsReady = false;
  List<webrtc.RTCIceCandidate> iceCandidateList = [];
  final Map<String, dynamic> iceServers = {
    'iceServers': [
      // {'url': 'stun:stun.l.google.com:19302'},
      {
        "url": "turn:relay1.expressturn.com:3478",
        "username": "efC2OT8W129D2ID63H",
        "credential": "6ZeChztFE4cxEmgg",
      },
    ]
  };

  MyClassroomController();

  @override
  void onClose() {
    debugPrint("close myclassroom controller");
    heartbeatTimer.cancel();
    webSocketChannel.sink.close();
    localStreamRenderer.value.srcObject = null;
    localStreamRenderer.value.dispose();
    remoteStreamRenderer.value.srcObject = null;
    remoteStreamRenderer.value.dispose();
    localStream?.dispose();
    clearPc();
    super.onClose();
  }

  void clearPc() {
    pc?.close();
    pc = null;
    remoteIsReady = false;
    iceCandidateList = [];
  }

  void onLeaveRoom() {
    showRemoteVideo.value = false;
    remoteStreamRenderer.value.srcObject = null;
    clearPc();
  }

  Future<void> initClassroom() async {
    String? userId = await UserPrefs.getUserId();
    webSocketChannel = WebSocketChannel.connect(Uri.parse(EnvSetting.CLASSROOM_WEBSOCKET_IP +
        '/?userId=' + userId! + '&applicationType=app'));
    wsMessageService = WsMessageService(webSocketChannel);
    listenAndProcessMsg();
    await initRenderers();
    classroomId = await wsMessageService.sendOpenRoomCmd(classSettingInfo);
    startHeartbeat();
  }

  Future<void> initRenderers() async {
    await localStreamRenderer.value.initialize();
    await remoteStreamRenderer.value.initialize();

    if(localStream == null) {
      localStream = await webrtc.navigator.mediaDevices.getUserMedia(MyMediaConstraints.MEDIA_CONSTRAINTS);
    }

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

  void processMsg(dynamic msg) {
    switch (msg['cmd']) {
      case "open room":
        ToastService.showSuccess("open success");
        break;
      case "ask":
        remoteApplicationType = msg["applicationType"];
        remoteId = msg["senderId"];
        // AskPermissionDialog().show(msg, currentContext, webSocketChannel);
        break;
      case "leave room":
        onLeaveRoom();
        break;
      case "instant message":
        break;
      case "offer":
        initRenderers();
        startPeerConnection(msg);
        break;
      case "candidate":
        wsMessageService.onCandidateCmd(msg, pc, remoteIsReady, iceCandidateList);
        break;
      case "last class info":
        wsMessageService.onLastClassInfoCmd(msg, classSettingInfo, remoteId, remoteApplicationType, classroomId);
        break;
      case "pay success":
        Toast.show("付款成功", backgroundColor: Colors.green[300]!);
        break;
      case "start class":
        startClass(msg);
        break;
      case "finish class":
        finishClass(msg);
        break;
      case "unexpect error":
        ToastService.showAlert(msg['message']);
        break;
    }
  }

  void getLastClassInfoCmd() {
    if(remoteId == "") {
      Toast.show("沒學生在教室中", backgroundColor: Colors.red[300]!);
      return;
    }

    wsMessageService.sendGetLastClassInfoCmd(remoteId);
  }

  void sendFinishClassMessage() {
    if(classId != "") {
      wsMessageService.sendFinishClassCmd(classId, classroomId);
    }
    wsMessageService.sendCloseRoomCmd(classroomId);
  }

  Future<void> startPeerConnection(dynamic message) async {
    pc = await webrtc.createPeerConnection(iceServers, MyMediaConstraints.PC_CONSTRAINTS);
    pc!.onConnectionState = (connectionState) {
      if(pcOpened && (connectionState == webrtc.RTCPeerConnectionState.RTCPeerConnectionStateDisconnected ||
          connectionState == webrtc.RTCPeerConnectionState.RTCPeerConnectionStateClosed ||
          connectionState == webrtc.RTCPeerConnectionState.RTCPeerConnectionStateFailed)) {
        pcOpened = false;
        remoteId = "";
        closePeerConnection();
      }

      if(connectionState == webrtc.RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        print("[peer connection] connected!!");
        remoteId = message["senderId"];
        pcOpened = true;
      }
    };

    localStream?.getTracks().forEach((track) async {
      pc!.addTrack(track, localStream!);
    });
    pc!.onAddStream = (stream) {
      print("[peer connection] on add stream");
      showRemoteVideo.value = true;
      remoteStreamRenderer.value.srcObject = stream;
      remoteStreamRenderer.value = remoteStreamRenderer.value;
    };

    // set remote sdp
    var description = message["message"];
    await pc!.setRemoteDescription(webrtc.RTCSessionDescription(description['sdp'], description['type']));
    webrtc.RTCSessionDescription localSdp = await pc!.createAnswer(MyMediaConstraints.SDP_CONSTRAINTS);
    pc!.onIceCandidate = (candidate) {
      wsMessageService.sendCandidateCmd(candidate, message, classroomId);
    };
    await pc!.setLocalDescription(localSdp);

    remoteIsReady = true;
    for (var candidate in iceCandidateList) {
      await pc!.addCandidate(candidate);
    }

    // send answer sdp
    wsMessageService.sendAnswerCmd(message, localSdp, classroomId);
  }

  Future<void> startClass(dynamic msg) async {
    Map classInfo = json.decode(msg["message"]);
    classId = classInfo["classId"];
    DateTime startTime = DateTime.parse(msg["time"]);
    timerBackgroundColor.value = primaryDefault;
    classTimer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      DateTime now = DateTime.now();
      Duration classTime = now.difference(startTime);
      NumberFormat formatter = NumberFormat("00");

      timerMin.value = formatter.format(classSettingInfo.classTime - classTime.inMinutes - 1);
      timerSec.value = formatter.format(60 - (classTime.inSeconds % 60));
    });
  }

  void startHeartbeat() {
    heartbeatTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      wsMessageService.sendHeartbeat();
      print("[classroom] ping");
    });
  }

  Future<void> finishClass(dynamic msg) async {
    classTimer.cancel();
    timerSec.value = "00";
    timerMin.value = "00";
    Toast.show("課程結束", backgroundColor: Colors.green[300]!);
  }

  void closePeerConnection() {
    if(pc != null) {
      pc = null;
    }

    if (remoteStreamRenderer != null) {
      remoteStreamRenderer.value.srcObject = null;
    }
  }
}