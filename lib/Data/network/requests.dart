import 'dart:convert';
import 'dart:io';
import 'package:diamond_line/Data/Models/Driver_Models/driver_trips_model.dart';
import 'package:diamond_line/Data/Models/User_Models/email_login_model.dart';
import 'package:diamond_line/Data/Models/User_Models/email_register_model.dart';
import 'package:diamond_line/Data/Models/User_Models/filter_vechile_model.dart';
import 'package:diamond_line/Data/Models/User_Models/forget_password_email_model.dart';
import 'package:diamond_line/Data/Models/User_Models/get_goverment_model.dart';
import 'package:diamond_line/Data/Models/User_Models/get_sub_category_model.dart';
import 'package:diamond_line/Data/Models/User_Models/get_type_option_Model.dart';
import 'package:diamond_line/Data/Models/User_Models/get_user_trips_model.dart';
import 'package:diamond_line/Data/Models/User_Models/login_model.dart';
import 'package:diamond_line/Data/Models/User_Models/forget_password_model.dart';
import 'package:diamond_line/Data/Models/User_Models/get_profile_model.dart';
import 'package:diamond_line/Data/Models/User_Models/id_register_model.dart';
import 'package:diamond_line/Data/Models/User_Models/order_tour_model.dart';
import 'package:diamond_line/Data/Models/User_Models/order_trip_outside_model.dart';
import 'package:diamond_line/Data/Models/User_Models/passport_number_register_model.dart';
import 'package:diamond_line/Data/Models/User_Models/send_otp_email_model.dart';
import 'package:diamond_line/Data/Models/User_Models/send_otp_model.dart';
import 'package:diamond_line/Data/Models/User_Models/source_destination_delayed_model.dart';
import 'package:diamond_line/Data/Models/User_Models/source_distenation_model.dart';
import 'package:diamond_line/Data/Models/User_Models/trip_out_city_model.dart';
import 'package:diamond_line/Data/Models/User_Models/update_profile_foreigner_model.dart';
import 'package:diamond_line/Data/Models/User_Models/update_profile_model.dart';
import 'package:diamond_line/Data/Models/User_Models/update_profile_passport_model.dart';
import 'package:diamond_line/Data/Models/User_Models/verify_otp_email_model.dart';
import 'package:diamond_line/Data/Models/User_Models/verify_otp_model.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../Models/Driver_Models/ChargeWalletModel.dart';
import '../Models/Driver_Models/CheckPaymentStatusModel.dart';
import '../Models/Driver_Models/CreatePaymentIdModel.dart';
import '../Models/Driver_Models/DriverEfficientTripsModel.dart';
import '../Models/Driver_Models/driver_complete_register_model.dart';
import '../Models/Driver_Models/driver_register_model.dart';
import '../Models/Driver_Models/driver_status_model.dart';
import '../Models/Driver_Models/payment_model.dart';
import '../Models/Driver_Models/trip_payment_model.dart';
import '../Models/User_Models/InitUserTripsModel.dart';
import '../Models/User_Models/NearestCarsMapModel.dart';
import '../Models/User_Models/UserOrdersModel.dart';
import '../Models/User_Models/user_register_model.dart';
import '../util/request_type.dart';
import 'network_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class AppRequests {
  static network_client client = network_client(Client());
  static late String? token;
  static late String? user_id;
  static late String? type_of_customer;
  static late String? deviceNumber;
  static late String? fcm_token;

  ///login
  static Future<LoginModel> LoginRequest(
      String phone, String password, bool isUser) async {
    print("Login phone" + phone);
    print("Login password" + password);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fcm_token = prefs.getString('fcm_token') ?? '';
    String user_type = '';
    if (isUser == true) {
      user_type = 'user';
    } else {
      user_type = 'driver';
    }
    print('*********************************');
    print(user_type);
    print(fcm_token);

    final response = await client.request(
        requestType: RequestType.POST,
        path: "api/user-login",
        parameter: {
          "phone": phone,
          "password": password,
          "device_token": fcm_token,
          // "user_type": "user"
          "user_type": user_type
        });
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      if (LoginModel.fromJson(json.decode(response.body)).error == false) {
        token = LoginModel.fromJson(json.decode(response.body)).data!.apiToken;
        prefs.setString('token', token!);
        user_id =
            LoginModel.fromJson(json.decode(response.body)).data!.id.toString();
        prefs.setString('user_id', user_id!);
        type_of_customer =
            LoginModel.fromJson(json.decode(response.body)).data!.type;
        prefs.setString('type_of_customer', type_of_customer!);
        // if(type_of_customer == 'external_driver' || type_of_customer == 'driver'){
        //   deviceNumber = LoginModel.fromJson(json.decode(response.body)).data!.deviceNumber;
        // prefs.setString('deviceNumber', deviceNumber!);
        // }
        return LoginModel.fromJson(json.decode(response.body));
      } else {
        return LoginModel.fromJson(json.decode(response.body));
      }
    } else {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status NOT 200");
      return LoginModel.fromJson(json.decode(response.body));
    }
  }

  ///login with email
  static Future<EmailLoginModel> EmailLoginRequest(
      String email, String password) async {
    print("Login fetch email register" + email);
    print("Login fetch password register" + password);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fcm_token = prefs.getString('fcm_token') ?? '';

    // String user_type = '';
    // if(isUser == true){
    //   user_type = 'user';
    // }
    // else{
    //   user_type = 'driver';
    // }
    // print('*********************************');
    // print(user_type);

    final response = await client.request(
        requestType: RequestType.POST,
        path: "api/userforiegn-login",
        parameter: {
          "email": email,
          "password": password,
          "device_token": fcm_token,
          // "user_type" : user_type,
          "user_type": "user"
        });
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      if (EmailLoginModel.fromJson(json.decode(response.body)).error == false) {
        token =
            EmailLoginModel.fromJson(json.decode(response.body)).data!.apiToken;
        print(token);
        prefs.setString('token', token!);
        user_id = EmailLoginModel.fromJson(json.decode(response.body))
            .data!
            .id
            .toString();
        prefs.setString('user_id', user_id!);
        type_of_customer =
            EmailLoginModel.fromJson(json.decode(response.body)).data!.userType;
        prefs.setString('type_of_customer', type_of_customer!);
        //  if(type_of_customer == 'external_driver' || type_of_customer == 'driver'){
        //   deviceNumber = EmailLoginModel.fromJson(json.decode(response.body)).data!.deviceNumber;
        // prefs.setString('deviceNumber', deviceNumber!);
        // }
        return EmailLoginModel.fromJson(json.decode(response.body));
      } else {
        return EmailLoginModel.fromJson(json.decode(response.body));
      }
    } else {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status NOT 200");
      return EmailLoginModel.fromJson(json.decode(response.body));
    }
  }

  /// User register
  ///User register with upload image
  static Future<UerRegisterModel> UserRegisterRequest(
      String fname,
      String lname,
      String mother_name,
      String father_name,
      String phone,
      String password,
      String email,
      String place_of_birth,
      String date_of_birth,
      [File? imageFile]) async {
    print("UserRegisterRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fcm_token = prefs.getString('fcm_token') ?? '';
    //TODO
    // String? token = prefs.getString('token') ?? '';
    String? token = 'StAX3iQry3U9hwYMFoyjpW6IZJoV8a7DNI0VS4aQtlkfSzL1DG3fMEzTjNZY';
    print("start send");
    print(token);
    var req = http.MultipartRequest(
        'POST', Uri.parse('$BaseUrl/api/user1-registration'));
    print("afterrrrrr");
    req.fields['first_name'] = fname;
    req.fields['last_name'] = lname;
    req.fields['mother_name'] = mother_name;
    req.fields['father_name'] = father_name;
    req.fields['phone'] = phone;
    req.fields['password'] = password;
    req.fields['email'] = email;
    req.fields['place_of_birth'] = place_of_birth;
    req.fields['date_of_birth'] = date_of_birth;
    req.fields['device_token'] = fcm_token!;

    if (imageFile != null) {
      print("path" + imageFile.path.split("/").last.toString());
      print('********************');
      print((imageFile.path).toString().split("/").last);
      if (imageFile.path != "") {
        print("imagefile not null");

        var stream = new http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();

        var multipartFile = new http.MultipartFile(
            'profile_image', stream, length,
            filename: (imageFile.path).toString().split("/").last);

        req.files.add(multipartFile);
      }
    }
    req.headers.addAll({"Authorization": "Bearer " + token});
    var streamedResponse = await req.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");

      if (UerRegisterModel.fromJson(json.decode(response.body)).error ==
          false) {
        token = UerRegisterModel.fromJson(json.decode(response.body))
            .data!
            .apiToken;
        user_id = UerRegisterModel.fromJson(json.decode(response.body))
            .data!
            .user!
            .id
            .toString();
        print(token);
        print(user_id);
        prefs.setString('token', token!);
        prefs.setString('user_id', user_id!);
        type_of_customer = UerRegisterModel.fromJson(json.decode(response.body))
            .data!
            .user!
            .userType;
        ;
        prefs.setString('type_of_customer', type_of_customer!);
        // if(type_of_customer == 'external_driver' || type_of_customer == 'driver'){
        //   deviceNumber = PassportNumberRegisterModel.fromJson(json.decode(response.body)).data!.deviceNumber;
        // prefs.setString('deviceNumber', deviceNumber!);
        // }
        return UerRegisterModel.fromJson(json.decode(response.body));
      } else {
        return UerRegisterModel.fromJson(json.decode(response.body));
      }
    } else {
      return UerRegisterModel.fromJson(json.decode(response.body));
    }
    // } else {
    //   throw Exception('Failed to load trip category');
    // }
  }

  // EMAIL REGISTER WITH IMAGE
  static Future<EmailRegisterModel> EmailRegisteruploadImageRequest(
      String fname, String lname, String email, String password,
      [File? imageFile]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fcm_token = prefs.getString('fcm_token') ?? '';
    String? token = prefs.getString('token') ?? '';
    print('EmailRegisterRequest');
    print("start send");
    var req = http.MultipartRequest(
        'POST', Uri.parse('$BaseUrl/api/userforiegn-registration'));
    print("afterrrrrr");
    req.fields['first_name'] = fname;
    req.fields['last_name'] = lname;
    req.fields['email'] = email;
    req.fields['password'] = password;
    req.fields['user_type'] = "foreign user";
    req.fields['device_token'] = fcm_token!;

    if (imageFile != null) {
      print("path" + imageFile.path.split("/").last.toString());
      print('********************');
      print((imageFile.path).toString().split("/").last);
      if (imageFile.path != "") {
        print("imagefile not null");
        var stream = new http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();

        var multipartFile = new http.MultipartFile(
            'profile_image', stream, length,
            filename: (imageFile.path).toString().split("/").last);
        req.files.add(multipartFile);
      }
    }
    req.headers.addAll({"Authorization": "Bearer " + token});
    var streamedResponse = await req.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      if (EmailRegisterModel.fromJson(json.decode(response.body)).error ==
          false) {
        token = EmailRegisterModel.fromJson(json.decode(response.body))
            .data!
            .apiToken;
        user_id = EmailRegisterModel.fromJson(json.decode(response.body))
            .data!
            .user!
            .id
            .toString();
        print(token);
        print(user_id);
        prefs.setString('token', token!);
        prefs.setString('user_id', user_id!);

        type_of_customer =
            EmailRegisterModel.fromJson(json.decode(response.body))
                .data!
                .user!
                .userType;
        prefs.setString('type_of_customer', type_of_customer!);
        // if(type_of_customer == 'external_driver' || type_of_customer == 'driver'){
        //   deviceNumber = EmailRegisterModel.fromJson(json.decode(response.body)).data!.deviceNumber;
        // prefs.setString('deviceNumber', deviceNumber!);
        // }
        return EmailRegisterModel.fromJson(json.decode(response.body));
      } else {
        return EmailRegisterModel.fromJson(json.decode(response.body));
      }
    } else {
      return EmailRegisterModel.fromJson(json.decode(response.body));
    }
    // } else {
    //   throw Exception('Failed to load trip category');
    // }
  }

  ///forget password
  static Future<ForgetPasswordModel> ForgetPasswordRequest(
      String mobile, String pass, String confirmPass, bool isUser) async {
    print("ForgetPasswordRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    fcm_token = prefs.getString('fcm_token') ?? '';
    // print(token);
    String user_type = '';
    print(isUser);
    if (isUser == true) {
      user_type = 'user';
    } else {
      user_type = 'driver';
    }
    print('*********************************');
    print(user_type);

    // final response = await client.requesttoken(
    //     requestType: RequestType.POST,
    //     path: "api/forgot-password",
    //     parameter: {
    //       "phone": mobile,
    //       "password": pass,
    //       "confirm_password": confirmPass,
    //       "device_token": fcm_token
    //     },
    //     token: token);

    final response = await client.request(
        requestType: RequestType.POST,
        path: "api/forgot-password",
        parameter: {
          "phone": mobile,
          "password": pass,
          "confirm_password": confirmPass,
          "device_token": fcm_token,
          "user_type" : user_type
        });
    print(mobile);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      print(ForgetPasswordModel.fromJson(json.decode(response.body)).message);
      if (ForgetPasswordModel.fromJson(json.decode(response.body)).error == false) {
        user_id = ForgetPasswordModel.fromJson(json.decode(response.body))
            .data!
            .id
            .toString();
        prefs.setString('user_id', user_id!);
        token = ForgetPasswordModel.fromJson(json.decode(response.body))
            .data!
            .apiToken!;
        prefs.setString('token', token);
        type_of_customer =
            ForgetPasswordModel.fromJson(json.decode(response.body))
                .data!
                .userType;
        prefs.setString('type_of_customer', type_of_customer!);
        // if(type_of_customer == 'external_driver' || type_of_customer == 'driver'){
        //   deviceNumber = ForgetPasswordModel.fromJson(json.decode(response.body)).data!.deviceNumber;
        // prefs.setString('deviceNumber', deviceNumber!);
        // }
      }
      return ForgetPasswordModel.fromJson(json.decode(response.body));
    } else {
      return ForgetPasswordModel.fromJson(json.decode(response.body));
    }
  }

  ///forget password email
  static Future<ForgetPasswordEmailModel> ForgetPasswordEmailRequest(
      String email, String pass, String confirmPass) async {
    print("ForgetPasswordEmailRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    fcm_token = prefs.getString('fcm_token') ?? '';

    print(token);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/forgot-password-email",
        parameter: {
          "email": email,
          "password": pass,
          "confirm_password": confirmPass,
          "device_token": fcm_token
        },
        token: token);
    print(email);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      print(ForgetPasswordEmailModel.fromJson(json.decode(response.body))
          .message);
      user_id = ForgetPasswordEmailModel.fromJson(json.decode(response.body))
          .data!
          .id
          .toString();
      prefs.setString('user_id', user_id!);
      token = ForgetPasswordEmailModel.fromJson(json.decode(response.body))
          .data!
          .apiToken!;
      prefs.setString('token', token);
      type_of_customer =
          ForgetPasswordEmailModel.fromJson(json.decode(response.body))
              .data!
              .userType;
      prefs.setString('type_of_customer', type_of_customer!);
      // if(type_of_customer == 'external_driver' || type_of_customer == 'driver'){
      //   deviceNumber = IdCardRegisterModel.fromJson(json.decode(response.body)).data!.deviceNumber;
      // prefs.setString('deviceNumber', deviceNumber!);
      // }
      return ForgetPasswordEmailModel.fromJson(json.decode(response.body));
    } else {
      return ForgetPasswordEmailModel.fromJson(json.decode(response.body));
    }
  }

  ///send otp code
  static Future<SendOtpModel> sendOtpRequest(String mobile, String request_from, bool isUser) async {
    print("otp fetch mobile :" + mobile.toString());
    print("SendOtpRequest");
    String user_type = '';
    print(isUser);
    if (isUser == true) {
      user_type = 'user';
    } else {
      user_type = 'driver';
    }
    print('*********************************');
    print(user_type);
    final response = await client
        .request(requestType: RequestType.POST, path: "api/otp", parameter: {
      "phone": mobile,
      "request_from": request_from,
      "user_type" : user_type
    });
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetch Services status 200");
      return SendOtpModel.fromJson(json.decode(response.body));
    }
    return SendOtpModel.fromJson(json.decode(response.body));
  }

  ///send otp  email code
  static Future<SendOtpEmailModel> sendOtpEmailRequest(String email) async {
    print("otp fetch email :  " + email.toString());
    print("SendOtpEmailRequest");
    bool error;
    final response = await client.request(
        requestType: RequestType.POST,
        path: "api/otp_email",
        parameter: {
          "email": email,
        });
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetch Services status 200");
      return SendOtpEmailModel.fromJson(json.decode(response.body));
    }
    return SendOtpEmailModel.fromJson(json.decode(response.body));
  }

  //verify otp code
  static Future<VerifyOtpModel> verifyOtpRequest(
      String mobile, String code) async {
    print("otp fetch mobile :  " + mobile.toString());
    print("otp fetch code :  " + code.toString());
    print("verifyOtpRequest");

    final response = await client.request(
        requestType: RequestType.POST,
        path: "api/otp/verify",
        parameter: {"phone": mobile, "code": code});
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetch Services status 200");
      return VerifyOtpModel.fromJson(json.decode(response.body));
    } else {
      return VerifyOtpModel.fromJson(json.decode(response.body));
    }
  }

  //verify otp email code
  static Future<VerifyOtpEmailModel> verifyOtpEmailRequest(
      String email, String code) async {
    print("otp fetch email :  " + email.toString());
    print("otp fetch code :  " + code.toString());
    print("verifyOtpEmailRequest");

    final response = await client.request(
        requestType: RequestType.POST,
        path: "api/otp/verify_email",
        parameter: {"email": email, "code": code});
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetch Services status 200");
      return VerifyOtpEmailModel.fromJson(json.decode(response.body));
    } else {
      return VerifyOtpEmailModel.fromJson(json.decode(response.body));
    }
  }

  ///profile
  ///get profile
  static Future<GetProfileModel> getProfilRequest() async {
    print("ProfilRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String user_id = prefs.getString('user_id') ?? '';
    print(token);
    print(user_id);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/get_profile",
        parameter: {"user_id": user_id},
        token: token);

    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return GetProfileModel.fromJson(json.decode(response.body));
    } else {
      return GetProfileModel.fromJson(json.decode(response.body));
    }
  }

  // //update profile user
  // static Future<UpdateProfileModel> UpdateProfilRequest(
  //     String first_name,
  //     String last_name,
  //     String mother_name,
  //     String father_name,
  //     String phone,
  //     String password,
  //     String email,
  //     String place_of_birth,
  //     String date_of_birth,
  //     ) async {
  //   print("UpdateProfileRequest");
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String token = prefs.getString('token') ?? '';
  //   user_id = prefs.getString('user_id') ?? '';
  //   print(token);
  //   print(user_id);
  //   final response = await client.requesttoken(
  //       requestType: RequestType.POST,
  //       path: "api/edit-user-profile",
  //       parameter: {
  //         "first_name": first_name,
  //         "last_name": last_name,
  //         "mother_name": mother_name,
  //         "father_name": father_name,
  //         "phone": phone,
  //         "password": password,
  //         "email": email,
  //         "place_of_birth": place_of_birth,
  //         "date_of_birth": date_of_birth,
  //         "user_id": user_id,
  //       },
  //       token: token);
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     print(response.statusCode.toString() + response.body);
  //     print("fetchServices status 200");
  //     return UpdateProfileModel.fromJson(json.decode(response.body));
  //   } else {
  //     return UpdateProfileModel.fromJson(json.decode(response.body));
  //   }
  // }

  //update profile user
  static Future<UpdateProfileModel> UpdateProfilRequest(
      String first_name,
      String last_name,
      String mother_name,
      String father_name,
      String phone,
      String password,
      String email,
      String place_of_birth,
      String date_of_birth,
      [File? imageFile]) async {
    print("UpdateProfileRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    print(user_id);

    print("start send");
    var req = http.MultipartRequest(
        'POST', Uri.parse('$BaseUrl/api/edit-user-profile'));
    print("afterrrrrr");
    req.fields['first_name'] = first_name;
    req.fields['last_name'] = last_name;
    req.fields['mother_name'] = mother_name;
    req.fields['father_name'] = father_name;
    req.fields['phone'] = phone;
    req.fields['password'] = password;
    req.fields['email'] = email;
    req.fields['place_of_birth'] = place_of_birth;
    req.fields['date_of_birth'] = date_of_birth;
    req.fields['user_id'] = user_id!;

    if (imageFile != null) {
      print("path" + imageFile.path.split("/").last.toString());
      print('********************');
      print((imageFile.path).toString().split("/").last);
      print(imageFile.path);
      if (imageFile.path != "") {
        var stream = new http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();
        var multipartFile = new http.MultipartFile(
            'profile_image', stream, length,
            filename: (imageFile.path).toString().split("/").last);
        req.files.add(multipartFile);
      }
    }
    req.headers.addAll({"Authorization": "Bearer " + token});
    var streamedResponse = await req.send();
    var response = await http.Response.fromStream(streamedResponse);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      if (UpdateProfileModel.fromJson(json.decode(response.body)).error == false) {
        return UpdateProfileModel.fromJson(json.decode(response.body));
      } else {
        return UpdateProfileModel.fromJson(json.decode(response.body));
      }
    } else {
      return UpdateProfileModel.fromJson(json.decode(response.body));
    }
  }


  //update profile driver
  static Future<UpdateProfileModel> UpdateProfilDriverRequest(
      String first_name,
      String last_name,
      String phone,
      String email,
      String date_of_birth,
      [File? imageFile]) async {
    print("UpdateProfileRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    print(user_id);

    print("start send");
    var req = http.MultipartRequest(
        'POST', Uri.parse('$BaseUrl/api/edit-user-profile'));
    print("afterrrrrr");
    req.fields['first_name'] = first_name;
    req.fields['last_name'] = last_name;
    req.fields['phone'] = phone;
    req.fields['email'] = email;
    req.fields['date_of_birth'] = date_of_birth;
    req.fields['user_id'] = user_id!;

    if (imageFile != null) {
      print("path" + imageFile.path.split("/").last.toString());
      print('********************');
      print((imageFile.path).toString().split("/").last);
      print(imageFile.path);
      if (imageFile.path != "") {
        var stream = new http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();
        var multipartFile = new http.MultipartFile(
            'profile_image', stream, length,
            filename: (imageFile.path).toString().split("/").last);
        req.files.add(multipartFile);
      }
    }
    req.headers.addAll({"Authorization": "Bearer " + token});
    var streamedResponse = await req.send();
    var response = await http.Response.fromStream(streamedResponse);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      if (UpdateProfileModel.fromJson(json.decode(response.body)).error == false) {
        return UpdateProfileModel.fromJson(json.decode(response.body));
      } else {
        return UpdateProfileModel.fromJson(json.decode(response.body));
      }
    } else {
      return UpdateProfileModel.fromJson(json.decode(response.body));
    }
  }

  // //update profile foreigner
  // static Future<UpdateProfileForeignerModel> UpdateProfileForeignerRequest(
  //     String first_name,
  //     String last_name,
  //     String email,
  //     String password,
  //     // String profile_image
  //     ) async {
  //   print(" UpdateProfileForeignerRequest");
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   token = prefs.getString('token') ?? '';
  //   user_id = prefs.getString('user_id') ?? '';
  //   String user_type = 'user';
  //   print(token);
  //   print(user_id);
  //   final response = await client.requesttoken(
  //       requestType: RequestType.POST,
  //       path: "api/edit-userforiegn-profile",
  //       parameter: {
  //         "first_name": first_name,
  //         "last_name": last_name,
  //         "email": email,
  //         "password": password,
  //         "user_type": user_type,
  //         "user_id": user_id,
  //         // "profile_image": profile_image,
  //       },
  //       token: token);
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     print(response.statusCode.toString() + response.body);
  //     print("fetchServices status 200");
  //     return UpdateProfileForeignerModel.fromJson(json.decode(response.body));
  //   } else {
  //     return UpdateProfileForeignerModel.fromJson(json.decode(response.body));
  //   }
  // }

  //update profile foreigner
  static Future<UpdateProfileForeignerModel> UpdateProfileForeignerRequest(
      String first_name, String last_name, String email, String password,
      [File? imageFile]
      // String profile_image
      ) async {
    print(" UpdateProfileForeignerRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    // String user_type = 'user';
    print(token);
    print(user_id);

    print("start send");
    var req = http.MultipartRequest(
        'POST', Uri.parse('$BaseUrl/api/edit-userforiegn-profile'));
    print("afterrrrrr");
    req.fields['first_name'] = first_name;
    req.fields['last_name'] = last_name;
    // req.fields['mother_name'] = mother_name;
    // req.fields['father_name'] = father_name;
    req.fields['password'] = password;
    req.fields['email'] = email;
    req.fields['user_id'] = user_id!;
    // req.fields['user_type'] = user_type!;

    if (imageFile != null) {
      print("path" + imageFile.path.split("/").last.toString());
      print('********************');
      print((imageFile.path).toString().split("/").last);
      print(imageFile.path);
      if (imageFile.path != "") {
        var stream = new http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();
        var multipartFile = new http.MultipartFile(
            'profile_image', stream, length,
            filename: (imageFile.path).toString().split("/").last);
        req.files.add(multipartFile);
      }
    }
    req.headers.addAll({"Authorization": "Bearer " + token});

    var streamedResponse = await req.send();
    var response = await http.Response.fromStream(streamedResponse);

    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return UpdateProfileForeignerModel.fromJson(json.decode(response.body));
    } else {
      return UpdateProfileForeignerModel.fromJson(json.decode(response.body));
    }
  }

  // // get trip category api
  // static Future<List<GetTripCategoryModel>> getTripCategoryRequest() async {
  //   print(" GetTripCategoryRequest");
  //   // String token =
  //   //     "eZrJGjfNh8UqpPwNDXA8lJJgmDsWkOau2x05DLOpRzCUlIbGm3884J6CKhqX";
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   token = prefs.getString('token') ?? '';
  //   print(token);
  //   final response = await client.requesttoken(
  //       requestType: RequestType.GET, path: "api/category", token: token);
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     print(response.statusCode.toString() + response.body);
  //     print("fetchServices status 200");
  //     // return GetTripCategoryModel.fromJson(json.decode(response.body));
  //     return TripsCategoryList.fromJson(json.decode(response.body)["data"])
  //         .tripsget;
  //   } else {
  //     throw Exception('Failed to load trip category');
  //     // return GetTripCategoryModel.fromJson(json.decode(response.body));
  //   }
  // }

  //   // get sub trip category api
  // static Future<List<GetSubCategoryModel>> getSubTripCategoryRequest(String category_id) async {
  //   print("GetSubCategoryRequest");
  //   String token =
  //       "GOQyunADEG5H59uSJn74NEcP19DIXmuaqYsMoCbbIDQl75SWlJqrGx5oAxyq";
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // token = prefs.getString('token') ?? '';
  //   print(token);
  //   final response = await client.requesttoken(
  //       requestType: RequestType.POST, path: "api/subcategory", token: token,
  //       parameter: {
  //         "category_id" : category_id
  //       });
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //         print(response.statusCode.toString() + response.body);
  //         print("fetchServices status 200");
  //         return SubTripsCategoryList.fromJson(json.decode(response.body)("data")).tripsget;
  //   } else {
  //     throw Exception('Failed to load trip category');
  //     // return GetTripCategoryModel.fromJson(json.decode(response.body));
  //   }
  // }

  // get sub trip category api
  static Future<GetSubCategoryModel> getSubTripCategoryRequest(
      String category_id) async {
    print("GetSubCategoryRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    print(token);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/subcategory",
        token: token,
        parameter: {"category_id": category_id});
    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return GetSubCategoryModel.fromJson(json.decode(response.body));
    } else {
      // throw Exception('Failed to load trip category');
      return GetSubCategoryModel.fromJson(json.decode(response.body));
    }
  }

  // get filter vechile api
  static Future<FilterVechileModel> getFilterVechilesCategoryRequest(
      String category_id,
      String subcategory_id,
      String seats,
      String bags,
      String distance,
      String time,
      ) async {
    print("FilterVechileRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    print(token);
    user_id = prefs.getString('user_id') ?? '';
    print(user_id);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/filter_vehicle",
        token: token,
        parameter: {
          "category_id": category_id,
          "subcategory_id": subcategory_id,
          "seats": seats,
          "bags": bags,
          "km" : distance,
          "min" : time,
          "user_id" : user_id
        });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return FilterVechileModel.fromJson(json.decode(response.body));
    } else {
      return FilterVechileModel.fromJson(json.decode(response.body));
    }
  }

  // get filter vechile api
  static Future<OrderTripOutsideModel> orderTripRequest(
      String vehicle_id,
      String category_id,
      String subcategory_id,
      String person,
      String bags,
      String time,
      String date,
      String direction) async {
    print("orderTripRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    print(user_id);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/trip_order",
        token: token,
        parameter: {
          "vehicle_id": vehicle_id,
          "user_id": user_id,
          "category_id": category_id,
          "subcategory_id": subcategory_id,
          "person": person,
          "bags": bags,
          "status": "pending",
          "time": time,
          "date": date,
          // "direction" : "direction"
        });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return OrderTripOutsideModel.fromJson(json.decode(response.body));
    } else {
      return OrderTripOutsideModel.fromJson(json.decode(response.body));
    }
  }

  // get goverment api
  static Future<GetGovermentModel> getGovermentRequest() async {
    print("getGovermentRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    print(token);
    final response = await client.requesttoken(
      requestType: RequestType.GET,
      path: "api/goverment",
      token: token,
    );
    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return GetGovermentModel.fromJson(json.decode(response.body));
    } else {
      return GetGovermentModel.fromJson(json.decode(response.body));
    }
  }

  // get trip outcity api
  static Future<TripOutCityModel> getTripOutcityRequest(
      String pickup_latitude,
      String pickup_longitude,
      String drop_latitude,
      String drop_longitude,
      String category_id,
      String subcategory_id,
      String km,
      String minutes,
      String vehicle_id,
      String time,
      String date,
      String bags,
      String seats,
      String direction,
      String from,
      String to) async {
    print("getTripOutcityRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    print(user_id);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/trip_outcity",
        token: token,
        parameter: {
          "pickup_latitude": pickup_latitude,
          "pickup_longitude": pickup_longitude,
          "drop_latitude": drop_latitude,
          "drop_longitude": drop_longitude,
          "category_id": category_id,
          "subcategory_id": subcategory_id,
          "km": km,
          "minutes": minutes,
          "vehicle_id": vehicle_id,
          "user_id": user_id,
          "time": time,
          "date": date,
          "status": "pending",
          "bags": bags,
          "seats": seats,
          "direction": direction,
          "from": from,
          "to": to
        });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return TripOutCityModel.fromJson(json.decode(response.body));
    } else {
      return TripOutCityModel.fromJson(json.decode(response.body));
    }
  }

  // cancel trip api
  static Future cancelTripRequest(String trip_id) async {
    print("cancelTripRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    print(token);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/cancle-trip",
        token: token,
        parameter: {
          "trip_id": trip_id,
        });
    print(response.body);
    return response.body;

    // if (response.statusCode == 200) {
    //       print(response.statusCode.toString() + response.body);
    //       print("fetchServices status 200");
    // return TripOutCityModel.fromJson(json.decode(response.body));
    // } else {
    //   return TripOutCityModel.fromJson(json.decode(response.body));
    // }
  }

  // get user trips api
  static Future<GetUserTripsModel> getUserTripsRequest() async {
    print("getUserTripsRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    print(user_id);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/get_mytrip",
        token: token,
        parameter: {
          "user_id": user_id
        });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return GetUserTripsModel.fromJson(json.decode(response.body));
    } else {
      return GetUserTripsModel.fromJson(json.decode(response.body));
    }
  }

  // get user orders api (accepted trips)
  static Future<UserOrdersModel> getUserOrdersRequest() async {
    print("getUserOrdersRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    print(user_id);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/accepted-trip",
        token: token,
        parameter: {
          "user_id": user_id
        });
    print(response.body);
    if (response.statusCode == 200) {
      // print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return UserOrdersModel.fromJson(json.decode(response.body));
    } else {
      return UserOrdersModel.fromJson(json.decode(response.body));
    }
  }

  // order tour api
  static Future<OrderTourModel> orderTourRequest(
      String trip_id, String start_time, String end_time) async {
    print("orderTourRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    print(token);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/order_tour",
        token: token,
        parameter: {
          "trip_id": trip_id,
          "start_time": start_time,
          "end_time": end_time,
          "status": "pending"
        });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return OrderTourModel.fromJson(json.decode(response.body));
    } else {
      return OrderTourModel.fromJson(json.decode(response.body));
    }
  }

  // cancel tour api
  static Future cancelTourRequest(String tour_id) async {
    print("cancelTripRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    print(token);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/cancle-tour",
        token: token,
        parameter: {
          "tour_id": tour_id,
        });
    print(response.body);
    return response.body;
  }

  // source destination api
  static Future<SourceDistenationModel> sourceDestinationRequest(
      String pickup_latitude,
      String pickup_longitude,
      String drop_latitude,
      String drop_longitude,
      String km,
      String minutes) async {
    print("sourceDestinationRequest");
    print(km);
    print(minutes);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/source-destination",
        token: token,
        parameter: {
          "pickup_latitude": pickup_latitude,
          "pickup_longitude": pickup_longitude,
          "drop_latitude": drop_latitude,
          "drop_longitude": drop_longitude,
          "km": km,
          "minutes": minutes,
          "user_id": user_id
        });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return SourceDistenationModel.fromJson(json.decode(response.body));
    } else {
      return SourceDistenationModel.fromJson(json.decode(response.body));
    }
  }

  // getTypeOption api
  static Future<GetTypeOptionModel> getTypeOptionRequest(String id) async {
    print("getTypeOptionRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    print(token);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/type-option",
        token: token,
        parameter: {
          "id": id,
        });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return GetTypeOptionModel.fromJson(json.decode(response.body));
    } else {
      return GetTypeOptionModel.fromJson(json.decode(response.body));
    }
  }

  // book now api
  static Future bookNowRequest(
      String latitude,
      String longitude,
      String drop_latitude,
      String drop_longitude,
      String km,
      String minutes,
      String pickup_addr,
      String dest_addr,
      String cost,
      String type_id,
      List option_id,
      String order_time) async {
    print("bookNowRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/book-now",
        token: token,
        parameter: {
          "latitude": latitude,
          "longitude": longitude,
          "category_id": "1",
          "km": km,
          "minutes": minutes,
          "user_id": user_id,
          "status": "pending",
          "pickup_addr": pickup_addr,
          "dest_addr": dest_addr,
          "cost": cost,
          "type_id": type_id,
          "request_type": "moment",
          "option_id": option_id,
          "drop_latitude": drop_latitude,
          "drop_longitude" : drop_longitude,
          "order_time" : order_time
        });
    print(response.body);
    return response.body;
  }

  // source destination delayed api
  static Future<SourceDestinationDelayedModel> sourceDestinationDelayedRequest(
      String pickup_latitude,
      String pickup_longitude,
      String drop_latitude,
      String drop_longitude,
      String km,
      String minutes,
      String date,
      String time) async {
    print("sourceDestinationDelayedRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/source-destination-delayed",
        token: token,
        parameter: {
          "pickup_latitude": pickup_latitude,
          "pickup_longitude": pickup_longitude,
          "drop_latitude": drop_latitude,
          "drop_longitude": drop_longitude,
          "km": km,
          "minutes": minutes,
          "user_id": user_id,
          "date": date,
          "time": time
        });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return SourceDestinationDelayedModel.fromJson(json.decode(response.body));
    } else {
      return SourceDestinationDelayedModel.fromJson(json.decode(response.body));
    }
  }

  // book now delayed api
  static Future bookNowDelayedRequest(
      String latitude,
      String longitude,
      String drop_latitude,
      String drop_longitude,
      String km,
      String minutes,
      String pickup_addr,
      String dest_addr,
      String cost,
      String type_id,
      String date,
      String time,
      List option_id) async {
    print("bookNowDelayedRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/book-now-delayed",
        token: token,
        parameter: {
          "latitude": latitude,
          "longitude": longitude,
          "category_id": "1",
          "km": km,
          "minutes": minutes,
          "user_id": user_id,
          "status": "pending",
          "pickup_addr": pickup_addr,
          "dest_addr": dest_addr,
          "cost": cost,
          "type_id": type_id,
          "request_type": "delayed",
          "date": date,
          "time": time,
          "option_id": option_id,
          "drop_latitude": drop_latitude,
          "drop_longitude" : drop_longitude
        });
    print(response.body);
    return response.body;
  }

  // review (rating) api
  static Future reviewRequest(
      String trip_id, String review_text, String ratings) async {
    print("reviewRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/review",
        token: token,
        parameter: {
          "trip_id": trip_id,
          "user_id": user_id,
          "review_text": review_text,
          "ratings": ratings,
          "type" : "user"
        });
    print(response.body);
    return response.body;
  }

  // contact us api
  static Future contactUsRequest() async {
    print("contactUsRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    print(token);
    final response = await client.requesttoken(
      requestType: RequestType.GET,
      path: "api/contact",
      token: token,
    );
    print(response.body);
    return response.body;
  }

///////////////////    DRIVER API    ///////////////////////////
  // driver register with images
  static Future<DriverRegisterModel> DriverRegisteruploadImageRequest(
    String first_name,
    String last_name,
    String email,
    String password,
    String phone, [
    File? car_mechanic,
    File? car_insurance,
  ]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fcm_token = prefs.getString('fcm_token') ?? '';
    String? token = prefs.getString('token') ?? '';
    print('DriverRegisterRequest');
    print("start send");
    var req = http.MultipartRequest('POST', Uri.parse('$BaseUrl/api/join_us'));
    print("afterrrrrr");
    req.fields['first_name'] = first_name;
    req.fields['last_name'] = last_name;
    req.fields['email'] = email;
    req.fields['password'] = password;
    req.fields['phone'] = phone;
    req.fields['is_active'] = "pending";
    req.fields['device_token'] = fcm_token!;

    if (car_mechanic != null) {
      print('********************');
      print("path" + car_mechanic.path.split("/").last.toString());
      print((car_mechanic.path).toString().split("/").last);
      if (car_mechanic.path != "") {
        print("car_mechanic not null");
        var stream = new http.ByteStream(car_mechanic.openRead());
        var length = await car_mechanic.length();
        var multipartFile = new http.MultipartFile(
            'car_mechanic', stream, length,
            filename: (car_mechanic.path).toString().split("/").last);
        req.files.add(multipartFile);
      }
    }

    if (car_insurance != null) {
      print('********************');
      print("path2" + car_insurance.path.split("/").last.toString());
      print((car_insurance.path).toString().split("/").last);
      if (car_insurance.path != "") {
        print("car_insurance not null");
        var stream2 = new http.ByteStream(car_insurance.openRead());
        var length2 = await car_insurance.length();
        var multipartFile2 = new http.MultipartFile(
            'car_insurance', stream2, length2,
            filename: (car_insurance.path).toString().split("/").last);
        req.files.add(multipartFile2);
      }
    }
    req.headers.addAll({"Authorization": "Bearer " + token});
    var streamedResponse = await req.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      if (DriverRegisterModel.fromJson(json.decode(response.body)).error ==
          false) {
        token = DriverRegisterModel.fromJson(json.decode(response.body))
            .data!
            .apiToken;
        user_id = DriverRegisterModel.fromJson(json.decode(response.body))
            .data!
            .user!
            .id
            .toString();
        print(token);
        print(user_id);
        prefs.setString('token', token!);
        prefs.setString('user_id', user_id!);

        type_of_customer =
            DriverRegisterModel.fromJson(json.decode(response.body))
                .data!
                .user!
                .userType;
        prefs.setString('type_of_customer', type_of_customer!);
        // if(type_of_customer == 'external_driver' || type_of_customer == 'driver'){
        //   deviceNumber = EmailRegisterModel.fromJson(json.decode(response.body)).data!.deviceNumber;
        // prefs.setString('deviceNumber', deviceNumber!);
        // }
        return DriverRegisterModel.fromJson(json.decode(response.body));
      } else {
        return DriverRegisterModel.fromJson(json.decode(response.body));
      }
    } else {
      return DriverRegisterModel.fromJson(json.decode(response.body));
    }
    // } else {
    //   throw Exception('Failed');
    // }
    // }
    // else {
    //   throw Exception('Failed');
    // }
  }

  // complete register with images
  static Future<DriverCompleteRegisterModel>
      DriverCompleteRegisteruploadImageRequest([
    File? car_image,
    File? personal_identity,
    File? driving_certificate,
  ]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fcm_token = prefs.getString('fcm_token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    String token = prefs.getString('token') ?? '';

    print('DriverCompleteRegisteruploadImageRequest');
    print("start send");
    var req = http.MultipartRequest(
        'POST', Uri.parse('$BaseUrl/api/complete_register'));
    print("afterrrrrr");
    req.fields['user_id'] = user_id!;
    // req.fields['device_token'] = fcm_token!;

    if (car_image != null) {
      print('********************');
      print("path" + car_image.path.split("/").last.toString());
      print((car_image.path).toString().split("/").last);
      if (car_image.path != "") {
        print("car_image not null");
        var stream = new http.ByteStream(car_image.openRead());
        var length = await car_image.length();
        var multipartFile = new http.MultipartFile('car_image', stream, length,
            filename: (car_image.path).toString().split("/").last);
        req.files.add(multipartFile);
      }
    }

    if (personal_identity != null) {
      print('********************');
      print("path2" + personal_identity.path.split("/").last.toString());
      print((personal_identity.path).toString().split("/").last);
      if (personal_identity.path != "") {
        print("personal_identity not null");
        var stream2 = new http.ByteStream(personal_identity.openRead());
        var length2 = await personal_identity.length();
        var multipartFile2 = new http.MultipartFile(
            'personal_identity', stream2, length2,
            filename: (personal_identity.path).toString().split("/").last);
        req.files.add(multipartFile2);
      }
    }

    if (driving_certificate != null) {
      print('********************');
      print("path3" + driving_certificate.path.split("/").last.toString());
      print((driving_certificate.path).toString().split("/").last);
      if (driving_certificate.path != "") {
        print("driving_certificate not null");
        var stream3 = new http.ByteStream(driving_certificate.openRead());
        var length3 = await driving_certificate.length();
        var multipartFile3 = new http.MultipartFile(
            'driving_certificate', stream3, length3,
            filename: (driving_certificate.path).toString().split("/").last);
        req.files.add(multipartFile3);
      }
    }
    req.headers.addAll({"Authorization": "Bearer " + token});
    var streamedResponse = await req.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      if (DriverCompleteRegisterModel.fromJson(json.decode(response.body))
              .error ==
          false) {
        return DriverCompleteRegisterModel.fromJson(json.decode(response.body));
      } else {
        return DriverCompleteRegisterModel.fromJson(json.decode(response.body));
      }
    } else {
      return DriverCompleteRegisterModel.fromJson(json.decode(response.body));
    }
    // } else {
    //   throw Exception('Failed');
    // }
    // }
    // else {
    //   throw Exception('Failed');
    // }
    // }
    // else {
    //   throw Exception('Failed');
    // }
  }

  ///getDriverStatusRequest
  static Future<DriverStatusModel> getDriverStatusRequest() async {
    print("getDriverStatusRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/driver-status",
        token: token,
        parameter: {
          "driver_id": user_id,
        });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      var data = json.decode(response.body);
      print('+++++++++++++++');
      print(data['error']);
      if (data['error'] == false) {
        deviceNumber = DriverStatusModel.fromJson(json.decode(response.body))
            .data!
            .deviceNumber
            .toString();
        prefs.setString('deviceNumber', deviceNumber!);
      }
      // deviceNumber = DriverStatusModel.fromJson(json.decode(response.body)).data!.deviceNumber;
      // prefs.setString('deviceNumber', deviceNumber!);
      return DriverStatusModel.fromJson(json.decode(response.body));
    } else {
      return DriverStatusModel.fromJson(json.decode(response.body));
    }
  }

  // get location api
  static Future getLocationRequest(
      String latitude, String longitude, String device_id) async {
    print("getLocationRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    print(user_id);
    print(latitude);
    print(longitude);
    print(device_id);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/location",
        token: token,
        parameter: {
          "latitude": latitude,
          "longitude": longitude,
          "device_id": device_id,
          "user_id": user_id
        });
    print(response.body);
    return response.body;
  }

  ///driver trips api
  static Future<GetDriverTripsModel> getDriverTripsRequest() async {
    print("getDriverTripsRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/driver-trip",
        token: token,
        parameter: {
          "driver_id": user_id,
        });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return GetDriverTripsModel.fromJson(json.decode(response.body));
    } else {
      return GetDriverTripsModel.fromJson(json.decode(response.body));
    }
  }

  /// accept-trip api
  static Future acceptTripRequest(String trip_id) async {
    print("acceptTripRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    String device_number = prefs.getString('deviceNumber') ?? '';
    print('device_number $device_number');
    print(token);
    print(user_id);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/accept-trip",
        token: token,
        parameter: {
          "trip_id": trip_id,
          "driver_id": user_id,
          "device_number" : device_number
        });
    print(response.body);
    return response.body;
  }

  /// start trip api
  static Future startTripRequest(String trip_id, String start_time) async {
    print("startTripRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    print(user_id);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/trip-start",
        token: token,
        parameter: {
          "trip_id": trip_id,
          "start_time": start_time,
          "driver_id": user_id
        });
    print(response.body);
    return response.body;
  }

  /// end trip api
  static Future endTripRequest(
      String trip_id, String end_time, String km) async {
    print("endTripRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    print(user_id);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/trip-end",
        token: token,
        parameter: {
          "trip_id": trip_id,
          "end_time": end_time,
          "km": km,
          "driver_id": user_id
        });
    print(response.body);
    return response.body;
  }

  /// review (rating) api
  static Future reviewDriverRequest(String trip_id, String review_text,
      String ratings, String userIdRate) async {
    print("reviewDriverRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    print(user_id);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/review",
        token: token,
        parameter: {
          "trip_id": trip_id,
          // "user_id": userIdRate,
          "user_id": user_id,
          "review_text": review_text,
          "ratings": ratings,
          "type" : "driver"
        });
    print(response.body);
    return response.body;
  }

  /// trip expenses api
  static Future tripExpensesRequest(
      String trip_id, List type, List price) async {
    print("tripExpensesRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    print(user_id);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/trip-expense",
        token: token,
        parameter: {
          "trip_id": trip_id,
          "type": type,
          "price": price,
          "driver_id": user_id
        });
    print(response.body);
    return response.body;
  }

  /// tripPaymentRequest
  static Future<TripPaymentModel> tripPaymentRequest(
      // String trip_id,
      String method, String amount) async {
    print("tripPaymentRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/trip-payment",
        token: token,
        parameter: {
          "driver_id": user_id,
          // "trip_id": trip_id,
          "method": method,
          "amount": amount,
        });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return TripPaymentModel.fromJson(json.decode(response.body));
    } else {
      return TripPaymentModel.fromJson(json.decode(response.body));
    }
  }

  /// tripPaymentTransferRequest
  static Future<TripPaymentModel> tripPaymentTransferRequest(
      // String trip_id,
      String method, String amount, File imageFile) async {
    print("tripPaymentTransferRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    // final response = await client.requesttoken(
    //     requestType: RequestType.POST,
    //     path: "api/trip-payment",
    //     token: token,
    //     parameter: {
    //       "driver_id": user_id,
    //       "trip_id" : trip_id,
    //       "method" : method,
    //       "amount" : amount,
    //       "transfer_image" : imageFile
    //     });
    // print(response.body);

    print("start send");
    var req =
        http.MultipartRequest('POST', Uri.parse('$BaseUrl/api/trip-payment'));
    print("afterrrrrr");
    req.fields['driver_id'] = user_id!;
    // req.fields['trip_id'] = trip_id;
    req.fields['method'] = method;
    req.fields['amount'] = amount;
    print("path" + imageFile.path.split("/").last.toString());
    print('********************');
    print((imageFile.path).toString().split("/").last);
    if (imageFile.path != "") {
      print("imageFile not null");
      var stream = new http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = new http.MultipartFile(
          'transfer_image', stream, length,
          filename: (imageFile.path).toString().split("/").last);
      req.files.add(multipartFile);
    }
    req.headers.addAll({"Authorization": "Bearer " + token});
    var streamedResponse = await req.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return TripPaymentModel.fromJson(json.decode(response.body));
    } else {
      return TripPaymentModel.fromJson(json.decode(response.body));
    }
    // }
    // else {
    //   throw Exception('Failed');
    // }
  }

  // get driver wallet
  static Future getDriverWalletRequest() async {
    print("getDriverWalletRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    print(user_id);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/driver-wallet",
        token: token,
        parameter: {"driver_id": user_id});
    print(response.body);
    return response.body;
  }

  /// chargeWalletRequest
  static Future<ChargeWalletModel> chargeWalletRequest(String method, String new_amount) async {
    print("chargeWalletRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/charge-wallet",
        token: token,
        parameter: {
          "driver_id": user_id,
          "method": method,
          "new_amount": new_amount,
        });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return ChargeWalletModel.fromJson(json.decode(response.body));
    } else {
      return ChargeWalletModel.fromJson(json.decode(response.body));
    }
  }

  /// chargeWalletTransferRequest
  static Future<ChargeWalletModel> chargeWalletTransferRequest(String method, String amount, File imageFile) async {
    print("chargeWalletTransferRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    print("start send");
    var req =
    http.MultipartRequest('POST', Uri.parse('$BaseUrl/api/charge-wallet'));
    print("afterrrrrr");
    req.fields['driver_id'] = user_id!;
    req.fields['method'] = method;
    req.fields['new_amount'] = amount;
    print("path" + imageFile.path.split("/").last.toString());
    print('********************');
    print((imageFile.path).toString().split("/").last);
    if (imageFile.path != "") {
      print("imageFile not null");
      var stream = new http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = new http.MultipartFile(
          'transfare_image', stream, length,
          filename: (imageFile.path).toString().split("/").last);
      req.files.add(multipartFile);
    }
    req.headers.addAll({"Authorization": "Bearer " + token});
    var streamedResponse = await req.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return ChargeWalletModel.fromJson(json.decode(response.body));
    } else {
      return ChargeWalletModel.fromJson(json.decode(response.body));
    }
  }

  // user complaint
  static Future complaintRequest(String description) async {
    print("complaintRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    print(user_id);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/send-complaint",
        token: token,
        parameter: {"user_id": user_id, "description": description});
    print(response.body);
    return response.body;
  }

  /// paymentRequest
  static Future<PaymentModel> paymentRequest() async {
    print("paymentRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/driver-payment",
        token: token,
        parameter: {"driver_id": user_id});
    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return PaymentModel.fromJson(json.decode(response.body));
    } else {
      return PaymentModel.fromJson(json.decode(response.body));
    }
  }

  /// sign out api
  static Future signOutRequest() async {
    print("signOutRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    print(user_id);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/siginout",
        token: token,
        parameter: {
          "user_id": user_id,
        });
    print(response.body);
    return response.body;
  }

  /// driverEfficientTripsRequest
  static Future<DriverEfficientTripsModel> driverEfficientTripsRequest() async {
    print("driverEfficientTripsRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(user_id);
    print(token);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/outcity_trip",
        token: token,
        parameter: {
          "driver_id": user_id,
        });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return DriverEfficientTripsModel.fromJson(json.decode(response.body));
    } else {
      return DriverEfficientTripsModel.fromJson(json.decode(response.body));
    }
  }


  /// arriveDriver api
  static Future arriveDriverRequest(String trip_id) async {
    print("arriveDriverRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    print(user_id);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/driver-notification",
        token: token,
        parameter: {
          "driver_id" : user_id,
          "trip_id": trip_id,
        });
    print(response.body);
    return response.body;
  }


  /// mtn api
  static Future mtnRequest(String phone, String code) async {
    print("mtnRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    print(user_id);
    final response = await client.request(
        requestType: RequestType.POST,
        path: "api/MTN",
        parameter: {
          "otp" : code,
          "mobile" : phone,
        });

    // Response response = await post(Uri.parse("$_baseUrl" + "mtn"),
    //   body: {
    //     "mobile" : phone,
    //     "otp" : data1.toString()
    //   },
    // );

    print(response.body);
    return response.body;
  }

  /// driver delete account api
  static Future driverDeleteAccountRequest(String phone, String password) async {
    print("driverDeleteAccountRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    print(user_id);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/delete_driver",
        token: token,
        parameter: {
          "phone" : phone,
          "password" : password,
          "driver_id" : user_id
        });
    print(response.body);
    return response.body;
  }


  /// user delete account api
  static Future userDeleteAccountRequest(String phone, String password) async {
    print("userDeleteAccountRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(token);
    print(user_id);
    print(phone);
    print(password);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/delete_rider",
        token: token,
        parameter: {
          "user_id" : user_id,
          "phone" : phone,
          "password" : password,
        });
    print('response.body ${response.body}');
    return response.body;
  }


  /// createPaymentIdRequest
  static Future<CreatePaymentIdModel> createPaymentIdRequest(String amount) async {
    print("createPaymentIdRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    print(user_id);
    print(token);
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/create-orderid",
        token: token,
        parameter: {
          "driver_id": user_id,
          "amount" : amount
        });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return CreatePaymentIdModel.fromJson(json.decode(response.body));
    } else {
      return CreatePaymentIdModel.fromJson(json.decode(response.body));
    }
  }

  /// getEcashPaymentStatusRequest
  static Future<CheckPaymentStatusModel> getEcashPaymentStatusRequest(String payment_id) async {
    print("getEcashPaymentStatusRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/check-status",
        token: token,
        parameter: {
          "order_id": payment_id
        });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return CheckPaymentStatusModel.fromJson(json.decode(response.body));
    } else {
      return CheckPaymentStatusModel.fromJson(json.decode(response.body));
    }
  }

  /// delete payment id api
  static Future deletePaymentIdRequest(String payment_id) async {
    print("deletePaymentIdRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/delete_order",
        token: token,
        parameter: {
          "order_id" : payment_id
        });
    print('response.body ${response.body}');
    return response.body;
  }

  // termsRequest api
  static Future termsRequest() async {
    print("termsRequest");
    final response = await client.request(
    requestType: RequestType.GET,
    path: "api/terms",
  );
    return response.body;
  }


  /// nearestCarMapRequest
  static Future<NearestCarsMapModel> nearestCarMapRequest(String lat, String lng) async {
    print("nearestCarMapRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    user_id = prefs.getString('user_id') ?? '';
    final response = await client.requesttoken(
        requestType: RequestType.POST,
        path: "api/map_cars",
        token: token,
        parameter: {
          "pickup_latitude": lat,
          "pickup_longitude": lng
        });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return NearestCarsMapModel.fromJson(json.decode(response.body));
    } else {
      return NearestCarsMapModel.fromJson(json.decode(response.body));
    }
  }


  /// getInitUserTripsRequest
  static Future<InitUserTripsModel> getInitUserTripsRequest() async {
    print("getInitUserTripsRequest");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    // user_id = prefs.getString('user_id') ?? '';
    // print(user_id);
    print(token);
    final response = await client.requesttoken(
      requestType: RequestType.GET,
      path: "api/user-trips",
      token: token,
    );
    if (response.statusCode == 200) {
      print(response.statusCode.toString() + response.body);
      print("fetchServices status 200");
      return InitUserTripsModel.fromJson(json.decode(response.body));
    } else {
      return InitUserTripsModel.fromJson(json.decode(response.body));
    }
  }


