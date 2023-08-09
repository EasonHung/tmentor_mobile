import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mentor_app_flutter/features/bid_screen/bid_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../vo/student_case_item.dart';
import '../../user_info_screen/user_info_screen.dart';

class StudentItem extends StatefulWidget {
  final StudentCaseItem studentCaseItem;

  StudentItem(this.studentCaseItem);

  @override
  State<StatefulWidget> createState() {
    return _StudentItemState(studentCaseItem);
  } 
}

class _StudentItemState extends State<StudentItem> {
  StudentCaseItem studentCaseItem;
  int showImageIndex = 0;

  _StudentItemState(this.studentCaseItem);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20)
            )
          ),
          // isScrollControlled: true,
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text("success"),
              )
            );
          }
        );
        // Navigator.of(context).push(MaterialPageRoute(builder: (context){
        //   return BidScreen(studentCaseItem.studentCaseId);
        // }));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: [
                    ListTile(
                      leading:  Container(
                        height: 60,
                        width: 60,
                        child: InkWell(
                          child: CircleAvatar(
                            radius: 34,
                            backgroundImage: studentCaseItem.avatarUrl == ""? AssetImage("assets/images/null_avatar.png") as ImageProvider : NetworkImage(studentCaseItem.avatarUrl)
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context){
                              return UserInfoScreen();
                            }));
                          }
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green[200]
                        ),
                      ),
                      title: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            return UserInfoScreen();
                          }));
                        },
                        child: Text(
                        studentCaseItem.nickname,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ) 
                      ),
                      subtitle: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            return UserInfoScreen();
                          }));
                        },
                        child: Text(studentCaseItem.postTime.replaceAll("T", " ").substring(0, 16)),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        children:[
                          Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              studentCaseItem.title,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              studentCaseItem.content,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ]
                      ),
                    ),
                    buildUserImage(studentCaseItem.pictureUrl),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                studentCaseItem.bidInfoIds.length.toString(),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                onPressed: () {}, 
                                icon: Icon(Icons.add_box_outlined),
                                iconSize: 30.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget buildUserImage(List<String> imageUrl) {
    if(imageUrl.length == 0) {
      return SizedBox.shrink();
    } else if(imageUrl.length == 1) {
      return buildImage(imageUrl[0]);
    } else {
      return Stack(
        alignment: Alignment.center,
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
              height: 380,
              viewportFraction: 1,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  showImageIndex = index;
                });
              }
            ),
            itemCount: studentCaseItem.pictureUrl.length,
            itemBuilder: (context, index, realIndex) {
              final imageFile = studentCaseItem.pictureUrl[index];
              return buildImage(imageFile);
            },
          ),
          Positioned(
            bottom: 20,
            child: buildShowImageIndicator()
          )
        ]
      );
    }
  }

  Widget buildImage(String imageUrl) {
    return Container(
      margin: EdgeInsets.all(10.0),
      width: double.infinity,
      height: 400.0,
      child:Image.network(
          imageUrl,
          fit: BoxFit.fitWidth,
          loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;

              return const Center(child: Text('Loading...'));
          },
        ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(color: Colors.white, offset: Offset(0, 5), blurRadius: 8.0),
        ],
      ),
    );
  }

  Widget buildShowImageIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: showImageIndex, 
      count: studentCaseItem.pictureUrl.length,
      effect: SlideEffect(
        activeDotColor: Colors.green[200]!
      ),
    );
  }
}