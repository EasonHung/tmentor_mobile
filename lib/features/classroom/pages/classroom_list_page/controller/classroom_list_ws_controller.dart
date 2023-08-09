import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../../config/server_url.dart';
import 'classroom_list_controller.dart';

class ClassroomListWsController extends GetxController {
  WebSocketChannel? wsChannel;
  ClassroomListController classroomListController = Get.find<ClassroomListController>();
  Timer? heartbeatTimer;

  @override
  onInit() async {
    super.onInit();
    // initWsChannel();
  }

  @override
  onClose() async {
    stopHeartbeat();
    wsChannel?.sink.close();
  }

  Future<void> initWsChannel() async {
    String? userId = await UserPrefs.getUserId();
    wsChannel = WebSocketChannel.connect(
        Uri.parse(EnvSetting.CLASSROOM_WEBSOCKET_IP + '/?userId=' + userId! + '&applicationType=app'));
    listenAndProcessMsg();
    startHeartbeat();
  }

  void closeWs() {
    print("close classroom list ws");
    stopHeartbeat();
    wsChannel?.sink.close();
  }

  void reconnectWs() {
    initWsChannel();
  }

  void startHeartbeat() async {
    if(heartbeatTimer != null) {
      return;
    }

    heartbeatTimer = Timer.periodic(Duration(seconds: 30), (Timer t) {
      print("[classroom list] ping");
      wsChannel?.sink.add(json.encode({
        "cmd": "ping",
      }).codeUnits);
    });
  }

  void stopHeartbeat() async {
    heartbeatTimer?.cancel();
    heartbeatTimer = null;
  }

  void listenAndProcessMsg() {
    wsChannel?.stream.listen((message) {
      // utf8.encode -> string to List<int>
      var messageJson = json.decode(message);
      switch (messageJson['cmd']) {
        case "open room":
          classroomListController.changeClassroomStatus(messageJson["classroomId"]);
          break;
        case "join room":
          classroomListController.changeClassroomStatus(messageJson["classroomId"]);
          break;
        case "close room":
          classroomListController.changeClassroomStatus(messageJson["classroomId"]);
          break;
        case "leave room":
          classroomListController.changeClassroomStatus(messageJson["classroomId"]);
          break;
      }
    });
  }
}