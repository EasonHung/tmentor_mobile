import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mentor_app_flutter/color_constants.dart';

import '../../../components/bottom_confirm_btn.dart';
import '../../../sharedPrefs/cardPrefs.dart';
import '../../../sharedPrefs/userPrefs.dart';

class FilterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FilterPageState();
  }
}

class FilterPageState extends State<FilterPage>{
  bool isChecked = true;
  List<String> fieldsOptions = ["家教","資訊", "設計", "商業/管理", "行銷/企劃", "運動/營養", "多媒體", "藝術", "人文"];
  List<bool> fieldsChecks = [false, false, false, false, false, false, false, false, false];
  List<String> selectedField = [];
  List<String> genderOptions = ["male", "female"];
  List<bool> genderChecks = [false, false];
  List<String> selectedGender = [];

  @override
  void initState() {
    super.initState();
    initSelection();
  }

  Future<void> initSelection() async {
    String? userId = await UserPrefs.getUserId();
    selectedField = (await CardPrefs.getFilterFields(userId!))!;
    for(int i = 0;i < selectedField.length; i++) {
      fieldsChecks[fieldsOptions.indexOf(selectedField[i])] = true;
    }

    selectedGender = (await CardPrefs.getFilterGender(userId))!;
    for(int i = 0;i < selectedGender.length; i++) {
      genderChecks[genderOptions.indexOf(selectedGender[i])] = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildTitle(),
            SizedBox(height: ScreenUtil().setHeight(10)),
            buildDivider(),
            buildFieldsSelection(),
            buildDivider(),
            buildGenderSelection(),
            SizedBox(height: ScreenUtil().setHeight(10)),
            BottomConfirmBtn(() {Navigator.of(context).pop();}, "搜尋"),
            SizedBox(height: ScreenUtil().setHeight(10)),
          ],
        )
      )
    );
  }

  Widget buildDivider() {
    return SizedBox(
      height: ScreenUtil().setHeight(1),
      width: ScreenUtil().screenWidth,
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.grey[300]),
      )
    );
  }

  Widget buildSearchBtn() {
    return SizedBox(
      height: ScreenUtil().setHeight(60), // <-- Your height
      width: ScreenUtil().screenWidth * 0.9,
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          "搜尋",
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(16)
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: primaryDefault,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().radius(15)))),
        ),
      )
    );
  }

  Widget buildGenderSelection() {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ListTileTheme(
        contentPadding: EdgeInsets.only(left: 18, right: 16),
        child: ExpansionTile(
        initiallyExpanded: true,
        children: [
          ...buildGenderOptions(genderOptions)
        ],
        title: Text(
          "性別",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        )
      )
    )
    );
  }

  Widget buildFieldsSelection() {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ListTileTheme(
        contentPadding: EdgeInsets.only(left: 18, right: 16),
        child: ExpansionTile(
          initiallyExpanded: true,
          children: [
            ...buildFieldOptions(fieldsOptions)
          ],
          title: Text(
            "專業領域",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20,
            ),
          )
        )
      )
    );
  }

  List<Widget> buildFieldOptions(List<String> options) {
    List<Widget> widgets = [];

    for(int i = 0; i < options.length; i++) {
      widgets.add(
        FractionallySizedBox(
          widthFactor: 1,
          child: InkWell(
            onTap: () async {
              String? userId = await UserPrefs.getUserId();
              setState(() {
                fieldsChecks[i] = !fieldsChecks[i];
                if(fieldsChecks[i]) {
                  this.selectedField.add(fieldsOptions[i]);
                } else {
                  this.selectedField.remove(fieldsOptions[i]);
                }
              });
              CardPrefs.putFilterFields(userId!, selectedField);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(3)),
              margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(5), left: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    options[i],
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Transform.scale(
                    scale: 1.3,
                    child: Checkbox(
                      checkColor: Colors.white,
                      side: MaterialStateBorderSide.resolveWith(getCheckboxBorderColor),
                      fillColor: MaterialStateProperty.resolveWith(getCheckboxColor),
                      shape: CircleBorder(),
                      value: fieldsChecks[i],
                      onChanged: (value) async {
                        String? userId = await UserPrefs.getUserId();
                        setState(() {
                          fieldsChecks[i] = value!;
                          if(fieldsChecks[i]) {
                            this.selectedField.add(fieldsOptions[i]);
                          } else {
                            this.selectedField.remove(fieldsOptions[i]);
                          }
                        });
                        CardPrefs.putFilterFields(userId!, selectedField);
                      },
                    ),
                  ),
                ]
              ),
            ),
          )
        )
      );
    }

    return widgets;
  }

  Color getCheckboxColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
      MaterialState.selected
    };
    if (states.any(interactiveStates.contains)) {
      return primaryDefault;
    }
    return primaryDefault;
  }

  BorderSide getCheckboxBorderColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
      MaterialState.selected
    };
    if (states.any(interactiveStates.contains)) {
      return BorderSide(width: 1.0, color: primaryDefault);
    }
    return BorderSide(width: 1.0, color: black400);
  }

  List<Widget> buildGenderOptions(List<String> options) {
    List<Widget> widgets = [];

    for(int i = 0; i < options.length; i++) {
      widgets.add(
          FractionallySizedBox(
            widthFactor: 1,
            child: InkWell(
              onTap: () async {
                String? userId = await UserPrefs.getUserId();
                setState(() {
                  genderChecks[i] = !genderChecks[i];
                  if(genderChecks[i]) {
                    this.selectedGender.add(genderOptions[i]);
                  } else {
                    this.selectedGender.remove(genderOptions[i]);
                  }
                });
                CardPrefs.putFilterGender(userId!, selectedGender);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(5)),
                margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(5), left: ScreenUtil().setWidth(12)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        options[i] == "male"? "男性" : "女性",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Transform.scale(
                        scale: 1.3,
                        child: Checkbox(
                          checkColor: Colors.white,
                          side: MaterialStateBorderSide.resolveWith(getCheckboxBorderColor),
                          fillColor: MaterialStateProperty.resolveWith(getCheckboxColor),
                          shape: CircleBorder(),
                          value: genderChecks[i],
                          onChanged: (value) async {
                            String? userId = await UserPrefs.getUserId();
                            setState(() {
                              genderChecks[i] = value!;
                              if(genderChecks[i]) {
                                this.selectedGender.add(genderOptions[i]);
                              } else {
                                this.selectedGender.remove(genderOptions[i]);
                              }
                            });
                            CardPrefs.putFilterGender(userId!, selectedGender);
                          },
                        ),
                      ),
                    ]
                ),
              ),
            )
          )
      );
    }

    return widgets;
  }

  Widget buildTitle() {
    return Container(
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(16), right: 0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "篩選條件",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(20)
            ),
          ),
          TextButton(
            onPressed: () async {
              String? userId = await UserPrefs.getUserId();
              CardPrefs.putFilterGender(userId!, []);
              CardPrefs.putFilterFields(userId, []);
              setState(() {
                fieldsChecks = [false, false, false, false, false, false, false, false, false];
                genderChecks = [false, false];
                selectedField = [];
                selectedGender = [];
              });
            },
            child: Text(
              "清除",
              style: TextStyle(
                color: primaryDefault,
                fontSize: ScreenUtil().setSp(18)
              ),
            )
          )
        ],
      )
    );
  }

}
