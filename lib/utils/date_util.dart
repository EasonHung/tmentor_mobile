import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class MentorDateUtil {
  
  static String getNowString(String format) {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat(format);
    return formatter.format(now);
  }

  static String getWeekDay(int weekDay) {
    switch (weekDay) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday.';
      case 3:
        return 'Wednsday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Err';
    }
  }

  static String getMonthString(int month) {
    switch (month) {
      case 1:
        return 'Jan.';
      case 2:
        return 'Feb.';
      case 3:
        return 'Mar.';
      case 4:
        return 'Apr.';
      case 5:
        return 'May';
      case 6:
        return 'Jun.';
      case 7:
        return 'Jul.';
      case 8:
        return 'Aug.';
      case 9:
        return 'Sept.';
      case 10:
        return 'Oct.';
      case 11:
        return 'Nov.';
      case 12:
        return 'Dec.';
      default:
        return 'Err';
    }
  }

  static String timeFormater(TimeOfDay timeOfDay) {
    String hourStr = timeOfDay.hour.toString().length == 1? "0" + timeOfDay.hour.toString() : timeOfDay.hour.toString();
    String minuteStr = timeOfDay.minute.toString().length == 1? "0" + timeOfDay.minute.toString() : timeOfDay.minute.toString();

    return hourStr + ":" + minuteStr;
  }
}

class MentorImageUtils {

  static Future<Object?> pickMidia(bool fromGallery, Future<CroppedFile?> Function(File file)? cropImageFunc) async {
    final resource = fromGallery? ImageSource.gallery : ImageSource.camera;
    final pickedFile = await ImagePicker().pickImage(source: resource);

    if(pickedFile == null) {
      return null;
    }

    if(cropImageFunc == null) {
      return File(pickedFile.path);
    }

    final file = File(pickedFile.path);

    return cropImageFunc(file);
  }

  static Future<Object?> pickMedia(bool fromGallery, Future<File?> Function(File file)? cropImageFunc) async {
    final resource = fromGallery? ImageSource.gallery : ImageSource.camera;
    final pickedFile = await ImagePicker().pickImage(source: resource);

    if(pickedFile == null) {
      return null;
    }

    if(cropImageFunc == null) {
      return File(pickedFile.path);
    }

    final file = File(pickedFile.path);

    return cropImageFunc(file);
  }

  static Future<File?> cropImageFunc(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.square],
        compressQuality: 70,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "裁減圖片",
            hideBottomControls: true,
            lockAspectRatio: false)
        ]
    );

    return File(croppedFile!.path);
  }
}