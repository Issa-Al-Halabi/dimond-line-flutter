import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/login_model.dart';
import '../../../Data/network/requests.dart';

class LogInProvider extends ChangeNotifier {
  LoginModel data = LoginModel();
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

  getLogin(String num, String password, bool isUser) async {
    print("LayanTest");
    isLoading=true;
    data = await AppRequests.LoginRequest(num, password, isUser);
    print('Dataaaaaaa');
    print(data);
    // print(data.data!.apiToken);
    // token=data.data!.apiToken!;
    print("loaddding");
    // print(token);
    isLoading = false;
    notifyListeners();
  }
}