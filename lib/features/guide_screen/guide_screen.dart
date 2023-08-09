import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mentor_app_flutter/features/guide_screen/controller/about_me_controller.dart';
import 'package:mentor_app_flutter/features/guide_screen/controller/avatar_controller.dart';
import 'package:mentor_app_flutter/features/guide_screen/controller/education_controller.dart';
import 'package:mentor_app_flutter/features/guide_screen/controller/guide_exit_controller.dart';
import 'package:mentor_app_flutter/features/guide_screen/controller/field_controller.dart';
import 'package:mentor_app_flutter/features/guide_screen/controller/job_experience_controller.dart';
import 'package:mentor_app_flutter/features/guide_screen/controller/skill_controller.dart';
import 'package:mentor_app_flutter/features/guide_screen/pages/add_education_page.dart';
import 'package:mentor_app_flutter/features/guide_screen/pages/add_job_experience_page.dart';
import 'package:mentor_app_flutter/features/guide_screen/pages/add_skill_page.dart';
import 'package:mentor_app_flutter/features/guide_screen/pages/complete_page.dart';
import 'package:mentor_app_flutter/features/guide_screen/pages/field_selection_page.dart';
import 'package:mentor_app_flutter/features/guide_screen/pages/input_about_me_page.dart';
import 'package:mentor_app_flutter/features/guide_screen/pages/select_gender_page.dart';
import 'package:mentor_app_flutter/features/guide_screen/pages/upload_avatar_page.dart';
import 'package:mentor_app_flutter/features/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../apiManager/userApiManager.dart';
import '../../color_constants.dart';
import '../../utils/date_util.dart';
import '../../vo/mentor_item.dart';
import 'component/skip_button.dart';
import 'controller/gender_controller.dart';
import 'controller/step_controller.dart';
import 'controller/nickname_and_profession_controller.dart';
import 'pages/input_name_page.dart';
import 'component/next_step_button.dart';
import 'controller/user_guide_controller.dart';

class GuideScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GuideScreenState();
  }
}

class GuideScreenState extends State<GuideScreen> {
  late UserGuideController userGuideController;
  late StepController stepController;
  late SkillController skillController;
  late JobExperienceController jobExperienceController;
  late GuideExitController exitController;
  List<JobExperience> jobExperiences = [];
  List<Education> educationList = [];
  List<String> skillList = [];
  List<String> genderList = ["男", "女", "雙"];
  String? selectedGender = "男";
  List<String> fields = ["家教","資訊", "設計", "商業/管理", "行銷/企劃", "運動/營養", "多媒體", "藝術", "人文"];
  String selectedFields = "資訊";
  File? selectedAvatar;
  File? selectedPicture;
  bool isFirstPage = true;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    stepController = Get.put<StepController>(StepController());
    Get.put<NicknameAndProfessionController>(NicknameAndProfessionController());
    Get.put<GenderController>(GenderController());
    Get.put<AvatarController>(AvatarController());
    Get.put<FieldController>(FieldController());
    Get.put<AboutMeController>(AboutMeController());
    skillController = Get.put<SkillController>(SkillController());
    jobExperienceController = Get.put<JobExperienceController>(JobExperienceController());
    exitController = Get.put<GuideExitController>(GuideExitController());
    Get.put<EducationController>(EducationController());
    userGuideController = Get.put<UserGuideController>(UserGuideController());
  }

  @override
  void dispose() {
    Get.delete<UserGuideController>();
    Get.delete<NicknameAndProfessionController>();
    Get.delete<StepController>();
    Get.delete<GenderController>();
    Get.delete<FieldController>();
    Get.delete<AvatarController>();
    Get.delete<AboutMeController>();
    Get.delete<SkillController>();
    Get.delete<JobExperienceController>();
    Get.delete<EducationController>();
    Get.delete<GuideExitController>();
    super.dispose();
  }

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userToken");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          jobExperienceController.cleanFocus();
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
            skillController.skillInputFocus.value = false;
          }
        },
        child: WillPopScope(
          onWillPop: exitController.doubleCheckExit,
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                children: [
                  Expanded(
                    child: Container(
                      child: PageView(
                        controller: stepController.pageController,
                        physics: NeverScrollableScrollPhysics(),
                        onPageChanged: (index) {
                          stepController.changeSkipBtnStatusByPage(index);
                          stepController.changeBottomBtnStatusByPage(index);
                          stepController.checkIsLastPage(index);
                        },
                        children: [
                          InputNamePage(),
                          SelectGenderPage(),
                          UploadAvatarPage(),
                          FieldSelectionPage(),
                          InputAboutMePage(),
                          AddSkillPage(),
                          AddJobExperiencePage(),
                          AddEducationPage(),
                          GuideCompletePage()
                        ],
                      )
                    )
                  ),
                  Obx(() => stepController.showBottomBtn.value? Container(
                    margin: EdgeInsets.only(bottom: stepController.showSkipBtn.value? ScreenUtil().setHeight(0) : ScreenUtil().setHeight(20)),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        NextStepBtn(),
                        SkipBtn()
                      ]
                    )
                  ) : SizedBox.shrink()),
                ]
              ),
              // 必須放在最後一層，不然感知不到 gesture event
              BackButton(
                onPressed: stepController.goBackLastPage,
              ),
            ]
          ),
        )
      )
    )
    );
  }
}