// // delete account api
//   Future<void> deleteAccount(String mobile, String password) async {
//     try {
//       _isNetworkAvail = await isNetworkAvailable();
//       if (_isNetworkAvail) {
//         print("There is internet");
//         Loader.show(context, progressIndicator: LoaderWidget());
//         print("deleteAccount");
//         print("$baseUrl"+"delete_user");
//         dynamic response =
//         await http.post(Uri.parse("$baseUrl"+"delete_user"),
//             body: {
//               // "user_id" : CUR_USERID,
//               // "user_id" : "29",
//               "mobile" : mobile,
//               "password" : password
//             },
//             headers: headers
//         );
//         print(response.statusCode);
//         var data = json.decode(response.body);
//         String msg = data["message"];
//         bool error = data["error"];
//         print(msg);
//         print(error);
//         if (error == false) {
//           Loader.hide();
//           Navigator.of(context).pop();
//           setSnackbar(msg);
//           setState(() {
//             Future.delayed(const Duration(seconds: 5)).then((_) async {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => Login(),
//                 ),
//               );
//             });
//           });
//         } else {
//           Loader.hide();
//           setSnackbar(msg);
//         }
//       } else {
//         setSnackbar("no internet");
//       }
//       if (mounted) setState(() {});
//     } on TimeoutException catch (_) {
//       setSnackbar(getTranslated(context, 'somethingMSg')!);
//       await buttonController!.reverse();
//     }
//   }

