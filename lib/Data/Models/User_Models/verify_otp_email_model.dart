import 'dart:convert';
/// message : "OTP verification successful"
/// erorr : false

VerifyOtpEmailModel verifyOtpEmailModelFromJson(String str) => VerifyOtpEmailModel.fromJson(json.decode(str));
String verifyOtpEmailModelToJson(VerifyOtpEmailModel data) => json.encode(data.toJson());
class VerifyOtpEmailModel {
  VerifyOtpEmailModel({
      String? message, 
      bool? erorr,}){
    _message = message;
    _erorr = erorr;
}

  VerifyOtpEmailModel.fromJson(dynamic json) {
    _message = json['message'];
    _erorr = json['erorr'];
  }
  String? _message;
  bool? _erorr;
VerifyOtpEmailModel copyWith({  String? message,
  bool? erorr,
}) => VerifyOtpEmailModel(  message: message ?? _message,
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