import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:flutter/material.dart';

import '../../../Data/Models/User_Models/user_register_model.dart';

String tokenn = "";

class UserRegisterProvider extends ChangeNotifier {
  UerRegisterModel data = UerRegisterModel();
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

  getCreatAcount(String fname, String lname, String mother_name, String father_name,String phone, String password,
      String email, String place_of_birth,
      String date_of_birth, [File? imageFile]) async {
    print("getcreataccount provider");
    isLoading = true;
    if(imageFile != null){
      data = await AppRequests.UserRegisterRequest(fname, lname, mother_name, father_name, phone, password,email,
        place_of_birth,
        date_of_birth,
        imageFile
      );
    }
    else{
      data = await AppRequests.UserRegisterRequest(fname, lname, mother_name, father_name, phone, password,email,
        place_of_birth,
        date_of_birth,
        // imageFile!
      );
    }
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}