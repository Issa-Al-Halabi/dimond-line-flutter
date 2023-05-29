import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/network/requests.dart';
import '../../../Data/Models/User_Models/NearestCarsMapModel.dart';

class NearestCarsMapProvider extends ChangeNotifier {
  NearestCarsMapModel data = NearestCarsMapModel();
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

  getNearestCarMap(String lat, String lng) async {
    isLoading = true;
    data = await AppRequests.nearestCarMapRequest(lat, lng);
    isLoading = false;
    notifyListeners();
  }
}
