import 'package:get/get.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/controller/teacher_classroom_media_controller.dart';

import '../../../../../service/toast_service.dart';
import '../constraints.dart';
import '../service/teacher_classroom_message_service.dart';

class TeacherClassroomWebrtcController extends GetxController {
  String teacherClassroomId;
  TeacherClassroomMessageService messageService;
  TeacherClassroomMediaController teacherClassroomMediaController = Get.find<TeacherClassroomMediaController>();
  webrtc.RTCPeerConnection? pc;
  bool remoteIsReady = false;
  bool pcOpened = false;
  String remoteId = "";
  List<webrtc.RTCIceCandidate> candidateList = [];
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

  TeacherClassroomWebrtcController(this.messageService, this.teacherClassroomId);

  @override
  void onClose() {
    pc?.close();
    pc = null;
    remoteIsReady = false;
    candidateList = [];
    super.onClose();
  }

  void onAnswer(dynamic message) {
    var description = message["message"];
    pc!.setRemoteDescription(webrtc.RTCSessionDescription(description['sdp'], description['type']));
  }

  Future<void> addICECandidate(webrtc.RTCIceCandidate candidate) async {
    if (pc != null && remoteIsReady) {
      await pc?.addCandidate(candidate);
    } else {
      candidateList.add(candidate);
    }
  }

  Future<void> startPcConnection(dynamic msg) async {
    pc = await webrtc.createPeerConnection(iceServers, MyMediaConstraints.PC_CONSTRAINTS);

    pc!.onIceCandidate = (candidate) {
      messageService.sendCandidateCmd(candidate, msg, teacherClassroomId);
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

    teacherClassroomMediaController.getLocalStreamTracks()?.forEach((track) async {
      pc!.addTrack(track, teacherClassroomMediaController.localStream!);
    });

    pc!.onAddStream = (stream) {
      print("[peer connection] on add stream");
      teacherClassroomMediaController.startRemoteMedia(stream);
    };

    webrtc.RTCSessionDescription localSdp = await pc!.createOffer(MyMediaConstraints.SDP_CONSTRAINTS);
    await pc!.setLocalDescription(localSdp);
    messageService.sendOfferCmd(msg, localSdp, teacherClassroomId);

    remoteIsReady = true;
    for (var candidate in candidateList) {
      await pc!.addCandidate(candidate);
    }
  }

  Future<void> screenSharing() async {
    if(pc == null) {
      ToastService.showAlert("連線尚未開始，無法分享螢幕");
      return;
    }

    List<webrtc.RTCRtpSender> senderList = await pc!.getSenders();
    List<webrtc.MediaStreamTrack>? mediaStreamTrackList = await teacherClassroomMediaController.onScreenSharing();
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
    List<webrtc.MediaStreamTrack>? mediaStreamTrackList = await teacherClassroomMediaController.onStopScreenSharing()!;
    mediaStreamTrackList?.forEach((mediaStreamTrack) {
      senderList.forEach((sender) {
        if(sender.track?.kind == mediaStreamTrack.kind) {
          sender.replaceTrack(mediaStreamTrack);
        }
      });
    });
  }
}