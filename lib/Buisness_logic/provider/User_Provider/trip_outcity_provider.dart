import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/trip_out_city_model.dart';
import 'package:diamond_line/Data/network/requests.dart';

class TripOutCityProvider extends ChangeNotifier {
  TripOutCityModel data = TripOutCityModel();
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

  getTripOutcity(String pickup_latitude, String pickup_longitude, String drop_latitude, String drop_longitude,
  String category_id, String subcategory_id, String km, String minutes,  String vehicle_id,
      String time, String date, String bags, String seats, String direction,
      String from,
      String to) async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.getTripOutcityRequest(pickup_latitude, pickup_longitude, drop_latitude, drop_longitude, category_id, subcategory_id,
    km, minutes, vehicle_id, time, date, bags, seats, direction, from, to);
    print(data.message);
    print(data.error);
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
