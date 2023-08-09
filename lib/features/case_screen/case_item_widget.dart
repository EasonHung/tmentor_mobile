import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:mentor_app_flutter/apiManager/studentCaseApiManager.dart';
import 'package:mentor_app_flutter/features//introduce_screen/introduce_screen.dart';
import 'package:mentor_app_flutter/utils/date_util.dart';
import 'package:mentor_app_flutter/vo/bid_info_item.dart';
import 'package:mentor_app_flutter/vo/student_case_item.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:time_range_picker/time_range_picker.dart';

import '../../apiManager/userApiManager.dart';
import '../user_info_screen/user_info_screen.dart';

class CaseItemWidget extends StatefulWidget {
  final StudentCaseItem studentCaseItem;

  const CaseItemWidget(this.studentCaseItem);

  @override
  State<StatefulWidget> createState() {
    return CaseItemWidgetState(studentCaseItem);
  }
}

class CaseItemWidgetState extends State<CaseItemWidget> {
  final StudentCaseItem? studentCaseItem;
  int? showImageIndex = 0;
  TextEditingController? bidValueController = new TextEditingController();
  StateSetter? modalSetter;
  String? bidDate = "";
  String? bidTimeRange = "";
  String? highestBidPrice = "0";
  String? lowestBidPrice = "0";

  CaseItemWidgetState(this.studentCaseItem);

  @override
  void initState() {
    super.initState();
    initBidTime();
  }

  void initBidTime() {
    TimeOfDay timeNow = TimeOfDay.now();
    DateTime dateTimeNow = DateTime.now();
    bidDate = MentorDateUtil.getWeekDay(dateTimeNow.weekday) +
        ", " +
        dateTimeNow.day.toString() +
        " " +
        MentorDateUtil.getMonthString(dateTimeNow.month);
    bidTimeRange = MentorDateUtil.timeFormater(timeNow) + " - " + MentorDateUtil.timeFormater(timeNow);
  }

  Future<void> sendBid() async {
    await userApiManager.updateUserToken();
    int? statusCode = await studentCaseApiManager.addBid(
        studentCaseItem!.studentCaseId, int.parse(bidValueController!.text), bidDate! + " " + bidTimeRange!);
    setState(() {
      bidValueController?.text = "";
    });

    printBidResult(statusCode!);
    Navigator.of(context).pop();
  }

  void printBidResult(int statusCode) {
    if (statusCode == 200)
      Toast.show("出價成功!!", backgroundColor: Colors.green[200]!);
    else
      Toast.show("系統異常，請稍後再試", backgroundColor: Colors.red[300]!);
  }

  Future<void> loadHistoryBidPrice() async {
    // 先變回0元以免讀成上一個
    highestBidPrice = "0";
    lowestBidPrice = "0";
    List<BidInfoItem> bidInfos = await studentCaseApiManager.getBidInfo(studentCaseItem!.studentCaseId);

    if (bidInfos.length != 0) {
      int highest = bidInfos[0].bidPrice;
      int lowest = bidInfos[0].bidPrice;
      for (int i = 0; i < bidInfos.length; i++) {
        if (highest < bidInfos[i].bidPrice) highest = bidInfos[i].bidPrice;
        if (lowest > bidInfos[i].bidPrice) lowest = bidInfos[i].bidPrice;
      }

      modalSetter!(() {
        highestBidPrice = highest.toString();
        lowestBidPrice = lowest.toString();
      });
    }
  }

