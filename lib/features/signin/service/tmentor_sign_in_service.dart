import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mentor_app_flutter/apiManager/errorCode.dart';
import 'package:mentor_app_flutter/apiManager/userApiManager.dart';
import 'package:mentor_app_flutter/main.dart';
import 'package:mentor_app_flutter/service/toast_service.dart';

import '../../../apiManager/user_api_dto/res/create_user_res.dart';
import '../../../sharedPrefs/userPrefs.dart';
import '../constants/user_info_fill_in_status.dart';
import '../constants/user_status.dart';

class TMentorSignInService {
  Future<void> signIn(GoogleSignInAccount account) async {
    if(hasLoggedIn)
      return;

  }

  Future<bool> loginToUserSystemAndCheckIsFirstLogin(GoogleSignInAccount account) async {
    if (hasLoggedIn) return false;
    var googleAuthentication = await account.authentication;

    var responseBody;
    try {
      responseBody = await userApiManager.loginByThirdParty(account.id, googleAuthentication.accessToken!);
      hasLoggedIn = true;
    } on DioError catch (e) {
      // todo: error handling
      if (e.error == "Http status error [401]") {
        CreateUserRes res = await userApiManager.createNewUser(account.displayName, account.email, account.photoUrl, account.id);
        await Future.delayed(Duration(seconds: 2));
        if(res.code != ApiErrorCode.SUCCESS) {
          ToastService.showAlert(res.message!);
          throw e;
        }

        return await loginToUserSystemAndCheckIsFirstLogin(account);
      } else {
        throw e;
      }
    }

    await UserPrefs.setUserIdToken(responseBody["data"]["userId"], responseBody["data"]["accessToken"]);
    await UserPrefs.setUserRefreshToken(responseBody["data"]["userId"], responseBody["data"]["refreshToken"]);
    await userApiManager.insertFcmToken(await firebaseMessaging.getToken());
    String userStatus = responseBody["data"]["userStatus"];
    if (userStatus == UserStatus.INITIAL) {
      await UserPrefs.setUserInfoFillInStatus(UserInfoFillInStatus.NotYet);
      return true;
    } else {
      await UserPrefs.setUserInfoFillInStatus(UserInfoFillInStatus.Done);
      return false;
    }
  }
}