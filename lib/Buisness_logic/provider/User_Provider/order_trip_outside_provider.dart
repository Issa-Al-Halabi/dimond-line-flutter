import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/order_trip_outside_model.dart';
import 'package:diamond_line/Data/network/requests.dart';

class OrderTripOutsideProvider extends ChangeNotifier {
  OrderTripOutsideModel data = OrderTripOutsideModel();
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

  getOrderTrip(String vehicle_id, String category_id, String subcategory_id, String person, String bags, String time, String date, String direction) async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.orderTripRequest(vehicle_id, category_id, subcategory_id, person, bags, time, date, direction);
    print(data.message.toString());
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
