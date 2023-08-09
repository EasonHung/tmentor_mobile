import 'dart:async';
import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../../../apiManager/classroomApiManager.dart';
import '../../../../../sharedPrefs/userPrefs.dart';
import '../../../../../vo/class_setting_info.dart';

class MyClassroomMessageService {
  StreamController<dynamic> messageQueue = StreamController<dynamic>();

  void closeMessageQueue() {
    messageQueue.close();
  }

  Future<void> sendRejectCmd(String receiverId, String receiverApplicationType) async {
    String? userId = await UserPrefs.getUserId();
    String classroomId = await classroomApiManager.getClassroomId(userId!);
    messageQueue.sink.add(json.encode({
      "cmd": "reject",
      "senderId": userId,
      "recieverId": receiverId,
      "receiverApplicationType": receiverApplicationType,
      "classroomId": classroomId,
    }).codeUnits);
  }

  Future<void> sendAcceptCmd(String receiverId, String receiverApplicationType) async {
    String? userId = await UserPrefs.getUserId();
    String classroomId = await classroomApiManager.getClassroomId(userId!);
    messageQueue.sink.add(json.encode({
      "cmd": "accept",
      "senderId": userId,
      "applicationType": "app",
      "recieverId": receiverId,
      "receiverApplicationType": receiverApplicationType,
      "classroomId": classroomId,
    }).codeUnits);
  }

  Future<void> sendCandidateCmd(RTCIceCandidate candidate, dynamic msg, String classroomId) async {
    String? userId = await UserPrefs.getUserId();
    messageQueue.sink.add(json.encode({
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
    messageQueue.sink.add(json.encode({
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

  Future<void> sendClassRequestCmd(String classId, String classroomId, String studentId) async {
    String? userId = await UserPrefs.getUserId();
    messageQueue.sink.add(json.encode({
      "cmd": "ask acceptance",
      "senderId": userId,
      "applicationType": "app",
      "recieverId": studentId,
      "classroomId": classroomId,
      "message": classId
    }).codeUnits);
  }

  Future<void> sendClockOnCmd(String clockOnReqString) async {
    String? userId = await UserPrefs.getUserId();

    messageQueue.sink.add(json.encode({
      "cmd": "clock on",
      "senderId": userId,
      "applicationType": "app",
      "recieverId": "",
      "receiverApplicationType": "",
      "classroomId": "",
      "message": clockOnReqString
    }).codeUnits);
  }

  Future<void> sendFinishClassCmd(String classId) async {
    String? userId = await UserPrefs.getUserId();
    String classroomId = await classroomApiManager.getClassroomId(userId!);

    messageQueue.sink.add(json.encode({
      "cmd": "finish class",
      "senderId": userId,
      "applicationType": "app",
      "classroomId": classroomId,
      "message": classId
    }).codeUnits);
  }

  Future<String> sendOpenRoomCmd(ClassSettingInfo classSettingInfo) async {
    String? userId = await UserPrefs.getUserId();
    String classroomId = await classroomApiManager.getClassroomId(userId!);
    messageQueue.sink.add(json.encode({
      "cmd": "open room",
      "senderId": userId,
      "applicationType": "app",
      "classroomId": classroomId,
      "message": jsonEncode(classSettingInfo)
    }));
    return classroomId;
  }

  Future<void> sendCloseRoomCmd() async {
    String? userId = await UserPrefs.getUserId();
    String classroomId = await classroomApiManager.getClassroomId(userId!);
    messageQueue.sink.add(json.encode({
      "cmd": "close room",
      "senderId": userId,
      "applicationType": "app",
      "classroomId": classroomId,
      "message": jsonEncode("")
    }).codeUnits);
  }
}