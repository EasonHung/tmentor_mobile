import 'package:flutter/material.dart';

class SignInTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "歡迎加入 T-Mentor",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w600,
        fontSize: 32,
      ),
    );
  }
}