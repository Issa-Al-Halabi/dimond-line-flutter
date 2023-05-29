import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/network/requests.dart';
import '../../../Data/Models/Driver_Models/driver_complete_register_model.dart';

class DriverCompleteRegisterProvider extends ChangeNotifier {
  DriverCompleteRegisterModel data = DriverCompleteRegisterModel();
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

  driverCompleteRegister( [File? car_image,
      File? personal_identity,
      File? driving_certificate,]
      ) async {
    print("layan Test");
    isLoading = true;
           if (car_image != null && personal_identity != null) {
    data = await AppRequests.DriverCompleteRegisteruploadImageRequest(car_image, personal_identity, driving_certificate);
           }

           else  if (car_image != null) {
    data = await AppRequests.DriverCompleteRegisteruploadImageRequest(car_image, driving_certificate);
           }

           else  if (personal_identity != null) {
    data = await AppRequests.DriverCompleteRegisteruploadImageRequest(personal_identity, driving_certificate);
           }

           else {
    data = await AppRequests.DriverCompleteRegisteruploadImageRequest(driving_certificate);
           }
    // print(data.message);
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
