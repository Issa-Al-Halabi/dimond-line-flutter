// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/cupertino.dart';
// import 'package:diamond_line/Data/Models/User_Models/id_register_model.dart';
// import 'package:diamond_line/Data/network/requests.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

// String tokenn = "";

// class IdRegisterProvider extends ChangeNotifier {
//   IdCardRegisterModel data = IdCardRegisterModel();
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

// //   getCreatAcount(
// //       String fname,
// //       String lname,
// //       String mother_name,
// //       String father_name,
// //       String phone,
// //       String password,
// //       String email,
// //       String id_entry,
// //       String national_number,
// //       String place_of_birth,
// //       String date_of_birth) async {
// //     print("getcreataccount provider");
// //     isLoading = true;
// //     // profile_image = await AppRequests.getImage(profile_image);
// //     // print(profile_image);
// //     // print(profile_image.runtimeType);
// //     data = await AppRequests.IdRegisterRequest(
// //         fname,
// //         lname,
// //         mother_name,
// //         father_name,
// //         phone,
// //         password,
// //         email,
// //         id_entry,
// //         national_number,
// //         place_of_birth,
// //         date_of_birth);
// //     // print(data.data!.apiToken.toString());
// //     // tokenn = data.data!.apiToken.toString();
// //     print("loaddding");

// //     isLoading = false;
// //     notifyListeners();
// //   }
// // //"0911111111"
// // // "1234567890"


// addphotoApi(
//       String fname,
//       String lname,
//       String mother_name,
//       String father_name,
//       String phone,
//       String password,
//       String email,
//       String id_entry,
//       String national_number,
//       String place_of_birth,
//       String date_of_birth,
//       File imageFile) async {


//    print("upload image provider");
//     isLoading = true;
//     data = await AppRequests.IdCardRegisteruploadImageRequest(
//         fname,
//         lname,
//         mother_name,
//         father_name,
//         phone,
//         password,
//         email,
//         id_entry,
//         national_number,
//         place_of_birth,
//         date_of_birth,
//         imageFile
//         );
//     // print(data.data!.apiToken.toString());
//     // tokenn = data.data!.apiToken.toString();
//     print("loaddding");
//     print(data.error);

//     isLoading = false;
//     notifyListeners();

//   }
// }

// //   addphotoApi(
// //       String fname,
// //       String lname,
// //       String mother_name,
// //       String father_name,
// //       String phone,
// //       String password,
// //       String email,
// //       String id_entry,
// //       String national_number,
// //       String place_of_birth,
// //       String date_of_birth,
// //       File imageFile) async {

// //     print("start send");
// //     var req = http.MultipartRequest('POST',
// //         Uri.parse('http://dimond-line.peaklinkdemo.com/api/user-registration')
// //         // Uri.parse('http://generalpos.fingerprint.ml/api/Category/AddCategory')
// //         );
// //     print("afterrrrrr");
// //     req.fields['first_name'] = fname;
// //     req.fields['last_name'] = lname;
// //     req.fields['mother_name'] = mother_name;
// //     req.fields['father_name'] = father_name;
// //     req.fields['phone'] = phone;
// //     req.fields['password'] = password;
// //     req.fields['email'] = email;
// //     req.fields['id_entry'] = id_entry;
// //     req.fields['national_number'] = national_number;
// //     req.fields['place_of_birth'] = place_of_birth;
// //     req.fields['date_of_birth'] = date_of_birth;
// //     print("path" + imageFile.path.split("/").last.toString());
// //     print('********************');
// //     print((imageFile.path).toString().split("/").last);

// //     if (imageFile.path != "") {
// //       print("imagefile not null");

// //       // var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
// //       // int length = imageBytes.length;

// //       var stream = new http.ByteStream(imageFile.openRead());
// //       var length = await imageFile.length();

// //       var multipartFile = new http.MultipartFile(
// //           'profile_image', stream, length,
// //           filename: (imageFile.path).toString().split("/").last);

// //       req.files.add(multipartFile);

// //      // // req.files.add(multipartFile);
// //       // var r = await req.send();
// //       // if (r.statusCode == 200) {
// //       //   print("sssecsess");
// //       //   print(req.url);
// //       //   print("*******rrrr********" + r.statusCode.toString());
// //       //   var response = r.stream.bytesToString();
// //       //   print("response" + response.toString());
// //       // }

// //       //////////////////
// //             var streamedResponse = await req.send();
// // var response = await http.Response.fromStream(streamedResponse);
// // print(response.body);
// // print(response.body.runtimeType);
// // print(response.runtimeType);

// //  if (streamedResponse.statusCode == 200) {
// //         print("sssecsess");
// //         print(req.url);
// //         print("*******rrrr********" + streamedResponse.statusCode.toString());
// //         // var response = streamedResponse.stream.bytesToString();
// //         // print("response" + response.toString());
// //         return IdCardRegisterModel.fromJson(json.decode(response.body));
// //         // return response;
// //       }
// // ////////////////////////
// //     } else {
// //       var r = await req.send();
// //       if (r.statusCode == 200) {
// //         print("sssecsess");
// //       }
// //     }
// //     notifyListeners();
// //     // // print("*******rrrr********" + r.statusCode.toString());
// //     // // var response = r.stream.bytesToString();
// //     // // print("response" + response.toString());
// //   }
// // }

// //  getCreatAcount(XFile image, String fname, String lname, String mother_name, String father_name,String phone, String password,
// //        String email, String id_entry, String national_number, String place_of_birth,
// //         String date_of_birth) async {
// //     print("getcreataccount provider");
// //     isLoading = true;
// //     // profile_image = await AppRequests.getImage(profile_image);
// //     // print(profile_image);
// //     // print(profile_image.runtimeType);
// //     data = await AppRequestsDio.uploadImage2(image, fname, lname, mother_name, father_name, phone, password, email, id_entry, national_number, place_of_birth, date_of_birth);
// //     // print(data.data!.apiToken.toString());
// //     // tokenn = data.data!.apiToken.toString();
// //     print("loaddding");

// //     isLoading = false;
// //     notifyListeners();
// //   }
// // //"0911111111"
// // // "1234567890"
// // }



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



    