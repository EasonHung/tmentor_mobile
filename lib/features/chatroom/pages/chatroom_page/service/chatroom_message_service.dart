import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

class ChatroomMessageService {
  final StreamController<dynamic> messageQueue = StreamController<dynamic>();

  void closeMessageQueue() {
    messageQueue.close();
  }

  void sendReadMessage(String userId, String messageId, String conversationId, String remoteId) {
    print("send read message, conversationId: " + conversationId);
    print("messageId: " + messageId);
    messageQueue.sink.add(
        json.encode({
          "cmd": 1,
          "senderId": userId,
          "conversationId": conversationId,
          "recieverId": remoteId,
          "messageId": messageId
        }).codeUnits
    );
  }

  void sendSimpleMessage(String userId, String message, String conversationId, String remoteId) {
    messageQueue.sink.add(
        json.encode({
          "cmd": 0,
          "senderId": userId,
          "conversationId": conversationId,
          "recieverId": remoteId,
          "message": String.fromCharCodes(Uint8List.fromList(utf8.encode(message)))
        }).codeUnits
    );
  }

  void sendClassroomInvitationMessage(String userId, String remoteId, String conversationId) {
    messageQueue.sink.add(
        json.encode({
          "cmd": 4,
          "senderId": userId,
          "conversationId": conversationId,
          "recieverId": remoteId,
          "message": String.fromCharCodes(Uint8List.fromList(utf8.encode("教室邀請")))
        }).codeUnits
    );
  }

  void sendHeartBeatMessage(String userId) {
    messageQueue.sink.add(
        json.encode({
          "cmd": 5,
          "messageId": "",
          "senderId": userId,
          "conversationId": "",
          "recieverId": "",
          "message": "ping"
        }).codeUnits
    );
  }
}