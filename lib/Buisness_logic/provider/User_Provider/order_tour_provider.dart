import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/order_tour_model.dart';
import 'package:diamond_line/Data/network/requests.dart';

class OrderTourProvider extends ChangeNotifier {
  OrderTourModel data = OrderTourModel();
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

  orderTour(String trip_id, String start_time, String end_time) async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.orderTourRequest(trip_id, start_time, end_time);
    print(data.message.toString());
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
