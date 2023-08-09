import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/service/my_classroom_message_service.dart';

import '../../../../../vo/class_setting_info.dart';

class MyClassroomClassController extends GetxController {
  final MyClassroomMessageService messageService;
  final ClassSettingInfo classSettingInfo;
  int? startClassTime;
  int? startClassPoints;

  MyClassroomClassController(this.messageService, this.classSettingInfo);

  Future<void> closeRoom() async {
    await messageService.sendCloseRoomCmd();
  }

  void sendOpenClassroomMessage() {
    messageService.sendOpenRoomCmd(classSettingInfo);
  }
}