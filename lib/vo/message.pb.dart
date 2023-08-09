///
//  Generated code. Do not modify.
//  source: message.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class MessagePb extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MessagePb', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'dto'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'MessageId', protoName: 'MessageId')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Cmd', $pb.PbFieldType.O3, protoName: 'Cmd')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'SenderId', protoName: 'SenderId')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'RecieverId', protoName: 'RecieverId')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ConversationId', protoName: 'ConversationId')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Time', protoName: 'Time')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Message', protoName: 'Message')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Picture', protoName: 'Picture')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Url', protoName: 'Url')
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'SendId', protoName: 'SendId')
    ..hasRequiredFields = false
  ;

  MessagePb._() : super();
  factory MessagePb({
    $core.String? messageId,
    $core.int? cmd,
    $core.String? senderId,
    $core.String? recieverId,
    $core.String? conversationId,
    $core.String? time,
    $core.String? message,
    $core.String? picture,
    $core.String? url,
    $core.String? sendId,
  }) {
    final _result = create();
    if (messageId != null) {
      _result.messageId = messageId;
    }
    if (cmd != null) {
      _result.cmd = cmd;
    }
    if (senderId != null) {
      _result.senderId = senderId;
    }
    if (recieverId != null) {
      _result.recieverId = recieverId;
    }
    if (conversationId != null) {
      _result.conversationId = conversationId;
    }
    if (time != null) {
      _result.time = time;
    }
    if (message != null) {
      _result.message = message;
    }
    if (picture != null) {
      _result.picture = picture;
    }
    if (url != null) {
      _result.url = url;
    }
    if (sendId != null) {
      _result.sendId = sendId;
    }
    return _result;
  }
  factory MessagePb.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MessagePb.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MessagePb clone() => MessagePb()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MessagePb copyWith(void Function(MessagePb) updates) => super.copyWith((message) => updates(message as MessagePb)) as MessagePb; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MessagePb create() => MessagePb._();
  MessagePb createEmptyInstance() => create();
  static $pb.PbList<MessagePb> createRepeated() => $pb.PbList<MessagePb>();
  @$core.pragma('dart2js:noInline')
  static MessagePb getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessagePb>(create);
  static MessagePb? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get messageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set messageId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessageId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get cmd => $_getIZ(1);
  @$pb.TagNumber(2)
  set cmd($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCmd() => $_has(1);
  @$pb.TagNumber(2)
  void clearCmd() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get senderId => $_getSZ(2);
  @$pb.TagNumber(3)
  set senderId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSenderId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSenderId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get recieverId => $_getSZ(3);
  @$pb.TagNumber(4)
  set recieverId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRecieverId() => $_has(3);
  @$pb.TagNumber(4)
  void clearRecieverId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get conversationId => $_getSZ(4);
  @$pb.TagNumber(5)
  set conversationId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasConversationId() => $_has(4);
  @$pb.TagNumber(5)
  void clearConversationId() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get time => $_getSZ(5);
  @$pb.TagNumber(6)
  set time($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearTime() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get message => $_getSZ(6);
  @$pb.TagNumber(7)
  set message($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasMessage() => $_has(6);
  @$pb.TagNumber(7)
  void clearMessage() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get picture => $_getSZ(7);
  @$pb.TagNumber(8)
  set picture($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasPicture() => $_has(7);
  @$pb.TagNumber(8)
  void clearPicture() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get url => $_getSZ(8);
  @$pb.TagNumber(9)
  set url($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasUrl() => $_has(8);
  @$pb.TagNumber(9)
  void clearUrl() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get sendId => $_getSZ(9);
  @$pb.TagNumber(10)
  set sendId($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasSendId() => $_has(9);
  @$pb.TagNumber(10)
  void clearSendId() => clearField(10);
}

