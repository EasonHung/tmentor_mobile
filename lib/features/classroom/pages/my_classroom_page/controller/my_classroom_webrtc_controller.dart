import 'package:get/get.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:mentor_app_flutter/service/toast_service.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';

import '../../../../../apiManager/classroomApiManager.dart';
import '../constraints.dart';
import '../service/my_classroom_message_service.dart';
import 'my_classroom_media_controller.dart';

class MyClassroomWebrtcController extends GetxController {
  MyClassroomMediaController myClassroomMediaController = Get.find<MyClassroomMediaController>();
  MyClassroomMessageService messageService;
  webrtc.RTCPeerConnection? pc;
  bool remoteIsReady = false;
  bool pcOpened = false;
  String remoteId = "";
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

  MyClassroomWebrtcController(this.messageService);

  @override
  void onClose() {
    clearPc();
    super.onClose();
  }

  void clearPc() {
    pc?.close();
    pc = null;
    remoteIsReady = false;
    iceCandidateList = [];
  }

  void closePeerConnection() {
    if(pc != null) {
      pc = null;
    }
    myClassroomMediaController.closeRemoteMedia();
  }

  Future<void> startPeerConnection(dynamic message) async {
    String? userId = await UserPrefs.getUserId();
    String classroomId = await classroomApiManager.getClassroomId(userId!);
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

    myClassroomMediaController.getLocalStreamTracks()?.forEach((track) async {
      pc!.addTrack(track, myClassroomMediaController.localStream!);
    });
    pc!.onAddStream = (stream) {
      print("[peer connection] on add stream");
      myClassroomMediaController.startRemoteVideo(stream);
    };

    // set remote sdp
    var description = message["message"];
    await pc!.setRemoteDescription(webrtc.RTCSessionDescription(description['sdp'], description['type']));
    webrtc.RTCSessionDescription localSdp = await pc!.createAnswer(MyMediaConstraints.SDP_CONSTRAINTS);
    pc!.onIceCandidate = (candidate) {
      messageService.sendCandidateCmd(candidate, message, classroomId);
    };
    await pc!.setLocalDescription(localSdp);

    remoteIsReady = true;
    for (var candidate in iceCandidateList) {
      await pc!.addCandidate(candidate);
    }

    // send answer sdp
    messageService.sendAnswerCmd(message, localSdp, classroomId);
  }

  Future<void> addICECandidate(webrtc.RTCIceCandidate candidate) async {
    if (pc != null && remoteIsReady) {
      await pc!.addCandidate(candidate);
    } else {
      iceCandidateList.add(candidate);
    }
  }

  Future<void> screenSharing() async {
    if(pc == null) {
      ToastService.showAlert("連線尚未開始，無法分享螢幕");
      return;
    }

    List<webrtc.RTCRtpSender> senderList = await pc!.getSenders();
    List<webrtc.MediaStreamTrack>? mediaStreamTrackList = await myClassroomMediaController.onScreenSharing();
    mediaStreamTrackList?.forEach((mediaStreamTrack) {
      senderList.forEach((sender) {
        if(sender.track?.kind == mediaStreamTrack.kind) {
          sender.replaceTrack(mediaStreamTrack);
        }
      });
    });
  }

  Future<void> stopScreenSharing() async {
    if(pc == null) {
      return;
    }

    List<webrtc.RTCRtpSender> senderList = await pc!.getSenders();
    List<webrtc.MediaStreamTrack>? mediaStreamTrackList = await myClassroomMediaController.onStopScreenSharing()!;
    mediaStreamTrackList?.forEach((mediaStreamTrack) {
      senderList.forEach((sender) {
        if(sender.track?.kind == mediaStreamTrack.kind) {
          sender.replaceTrack(mediaStreamTrack);
        }
      });
    });
  }
}