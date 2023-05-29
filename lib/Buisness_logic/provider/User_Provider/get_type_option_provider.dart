import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/get_type_option_Model.dart';
import 'package:diamond_line/Data/network/requests.dart';

class GetTypeOptionProvider extends ChangeNotifier {
  GetTypeOptionModel data = GetTypeOptionModel();
  late bool isLoading = true;
  late bool hasError = false;
  List featuresList=[];
  static late String token;
  
  changeIsLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void changeHasError() {
    hasError = !hasError;
    notifyListeners();
  }

  getTypeOption(String id) async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.getTypeOptionRequest(id);
    // print(data.message);
    featuresList = data.data!;
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}