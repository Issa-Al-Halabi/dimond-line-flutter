import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/email_login_model.dart';
import '../../../Data/network/requests.dart';

class EmailLogInProvider extends ChangeNotifier {
  EmailLoginModel data = EmailLoginModel();
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

  getEmailLogin(String email, String password) async {
    print("LayanTest");
    isLoading=true;
    data = await AppRequests.EmailLoginRequest(email, password );
    print(data);
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}