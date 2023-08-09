import 'package:flutter/material.dart';
import 'package:mentor_app_flutter/features/classroom/pages/my_classroom_page/components/bottom_btns.dart';

import 'components/class_video.dart';

class MyClassroomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children:[
          ClassVideo(),
          BottomBtns()
        ]
      )
    );
  }
}