// //////////////////////////////
//   Future uploadImage(File file) async {
//     var stream = new http.ByteStream(file.openRead());

//     var length = await file.length();

//     var uri =
//         Uri.parse("http://dimond-line.peaklinkdemo.com/api/user-registration");

//     var request = new http.MultipartRequest("POST", uri);

//     request.fields['first_name'] = 'hala';

//     var multipartFile = new http.MultipartFile('profile_image', stream, length);

//     request.files.add(multipartFile);

//     var response = await request.send();

//     if (response.statusCode == 200) {
//       print('image uploaded');
//     } else {
//       print('no image selected');
//     }
//   }

// //mdcin upload image
//   Future<String?> uploadImage2(XFile image,String oldToken) async {
//     String fileName = image.path.split('/').last;

//     FormData formData = FormData.fromMap({
//       "image" : MultipartFile.fromFile(image.path,filename: fileName),

//     });
//     try {
//       var response = await dio.(
//         '$SERVER_IP/signUp/uploadImage/mobile',
//         data: formData,
//         options: Options(
//         headers: {
//           "token" : oldToken,
//           Headers.contentLengthHeader: oldToken.length, // set content-length
//           Headers.contentTypeHeader : "multipart/form-data"

//         }
//       ),

//       );

//       if (response.statusCode == 200) {
//         return response.data["token"];
//       }
//     } on DioError catch (e) {
//       print(e);
//       print("((Done))");

