import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/mentor_card_loading_state.dart';

class LoadingBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadingStatus = ref.watch(mentorCardLoadingProvider);

    return loadingStatus
      ? Center(
        child: SizedBox(
          width: 50.w,
          height: 50.w,
          child: CircularProgressIndicator(
            strokeWidth: 7.w,
          )
        )
      )
      : SizedBox.shrink();
  }

}