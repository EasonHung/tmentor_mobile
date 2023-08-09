import 'package:objectbox/objectbox.dart';

import '../../main.dart';
import '../../objectbox.g.dart';

@Entity()
class ChatMessageContent {
  int? id;

  String? ownerId;

  String? messageId;

  String? conversationId;

  String? messageText;

  String? senderId;

  String? time;

  String? userId;

  int? cmd;

  String? url;

  ChatMessageContent(this.id, this.ownerId, this.messageId, this.conversationId, this.messageText, this.senderId,
      this.time, this.userId, this.cmd, this.url);

  static ChatMessageContent NewContentFromMessage(dynamic message, String userId) {
    return ChatMessageContent(
        null,
        userId,
        message['messageId'],
        message['conversationId'],
        message['message'],
        message['senderId'],
        message['time'],
        userId,
        message['cmd'],
        message['url']);
  }
}

class ChatMessageContentDao {
  static Future<void> insert(Store store, ChatMessageContent object) async {
    print("insert messageId: " + object.messageId!);
    final box = store.box<ChatMessageContent>();

    box.put(object);
  }

  static Future<List<ChatMessageContent>> findAll(Store store) async {
    final box = store.box<ChatMessageContent>();
    List<ChatMessageContent> result = box.getAll();

    return result;
  }

  static List<ChatMessageContent> findUnReadByConversationId(
      Store store, String ownerId, String conversationId, String userId) {
    final box = store.box<ChatMessageContent>();

    return box
        .query(ChatMessageContent_.conversationId
            .equals(conversationId)
            .and(ChatMessageContent_.ownerId.equals(ownerId))
            .and(ChatMessageContent_.cmd.equals(0))
            .and(ChatMessageContent_.senderId.equals(userId)))
        .build()
        .find();
  }

  static Future<List<ChatMessageContent>?> findLast(
      String ownerId, String conversationId, int limit) async {
    final builder = store?.box<ChatMessageContent>().query(
        ChatMessageContent_.conversationId.equals(conversationId).and(ChatMessageContent_.ownerId.equals(ownerId)))
        .order(ChatMessageContent_.messageId, flags: Order.descending);
    final query = builder?.build();

    query?.limit = limit;

    return query?.find();
  }

  static ChatMessageContent? findLastOne(
      String ownerId, String conversationId) {
    final builder = store?.box<ChatMessageContent>().query(
        ChatMessageContent_.conversationId.equals(conversationId).and(ChatMessageContent_.ownerId.equals(ownerId)))
        .order(ChatMessageContent_.messageId, flags: Order.descending);
    final query = builder?.build();

    query?.limit = 1;

    return query?.findFirst();
  }

  static String? findLastMessageIdWithLimit(
      String ownerId, String conversationId, int limit) {
    final builder = store?.box<ChatMessageContent>().query(
        ChatMessageContent_.conversationId.equals(conversationId).and(ChatMessageContent_.ownerId.equals(ownerId)))
      .order(ChatMessageContent_.messageId, flags: Order.descending);
    final query = builder?.build();

    query?.limit = limit;

    List<ChatMessageContent>? messageList = query?.find();
    if(messageList == null || messageList.length < limit) {
      return "";
    }

    return query?.find().last.messageId;
  }

  static String? findLastMessageIdBeforeMessageWithLimit(String ownerId, String conversationId, String messageId, int limit) {
    final builder = store?.box<ChatMessageContent>().query(
        ChatMessageContent_.conversationId.equals(conversationId).and(ChatMessageContent_.ownerId.equals(ownerId))
            .and(ChatMessageContent_.messageId.lessThan(messageId)))
        .order(ChatMessageContent_.messageId, flags: Order.descending);
    final query = builder?.build();

    query?.limit = limit;

    List<ChatMessageContent>? messageList = query?.find();
    if(messageList == null || messageList.length == 0) {
      return "";
    }

    return query?.find().last.messageId;
  }

  static List<ChatMessageContent> findBeforeMessageId(
      Store store, String ownerId, String conversationId, String messageId, int limit) {
    final builder = store.box<ChatMessageContent>().query(ChatMessageContent_.conversationId
        .equals(conversationId)
        .and(ChatMessageContent_.ownerId.equals(ownerId))
        .and(ChatMessageContent_.messageId.lessThan(messageId)))
      ..order(ChatMessageContent_.messageId, flags: Order.descending);
    final query = builder.build();

    query..limit = limit;

    return query.find();
  }

  static ChatMessageContent? findByMessageId(Store store, String ownerId, String messageId) {
    final box = store.box<ChatMessageContent>();
    ChatMessageContent? result = box
        .query(ChatMessageContent_.messageId.equals(messageId).and(ChatMessageContent_.ownerId.equals(ownerId)))
        .build()
        .findUnique();

    return result;
  }

  static Future<void> insertNewOrUpdateCmd(Store store, ChatMessageContent object) async {
    final box = store.box<ChatMessageContent>();
    ChatMessageContent? result = box.query(
        ChatMessageContent_.messageId.equals(object.messageId!)
            .and(ChatMessageContent_.ownerId.equals(object.ownerId!))
    ).build().findUnique();
    if(result != null) {
      result.cmd = object.cmd;
      print("update messageId: " + result.messageId!);
      // 若id相同則為update
      box.put(result);
      return;
    }

    print("upsert messageId: " + object.messageId!);
    box.put(object);
  }

  static List<ChatMessageContent>? findAfterMessageId(String conversationId, String userId, String? messageId) {
    if(messageId == null) {
      return [];
    }

    return store?.box<ChatMessageContent>().query(ChatMessageContent_.conversationId
        .equals(conversationId)
        .and(ChatMessageContent_.ownerId.equals(userId))
        .and(ChatMessageContent_.messageId.greaterThan(messageId)))
        .order(ChatMessageContent_.messageId, flags: Order.descending).build().find();
  }

  static Stream<Query<ChatMessageContent>>? getChatroomContentStream(String conversationId, String userId, String messageId) {
    return store?.box<ChatMessageContent>().query(ChatMessageContent_.conversationId
        .equals(conversationId)
        .and(ChatMessageContent_.ownerId.equals(userId))
        .and(ChatMessageContent_.messageId.greaterThan(messageId)))
      .order(ChatMessageContent_.messageId, flags: Order.descending)
      .watch();
  }
}
