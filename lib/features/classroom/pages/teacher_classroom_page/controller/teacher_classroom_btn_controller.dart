import 'package:get/get.dart';

class TeacherClassroomBtnController extends GetxController {
  Rx<bool> showBottomBtns = true.obs;

  void changeBottomBtnStatus() {
    showBottomBtns.value = !showBottomBtns.value;
  }
}