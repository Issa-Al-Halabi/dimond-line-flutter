import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/forget_password_email_model.dart';
import '../../../Data/network/requests.dart';

class ForgetPasswordEmailProvider extends ChangeNotifier {
  ForgetPasswordEmailModel data=ForgetPasswordEmailModel();
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
  
  getForgetPassword(String email, String pass, String confirmPass) async {
    isLoading=true;
    data = await AppRequests.ForgetPasswordEmailRequest(email, pass, confirmPass);
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}