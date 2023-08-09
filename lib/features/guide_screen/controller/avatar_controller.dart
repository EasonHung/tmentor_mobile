import 'dart:io';

import 'package:get/get.dart';
import 'package:mentor_app_flutter/features/guide_screen/controller/step_controller.dart';

import '../../../utils/date_util.dart';

class AvatarController extends GetxController {
  StepController stepController = Get.find<StepController>();
  Rx<File> selectedAvatar = File("").obs;

  Future<void> selectAvatar(bool fromGallery) async {
    File? selectFile = await MentorImageUtils.pickMedia(fromGallery, (file) => MentorImageUtils.cropImageFunc(file)) as File?;
    selectedAvatar.value = selectFile?? File("");

    stepController.changeNavigationStatus( (selectedAvatar.value.path != "") );
    // await UserApiManager.updateAvatar(selectedAvatar!);
  }

  bool checkAvatarFile() {
    return selectedAvatar.value.path != "";
  }
}