import 'dart:convert';
/// error : false
/// data : {"phone":"0935681341","code":755777}
/// message : "success"

SendOtpModel sendOtpModelFromJson(String str) => SendOtpModel.fromJson(json.decode(str));
String sendOtpModelToJson(SendOtpModel data) => json.encode(data.toJson());
class SendOtpModel {
  SendOtpModel({
      bool? error, 
      Data? data, 
      String? message,}){
    _error = error;
    _data = data;
    _message = message;
}

  SendOtpModel.fromJson(dynamic json) {
    _error = json['error'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _message = json['message'];
  }
  bool? _error;
  Data? _data;
  String? _message;
SendOtpModel copyWith({  bool? error,
  Data? data,
  String? message,
}) => SendOtpModel(  error: error ?? _error,
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

/// phone : "0935681341"
/// code : 755777

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? phone, 
      num? code,}){
    _phone = phone;
    _code = code;
}

  Data.fromJson(dynamic json) {
    _phone = json['phone'];
    _code = json['code'];
  }
  String? _phone;
  num? _code;
Data copyWith({  String? phone,
  num? code,
}) => Data(  phone: phone ?? _phone,
  code: code ?? _code,
);
  String? get phone => _phone;
  num? get code => _code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phone'] = _phone;
    map['code'] = _code;
    return map;
  }

}