//       return null;
//     }
//   }

// addphotoApi() async {
//     print("dddd");
//     for (int index = 0; index < select.length; index++) {
//       var req = http.MultipartRequest(
//           'POST', Uri.parse(MyApp.BaseURL + '/api/Category/AddCategory')
//         // Uri.parse('http://generalpos.fingerprint.ml/api/Category/AddCategory')
//       );
//       print("ssss");
//       req.fields['Status'] = "1";
//       req.fields['StoreID'] = select[index].storeID.toString();
//       req.fields['Timestamp'] = TIMES;
//       req.fields['Name'] = NAMECAT;
//       req.fields['GSID'] = LayoutTemplate.user.toString();
//       print("patrh" + imageFile.path
//           .split("/")
//           .last
//           .toString());
//       if (imageFile.path != "") {
//         print("fffff");

//         var stream = new http.ByteStream(
//             DelegatingStream.typed(imageFile.openRead()));
//         int length = imageBytes.length;
//         var multipartFile = new http.MultipartFile(
//             'iconFile', stream, length, filename: (imageFile.name)
//             .toString()
//             .split("/")
//             .last);

//         req.files.add(multipartFile);
//         var r = await req.send();

//         if (r.statusCode == 200) {
//           print("sssecsess");
//         }
//       } else {
//         var r = await req.send();
//         if (r.statusCode == 200) {
//           print("sssecsess");
//         }
//       }
//       notifyListeners();
//     }
//     // // print("*******rrrr********" + r.statusCode.toString());
//     // // var response = r.stream.bytesToString();
//     // // print("response" + response.toString());
//   }

