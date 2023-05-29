import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/Driver_Models/driver_trips_model.dart';
import 'package:diamond_line/Data/network/requests.dart';

class GetDriverTripsProvider extends ChangeNotifier {
  GetDriverTripsModel data = GetDriverTripsModel();
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

  getDriverTrips() async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.getDriverTripsRequest();
    // print(data.message);
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
