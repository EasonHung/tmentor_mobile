class ChatroomItem {
  String? conversationId;
  String? avatarUrl;
  String? nickname;
  String? unReadedCount;
  int? type;
  String? remoteId;
  String? lastMessage;
  String? lastMessageTime;

  ChatroomItem(String conversationId, String avatarUrl, String nickname, String unReadedCount, int type, String remoteId, String lastMessage, String lastMessageTime) {
    this.conversationId = conversationId;
    this.unReadedCount = unReadedCount;
    this.avatarUrl = avatarUrl;
    this.nickname = nickname;
    this.type = type;
    this.remoteId = remoteId;
    this.lastMessage = lastMessage;
    this.lastMessageTime = lastMessageTime;
  }

  Map toJson() => {
    'conversationId': conversationId,
    'avatarUrl': avatarUrl,
    "nickname": nickname,
    "unReadedCount": unReadedCount,
    "type": type,
    "remoteId": remoteId,
    "lastMessage": lastMessage,
    "lastMessageTime": lastMessageTime
  };

  // factory ChatroomItem.fromJson(Map<String, dynamic> json) {
  //   return ChatroomItem(json["classroomId"], json["teacherId"], json["subject"]);
  // }
}