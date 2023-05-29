import 'dart:convert';
/// error : false
/// message : "password updated Successfully!."
/// data : {"id":244,"api_token":"hkqxcLqsyjCzxQ7KC1Rhj7eif6LhqEnCWmPjNRvjhCcCt6UAkLIXjpNlFtxH","user_type":"Organizations"}

ForgetPasswordEmailModel forgetPasswordEmailModelFromJson(String str) => ForgetPasswordEmailModel.fromJson(json.decode(str));
String forgetPasswordEmailModelToJson(ForgetPasswordEmailModel data) => json.encode(data.toJson());
class ForgetPasswordEmailModel {
  ForgetPasswordEmailModel({
      bool? error, 
      String? message, 
      Data? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  ForgetPasswordEmailModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _error;
  String? _message;
  Data? _data;
ForgetPasswordEmailModel copyWith({  bool? error,
  String? message,
  Data? data,
}) => ForgetPasswordEmailModel(  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get error => _error;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// id : 244
/// api_token : "hkqxcLqsyjCzxQ7KC1Rhj7eif6LhqEnCWmPjNRvjhCcCt6UAkLIXjpNlFtxH"
/// user_type : "Organizations"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      num? id, 
      String? apiToken, 
      String? userType,}){
    _id = id;
    _apiToken = apiToken;
    _userType = userType;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _apiToken = json['api_token'];
    _userType = json['user_type'];
  }
  num? _id;
  String? _apiToken;
  String? _userType;
Data copyWith({  num? id,
  String? apiToken,
  String? userType,
}) => Data(  id: id ?? _id,
  apiToken: apiToken ?? _apiToken,
  userType: userType ?? _userType,
);
  num? get id => _id;
  String? get apiToken => _apiToken;
  String? get userType => _userType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['api_token'] = _apiToken;
    map['user_type'] = _userType;
    return map;
  }

}