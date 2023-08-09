import 'dart:async';
import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

import '../../../../../sharedPrefs/userPrefs.dart';

class TeacherClassroomMessageService {
  final StreamController<dynamic> messageQueue = StreamController<dynamic>();

  void closeMessageQueue() {
    messageQueue.close();
  }

  Future<void> sendJoinRoomCmd(String classroomToken, String classroomId, String receiverId) async {
    String? userId = await UserPrefs.getUserId();
    messageQueue.sink.add(json.encode({
      "cmd": "join room",
      "senderId": userId,
      "applicationType": "app",
      "classroomId": classroomId,
      "recieverId": receiverId,
      "message": classroomToken,
    }).codeUnits);
  }

  Future<void> sendCandidateCmd(webrtc.RTCIceCandidate candidate, dynamic msg, String classroomId) async {
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

  Future<void> sendOfferCmd(dynamic message, webrtc.RTCSessionDescription localSdp, String teacherClassroomId) async {
    String? userId = await UserPrefs.getUserId();
    messageQueue.sink.add(json.encode({
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

  Future<void> sendAcceptClassCmd(String classId, String classroomId, String mentorId) async {
    String? userId = await UserPrefs.getUserId();
    messageQueue.sink.add(json.encode({
      "cmd": "accept class",
      "senderId": userId,
      "applicationType": "app",
      "recieverId": mentorId,
      "receiverApplicationType": "",
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

  Future<void> sendFinishClassCmd(String classId, String classroomId) async {
    String? userId = await UserPrefs.getUserId();

    messageQueue.sink.add(json.encode({
      "cmd": "finish class",
      "senderId": userId,
      "applicationType": "app",
      "classroomId": classroomId,
      "message": classId
    }).codeUnits);
  }

  Future<void> sendLeaveRoomCmd(String classroomId) async {
    String? userId = await UserPrefs.getUserId();
    messageQueue.sink.add(json.encode({
      "cmd": "leave room",
      "senderId": userId,
      "applicationType": "app",
      "classroomId": classroomId,
    }).codeUnits);
  }

  Future<void> sendAskPermissionCmd(String classroomId) async {
    String? userId = await UserPrefs.getUserId();
    messageQueue.sink.add(json.encode({
      "cmd": "ask",
      "senderId": userId,
      "applicationType": "app",
      "classroomId": classroomId,
    }).codeUnits);
  }
}