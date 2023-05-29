import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/network/requests.dart';
import '../../../Data/Models/Driver_Models/DriverEfficientTripsModel.dart';

class DriverOutcityTripsProvider extends ChangeNotifier {
  DriverEfficientTripsModel data = DriverEfficientTripsModel();
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

  getDriverEfficirntTrips() async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.driverEfficientTripsRequest();
    // print(data.message);
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
