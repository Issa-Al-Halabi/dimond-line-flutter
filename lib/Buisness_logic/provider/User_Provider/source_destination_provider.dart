import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/source_distenation_model.dart';
import 'package:diamond_line/Data/network/requests.dart';

class SourceDestinationProvider extends ChangeNotifier {
  SourceDistenationModel data = SourceDistenationModel();
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

  getSourceDistenation(String pickup_latitude, String pickup_longitude, String drop_latitude, String drop_longitude, String km, String minutes) async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.sourceDestinationRequest(pickup_latitude, pickup_longitude, drop_latitude, drop_longitude, km, minutes);

    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
