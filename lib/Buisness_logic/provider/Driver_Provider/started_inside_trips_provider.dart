import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/network/requests.dart';
import '../../../Data/Models/Driver_Models/started_inside_trips_model.dart';

class StartedInsideTripsProvider extends ChangeNotifier {
  StartedInsideTripsModel data = StartedInsideTripsModel();
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

  startedTrips() async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.getStartedTripsRequest();
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
