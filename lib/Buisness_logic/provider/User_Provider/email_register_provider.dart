import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/email_register_model.dart';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:flutter/material.dart';

String tokenn = "";

class EmailRegisterProvider extends ChangeNotifier {
  EmailRegisterModel data = EmailRegisterModel();
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

  // EmailgetCreatAcount(String first_name, String last_name, String email,
  //     String password, String profile_image, String passport_number) async {
  //   print("getcreataccountemail provider");
  //   isLoading = true;
  //   data = await AppRequests.EmailRegisterRequest(
  //       first_name, last_name, email, password, profile_image, passport_number);
  //   print("loaddding");
  //   isLoading = false;
  //   notifyListeners();
  // }

  // EmailCreatAcountwithphoto(
  //     String first_name,
  //     String last_name,
  //     String email,
  //     String password,
  //     String passport_number,
  //     File imageFile) async {
  //   print("upload image provider");
  //   isLoading = true;
  //   data = await AppRequests.EmailRegisteruploadImageRequest(
  //       first_name, last_name, email, password, passport_number, imageFile);
  //   // print(data.data!.apiToken.toString());
  //   // tokenn = data.data!.apiToken.toString();
  //   print("loaddding");
  //   isLoading = false;
  //   notifyListeners();
  // }

  EmailCreatAcountwithphoto(
      String first_name,
      String last_name,
      String email,
      String password,
     [File? imageFile]
      ) async {
    print("upload image provider");
    isLoading = true;
    if(imageFile != null) {
      data = await AppRequests.EmailRegisteruploadImageRequest(
          first_name, last_name, email, password,
          imageFile);
    }
    else{
      data = await AppRequests.EmailRegisteruploadImageRequest(
          first_name, last_name, email, password,
          // imageFile
      );
    }
    // print(data.data!.apiToken.toString());
    // tokenn = data.data!.apiToken.toString();
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
