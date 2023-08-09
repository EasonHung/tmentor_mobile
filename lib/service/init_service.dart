import '../features/signin/constants/user_info_fill_in_status.dart';
import '../sharedPrefs/userPrefs.dart';

class InitService {
  static Future<String> checkLoginStatusAndDecideRootPath() async {
    if(await UserPrefs.checkExistUserId()) {
      if(await UserPrefs.getUserInfoFillInStatus() == UserInfoFillInStatus.NotYet) {
        return "/guide";
      }
      return "/";
    }
    return "/login";
  }
}