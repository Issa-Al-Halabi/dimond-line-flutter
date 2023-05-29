import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/get_user_trips_model.dart';
import 'package:diamond_line/Data/network/requests.dart';

class GetUserTripsProvider extends ChangeNotifier {
  GetUserTripsModel data = GetUserTripsModel();
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

  getUserTrips() async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.getUserTripsRequest();
    // print(data.message);
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