// /////////////////////////////
//   static getImage(File imageFile) async {
//     var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
//     var length = await imageFile.length();
//     // var uri = Uri.parse("http://taxi.peaklinkdemo.com/api/upload_profile_image");
//     // var request = new http.MultipartRequest("GET", uri);
//     var multipartFile = new http.MultipartFile(
//       'file',
//       stream,
//       length,
//       filename: imageFile.path,
//     );

//     return multipartFile;
//     // request.files.add(multipartFile);
//     // var response = await request.send();
//     //     print(response.statusCode);
//     //     // response.stream.transform(utf8.decoder).listen((value) {
//     //       print(value);
//     //       print("qmar");
//     //     });
//     //   isLoading = true;
//     //   print("phhm");
//     //  // data = await AppRequests.ImageRequest("");
//     //  // print(data.imageUrl);
//     //   print("loaddding image");
//     //   isLoading = false;
//     //   notifyListeners();
//     // });
//   }

// getImage(File imageFile) async {
//       var stream =
//           http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
//       var length = await imageFile.length();
//        String token="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdGF4aS5wZWFrbGlua2RlbW8uY29tL2FwaS9sb2dpbiIsImlhdCI6MTY2NDI4NTAwNiwiZXhwIjoxNjY2OTEzMDA2LCJuYmYiOjE2NjQyODUwMDYsImp0aSI6IjhUNE9wMGdUWEpGdlBFTHUiLCJzdWIiOjEwMDA2LCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.dtlWqHA1zX0oszlrGVGvyr6aLwu_7f0pfkvHNj3ADlo";
//       var uri = Uri.parse("http://taxi.peaklinkdemo.com/api/upload_profile_image");
//            Map<String, String> auth = {"Content-Type": "application/json","Authorization":"Bearer "+token};
// //           Map<String, String> cont = {"Content-Type": "application/json"};
//                        print(auth);
//       var request = new http.MultipartRequest("GET", uri)..fields.addAll(auth);
//       var multipartFile = new http.MultipartFile('file', stream, length,
//           filename:imageFile.path,
//      );
//       //contentType: new MediaType('image', 'png'));
//                                           //request.fields['image'] = multipartFile;
//       request.files.add(multipartFile);
//       var response = await request.send();
//       print(response.statusCode);
//       response.stream.transform(utf8.decoder).listen((value) {
//         print(value);
//         print("qmar");
//       });
//     isLoading = true;
//     print("phhm");
//    // data = await AppRequests.ImageRequest("");
//    // print(data.imageUrl);
//     print("loaddding image");
//     isLoading = false;
//     notifyListeners();
//     // });
//   }

// //upload image
// Upload(File imageFile) async {
//   var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
//     var length = await imageFile.length();

//     var uri = Uri.parse(uploadURL);

//    var request = new http.MultipartRequest("POST", uri);
//     var multipartFile = new http.MultipartFile('file', stream, length,
//         filename: basename(imageFile.path));
//         //contentType: new MediaType('image', 'png'));

//     request.files.add(multipartFile);
//     var response = await request.send();
//     print(response.statusCode);
//     response.stream.transform(utf8.decoder).listen((value) {
//       print(value);
//     });
//   }

// static Future<GetProfileModel> getProfilRequest() async {
//   print("ProfilRequest");
//   String token="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdGF4aS5wZWFrbGlua2RlbW8uY29tL2FwaS9sb2dpbiIsImlhdCI6MTY2MjM3MjE3OSwiZXhwIjoxNjY1MDAwMTc5LCJuYmYiOjE2NjIzNzIxNzksImp0aSI6IjZISzJsRTFRTG9XWnp6QnoiLCJzdWIiOjEwMDI5LCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.f684nytra6QQ9wYvPtmcZffAACVob8nUUIK1pSQeykA";
//   final response = await client.requesttoken(
//       requestType: RequestType.GET,
//       path: "api/get_rider_profile",
//       token: token);
//   if (response.statusCode == 200) {
//     print(response.statusCode.toString() + response.body);
//     print("fetchServices status 200");
//     return GetProfileModel.fromJson(json.decode(response.body));
//   } else {
//     return GetProfileModel.fromJson(json.decode(response.body));
//   }
// }

//   static Future<UpdateProfilModel> UpdateProfilRequest(
//       String email,
//       String fname,
//       String lname,
//       String number,
//       String act,
//       String img,
//       String cod) async {
//     print(" UpdateProfilRequest");

//     String token="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdGF4aS5wZWFrbGlua2RlbW8uY29tL2FwaS9sb2dpbiIsImlhdCI6MTY2MjM3MjE3OSwiZXhwIjoxNjY1MDAwMTc5LCJuYmYiOjE2NjIzNzIxNzksImp0aSI6IjZISzJsRTFRTG9XWnp6QnoiLCJzdWIiOjEwMDI5LCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.f684nytra6QQ9wYvPtmcZffAACVob8nUUIK1pSQeykA";
//     final response = await client.requesttoken(
//         requestType: RequestType.GET,
//         path:
//             "api/update_rider_profile?email_id=$email&first_name=$fname&last_name=$lname&country_code=$cod&mobile_number=$number&status=$act&profile_image=$img",
//         token: token);

//     print(response.body);
//     if (response.statusCode == 200) {
//       print(response.statusCode.toString() + response.body);
//       print("fetchServices status 200");
//       return UpdateProfilModel.fromJson(json.decode(response.body));
//     } else {
//       return UpdateProfilModel.fromJson(json.decode(response.body));
//     }
//   }

//   static Future<ImageModel> ImageRequest(String image) async {
//     final response = await client.request(
//         requestType: RequestType.POST,
//         path: "api/upload_profile_image",
//         parameter: {
//           "image": image,
//         });
//     if (response.statusCode == 200) {
//       print(response.statusCode.toString() + response.body);
//       print("fetchServices image status 200");
//       return ImageModel.fromJson(json.decode(response.body));
//     } else {
//       return ImageModel.fromJson(json.decode(response.body));
//     }
//   }

//   ///rating
//   static Future<RatingModel> RatingRequest(double rating) async {
//     print("  RatingRequest  ");
//     //  String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdGF4aS5wZWFrbGlua2RlbW8uY29tL2FwaS9sb2dpbiIsImlhdCI6MTY2MDQ2NzE1NSwiZXhwIjoxNjYzMDk1MTU1LCJuYmYiOjE2NjA0NjcxNTUsImp0aSI6ImdWNUR3Z3Vac1E2a0FvQTAiLCJzdWIiOjEwMDA4LCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.dltBQ616-Vf7j9A-til2lEw7jE9EQbMdoHT5MhO3FcU";
//    String r="rider";
//    String g="good";
//    int i=4;
//    print(rating);
// //
// // String t="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdGF4aS5wZWFrbGlua2RlbW8uY29tL2FwaS9sb2dpbiIsImlhdCI6MTY2MTA3OTE4MiwiZXhwIjoxNjYzNzA3MTgyLCJuYmYiOjE2NjEwNzkxODIsImp0aSI6InRqOHZDR0pDZjJ3clRDWWIiLCJzdWIiOjEwMDA4LCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.U-Q18f8HhIwF4arsInjbaFfIX_F70EIVJ0j_ti2xxdA";
//     String tokenn =
//         "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdGF4aS5wZWFrbGlua2RlbW8uY29tL2FwaS9sb2dpbiIsImlhdCI6MTY2MTA3OTE4MiwiZXhwIjoxNjYzNzA3MTgyLCJuYmYiOjE2NjEwNzkxODIsImp0aSI6InRqOHZDR0pDZjJ3clRDWWIiLCJzdWIiOjEwMDA4LCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.U-Q18f8HhIwF4arsInjbaFfIX_F70EIVJ0j_ti2xxdA";
//     final response = await client.requesttoken(
//         requestType: RequestType.GET,
//         path:
//             "api/trip_rating?user_type=$r&trip_id=$i&rating=$rating&rating_comments=$g",
//         token: tokenn);
//     print("jdbhjb");

