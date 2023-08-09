import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/classroom/constants/ClassStatus.dart';

class MyClassroomBtnController extends GetxController {
  Rx<bool> showBottomBtns = true.obs;
  Rx<String> classStatus = ClassStatus.INIT.obs;
}