import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mentor_app_flutter/color_constants.dart';

class ToastService {
  static void showSuccess(String message) {
    Fluttertoast.showToast(msg: message, backgroundColor: tmentorGreen);
  }

  static void showAlert(String message) {
    Fluttertoast.showToast(msg: message, backgroundColor: secondaryRed);
  }
}