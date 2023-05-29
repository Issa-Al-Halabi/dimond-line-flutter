import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/source_destination_delayed_model.dart';
import 'package:diamond_line/Data/network/requests.dart';

class SourceDestinationDelayedProvider extends ChangeNotifier {
  SourceDestinationDelayedModel data = SourceDestinationDelayedModel();
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

  getSourceDistenationDelayed(String pickup_latitude, String pickup_longitude, 
  String drop_latitude, String drop_longitude, String km, String minutes,
  String date, String time) async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.sourceDestinationDelayedRequest(pickup_latitude, pickup_longitude, drop_latitude, drop_longitude, km, minutes, date, time);

    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
