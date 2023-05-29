import 'dart:convert';
/// error : false
/// message : "You have Signed in Successfully!"
/// data : {"api_token":"ltjviuCPlz6rxFflXv9OwPyD3I44UcZuF4QTEufucC0pNnWo7Z0f5npovgR1","id":242,"type":"external_driver","device_number":"248"}

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));
String loginModelToJson(LoginModel data) => json.encode(data.toJson());
class LoginModel {
  LoginModel({
      bool? error, 
      String? message, 
      Data? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  LoginModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _error;
  String? _message;
  Data? _data;
LoginModel copyWith({  bool? error,
  String? message,
  Data? data,
}) => LoginModel(  error: error ?? _error,
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

/// api_token : "ltjviuCPlz6rxFflXv9OwPyD3I44UcZuF4QTEufucC0pNnWo7Z0f5npovgR1"
/// id : 242
/// type : "external_driver"
/// device_number : "248"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? apiToken, 
      num? id, 
      String? type, 
      String? deviceNumber,}){
    _apiToken = apiToken;
    _id = id;
    _type = type;
    _deviceNumber = deviceNumber;
}

  Data.fromJson(dynamic json) {
    _apiToken = json['api_token'];
    _id = json['id'];
    _type = json['type'];
    _deviceNumber = json['device_number'];
  }
  String? _apiToken;
  num? _id;
  String? _type;
  String? _deviceNumber;
Data copyWith({  String? apiToken,
  num? id,
  String? type,
  String? deviceNumber,
}) => Data(  apiToken: apiToken ?? _apiToken,
  id: id ?? _id,
  type: type ?? _type,
  deviceNumber: deviceNumber ?? _deviceNumber,
);
  String? get apiToken => _apiToken;
  num? get id => _id;
  String? get type => _type;
  String? get deviceNumber => _deviceNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['api_token'] = _apiToken;
    map['id'] = _id;
    map['type'] = _type;
    map['device_number'] = _deviceNumber;
    return map;
  }

}