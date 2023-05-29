import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/get_sub_category_model.dart';
import 'package:diamond_line/Data/network/requests.dart';

class GetSubTripCategoryProvider extends ChangeNotifier {
  GetSubCategoryModel data = GetSubCategoryModel();
  late bool isLoading = true;
  late bool hasError = false;
  static late String token;
  List<GetSubCategoryModel> trips=[];
  
  changeIsLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void changeHasError() {
    hasError = !hasError;
    notifyListeners();
  }

  getSubTripCategory(String category_id) async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.getSubTripCategoryRequest(category_id);
    // print(data.message);
    // print(data.data!.phone);
    // print(data.name);
    print(trips.length.toString());
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
