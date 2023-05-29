import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/send_otp_email_model.dart';
import 'package:diamond_line/Data/network/requests.dart';

class SendOtpEmailProvider extends ChangeNotifier {
  SendOtpEmailModel data = SendOtpEmailModel();
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

  getSendOtpEmail(String email) async {
    print("layan Test");
    isLoading = true;
    print('email'+email.toString());
    print("phhm");
    data = await AppRequests.sendOtpEmailRequest(email);
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
