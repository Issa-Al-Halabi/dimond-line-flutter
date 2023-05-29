import 'dart:convert';
/// error : false
/// data : {"email":"layaneias@gmail.com","code":670995}
/// message : "success"

SendOtpEmailModel sendOtpEmailModelFromJson(String str) => SendOtpEmailModel.fromJson(json.decode(str));
String sendOtpEmailModelToJson(SendOtpEmailModel data) => json.encode(data.toJson());
class SendOtpEmailModel {
  SendOtpEmailModel({
      bool? error, 
      Data? data, 
      String? message,}){
    _error = error;
    _data = data;
    _message = message;
}

  SendOtpEmailModel.fromJson(dynamic json) {
    _error = json['error'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _message = json['message'];
  }
  bool? _error;
  Data? _data;
  String? _message;
SendOtpEmailModel copyWith({  bool? error,
  Data? data,
  String? message,
}) => SendOtpEmailModel(  error: error ?? _error,
  data: data ?? _data,
  message: message ?? _message,
);
  bool? get error => _error;
  Data? get data => _data;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['message'] = _message;
    return map;
  }

}

/// email : "layaneias@gmail.com"
/// code : 670995

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? email, 
      num? code,}){
    _email = email;
    _code = code;
}

  Data.fromJson(dynamic json) {
    _email = json['email'];
    _code = json['code'];
  }
  String? _email;
  num? _code;
Data copyWith({  String? email,
  num? code,
}) => Data(  email: email ?? _email,
  code: code ?? _code,
);
  String? get email => _email;
  num? get code => _code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['code'] = _code;
    return map;
  }

}