//     print(response.statusCode.toString() + response.body);
//     if (response.statusCode == 200) {
//       print(response.statusCode.toString() + response.body);
//       print("fetchServices status 200");
//       return RatingModel.fromJson(json.decode(response.body));
//     } else {
//       return RatingModel.fromJson(json.decode(response.body));
//     }
//   }
//   ///trips
//   // ignore: non_constant_identifier_names
//   static Future<List<TripsModel>> TripRequest() async {
//     print("TripRequest");
//    String t="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdGF4aS5wZWFrbGlua2RlbW8uY29tL2FwaS9sb2dpbiIsImlhdCI6MTY2MTQxODU0NywiZXhwIjoxNjY0MDQ2NTQ3LCJuYmYiOjE2NjE0MTg1NDcsImp0aSI6ImR1MHBoaXZMSGxJT0U3TEkiLCJzdWIiOjEwMDA4LCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.bfnLCtxSwHXziP9rDoIijH7QmTxJNK5Eg_0vDJUriZ8";
// String r="rider";
// print("token "+t);

//     final response = await client.requesttoken(
//         requestType: RequestType.GET,
//         path: "api/get_driver_trip?user_type=$r",
//         token: t);
//     print("after"+response.body.length.toString());
//     print(response.body.toString());
//     print(response.body);

//     print("after"+response.statusCode.toString());
//     if (response.statusCode == 200) {
//       print(response.statusCode.toString() + response.body);

//       print("fetchServices status 200");
//       print("fetchServices status 200");
//       return TripsList.fromJson(json.decode(response.body)["data"]).tripsget;
//     } else {
//       throw Exception('Failed to load post');
//   //return
//      // TripsList.fromJson(json.decode(response.body));
//     }
//   }
//   ///trips_details
//   static Future<TripDetailsModel> TripDetailsRequest(int id) async {
//     print("TripRequest");
//    //String t="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdGF4aS5wZWFrbGlua2RlbW8uY29tL2FwaS9sb2dpbiIsImlhdCI6MTY2MTQxODU0NywiZXhwIjoxNjY0MDQ2NTQ3LCJuYmYiOjE2NjE0MTg1NDcsImp0aSI6ImR1MHBoaXZMSGxJT0U3TEkiLCJzdWIiOjEwMDA4LCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.bfnLCtxSwHXziP9rDoIijH7QmTxJNK5Eg_0vDJUriZ8";
//     String t="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdGF4aS5wZWFrbGlua2RlbW8uY29tL2FwaS9sb2dpbiIsImlhdCI6MTY2MTIzNDg3NywiZXhwIjoxNjYzODYyODc3LCJuYmYiOjE2NjEyMzQ4NzcsImp0aSI6InZ6ZEpoODFSa1VTQU1HMHEiLCJzdWIiOjEwMDA4LCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.YOE0yuckhKAKh0fAnKVT5T8zTp6SPsOxvlKaBnUTeCM";
//     String r="rider";
//     print("token "+t);

//     final response = await client.requesttoken(
//         requestType: RequestType.GET,
//         path: "api/get_trip_details?trip_id=$id",
//         token: t);
//     print("after"+response.body.length.toString());
//     print(response.body.toString());
//     print(response.body);

//     print("after"+response.statusCode.toString());
//     if (response.statusCode == 200) {
//       print(response.statusCode.toString() + response.body);

//       print("fetchServices status 200");
//       print("fetchServices status 200");
//       return TripDetailsModel.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to load post');
//       //return
//       // TripsList.fromJson(json.decode(response.body));
//     }
//   }
//   ///Near Taxi
//   static Future<List<NearTaxiModel>> NearTaxiRequest(double lat,double lan) async {
//     print("NearTaxiRequest");
//     //String t="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdGF4aS5wZWFrbGlua2RlbW8uY29tL2FwaS9sb2dpbiIsImlhdCI6MTY2MTQxODU0NywiZXhwIjoxNjY0MDQ2NTQ3LCJuYmYiOjE2NjE0MTg1NDcsImp0aSI6ImR1MHBoaXZMSGxJT0U3TEkiLCJzdWIiOjEwMDA4LCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.bfnLCtxSwHXziP9rDoIijH7QmTxJNK5Eg_0vDJUriZ8";
//   //  String t="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdGF4aS5wZWFrbGlua2RlbW8uY29tL2FwaS9sb2dpbiIsImlhdCI6MTY2MTIzNDg3NywiZXhwIjoxNjYzODYyODc3LCJuYmYiOjE2NjEyMzQ4NzcsImp0aSI6InZ6ZEpoODFSa1VTQU1HMHEiLCJzdWIiOjEwMDA4LCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.YOE0yuckhKAKh0fAnKVT5T8zTp6SPsOxvlKaBnUTeCM";
//   String t="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdGF4aS5wZWFrbGlua2RlbW8uY29tL2FwaS9sb2dpbiIsImlhdCI6MTY2MzQ5NDMwNSwiZXhwIjoxNjY2MTIyMzA1LCJuYmYiOjE2NjM0OTQzMDUsImp0aSI6IkVTb2R6WUV6Y0ZwOWVtakQiLCJzdWIiOjEwMDMyLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.rFZxNUXg5uFXLRIyl0qqhlX-hdIyjhcCjtQVEc8TXVI";
//     String r="rider";
//     print("token "+t);

//     final response = await client.requesttoken(
//         requestType: RequestType.GET,
//         path: "api/get_nearest_vehicles?latitude=33.509071&longitude=36.317722",
//         token: t);
//     print("after"+response.body.length.toString());

//     print(response.body);
//     print("after"+response.statusCode.toString());
//     if (response.statusCode == 200) {
//       print(response.statusCode.toString() + response.body);
//       //print(NearTaxiModel.fromJson(json.decode(response.body)["data"]));

//       return NearTaxiList.fromJson(json.decode(response.body)["data"]).taxis;
//     } else {

//    //   return NearTaxiModel.fromJson(json.decode(response.body));
//       throw Exception('Failed to loads post');
//       //return
//       // TripsList.fromJson(json.decode(response.body));
//     }
//   }
//   /// search car with lat and lan
//   static Future<List<CarModel>> CarRequest(double lats,double lans,double latd,double land,) async {
//     print("NearTaxiRequest");
//   // String t="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vdGF4aS5wZWFrbGlua2RlbW8uY29tL2FwaS9sb2dpbiIsImlhdCI6MTY2MzQ5NDMwNSwiZXhwIjoxNjY2MTIyMzA1LCJuYmYiOjE2NjM0OTQzMDUsImp0aSI6IkVTb2R6WUV6Y0ZwOWVtakQiLCJzdWIiOjEwMDMyLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.rFZxNUXg5uFXLRIyl0qqhlX-hdIyjhcCjtQVEc8TXVI";
//     String t="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYXBpL2xvZ2luIiwiaWF0IjoxNjYzNjc4ODI4LCJleHAiOjE2NjYzMDY4MjgsIm5iZiI6MTY2MzY3ODgyOCwianRpIjoiT2dwaXJCWnBDejRTNmNBaiIsInN1YiI6MTAwMDUsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.oTv3OsgVxEaDZ-3BvpM88Vx7bJGUVfgifqux1Jk5hUA";
//    String r="rider";
//     print("token "+t);

//     final response = await client.requesttoken(
//         requestType: RequestType.GET,
//         path: "api/search_cars?pickup_latitude=33.513713&pickup_longitude=36.276401&drop_latitude=33.519170&drop_longitude=36.272023&user_type=rider&time=23:00:00",
//         token: t);
//     print("after"+response.body.length.toString());

//     print(response.body);
//     print("after"+response.statusCode.toString());
//     if (response.statusCode == 200) {
//       print(response.statusCode.toString() + response.body);
//       //print(NearTaxiModel.fromJson(json.decode(response.body)["data"]));

//       return CarList.fromJson(json.decode(response.body)["data"]).cars;
//     } else {

//       //   return NearTaxiModel.fromJson(json.decode(response.body));
//       throw Exception('Failed to load post');
//       //return
//       // TripsList.fromJson(json.decode(response.body));
//     }
//   }

// ///signup
// static Future<SignUpModel> SignUpRequest(
//     String mobil, String user, String countrycode) async {
//   print("SignUp fetch name register" + mobil.toString());
//   print("SignUp fetch Phone register" + user.toString());
//   print("SignUp fetch password register" + countrycode.toString());

//   final response = await client.request(
//     requestType: RequestType.GET,
//     path:
//         "api/numbervalidation?mobile_number=$mobil&user_type=$user&country_code=$countrycode",
//   );
//   if (response.statusCode == 200) {
//     print(response.statusCode.toString() + response.body);
//     print("fetchServices status 200");
//     return SignUpModel.fromJson(json.decode(response.body));
//   } else {
//     return SignUpModel.fromJson(json.decode(response.body));
//   }
// }

// ///otp
// static Future<OtpModel> OtpRequest(String mobil, String code) async {
//   print("  otp fetchnamemobile :  " + mobil.toString());
//   print("otp fetch code :   " + code.toString());
//   final response = await client.request(
//     requestType: RequestType.GET,
//     path: "api/otp_verification_signup?mobile_number=$mobil&code=$code",
//   );
//   print("jdbhjb");
//   if (response.statusCode == 200) {
//     print(response.statusCode.toString() + response.body);
//     print("fetchServices status 200");
//     return OtpModel.fromJson(json.decode(response.body));
//   } else {
//     return OtpModel.fromJson(json.decode(response.body));
//   }
// }

// ///reset password
// static Future<ResetModel> ResetRequest(
//     String number, int otp, String password, String confirm) async {
//   print("ResetRequest");
//   final response = await client.request(
//     requestType: RequestType.GET,
//     path:
//         "api/reset_password?mobile_number=$number&otp=$otp&password=$password&confirm_password=$confirm",
//   );
//   if (response.statusCode == 200) {
//     print(response.statusCode.toString() + response.body);
//     print("fetchServices status 200");

//     return ResetModel.fromJson(json.decode(response.body));
//   } else {
//     return ResetModel.fromJson(json.decode(response.body));
//   }
// }

/////////////////////////////////////////////////////////////////
  ///************************************************************* */

// ///creatacount
// ///id card register
// // static Future<IdCardRegisterModel> IdRegisterRequest(String first_name, String last_name, String mother_name, String father_name, String phone, String password, String email, String id_entry, String national_number, String place_of_birth, String date_of_birth,) async {
// //   print("IdRegisterRequest");
// //   SharedPreferences prefs = await SharedPreferences.getInstance();
// //   final response = await client.request(
// //       requestType: RequestType.POST,
// //       path: "api/user-registration",
// //       parameter: {
// //         "first_name": first_name,
// //         "last_name": last_name,
// //         "mother_name": mother_name,
// //         "father_name": father_name,
// //         "phone": phone,
// //         "password": password,
// //         "email": email,
// //         "id_entry": id_entry,
// //         "national_number": national_number,
// //         "place_of_birth": place_of_birth,
// //         "date_of_birth": date_of_birth,
// //         // "profile_image": profile_image,
// //       });

// //   if (response.statusCode == 200) {
// //     print(response.statusCode.toString() + response.body);
// //     print("fetch Services status 200");
// //     // token = IdCardRegisterModel.fromJson(json.decode(response.body))
// //     //     .data!
// //     //     .apiToken
// //     //     .toString();
// //     // print("the token in creat acount  :  " + token);
// //     // return IdCardRegisterModel.fromJson(json.decode(response.body));
// //     if (IdCardRegisterModel.fromJson(json.decode(response.body)).error ==
// //         false) {
// //       token = IdCardRegisterModel.fromJson(json.decode(response.body))
// //           .data!
// //           .apiToken;
// //       user_id = IdCardRegisterModel.fromJson(json.decode(response.body))
// //           .data!
// //           .user!
// //           .id
// //           .toString();
// //       print(token);
// //       print(user_id);
// //       prefs.setString('token', token!);
// //       prefs.setString('user_id', user_id!);
// //       return IdCardRegisterModel.fromJson(json.decode(response.body));
// //     } else {
// //       return IdCardRegisterModel.fromJson(json.decode(response.body));
// //     }
// //   } else {
// //     return IdCardRegisterModel.fromJson(json.decode(response.body));
// //   }
// // }

// // IdCard register with upload image
// static Future<IdCardRegisterModel> IdCardRegisteruploadImageRequest(
//     String fname,
//     String lname,
//     String mother_name,
//     String father_name,
//     String phone,
//     String password,
//     String email,
//     String id_entry,
//     String national_number,
//     String place_of_birth,
//     String date_of_birth,
//     File imageFile) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   fcm_token = prefs.getString('fcm_token') ?? '';

