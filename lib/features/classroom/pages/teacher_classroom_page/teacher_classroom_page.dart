import 'package:flutter/material.dart';
import 'package:mentor_app_flutter/features/classroom/pages/teacher_classroom_page/components/bottom_btns.dart';

import 'components/teacher_class_video.dart';

class TeacherClassroomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children:[
          TeacherClassVideo(),
          BottomBtns()
        ]
      )
    );
  }
}