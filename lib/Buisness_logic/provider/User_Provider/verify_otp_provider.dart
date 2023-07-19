import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/verify_otp_model.dart';
import 'package:diamond_line/Data/network/requests.dart';

class VerifyOtpProvider extends ChangeNotifier {
  VerifyOtpModel data = VerifyOtpModel();
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

  getVerifyOtpCode(String mobile, String code) async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.verifyOtpRequest(mobile, code);
    print(data.message.toString());
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
