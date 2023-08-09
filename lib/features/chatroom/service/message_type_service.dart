import '../constants/chatroom_cmd.dart';

class MessageTypeService {
  String userId;

  MessageTypeService(this.userId);

  bool isSimpleMessage(int cmd) {
    return cmd == ChatroomCmd.SIMPLE_MESSAGE;
  }

  bool isSelfSimpleMessage(int cmd, String senderId) {
    return cmd == ChatroomCmd.SIMPLE_MESSAGE && senderId == userId;
  }

  bool isOtherSimpleMessage(int cmd, String senderId) {
    return cmd == ChatroomCmd.SIMPLE_MESSAGE && senderId != userId;
  }

  bool isOthersReadMessage(int cmd, String senderId) {
    return cmd == ChatroomCmd.READED_MESSAGE && senderId != userId;
  }

  bool isSelfReadMessage(int cmd, String senderId) {
    return cmd == ChatroomCmd.READED_MESSAGE && senderId == userId;
  }

  bool isClassInfoMessage(int cmd) {
    return cmd == ChatroomCmd.CLASS_INFO;
  }

  bool isHeartbeatMessage(int cmd) {
    return cmd == ChatroomCmd.HEART_BEAT;
  }
}