//   print("start send");
//   var req = http.MultipartRequest('POST',
//       Uri.parse('http://dimond-line.peaklinkdemo.com/api/user-registration'));
//   print("afterrrrrr");
//   req.fields['first_name'] = fname;
//   req.fields['last_name'] = lname;
//   req.fields['mother_name'] = mother_name;
//   req.fields['father_name'] = father_name;
//   req.fields['phone'] = phone;
//   req.fields['password'] = password;
//   req.fields['email'] = email;
//   req.fields['id_entry'] = id_entry;
//   req.fields['national_number'] = national_number;
//   req.fields['place_of_birth'] = place_of_birth;
//   req.fields['date_of_birth'] = date_of_birth;
//   req.fields['device_token'] = fcm_token!;

//   print("path" + imageFile.path.split("/").last.toString());
//   print('********************');
//   print((imageFile.path).toString().split("/").last);

//   if (imageFile.path != "") {
//     print("imagefile not null");

//     var stream = new http.ByteStream(imageFile.openRead());
//     var length = await imageFile.length();

//     var multipartFile = new http.MultipartFile(
//         'profile_image', stream, length,
//         filename: (imageFile.path).toString().split("/").last);

//     req.files.add(multipartFile);
//     var streamedResponse = await req.send();
//     var response = await http.Response.fromStream(streamedResponse);

//     if (response.statusCode == 200) {
//       print(response.statusCode.toString() + response.body);
//       print("fetchServices status 200");
//       if (IdCardRegisterModel.fromJson(json.decode(response.body)).error ==
//           false) {
//         token = IdCardRegisterModel.fromJson(json.decode(response.body))
//             .data!
//             .apiToken;
//         user_id = IdCardRegisterModel.fromJson(json.decode(response.body))
//             .data!
//             .user!
//             .id
//             .toString();
//         print(token);
//         print(user_id);
//         prefs.setString('token', token!);
//         prefs.setString('user_id', user_id!);

//       type_of_customer = IdCardRegisterModel.fromJson(json.decode(response.body)).data!.user!.userType;;
//       prefs.setString('type_of_customer', type_of_customer!);
//       // if(type_of_customer == 'external_driver' || type_of_customer == 'driver'){
//       //   deviceNumber = IdCardRegisterModel.fromJson(json.decode(response.body)).data!.deviceNumber;
//       // prefs.setString('deviceNumber', deviceNumber!);
//       // }
//         return IdCardRegisterModel.fromJson(json.decode(response.body));
//       } else {
//         return IdCardRegisterModel.fromJson(json.decode(response.body));
//       }
//     } else {
//       return IdCardRegisterModel.fromJson(json.decode(response.body));
//     }
//   } else {
//     throw Exception('Failed to load trip category');
//   }
// }

// // ///passport register
// // static Future<PassportNumberRegisterModel> PassportRegisterRequest(String fname, String lname, String mother_name, String father_name, String phone, String password, String email, String passport_number, String place_of_birth, String date_of_birth,) async {
// //   print("PassportRegisterRequest");
// //   SharedPreferences prefs = await SharedPreferences.getInstance();
// //   final response = await client.request(
// //       requestType: RequestType.POST,
// //       path: "api/user1-registration",
// //       parameter: {
// //         "first_name": fname,
// //         "last_name": lname,
// //         "mother_name": mother_name,
// //         "father_name": father_name,
// //         "phone": phone,
// //         "password": password,
// //         "email": email,
// //         "passport_number": passport_number,
// //         "place_of_birth": place_of_birth,
// //         "date_of_birth": date_of_birth,
// //         // "profile_image": profile_image,
// //       });
// //   if (response.statusCode == 200) {
// //     print(response.statusCode.toString() + response.body);
// //     print("fetch Services status 200");
// //     // token = IdCardRegisterModel.fromJson(json.decode(response.body))
// //     //     .data!
// //     //     .apiToken
// //     //     .toString();
// //     // print("the token in creat acount  :  " + token);
// //     // return PassportNumberRegisterModel.fromJson(json.decode(response.body));

// //     if (PassportNumberRegisterModel.fromJson(json.decode(response.body))
// //             .error ==
// //         false) {
// //       token = PassportNumberRegisterModel.fromJson(json.decode(response.body))
// //           .data!
// //           .apiToken;
// //       user_id =
// //           PassportNumberRegisterModel.fromJson(json.decode(response.body))
// //               .data!
// //               .user!
// //               .id
// //               .toString();
// //       print(token);
// //       print(user_id);
// //       prefs.setString('token', token!);
// //       prefs.setString('user_id', user_id!);
// //       return PassportNumberRegisterModel.fromJson(json.decode(response.body));
// //     } else {
// //       return PassportNumberRegisterModel.fromJson(json.decode(response.body));
// //     }
// //   } else {
// //     return PassportNumberRegisterModel.fromJson(json.decode(response.body));
// //   }
// // }

// ///passport register with upload image
// static Future<PassportNumberRegisterModel> PassportRegisterRequest(
//     String fname,
//     String lname,
//     String mother_name,
//     String father_name,
//     String phone,
//     String password,
//     String email,
//     String passport_number,
//     String place_of_birth,
//     String date_of_birth,
//     File imageFile) async {
//   print("PassportRegisterRequest");
//   /////////////////////////
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   fcm_token = prefs.getString('fcm_token') ?? '';

//   print("start send");
//   var req = http.MultipartRequest(
//       'POST',
//       Uri.parse(
//           'http://dimond-line.peaklinkdemo.com/api/user1-registration'));
//   print("afterrrrrr");
//   req.fields['first_name'] = fname;
//   req.fields['last_name'] = lname;
//   req.fields['mother_name'] = mother_name;
//   req.fields['father_name'] = father_name;
//   req.fields['phone'] = phone;
//   req.fields['password'] = password;
//   req.fields['email'] = email;
//   req.fields['passport_number'] = passport_number;
//   req.fields['place_of_birth'] = place_of_birth;
//   req.fields['date_of_birth'] = date_of_birth;
//   req.fields['device_token'] = fcm_token!;

//   print("path" + imageFile.path.split("/").last.toString());
//   print('********************');
//   print((imageFile.path).toString().split("/").last);

//   if (imageFile.path != "") {
//     print("imagefile not null");

//     var stream = new http.ByteStream(imageFile.openRead());
//     var length = await imageFile.length();

//     var multipartFile = new http.MultipartFile(
//         'profile_image', stream, length,
//         filename: (imageFile.path).toString().split("/").last);

//     req.files.add(multipartFile);
//     var streamedResponse = await req.send();
//     var response = await http.Response.fromStream(streamedResponse);

//     if (response.statusCode == 200) {
//       print(response.statusCode.toString() + response.body);
//       print("fetchServices status 200");

//       if (PassportNumberRegisterModel.fromJson(json.decode(response.body))
//               .error ==
//           false) {
//         token =
//             PassportNumberRegisterModel.fromJson(json.decode(response.body))
//                 .data!
//                 .apiToken;
//         user_id =
//             PassportNumberRegisterModel.fromJson(json.decode(response.body))
//                 .data!
//                 .user!
//                 .id
//                 .toString();
//         print(token);
//         print(user_id);
//         prefs.setString('token', token!);
//         prefs.setString('user_id', user_id!);
//          type_of_customer = PassportNumberRegisterModel.fromJson(json.decode(response.body)).data!.user!.userType;;
//       prefs.setString('type_of_customer', type_of_customer!);
//       // if(type_of_customer == 'external_driver' || type_of_customer == 'driver'){
//       //   deviceNumber = PassportNumberRegisterModel.fromJson(json.decode(response.body)).data!.deviceNumber;
//       // prefs.setString('deviceNumber', deviceNumber!);
//       // }
//         return PassportNumberRegisterModel.fromJson(
//             json.decode(response.body));
//       } else {
//         return PassportNumberRegisterModel.fromJson(
//             json.decode(response.body));
//       }
//     } else {
//       return PassportNumberRegisterModel.fromJson(json.decode(response.body));
//     }
//   } else {
//     throw Exception('Failed to load trip category');
//   }
// }

  ///Email register
