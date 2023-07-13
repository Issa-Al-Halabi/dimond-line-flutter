import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/network/requests.dart';
import '../../../Data/Models/User_Models/InitUserTripsModel.dart';

class InitUserTripsProvider extends ChangeNotifier {
  InitUserTripsModel data = InitUserTripsModel();
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

  getInitTrips() async {
    isLoading = true;
    data = await AppRequests.getInitUserTripsRequest();
    isLoading = false;
    notifyListeners();
  }
}
