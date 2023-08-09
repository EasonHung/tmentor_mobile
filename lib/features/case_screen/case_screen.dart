import 'package:flutter/material.dart';
import 'package:mentor_app_flutter/apiManager/studentCaseApiManager.dart';
import 'package:mentor_app_flutter/vo/student_case_item.dart';

class CaseScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CaseScreenState();
  }
}

class CaseScreenState extends State<CaseScreen> {
  List<StudentCaseItem> studentCasItemList = [];
  List<String> filterCategory = [];
  TextEditingController filterTextController = new TextEditingController();
  String selectedIdentity = "teacher";

  @override
  void initState() {
    super.initState();
    // getStudentCaseListFromServer(0);
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

  swithToTeacher() {
    setState(() {
      selectedIdentity = "teacher";
    });
  }

  swithToStudent() {
    setState(() {
      selectedIdentity = "student";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
        child: Text(
          "coming soon~",
          style: TextStyle(fontSize: 25),
        ),
      )
          // child: Container(
          //   child: ListView.builder(
          //     itemCount: studentCasItemList.length + 3,
          //     itemBuilder: (context, index) {
          //       if(index == 0)
          //         return buildIcon();
          //       if(index == 1)
          //         return buildIdentitySwitcher();
          //       if(index == 2)
          //         return buildFilterRow();
          //       return CaseItemWidget(studentCasItemList[index - 3]);
          //     },
          //   )
          // )
          ),
    );
  }

  Widget buildIdentitySwitcher() {
    return Center(
        child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(color: Color(0xff71c57d), borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
              InkWell(
                  onTap: swithToTeacher,
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                      decoration: BoxDecoration(
                          color: selectedIdentity == "teacher" ? Color(0xfff5f5f5) : Color(0xff71c57d),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Text("老師",
                          style: TextStyle(
                              color: selectedIdentity == "teacher" ? Colors.black : Color(0xfff5f5f5),
                              fontWeight: FontWeight.w600,
                              fontSize: 18)))),
              InkWell(
                  onTap: swithToStudent,
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                      decoration: BoxDecoration(
                          color: selectedIdentity == "student" ? Color(0xfff5f5f5) : Color(0xff71c57d),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Text("學生",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: selectedIdentity == "student" ? Colors.black : Color(0xfff5f5f5),
                              fontSize: 18))))
            ])));
  }

  Widget buildIcon() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "aa",
              style: TextStyle(fontFamily: 'Raleway', fontSize: 24.0),
            )
          ],
        ));
  }

  Widget buildFilterRow() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(
                Icons.filter_alt_sharp,
              ),
              onPressed: () {
                showDialog(context: context, builder: buildFilterModal);
              },
            ),
            ...buildFilterItemList()
          ],
        ));
  }

  Widget buildFilterModal(BuildContext context) {
    return Dialog(
        child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: filterTextController,
                  decoration: InputDecoration(
                    hintText: "隨便打",
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  child: Text("篩選"),
                  onPressed: () {
                    setState(() {
                      if (filterTextController.text != null && filterTextController.text != "")
                        filterCategory.add(filterTextController.text);
                      filterTextController.text = "";
                      Navigator.of(context).pop();
                    });
                  },
                )
              ],
            )));
  }

  List<Widget> buildFilterItemList() {
    List<Widget> filterItemList = [];
    if (filterCategory.length == 0) {
      filterItemList.add(SizedBox.shrink());
      return filterItemList;
    } else {
      for (int i = 0; i < filterCategory.length; i++) {
        filterItemList.add(buildFilterItem(filterCategory[i]));
        filterItemList.add(SizedBox(width: 8));
      }
      return filterItemList;
    }
  }

  Widget buildFilterItem(String category) {
    return InkWell(
        onTap: () {
          setState(() {
            filterCategory.removeWhere((element) => element == category);
          });
        },
        child: Container(
            decoration: BoxDecoration(color: Color(0xfff5f5f5), borderRadius: BorderRadius.circular(15)),
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ))));
  }
}
