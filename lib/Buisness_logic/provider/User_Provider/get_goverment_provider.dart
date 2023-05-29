import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/get_goverment_model.dart';
import 'package:diamond_line/Data/network/requests.dart';

class GetGovermentProvider extends ChangeNotifier {
  GetGovermentModel data = GetGovermentModel();
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

  getGoverment() async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.getGovermentRequest();
    print(data.message);
    print(data.error);
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
