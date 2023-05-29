import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/Models/User_Models/update_profile_model.dart';
import 'package:diamond_line/Data/network/requests.dart';

class UpdateProfileProvider extends ChangeNotifier {
  UpdateProfileModel data = UpdateProfileModel();
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

  getUpdateProfile(
      String fname,
      String lname,
      String mother_name,
      String father_name,
      String phone,
      String password,
      String email,
      String place_of_birth,
      String date_of_birth,
      [File? profile_image]) async {
    isLoading = true;
    if (profile_image != null) {
      data = await AppRequests.UpdateProfilRequest(
          fname,
          lname,
          mother_name,
          father_name,
          phone,
          password,
          email,
          place_of_birth,
          date_of_birth,
          profile_image);
    } else {
      data = await AppRequests.UpdateProfilRequest(fname, lname, mother_name,
          father_name, phone, password, email, place_of_birth, date_of_birth);
    }
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }

  getUpdateDriverProfile(
      String fname,
      String lname,
      String phone,
      String email,
      String date_of_birth,
      [File? profile_image]) async {
    isLoading = true;
    if (profile_image != null) {
      data = await AppRequests.UpdateProfilDriverRequest(
          fname,
          lname,
          phone,
          email,
          date_of_birth,
          profile_image);
    } else {
      data = await AppRequests.UpdateProfilDriverRequest(fname, lname, phone, email, date_of_birth);
    }
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}