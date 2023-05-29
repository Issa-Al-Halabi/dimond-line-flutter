import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/network/requests.dart';
import '../../../Data/Models/User_Models/user_orders_model.dart';

class UserOrderProvider extends ChangeNotifier {
  UserOrdersModel data = UserOrdersModel();
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

  getUserOrders() async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.getUserOrdersRequest();
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}