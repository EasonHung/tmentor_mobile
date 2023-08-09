import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';
import 'package:mentor_app_flutter/vo/class_setting_info.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../apiManager/classroomApiManager.dart';

class WsMessageService {
  WebSocketChannel webSocketChannel;

  WsMessageService(this.webSocketChannel);

  Future<void> sendHeartbeat() async {
    String? userId = await UserPrefs.getUserId();
    webSocketChannel.sink.add(json.encode({
      "cmd": "ping",
      "senderId": userId,
      "applicationType": "app",
      "message": jsonEncode("")
    }));
  }

  Future<void> sendCandidateCmd(RTCIceCandidate candidate, dynamic msg, String classroomId) async {
    String? userId = await UserPrefs.getUserId();
    webSocketChannel.sink.add(json.encode({
      "cmd": "candidate",
      "senderId": userId,
      "applicationType": "app",
      "recieverId": msg["senderId"],
      "classroomId": classroomId,
      "message": {
        'sdpMLineIndex': candidate.sdpMLineIndex,
        'sdpMid': candidate.sdpMid,
        'candidate': candidate.candidate,
      }
    }).codeUnits);
  }

  Future<void> sendAnswerCmd(dynamic message, RTCSessionDescription localSdp, String classroomId) async {
    String? userId = await UserPrefs.getUserId();
    webSocketChannel.sink.add(json.encode({
      "cmd": "answer",
      "senderId": userId,
      "applicationType": "app",
      "recieverId": message["senderId"],
      "classroomId": classroomId,
      "message": {
        'sdp': localSdp.sdp,
        'type': localSdp.type,
      }
    }).codeUnits);
  }

  Future<String> sendOpenRoomCmd(ClassSettingInfo classSettingInfo) async {
    String? userId = await UserPrefs.getUserId();
    String classroomId = await classroomApiManager.getClassroomId(userId!);
    webSocketChannel.sink.add(json.encode({
      "cmd": "open room",
      "senderId": userId,
      "applicationType": "app",
      "classroomId": classroomId,
      "message": jsonEncode(classSettingInfo)
    }));
    return classroomId;
  }

  Future<void> sendCloseRoomCmd(String classroomId) async {
    String? userId = await UserPrefs.getUserId();
    webSocketChannel.sink.add(json.encode({
      "cmd": "close room",
      "senderId": userId,
      "applicationType": "app",
      "classroomId": classroomId,
      "message": jsonEncode("")
    }));
  }

  Future<void> onCandidateCmd(
      dynamic msg, RTCPeerConnection? pc, bool remoteIsReady, List<RTCIceCandidate> candidateList) async {
    // add candidate to peer connection or add to buffer if not init yet.
    var candidateMap = msg["message"];
    var sdpMLineIndex;

    if (candidateMap['sdpMLineIndex'] == null) {
      sdpMLineIndex = 0;
    } else {
      sdpMLineIndex = candidateMap['sdpMLineIndex'];
    }
    RTCIceCandidate candidate = RTCIceCandidate(candidateMap['candidate'], candidateMap['sdpMid'], sdpMLineIndex);

    if (pc != null && remoteIsReady) {
      await pc.addCandidate(candidate);
    } else {
      candidateList.add(candidate);
    }
  }

  Future<void> onLastClassInfoCmd(dynamic msg, ClassSettingInfo classSettingInfo, String remoteId,
      String remoteApplicationType, String classroomId) async {
    String? userId = await UserPrefs.getUserId();
    String classInfo = json.encode({"classTime": classSettingInfo.classTime, "points": classSettingInfo.classPoints});
    webSocketChannel.sink.add(json.encode({
      "cmd": "init class",
      "senderId": userId,
      "applicationType": "app",
      "recieverId": remoteId,
      "receiverApplicationType": remoteApplicationType,
      "classroomId": classroomId,
      "message": classInfo
    }).codeUnits);
  }

