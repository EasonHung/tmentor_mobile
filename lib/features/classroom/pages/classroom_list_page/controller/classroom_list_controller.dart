import '../../../../../apiManager/classroomApiManager.dart';
import '../../../../../apiManager/classroom_api_dto/res/get_classroom_status_res.dart';
import '../../../../../vo/teacher_item.dart';
import 'package:get/get.dart';

class ClassroomListController extends GetxController {
  RxList<TeacherClassroomItem> teacherClassroomList = <TeacherClassroomItem>[].obs;

  @override
  onInit() async {
    super.onInit();
    initTeacherClassroomList();
  }

  Future<void> initTeacherClassroomList() async {
    teacherClassroomList.value = await classroomApiManager.getClassroomList();
  }

  Future<void> changeClassroomStatus(String classroomId) async {
    GetClassroomStatusRes? statusRes = await classroomApiManager.getClassroomStatus(classroomId);

    TeacherClassroomItem statusChangeRoom = teacherClassroomList.firstWhere((classroom) => classroom.teacherClassroomId == classroomId);
    teacherClassroomList.removeWhere((classroom) => classroom.teacherClassroomId == classroomId);
    if ((statusRes?.classroomStatus == "online" || statusRes?.classroomStatus == "in class")) {
      statusChangeRoom.status = statusRes?.classroomStatus;
      statusChangeRoom.classTitle = statusRes?.classSettingInfo?.title;
      statusChangeRoom.classDesc = statusRes?.classSettingInfo?.desc;
      statusChangeRoom.classTime = statusRes?.classSettingInfo?.classTime;
      statusChangeRoom.classPoints = statusRes?.classSettingInfo?.classPoints;
      teacherClassroomList.insert(0, statusChangeRoom);
    } else {
      statusChangeRoom.status = statusRes?.classroomStatus;
      statusChangeRoom.classTitle = "";
      statusChangeRoom.classDesc = "";
      statusChangeRoom.classTime = null;
      statusChangeRoom.classPoints = null;
      teacherClassroomList.add(statusChangeRoom);
    }
  }
}