// static Future<EmailRegisterModel> EmailRegisterRequest(String first_name, String last_name, String email, String password, String profile_image, String passport_number) async {
//   print("EmailRegisterRequest");
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   final response = await client.request(
//       requestType: RequestType.POST,
//       path: "api/userforiegn-registration",
//       parameter: {
//         "first_name": first_name,
//         "last_name": last_name,
//         "email": email,
//         "password": password,
//         "profile_image": profile_image,
//         "passport_number": passport_number,
//         "user_type": "user"
//       });
//   if (response.statusCode == 200) {
//     print(response.statusCode.toString() + response.body);
//     print("fetch Services status 200");
//     if (EmailRegisterModel.fromJson(json.decode(response.body))
//             .error ==
//         false) {
//       token = EmailRegisterModel.fromJson(json.decode(response.body))
//           .data!
//           .apiToken;
//       user_id =
//           EmailRegisterModel.fromJson(json.decode(response.body))
//               .data!
//               .user!
//               .id
//               .toString();
//       print(token);
//       print(user_id);
//       prefs.setString('token', token!);
//       prefs.setString('user_id', user_id!);
//       return EmailRegisterModel.fromJson(json.decode(response.body));
//     } else {
//       return EmailRegisterModel.fromJson(json.decode(response.body));
//     }
//   } else {
//     return EmailRegisterModel.fromJson(json.decode(response.body));
//   }
// }
//
// // EMAIL REGISTER WITH IMAGE
// static Future<EmailRegisterModel> EmailRegisteruploadImageRequest(
//     String fname,
//     String lname,
//     String email,
//     String password,
//     String passport_number,
//     File imageFile) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   fcm_token = prefs.getString('fcm_token') ?? '';
//
//   print('EmailRegisterRequest');
//   print("start send");
//   var req = http.MultipartRequest(
//       'POST',
//       Uri.parse(
//           'http://dimond-line.peaklinkdemo.com/api/userforiegn-registration'));
//   print("afterrrrrr");
//   req.fields['first_name'] = fname;
//   req.fields['last_name'] = lname;
//   req.fields['email'] = email;
//   req.fields['password'] = password;
//   req.fields['passport_number'] = passport_number;
//   req.fields['user_type'] = "foreign user";
//   req.fields['device_token'] = fcm_token!;
//   print("path" + imageFile.path.split("/").last.toString());
//   print('********************');
//   print((imageFile.path).toString().split("/").last);
//
//   if (imageFile.path != "") {
//     print("imagefile not null");
//
//     var stream = new http.ByteStream(imageFile.openRead());
//     var length = await imageFile.length();
//
//     var multipartFile = new http.MultipartFile(
//         'profile_image', stream, length,
//         filename: (imageFile.path).toString().split("/").last);
//
//     req.files.add(multipartFile);
//     var streamedResponse = await req.send();
//     var response = await http.Response.fromStream(streamedResponse);
//
//     if (response.statusCode == 200) {
//       print(response.statusCode.toString() + response.body);
//       print("fetchServices status 200");
//       if (EmailRegisterModel.fromJson(json.decode(response.body)).error ==
//           false) {
//         token = EmailRegisterModel.fromJson(json.decode(response.body))
//             .data!
//             .apiToken;
//         user_id = EmailRegisterModel.fromJson(json.decode(response.body))
//             .data!
//             .user!
//             .id
//             .toString();
//         print(token);
//         print(user_id);
//         prefs.setString('token', token!);
//         prefs.setString('user_id', user_id!);
//
//
//          type_of_customer = EmailRegisterModel.fromJson(json.decode(response.body)).data!.user!.userType;
//       prefs.setString('type_of_customer', type_of_customer!);
//       // if(type_of_customer == 'external_driver' || type_of_customer == 'driver'){
//       //   deviceNumber = EmailRegisterModel.fromJson(json.decode(response.body)).data!.deviceNumber;
//       // prefs.setString('deviceNumber', deviceNumber!);
//       // }
//         return EmailRegisterModel.fromJson(json.decode(response.body));
//       } else {
//         return EmailRegisterModel.fromJson(json.decode(response.body));
//       }
//     } else {
//       return EmailRegisterModel.fromJson(json.decode(response.body));
//     }
//   } else {
//     throw Exception('Failed to load trip category');
//   }
// }

//
// //update profile id card
// static Future<UpdateProfileModel> UpdateProfilRequest(
//   String first_name,
//   String last_name,
//   String mother_name,
//   String father_name,
//   String phone,
//   String password,
//   String email,
//   String id_entry,
//   String national_number,
//   String place_of_birth,
//   String date_of_birth,
// ) async {
//   print(" UpdateProfilRequest");
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   // String token =
//   //     "NARI59DVrT0FVpuknzUDdwYrFp8ByWiGmrmFggjr6lI4IiT9BiPT5fluaRbm";
//   // String user_id = '173';
//   String token = prefs.getString('token') ?? '';
//   user_id = prefs.getString('user_id') ?? '';
//   print(token);
//   print(user_id);
//   final response = await client.requesttoken(
//       requestType: RequestType.POST,
//       path: "api/edit-user-profile",
//       parameter: {
//         "first_name": first_name,
//         "last_name": last_name,
//         "mother_name": mother_name,
//         "father_name": father_name,
//         "phone": phone,
//         "password": password,
//         "email": email,
//         "id_entry": id_entry,
//         "national_number": national_number,
//         "place_of_birth": place_of_birth,
//         "date_of_birth": date_of_birth,
//         "user_id": user_id,
//       },
//       token: token);
//   print(response.body);
//   if (response.statusCode == 200) {
//     print(response.statusCode.toString() + response.body);
//     print("fetchServices status 200");
//     return UpdateProfileModel.fromJson(json.decode(response.body));
//   } else {
//     return UpdateProfileModel.fromJson(json.decode(response.body));
//   }
// }

//  ///forget password email
//   static Future ForgetPasswordEmailRequest(
//       String email, String pass, String confirmPass) async {
//     print("ForgetPasswordEmailRequest");
//     // token = '09xOvCDnOhOSxumzIiWQSRdZx1oMcQrDCtZeFkvgJTXVNPJgXN35JMqWSSh7';
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String token = prefs.getString('token') ?? '';
//     print(token);
//     final response = await client.requesttoken(
//         requestType: RequestType.POST,
//         path: "api/forgot-password-email",
//         parameter: {
//           "email": email,
//           "password": pass,
//           "confirm_password": confirmPass,
//         },
//         token: token);
//     print(email);
//     print(response.body);
//     // var data = json.decode(response.body).data!.id.toString();
//     // var data = json.decode(response.body);
//     // data = data["data"];
//     // user_id = data["id"];
//     // prefs.setString('user_id', user_id!);
//         // token = json.decode(response.body).data!.apiToken;
//         // prefs.setString('token', token);
//         // type_of_customer = json.decode(response.body).data!.type;
//         // prefs.setString('type_of_customer', type_of_customer!);
//     return response.body;
//   }

////////////////////////////////////////////////////////
// ///// layan
// /// update profile id card with upload image
//   static Future<UpdateProfileModel> UpdateProfilRequest(
//   String first_name,
//   String last_name,
//   String mother_name,
//   String father_name,
//   String phone,
//   String password,
//   String email,
//   String id_entry,
//   String national_number,
//   String place_of_birth,
//   String date_of_birth,
//     File imageFile) async {
//   print("UpdateProfilRequest");
//   /////////////////////////
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   // String token =
//   //     "NARI59DVrT0FVpuknzUDdwYrFp8ByWiGmrmFggjr6lI4IiT9BiPT5fluaRbm";
//   // String user_id = '173';
//   String token = prefs.getString('token') ?? '';
//   String user_id = prefs.getString('user_id') ?? '';
//   print(token);
//   print(user_id);

//   print("start send");
//   var req = http.MultipartRequest(
//       'POST',
//       Uri.parse(
//           'http://dimond-line.peaklinkdemo.com/api/edit-user-profile'));
//   print("afterrrrrr");
//   req.fields['first_name'] = first_name;
//   req.fields['last_name'] = last_name;
//   req.fields['mother_name'] = mother_name;
//   req.fields['father_name'] = father_name;
//   req.fields['phone'] = phone;
//   req.fields['password'] = password;
//   req.fields['email'] = email;
//   req.fields['id_entry'] = id_entry;
//   req.fields['national_number'] = national_number;
//   req.fields['place_of_birth'] = place_of_birth;
//   req.fields['date_of_birth'] = date_of_birth;
//   req.fields['user_id'] = user_id;
//   print("path" + imageFile.path.split("/").last.toString());
//   print('********************');
//   print((imageFile.path).toString().split("/").last);
//   if (imageFile.path != "") {
//     print("imagefile not null");
//     var stream = new http.ByteStream(imageFile.openRead());
//      print("imagefile not null2");
//     var length = await imageFile.length();
//      print("imagefile not null3");
//     var multipartFile = new http.MultipartFile(
//         'profile_image', stream, length,
//         filename: (imageFile.path).toString().split("/").last);
//          print("imagefile not null4");
//     req.files.add(multipartFile);
//      print("imagefile not null5");
//     var streamedResponse = await req.send();
//      print("imagefile not null6");
//     var response = await http.Response.fromStream(streamedResponse);
//      print("imagefile not null7");
//      print(response.statusCode);
//     if (response.statusCode == 200) {
//       print(response.statusCode.toString() + response.body);
//       print("fetchServices status 200");
//       if (UpdateProfileModel.fromJson(json.decode(response.body))
//               .error ==
//           false) {
//         // print(token);
//         // print(user_id);
//         // prefs.setString('token', token!);
//         // prefs.setString('user_id', user_id!);
//         return UpdateProfileModel.fromJson(
//             json.decode(response.body));
//       } else {
//         return UpdateProfileModel.fromJson(
//             json.decode(response.body));
//       }
//     } else {
//       // return UpdateProfileModel.fromJson(json.decode(response.body));
//      throw Exception('Failed to load trip category');
//     }
//   } else {
//     throw Exception('Failed to load trip category');
//   }
// }
  ///layan
//////////////////////////////////////////////////////////

// //update profile passport
// static Future<UpdateProfilePassportModel> UpdateProfilePassportRequest(
//   String first_name,
//   String last_name,
//   String mother_name,
//   String father_name,
//   String phone,
//   String password,
//   String email,
//   String passport_number,
//   String place_of_birth,
//   String date_of_birth,
// ) async {
//   print(" UpdateProfilRequest");
//   // String token =
//   //     "09xOvCDnOhOSxumzIiWQSRdZx1oMcQrDCtZeFkvgJTXVNPJgXN35JMqWSSh7";
//   // String user_id = '210';
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   token = prefs.getString('token') ?? '';
//   user_id = prefs.getString('user_id') ?? '';
//   print(token);
//   print(user_id);
//   final response = await client.requesttoken(
//       requestType: RequestType.POST,
//       path: "api/edit-user1-profile",
//       parameter: {
//         "first_name": first_name,
//         "last_name": last_name,
//         "mother_name": mother_name,
//         "father_name": father_name,
//         "phone": phone,
//         "password": password,
//         "email": email,
//         "passport_number": passport_number,
//         "place_of_birth": place_of_birth,
//         "date_of_birth": date_of_birth,
//         "user_id": user_id,
//       },
//       token: token);
//   print(response.body);
//   if (response.statusCode == 200) {
//     print(response.statusCode.toString() + response.body);
//     print("fetchServices status 200");
//     return UpdateProfilePassportModel.fromJson(json.decode(response.body));
//   } else {
//     return UpdateProfilePassportModel.fromJson(json.decode(response.body));
//   }
// }

  /// layan
// //update profile passport with upload image
// static Future<UpdateProfilePassportModel> UpdateProfilePassportRequest(
//   String first_name,
//   String last_name,
//   String mother_name,
//   String father_name,
//   String phone,
//   String password,
//   String email,
//   String passport_number,
//   String place_of_birth,
//   String date_of_birth,
//     File imageFile) async {
//   print("UpdateProfilePassportRequest");
//   /////////////////////////
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   // String token =
//   //     "NARI59DVrT0FVpuknzUDdwYrFp8ByWiGmrmFggjr6lI4IiT9BiPT5fluaRbm";
//   // String user_id = '210';
//   String token = prefs.getString('token') ?? '';
//   String user_id = prefs.getString('user_id') ?? '';
//   print(token);
//   print(user_id);

//   print("start send");
//   var req = http.MultipartRequest(
//       'POST',
//       Uri.parse(
//           'http://dimond-line.peaklinkdemo.com/api/edit-user1-profile'));
//   print("afterrrrrr");
//   req.fields['first_name'] = first_name;
//   req.fields['last_name'] = last_name;
//   req.fields['mother_name'] = mother_name;
//   req.fields['father_name'] = father_name;
//   req.fields['phone'] = phone;
//   req.fields['password'] = password;
//   req.fields['email'] = email;
//   req.fields['passport_number'] = passport_number;
//   req.fields['place_of_birth'] = place_of_birth;
//   req.fields['date_of_birth'] = date_of_birth;
//   req.fields['user_id'] = user_id;
//   print("path" + imageFile.path.split("/").last.toString());
//   print('********************');
//   print((imageFile.path).toString().split("/").last);
//   if (imageFile.path != "") {
//     print("imagefile not null");
//     var stream = new http.ByteStream(imageFile.openRead());
//     var length = await imageFile.length();
//     var multipartFile = new http.MultipartFile(
//         'profile_image', stream, length,
//         filename: (imageFile.path).toString().split("/").last);
//     req.files.add(multipartFile);
//     var streamedResponse = await req.send();
//     var response = await http.Response.fromStream(streamedResponse);
//     if (response.statusCode == 200) {
//       print(response.statusCode.toString() + response.body);
//       print("fetchServices status 200");
//       if (UpdateProfileModel.fromJson(json.decode(response.body))
//               .error ==
//           false) {
//         // print(token);
//         // print(user_id);
//         // prefs.setString('token', token!);
//         // prefs.setString('user_id', user_id!);
//         return UpdateProfilePassportModel.fromJson(
//             json.decode(response.body));
//       } else {
//         return UpdateProfilePassportModel.fromJson(
//             json.decode(response.body));
//       }
//     } else {
//       return UpdateProfilePassportModel.fromJson(json.decode(response.body));
//     }
//   } else {
//     throw Exception('Failed to load trip category');
//   }
// }
// ///layan
// ////////////////////////////////////////////////////////////

// //update profile foreigner
// static Future<UpdateProfileForeignerModel> UpdateProfileForeignerRequest(
//     String first_name,
//     String last_name,
//     String email,
//     String password,
//     String passport_number,
//     // String profile_image
//     ) async {
//   print(" UpdateProfilRequest");
//   // String token =
//   //     "09xOvCDnOhOSxumzIiWQSRdZx1oMcQrDCtZeFkvgJTXVNPJgXN35JMqWSSh7";
//   // String user_id = '169';
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   token = prefs.getString('token') ?? '';
//   user_id = prefs.getString('user_id') ?? '';
//   String user_type = 'user';
//   print(token);
//   print(user_id);
//   final response = await client.requesttoken(
//       requestType: RequestType.POST,
//       path: "api/edit-userforiegn-profile",
//       parameter: {
//         "first_name": first_name,
//         "last_name": last_name,
//         "email": email,
//         "password": password,
//         "passport_number": passport_number,
//         "user_type": user_type,
//         "user_id": user_id,
//         // "profile_image": profile_image,
//       },
//       token: token);
//   print(response.body);
//   if (response.statusCode == 200) {
//     print(response.statusCode.toString() + response.body);
//     print("fetchServices status 200");
//     return UpdateProfileForeignerModel.fromJson(json.decode(response.body));
//   } else {
//     return UpdateProfileForeignerModel.fromJson(json.decode(response.body));
//   }
// }

//     ////////////////////////////////////////////////////////
//   ///// layan
//   ///update profile foreigner with upload image
//  static Future<UpdateProfileForeignerModel> UpdateProfileForeignerRequest(
//       String first_name,
//       String last_name,
//       String email,
//       String password,
//       String passport_number,
//       File imageFile) async {
//     print("UpdateProfileForeignerRequest");
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     // String token =
//     //     "NARI59DVrT0FVpuknzUDdwYrFp8ByWiGmrmFggjr6lI4IiT9BiPT5fluaRbm";
//     // String user_id = '173';
//     String token = prefs.getString('token') ?? '';
//     String user_id = prefs.getString('user_id') ?? '';
//     print(token);
//     print(user_id);
//     String user_type = 'user';

//     print("start send");
//     var req = http.MultipartRequest(
//         'POST',
//         Uri.parse(
//             'http://dimond-line.peaklinkdemo.com/api/edit-userforiegn-profile'));
//     print("afterrrrrr");
//     req.fields['first_name'] = first_name;
//     req.fields['last_name'] = last_name;
//     req.fields['password'] = password;
//     req.fields['email'] = email;
//     req.fields['passport_number'] = passport_number;
//     req.fields['user_type'] = user_type;
//     req.fields['user_id'] = user_id;

//     print("path" + imageFile.path.split("/").last.toString());
//     print('********************');
//     print((imageFile.path).toString().split("/").last);
//     if (imageFile.path != "") {
//       print("imagefile not null");
//       var stream = new http.ByteStream(imageFile.openRead());
//       var length = await imageFile.length();
//       var multipartFile = new http.MultipartFile(
//           'profile_image', stream, length,
//           filename: (imageFile.path).toString().split("/").last);
//       req.files.add(multipartFile);
//       var streamedResponse = await req.send();
//       var response = await http.Response.fromStream(streamedResponse);
//       if (response.statusCode == 200) {
//         print(response.statusCode.toString() + response.body);
//         print("fetchServices status 200");
//         if (UpdateProfileModel.fromJson(json.decode(response.body))
//                 .error ==
//             false) {
//           return UpdateProfileForeignerModel.fromJson(
//               json.decode(response.body));
//         } else {
//           return UpdateProfileForeignerModel.fromJson(
//               json.decode(response.body));
//         }
//       } else {
//         return UpdateProfileForeignerModel.fromJson(json.decode(response.body));
//       }
//     } else {
//       throw Exception('Failed to load trip category');
//     }
//   }
//   ///layan
//   ////////////////////////////////////////////////////////////

//     // get socket api
//   static Future<List<WebSocketModel>> getSocket(String category_id) async {
//     print("GetSubCategoryRequest");
//     String token =
//         "GOQyunADEG5H59uSJn74NEcP19DIXmuaqYsMoCbbIDQl75SWlJqrGx5oAxyq";
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     // token = prefs.getString('token') ?? '';
//     print(token);
//     final response = await client.requesttoken(
//         requestType: RequestType.POST, path: "api/subcategory", token: token,
//         parameter: {
//           "category_id" : category_id
//         });
//     print(response.body);
//     if (response.statusCode == 200) {
//           print(response.statusCode.toString() + response.body);
//           print("fetchServices status 200");
//           return SubTripsCategoryList.fromJson(json.decode(response.body)("data")).tripsget;
//     } else {
//       throw Exception('Failed to load trip category');
//       // return GetTripCategoryModel.fromJson(json.decode(response.body));
//     }
//   }

}
