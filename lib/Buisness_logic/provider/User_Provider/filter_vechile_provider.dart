import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/filter_vechile_model.dart';
import 'package:diamond_line/Data/network/requests.dart';

class filterVechileProvider extends ChangeNotifier {
  FilterVechileModel data = FilterVechileModel();
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

  getFilterVechilesCategory(String category_id, String subcategory_id, String seats, String bags, String distance, String time) async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.getFilterVechilesCategoryRequest(category_id, subcategory_id, seats, bags, distance, time);
    print(data.message);
    print(data.error);
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
