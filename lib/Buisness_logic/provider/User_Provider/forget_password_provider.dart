

import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/forget_password_model.dart';
import '../../../Data/network/requests.dart';
// import 'package:taxi/models/creat_acount_model.dart';
// import 'package:taxi/models/login_model.dart';
// import 'package:taxi/models/number_forget_model.dart';
// import 'package:taxi/models/update_profil_model.dart';
// import '../models/profil_model.dart';
// import '../network/requests.dart';

class ForgetPasswordProvider extends ChangeNotifier {
  ForgetPasswordModel data=ForgetPasswordModel();
  late bool isLoading = true;
  late bool hasError = false;
  changeIsLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }
  void changeHasError() {
    hasError = !hasError;
    notifyListeners();
  }
  
  getForgetPassword(String mobile, String pass, String confirmPass, bool isUser) async {
    print("getcreataccount provider");
    isLoading=true;
    // print("phhm");
    data = await AppRequests.ForgetPasswordRequest(mobile, pass, confirmPass, isUser);

    print("loaddding");

    isLoading = false;
    notifyListeners();
  }
}