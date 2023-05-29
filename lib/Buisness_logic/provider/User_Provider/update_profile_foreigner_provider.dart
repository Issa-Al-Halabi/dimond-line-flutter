import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/update_profile_foreigner_model.dart';
import 'package:diamond_line/Data/network/requests.dart';


class UpdateProfileForeignerProvider extends ChangeNotifier {
  UpdateProfileForeignerModel data=UpdateProfileForeignerModel();
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
  // getUpdateProfileForeigner(String first_name, String last_name, String email, String password, String passport_number,
  // //  String profile_image,
  //       // File profile_image
  //       ) async {
  //   print("updateprofile");
  //   isLoading=true;
  //  // print("phhm");
  //   data = await AppRequests.UpdateProfileForeignerRequest(first_name,  last_name,  email,  password,
  //   passport_number,
  //   // profile_image,
  //         // profile_image
  //         );
  // //  print(data.data!.firstName);
  //   print("loaddding");
  //   isLoading = false;
  //   notifyListeners();
  // }

  getUpdateProfileForeigner(String first_name, String last_name, String email, String password,
      //  String profile_image,
      [File? profile_image]
      ) async {
    print("updateprofile");
    isLoading=true;
    // print("phhm");
            if(profile_image != null){

    data = await AppRequests.UpdateProfileForeignerRequest(first_name,  last_name,  email,  password,
      profile_image,
      // profile_image
    );
            }
            else{
               data = await AppRequests.UpdateProfileForeignerRequest(first_name,  last_name,  email,  password,
    );
            }
    //  print(data.data!.firstName);
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}