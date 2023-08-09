import 'package:mentor_app_flutter/features/signin/constants/user_info_fill_in_status.dart';

import '../../../sharedPrefs/userPrefs.dart';

class UserStatusService {
  Future<bool> isLoggedIn() async {
    return await UserPrefs.checkExistUserId();
  }

  Future<bool> hasFillInInfo() async {
    String userFillInStatus = await UserPrefs.getUserInfoFillInStatus();
    return userFillInStatus == UserInfoFillInStatus.Done;
  }
}