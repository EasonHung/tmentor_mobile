import 'package:flutter/material.dart';
import 'package:mentor_app_flutter/apiManager/studentCaseApiManager.dart';
import 'package:mentor_app_flutter/features/user_case_screen/user_case_widget.dart';
import 'package:mentor_app_flutter/vo/student_case_item.dart';

import '../../apiManager/userApiManager.dart';

class UserCaseScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserCaseScreenState();
  }
}

class UserCaseScreenState extends State<UserCaseScreen> {
  List<StudentCaseItem> caseList = [];

  @override
  void initState() {
    super.initState();
    getUserCaseFromServer();
  }

  Future<void> getUserCaseFromServer() async {
    await userApiManager.updateUserToken();
    caseList = await studentCaseApiManager.getUserStudentCase();
    setState(() {
      caseList = caseList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF5F7F5),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          centerTitle: true,
          backgroundColor: Color(0xFFF5F7F5),
          title: Text(
            "我的貼文",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        body: Container(
            child: ListView.builder(
                itemCount: caseList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return UserCaseItemWidget(caseList[index]);
                })));
  }
}