  Future<void> setBidTime() async {
    DateTime? date = await showDatePicker(
        context: context, initialDate: DateTime.now(), firstDate: DateTime(2022, 01), lastDate: DateTime(2100, 12));
    TimeRange timeRange = await showTimeRangePicker(
      context: context,
      selectedColor: Color(0xff71c57d),
      labels: ["12 am", "3 am", "6 am", "9 am", "12 pm", "3 pm", "6 pm", "9 pm"].asMap().entries.map((e) {
        return ClockLabel.fromIndex(idx: e.key, length: 8, text: e.value);
      }).toList(),
    );

    if (date == null || timeRange == null) return;

    TimeOfDay startTime = timeRange.startTime;
    TimeOfDay endTime = timeRange.endTime;
    modalSetter!(() {
      bidDate = MentorDateUtil.getWeekDay(date.weekday) +
          ", " +
          date.day.toString() +
          " " +
          MentorDateUtil.getMonthString(date.month);
      bidTimeRange = MentorDateUtil.timeFormater(startTime) + "-" + MentorDateUtil.timeFormater(endTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return IntroduceScreen(studentCaseItem!.userId, false);
          }));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: width * 0.08, vertical: height * 0.01),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                Container(
                    child: Column(
                  children: [
                    ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: Container(
                          height: 50,
                          width: 50,
                          child: InkWell(
                              child: buildCaseAvator(studentCaseItem!.avatarUrl),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                  return IntroduceScreen(studentCaseItem!.userId, false);
                                }));
                              }),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.green[200]),
                        ),
                        title: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return UserInfoScreen();
                              }));
                            },
                            child: Text(
                              studentCaseItem!.nickname == "" ? "匿名使用者" : studentCaseItem!.nickname,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        subtitle: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return UserInfoScreen();
                            }));
                          },
                          child: Text(studentCaseItem!.postTime.replaceAll("T", " ").substring(0, 16)),
                        )),
                    Container(
                      child: Column(children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            studentCaseItem!.title,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            studentCaseItem!.content,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ]),
                    ),
                    buildUserImage(studentCaseItem!.pictureUrl),
                    SizedBox(height: 10),
                    buildBidBtn()
                  ],
                )),
              ],
            ),
          ),
        ));
  }

  Widget buildBidBtn() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
              // todo: background 改用textButton style做 會更自然
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                loadHistoryBidPrice();
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          modalSetter = setState;
                          return buildBidWidget(context);
                        },
                      );
                    });
              },
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                  decoration:
                      BoxDecoration(color: Color(0xff71c57d), borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Text("出價", style: TextStyle(color: Color(0xfff5f5f5), fontSize: 18))))
        ],
      ),
    );
  }

  Widget buildBidWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(
                top: size.height * 0.05,
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: size.width * 0.15,
                right: size.width * 0.15),
            child: Center(
                child: Column(
              children: [
                buildAvatarAndName(),
                SizedBox(height: 15),
                buildChosenTime(),
                SizedBox(height: 20),
                buildBidPrice(),
                SizedBox(height: 20),
                buildSendBtn(),
                SizedBox(height: 25),
                buildHighestPrice(),
                SizedBox(height: 10),
                buildLowestPrice(),
                SizedBox(height: 10),
              ],
            ))));
  }

  Widget buildHighestPrice() {
    return Row(
      children: [
        Text(
          "目前最高金額(NTD)",
          style: TextStyle(fontSize: 18),
        ),
        Spacer(),
        Text(
          highestBidPrice! + "/分鐘",
          style: TextStyle(fontSize: 18),
        )
      ],
    );
  }

  Widget buildLowestPrice() {
    return Row(
      children: [
        Text(
          "目前最低金額(NTD)",
          style: TextStyle(fontSize: 18),
        ),
        Spacer(),
        Text(
          lowestBidPrice! + "/分鐘",
          style: TextStyle(fontSize: 18),
        )
      ],
    );
  }

  Widget buildSendBtn() {
    return TextButton(
        onPressed: sendBid,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(color: Color(0xff71c57d), borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Center(
                child: Text(
              "送出",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.white),
            ))));
  }

  Widget buildBidPrice() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "出價金額(NTD)",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        TextField(
          controller: bidValueController,
          decoration: InputDecoration(hintText: "請輸入每分鐘之金額", suffixText: "NTD/分鐘"),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
        )
      ],
    );
  }

  Widget buildChosenTime() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Row(children: [Text("希望上課時間", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400))]),
      buildTimeBlock()
    ]);
  }

  Widget buildTimeBlock() {
    return InkWell(
        onTap: setBidTime,
        child: Container(
            margin: EdgeInsets.only(top: 10),
            height: MediaQuery.of(context).size.height * 0.13,
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(children: [
                  Container(
                      padding: EdgeInsets.all(3),
                      decoration:
                          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Icon(Icons.calendar_month_outlined, color: Color(0xff71c57d), size: 50)),
                  SizedBox(width: 10),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(bidDate!,
                            style: TextStyle(fontSize: 18, color: Colors.grey[400], fontWeight: FontWeight.w500)),
                        Text(bidTimeRange!,
                            style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500))
                      ])
                ]))));
  }

  Widget buildAvatarAndName() {
    String nickname = studentCaseItem!.nickname == "" ? "匿名使用者" : studentCaseItem!.nickname;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          width: 50,
          child: buildCaseAvator(studentCaseItem!.avatarUrl),
        ),
        SizedBox(width: 13),
        Text(
          nickname,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  Widget buildCaseAvator(String url) {
    if (url == "")
      return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Image.asset("assets/images/null_avatar.png", fit: BoxFit.cover));
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;

            return Image.asset("assets/images/null_avatar.png", fit: BoxFit.cover);
          },
        ));
  }

  Widget buildUserImage(List<String> imageUrl) {
    if (imageUrl.length == 0) {
      return SizedBox.shrink();
    } else if (imageUrl.length == 1) {
      return buildImage(imageUrl[0]);
    } else {
      return Stack(alignment: Alignment.center, children: [
        CarouselSlider.builder(
          options: CarouselOptions(
              height: 380,
              viewportFraction: 1,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  showImageIndex = index;
                });
              }),
          itemCount: studentCaseItem!.pictureUrl.length,
          itemBuilder: (context, index, realIndex) {
            final imageFile = studentCaseItem!.pictureUrl[index];
            return buildImage(imageFile);
          },
        ),
        Positioned(bottom: 20, child: buildShowImageIndicator())
      ]);
    }
  }

  Widget buildImage(String imageUrl) {
    return Container(
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Image.network(
            imageUrl,
            fit: BoxFit.fitWidth,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;

              return const Center(child: Text('Loading...'));
            },
          ),
        ));
  }

  Widget buildShowImageIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: showImageIndex!,
      count: studentCaseItem!.pictureUrl.length,
      effect: SlideEffect(activeDotColor: Colors.green[200]!),
    );
  }
}
