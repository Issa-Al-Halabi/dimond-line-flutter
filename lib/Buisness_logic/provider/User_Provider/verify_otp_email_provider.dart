import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/verify_otp_email_model.dart';
import 'package:diamond_line/Data/Models/User_Models/verify_otp_model.dart';
import 'package:diamond_line/Data/network/requests.dart';

class VerifyOtpEmailProvider extends ChangeNotifier {
  VerifyOtpEmailModel data = VerifyOtpEmailModel();
  late bool isLoading = true;
  late bool hasError = false;
  static late String token;
  changeIsLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void changeHasError() {
    hasError = !hasError;
    notifyListeners();
  }

  getVerifyOtpEmailCode(String email, String code) async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.verifyOtpEmailRequest(email, code);
    print(data.message.toString());
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
