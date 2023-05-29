// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:diamond_line/Data/network/requests.dart';
// import 'package:flutter/material.dart';

// import '../../../Data/Models/User_Models/user_register_model.dart';

// String tokenn = "";

// class PassportNumberRegisterProvider extends ChangeNotifier {
//   UerRegisterModel data = UerRegisterModel();
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

// //   getCreatAcountPassport(String fname, String lname, String mother_name, String father_name,String phone, String password,
// //        String email, String passport_number, String place_of_birth,
// //         String date_of_birth, File imageFile) async {
// //     print("getcreataccount provider");
// //     isLoading = true;
// //     // profile_image = await AppRequests.getImage(profile_image);
// //     // print(profile_image);
// //     // print(profile_image.runtimeType);
// //     data = await AppRequests.PassportRegisterRequest(fname, lname, mother_name, father_name, phone, password,email,
// //      passport_number, place_of_birth,
// //     date_of_birth, imageFile);
// //     // print(data.data!.apiToken.toString());
// //     // tokenn = data.data!.apiToken.toString();
// //     print("loaddding");
// //
// //     isLoading = false;
// //     notifyListeners();
// //   }
// // //"0911111111"
// // // "1234567890"
// // }


//   getCreatAcountPassport(String fname, String lname, String mother_name, String father_name,String phone, String password,
//       String email, String place_of_birth,
//       String date_of_birth, File imageFile) async {
//     print("getcreataccount provider");
//     isLoading = true;
//     // profile_image = await AppRequests.getImage(profile_image);
//     // print(profile_image);
//     // print(profile_image.runtimeType);
//     data = await AppRequests.UserRegisterRequest(fname, lname, mother_name, father_name, phone, password,email,
//         place_of_birth,
//         date_of_birth, imageFile);
//     // print(data.data!.apiToken.toString());
//     // tokenn = data.data!.apiToken.toString();
//     print("loaddding");

//     isLoading = false;
//     notifyListeners();
//   }
// //"0911111111"
// // "1234567890"
// }



// // getCreatAcount(String fname, String lname, String mother_name, String father_name,String phone, String password,
// //        String email, String id_entry, String national_number, String place_of_birth,
// //         String date_of_birth, 
// //         File profile_image
// //         ) async {
// //     print("dddd");
// //       var req = http.MultipartRequest(
// //           'POST', Uri.parse('http://dimond-line.peaklinkdemo.com/api/user-registration')
// //       );
// //       print("ssss");
// //       req.fields['first_name'] = fname;
// //       req.fields['last_name'] = lname;
// //       req.fields['mother_name'] = mother_name;
// //       req.fields['father_name'] = father_name;
// //       req.fields['phone'] = phone;
// //       req.fields['password'] = password;
// //       req.fields['email'] = email;
// //       req.fields['id_entry'] = id_entry;
// //       req.fields['national_number'] = national_number;
// //       req.fields['place_of_birth'] = place_of_birth;
// //       req.fields['date_of_birth'] = date_of_birth;
// //       print("path" + profile_image.path
// //           .split("/")
// //           .last
// //           .toString());
// //       if (profile_image.path != "") {
// //         print("fffff");

// //         // var stream = new http.ByteStream(
// //         //     DelegatingStream.typed(profile_image.openRead()));
// //         var stream = new http.ByteStream(profile_image.openRead());
// //         print(stream);
// //         // int length = imageBytes.length;
// //         var length = await profile_image.length();
// //         print(length);
// //         var multipartFile = new http.MultipartFile(
// //             'profile_image', stream, length, filename: (profile_image.path)
// //             .toString()
// //             .split("/")
// //             .last);

// //         print(multipartFile);

// //         req.files.add(multipartFile);
// //         var r = await req.send();
// //         var response = r.stream.bytesToString();
// //     print("response" + response.toString());

// //         if (r.statusCode == 200) {
// //           print("sssecsess");
// //         }
// //       } else {
// //         print('not success');
// //         // var r = await req.send();
// //         // if (r.statusCode == 200) {
// //         //   print("sssecsess");
// //         // }
// //       }
// //       notifyListeners();
// //     }
//     // // print("*******rrrr********" + r.statusCode.toString());
//     // // var response = r.stream.bytesToString();
//     // // print("response" + response.toString());