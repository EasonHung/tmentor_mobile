// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'local_database/dao/chat_message_content.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 1015654493685379142),
      name: 'ChatMessageContent',
      lastPropertyId: const IdUid(10, 4120008707420522472),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 8558252496477302073),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 2030614862872265162),
            name: 'messageId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 3388520989466614527),
            name: 'conversationId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 6297653238890167488),
            name: 'messageText',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 5735234280313242026),
            name: 'senderId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 937154268402398377),
            name: 'time',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 7368154808013628448),
            name: 'userId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 1765929946706280387),
            name: 'cmd',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 3538352099839351740),
            name: 'ownerId',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 4120008707420522472),
            name: 'url',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(2, 6159371818969473721),
      lastIndexId: const IdUid(2, 2909497851396648998),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [6159371818969473721],
      retiredIndexUids: const [7783462084253323233],
      retiredPropertyUids: const [
        8896703485105436665,
        3479205744823618118,
        6720289476880394242,
        220946058499779902,
        6646754785586358071,
        5433455817500303596
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    ChatMessageContent: EntityDefinition<ChatMessageContent>(
        model: _entities[0],
        toOneRelations: (ChatMessageContent object) => [],
        toManyRelations: (ChatMessageContent object) => {},
        getId: (ChatMessageContent object) => object.id,
        setId: (ChatMessageContent object, int id) {
          object.id = id;
        },
        objectToFB: (ChatMessageContent object, fb.Builder fbb) {
          final messageIdOffset = object.messageId == null
              ? null
              : fbb.writeString(object.messageId!);
          final conversationIdOffset = object.conversationId == null
              ? null
              : fbb.writeString(object.conversationId!);
          final messageTextOffset = object.messageText == null
              ? null
              : fbb.writeString(object.messageText!);
          final senderIdOffset = object.senderId == null
              ? null
              : fbb.writeString(object.senderId!);
          final timeOffset =
              object.time == null ? null : fbb.writeString(object.time!);
          final userIdOffset =
              object.userId == null ? null : fbb.writeString(object.userId!);
          final ownerIdOffset =
              object.ownerId == null ? null : fbb.writeString(object.ownerId!);
          final urlOffset =
              object.url == null ? null : fbb.writeString(object.url!);
          fbb.startTable(11);
          fbb.addInt64(0, object.id ?? 0);
          fbb.addOffset(1, messageIdOffset);
          fbb.addOffset(2, conversationIdOffset);
          fbb.addOffset(3, messageTextOffset);
          fbb.addOffset(4, senderIdOffset);
          fbb.addOffset(5, timeOffset);
          fbb.addOffset(6, userIdOffset);
          fbb.addInt64(7, object.cmd);
          fbb.addOffset(8, ownerIdOffset);
          fbb.addOffset(9, urlOffset);
          fbb.finish(fbb.endTable());
          return object.id ?? 0;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = ChatMessageContent(
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 4),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 20),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 6),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 8),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 10),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 12),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 14),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 16),
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 18),
              const fb.StringReader(asciiOptimization: true)
                  .vTableGetNullable(buffer, rootOffset, 22));

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [ChatMessageContent] entity fields to define ObjectBox queries.
class ChatMessageContent_ {
  /// see [ChatMessageContent.id]
  static final id =
      QueryIntegerProperty<ChatMessageContent>(_entities[0].properties[0]);

  /// see [ChatMessageContent.messageId]
  static final messageId =
      QueryStringProperty<ChatMessageContent>(_entities[0].properties[1]);

  /// see [ChatMessageContent.conversationId]
  static final conversationId =
      QueryStringProperty<ChatMessageContent>(_entities[0].properties[2]);

  /// see [ChatMessageContent.messageText]
  static final messageText =
      QueryStringProperty<ChatMessageContent>(_entities[0].properties[3]);

  /// see [ChatMessageContent.senderId]
  static final senderId =
      QueryStringProperty<ChatMessageContent>(_entities[0].properties[4]);

  /// see [ChatMessageContent.time]
  static final time =
      QueryStringProperty<ChatMessageContent>(_entities[0].properties[5]);

  /// see [ChatMessageContent.userId]
  static final userId =
      QueryStringProperty<ChatMessageContent>(_entities[0].properties[6]);

  /// see [ChatMessageContent.cmd]
  static final cmd =
      QueryIntegerProperty<ChatMessageContent>(_entities[0].properties[7]);

  /// see [ChatMessageContent.ownerId]
  static final ownerId =
      QueryStringProperty<ChatMessageContent>(_entities[0].properties[8]);

  /// see [ChatMessageContent.url]
  static final url =
      QueryStringProperty<ChatMessageContent>(_entities[0].properties[9]);
}
