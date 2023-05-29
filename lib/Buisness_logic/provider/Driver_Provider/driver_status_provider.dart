import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/network/requests.dart';
import '../../../Data/Models/Driver_Models/driver_status_model.dart';

class DriverStatusProvider extends ChangeNotifier {
  DriverStatusModel data = DriverStatusModel();
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

  driverStatus() async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.getDriverStatusRequest();
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
