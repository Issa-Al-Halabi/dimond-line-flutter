import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/get_profile_model.dart';
import 'package:diamond_line/Data/network/requests.dart';

class ProfilProvider extends ChangeNotifier {
  GetProfileModel data = GetProfileModel();
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

  getProfil() async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.getProfilRequest();
    print(data.message);
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
