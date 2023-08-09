import 'package:flutter/material.dart';
import 'package:mentor_app_flutter/apiManager/studentCaseApiManager.dart';
import 'package:mentor_app_flutter/features/search_screen/find_student_page/student_item.dart';

import '../../../vo/student_case_item.dart';

class FindStudentPage extends StatefulWidget {
  final VoidCallback onChangeBtnClick;

  FindStudentPage({required this.onChangeBtnClick});

  @override
  State<StatefulWidget> createState() {
    return FindStudentPageState(onChangeBtnClick);
  }
}

class FindStudentPageState extends State<FindStudentPage> {
  List<StudentCaseItem> studentCasItemList = [];
  VoidCallback onChangeBtnClick;
  int page = 0;

  FindStudentPageState(this.onChangeBtnClick);

  @override
  void initState() {
    super.initState();
    getStudentCaseListFromServer(0);
  }

  Future<void> getStudentCaseListFromServer(int page) async {
    if (page == 0) {
      studentCasItemList = [];
    }

    List<StudentCaseItem> responseDataList = await studentCaseApiManager.getStudentCase(page);
    setState(() {
      studentCasItemList..addAll(responseDataList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
      Container(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: studentCasItemList.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "mentor app",
                        style: TextStyle(fontFamily: 'Raleway', fontSize: 24.0),
                      )
                    ],
                  );
                } else {
                  return StudentItem(studentCasItemList[index - 1]);
                }
              })),
      Positioned(
          bottom: 10,
          left: 0,
          child: Row(children: [
            SizedBox(
              width: 30,
            ),
            Column(
              children: [
                IconButton(
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      size: 36.0,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      onChangeBtnClick();
                    }),
                Text(
                  "尋找老師",
                  style: TextStyle(fontFamily: 'Raleway', color: Colors.green, fontSize: 18.0),
                )
              ],
            )
          ]))
    ])));
  }
}
