import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:flutter/material.dart';

import '../../../Data/Models/Driver_Models/driver_register_model.dart';

String tokenn = "";

class DriverRegisterProvider extends ChangeNotifier {
  DriverRegisterModel data = DriverRegisterModel();
  late bool isLoading = true;
  late bool hasError = false;
  changeIsLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void changeHasError() {
    hasError = !hasError;
    notifyListeners();
  }

  DriverCreatAcountwithphoto(
      String first_name,
      String last_name,
      String email,
      String password,
      String phone,
      [File? car_mechanic,
      File? car_insurance,]
      ) async {
    print("upload image provider");
    isLoading = true;
          if(car_mechanic != null && car_insurance != null){
    data = await AppRequests.DriverRegisteruploadImageRequest(
        first_name, last_name, email, password, phone, car_mechanic, car_insurance);
          }
          else if(car_mechanic != null){
    data = await AppRequests.DriverRegisteruploadImageRequest(
        first_name, last_name, email, password, phone, car_mechanic);
          }
          else if( car_insurance != null){
    data = await AppRequests.DriverRegisteruploadImageRequest(
        first_name, last_name, email, password, phone, car_insurance);
          }
          else{
                data = await AppRequests.DriverRegisteruploadImageRequest(
        first_name, last_name, email, password, phone);
          }
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
