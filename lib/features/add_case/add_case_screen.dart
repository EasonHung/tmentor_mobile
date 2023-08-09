import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mentor_app_flutter/config/server_url.dart';
import 'package:mentor_app_flutter/sharedPrefs/userPrefs.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../apiManager/userApiManager.dart';
import '../main_page.dart';

class AddCaseScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddCaseScreenState();
  }
}

class AddCaseScreenState extends State<AddCaseScreen> {
  int currentStep = 0;
  int showImageIndex = 0;
  bool postCase = true;
  bool postResume = false;
  TextEditingController titleController = new TextEditingController();
  TextEditingController contentController = new TextEditingController();
  List<File> image = [];

  Future<void> pickImageFromGallery() async {
    final List<XFile> selecteImages = await ImagePicker().pickMultiImage();

    if (selecteImages.isEmpty) return;
    setState(() {
      for (XFile file in selecteImages) {
        this.image.add(File(file.path));
      }
    });
  }

  Future<void> postNewCaseToServer(BuildContext ctx) async {
    showLoadingDialog(ctx);
    await userApiManager.updateUserToken();

    Dio dio = new Dio();
    String subPath = postCase ? "/studentCase/add" : "/teacherCase/add";
    var formData = FormData.fromMap({
      "avatarUrl": await UserPrefs.getUserAvatarUrl(),
      "nickname": await UserPrefs.getUserNickname(),
      "title": titleController.text,
      "content": contentController.text,
      // "picture": await MultipartFile.fromFile(image.path)
    });
    try {
      dio.options.headers["authToken"] = await UserPrefs.getUserToken();
      await dio.post(EnvSetting.CASE_SYSTEM_SERVER_IP + subPath, data: formData);
    } catch (e) {
      print(e);
    }
    Navigator.of(ctx).push(MaterialPageRoute(builder: (context) {
      return MainScreen();
    }));
  }

  showLoadingDialog(BuildContext ctx) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return Container(
              height: 50,
              width: 50,
              child: Row(
                children: [
                  Spacer(),
                  CircularProgressIndicator(),
                  Spacer(),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Theme(
            data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: Colors.green[200]!)),
            child: Stepper(
              type: StepperType.vertical,
              steps: setSteps(),
              currentStep: currentStep,
              onStepContinue: () {
                final isLastStep = currentStep == setSteps().length - 1;

                if (isLastStep) {
                  postNewCaseToServer(context);
                } else {
                  setState(() {
                    currentStep += 1;
                  });
                }
              },
              onStepCancel: currentStep == 0
                  ? null
                  : () => setState(() => {
                        setState(() {
                          currentStep -= 1;
                        })
                      }),
              controlsBuilder: (BuildContext context, ControlsDetails controlsDetails) {
                return Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Row(
                      children: [
                        lastBtn(controlsDetails.onStepCancel),
                        const SizedBox(width: 12),
                        nextBtn(controlsDetails.onStepContinue),
                      ],
                    ));
              },
            )));
  }

  Widget lastBtn(var onStepCancel) {
    if (currentStep != 0)
      return Expanded(
          child: ElevatedButton(
        child: Text("上一步"),
        onPressed: onStepCancel,
      ));
    else
      return SizedBox.shrink();
  }

  Widget nextBtn(var onStepContinue) {
    if (currentStep != setSteps().length - 1)
      return Expanded(
          child: ElevatedButton(
        child: Text("繼續"),
        onPressed: onStepContinue,
      ));
    else
      return Expanded(
          child: ElevatedButton(
        child: Text("確認送出"),
        onPressed: onStepContinue,
      ));
  }

  Widget getImagePreview() {
    if (image.isEmpty) {
      return Text("快上傳照片吧~!");
    } else {
      return Center(
          child: Stack(alignment: Alignment.center, children: [
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
          itemCount: image.length,
          itemBuilder: (context, index, realIndex) {
            final imageFile = image[index];
            return buildImage(imageFile, index);
          },
        ),
        Positioned(bottom: 10, child: buildShowImageIndicator())
      ]));
    }
  }

  Widget buildImage(File imageFile, int index) {
    return Container(
      color: Colors.grey,
      child: Image.file(imageFile),
    );
  }

  Widget buildShowImageIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: showImageIndex,
      count: image.length,
      effect: SlideEffect(activeDotColor: Colors.green[200]!),
    );
  }

  List<Step> setSteps() {
    return [
      Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text("要找刊登案件還是刊登履歷?"),
          content: Container(
            child: Row(
              children: [
                Checkbox(
                    value: postCase,
                    onChanged: (bool? value) {
                      setState(() {
                        postCase = value!;
                        postResume = !value;
                      });
                    }),
                Text("刊登案件"),
                SizedBox(width: 20),
                Checkbox(
                    value: postResume,
                    onChanged: (bool? value) {
                      setState(() {
                        postCase = !value!;
                        postResume = value;
                      });
                    }),
                Text("刊登履歷"),
              ],
            ),
          )),
      Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: Text("設定標題"),
          content: Container(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: '標題名稱',
                  ),
                )
              ],
            ),
          )),
      Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: Text("寫點內容吸引人吧"),
          content: Container(
            child: Column(
              children: [
                TextFormField(
                  controller: contentController,
                  decoration: InputDecoration(
                    labelText: '內容',
                  ),
                )
              ],
            ),
          )),
      Step(
          title: Text("上傳照片"),
          content: Container(
            child: Column(
              children: [
                MaterialButton(color: Colors.blueGrey, child: Text("從相簿中挑選"), onPressed: pickImageFromGallery),
                SizedBox(height: 20),
                getImagePreview()
              ],
            ),
          )),
    ];
  }
}
