import 'package:flutter/material.dart';

import '../component/my_points.dart';
import '../component/stored_points_case_list.dart';

class PointsInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyPoints(),
            StoredPointsCaseList()
          ],
        )
    );
  }

}