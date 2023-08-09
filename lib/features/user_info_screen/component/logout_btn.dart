import 'package:flutter/material.dart';
import 'package:mentor_app_flutter/features/signin/sign_in_screen.dart';
import 'package:mentor_app_flutter/service/user_service.dart';

import '../../../color_constants.dart';

class LogoutBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          UserService.logout();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
        },
        child: Text("更換帳號", style: TextStyle(fontSize: 18, color: primaryDark2, fontWeight: FontWeight.bold)));
  }
}
