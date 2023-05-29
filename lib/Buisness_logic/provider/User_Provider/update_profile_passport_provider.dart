// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:diamond_line/Data/Models/User_Models/update_profile_model.dart';
// import 'package:diamond_line/Data/Models/User_Models/update_profile_passport_model.dart';
// import 'package:diamond_line/Data/network/requests.dart';


// class UpdateProfilePassportProvider extends ChangeNotifier {
//   UpdateProfilePassportModel data=UpdateProfilePassportModel();
//   late bool isLoading = true;
//   late bool hasError = false;
//   changeIsLoading() {
//     isLoading = !isLoading;
//     notifyListeners();
//   }
//   void changeHasError() {
//     hasError = !hasError;
//     notifyListeners();
//   }
//   getUpdateProfilePassport(String fname, String lname, String mother_name, String father_name,String phone, String password,
//        String email, String passport_number,String place_of_birth,
//         String date_of_birth, 
//         // File profile_image
//         ) async {
//     print("updateprofile");
//     isLoading=true;
//    // print("phhm");
//     data = await AppRequests.UpdateProfilePassportRequest(fname,  lname,  mother_name,  father_name, phone,  password,
//         email,  passport_number,  place_of_birth,
//          date_of_birth, 
//           // profile_image
//           );
//   //  print(data.data!.firstName);
//     print("loaddding");
//     isLoading = false;
//     notifyListeners();
//   }
// }