  Future<void> sendRejectCmd(String recieverId, String receiverApplicationType) async {
    String? userId = await UserPrefs.getUserId();
    String classroomId = await classroomApiManager.getClassroomId(userId!);
    webSocketChannel.sink.add(json.encode({
      "cmd": "reject",
      "senderId": userId,
      "recieverId": recieverId,
      "receiverApplicationType": receiverApplicationType,
      "classroomId": classroomId,
    }).codeUnits);
  }

  Future<void> sendAcceptCmd(String recieverId, String receiverApplicationType) async {
    String? userId = await UserPrefs.getUserId();
    String classroomId = await classroomApiManager.getClassroomId(userId!);
    webSocketChannel.sink.add(json.encode({
      "cmd": "accept",
      "senderId": userId,
      "applicationType": "app",
      "recieverId": recieverId,
      "receiverApplicationType": receiverApplicationType,
      "classroomId": classroomId,
    }).codeUnits);
  }

  Future<void> sendGetLastClassInfoCmd(String remoteId) async {
    String? userId = await UserPrefs.getUserId();
    String classroomId = await classroomApiManager.getClassroomId(userId!);
    webSocketChannel.sink.add(json.encode({
      "cmd": "last class info",
      "senderId": userId,
      "applicationType": "app",
      "recieverId": remoteId,
      "classroomId": classroomId
    }).codeUnits);
  }

  Future<void> sendFinishClassCmd(String classId, String classroomId) async {
    String? userId = await UserPrefs.getUserId();
    String classInfo = json.encode({"classId": classId});

    webSocketChannel.sink.add(json.encode({
      "cmd": "finish class",
      "senderId": userId,
      "applicationType": "app",
      "classroomId": classroomId,
      "message": classInfo
    }).codeUnits);
  }

  Future<void> sendAskPermissionCmd(String classroomId) async {
    String? userId = await UserPrefs.getUserId();
    webSocketChannel.sink.add(json.encode({
      "cmd": "ask",
      "senderId": userId,
      "applicationType": "app",
      "classroomId": classroomId,
    }).codeUnits);
  }

  Future<void> onAnswerCmd(dynamic message, RTCPeerConnection? pc) async {
    // set remote sdp
    var description = message["message"];
    await pc!.setRemoteDescription(RTCSessionDescription(description['sdp'], description['type']));
  }

  Future<void> onAcceptCmd(dynamic message, String teacherClassroomId) async {
    if (message['classroomId'] == teacherClassroomId) {
      String classroomToken = message['message'];
      sendJoinRoomCmd(classroomToken, teacherClassroomId, message["senderId"]);
    }
  }

  Future<void> sendJoinRoomCmd(String classroomToken, String classroomId, String receiverId) async {
    String? userId = await UserPrefs.getUserId();
    webSocketChannel.sink.add(json.encode({
      "cmd": "join room",
      "senderId": userId,
      "applicationType": "app",
      "classroomId": classroomId,
      "recieverId": receiverId,
      "message": classroomToken,
    }).codeUnits);
  }

  Future<void> sendLeaveRoomCmd(String classroomId) async {
    String? userId = await UserPrefs.getUserId();
    webSocketChannel.sink.add(json.encode({
      "cmd": "leave room",
      "senderId": userId,
      "applicationType": "app",
      "classroomId": classroomId,
    }).codeUnits);
  }

  Future<void> sendOfferCmd(dynamic message, RTCSessionDescription localSdp, String teacherClassroomId) async {
    String? userId = await UserPrefs.getUserId();
    webSocketChannel.sink.add(json.encode({
      "cmd": "offer",
      "senderId": userId,
      "applicationType": "app",
      "recieverId": message["senderId"],
      "classroomId": teacherClassroomId,
      "message": {
        'sdp': localSdp.sdp,
        'type': localSdp.type,
      }
    }).codeUnits);
  }

  Future<void> sendAcceptClassCmd(dynamic message, String classroomId) async {
    String? userId = await UserPrefs.getUserId();
    webSocketChannel.sink.add(json.encode({
      "cmd": "accept class",
      "senderId": userId,
      "applicationType": "app",
      "recieverId": message["senderId"],
      "receiverApplicationType": message["applicationType"],
      "classroomId": classroomId,
      "message": message["message"]
    }).codeUnits);
  }
}
