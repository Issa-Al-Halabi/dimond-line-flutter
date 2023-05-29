import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/send_otp_model.dart';
import 'package:diamond_line/Data/network/requests.dart';

class SendOtpProvider extends ChangeNotifier {
  SendOtpModel data = SendOtpModel();
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

  getSendOtp(String num, String request_from,  bool isUser) async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.sendOtpRequest(num, request_from, isUser);
    isLoading = false;
    notifyListeners();
  }
}
