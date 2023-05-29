// import 'dart:convert';
// /// message : "OTP verification successful"
// /// erorr : false

// VerifyOtpModel verifyOtpModelFromJson(String str) => VerifyOtpModel.fromJson(json.decode(str));
// String verifyOtpModelToJson(VerifyOtpModel data) => json.encode(data.toJson());
// class VerifyOtpModel {
//   VerifyOtpModel({
//       String? message, 
//       bool? erorr,}){
//     _message = message;
//     _erorr = erorr;
// }

//   VerifyOtpModel.fromJson(dynamic json) {
//     _message = json['message'];
//     _erorr = json['erorr'];
//   }
//   String? _message;
//   bool? _erorr;
// VerifyOtpModel copyWith({  String? message,
//   bool? erorr,
// }) => VerifyOtpModel(  message: message ?? _message,
//   erorr: erorr ?? _erorr,
// );
//   String? get message => _message;
//   bool? get erorr => _erorr;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['message'] = _message;
//     map['erorr'] = _erorr;
//     return map;
//   }

// }


import 'dart:convert';
/// message : "OTP verification successful"
/// erorr : false

VerifyOtpModel verifyOtpModelFromJson(String str) => VerifyOtpModel.fromJson(json.decode(str));
String verifyOtpModelToJson(VerifyOtpModel data) => json.encode(data.toJson());
class VerifyOtpModel {
  VerifyOtpModel({
      String? message, 
      bool? erorr,}){
    _message = message;
    _erorr = erorr;
}

  VerifyOtpModel.fromJson(dynamic json) {
    _message = json['message'];
    _erorr = json['erorr'];
  }
  String? _message;
  bool? _erorr;
VerifyOtpModel copyWith({  String? message,
  bool? erorr,
}) => VerifyOtpModel(  message: message ?? _message,
  erorr: erorr ?? _erorr,
);
  String? get message => _message;
  bool? get erorr => _erorr;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['erorr'] = _erorr;
    return map;
  }

}