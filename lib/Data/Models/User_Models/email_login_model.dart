/// error : false
/// message : "You have Signed in Successfully!"
/// data : {"api_token":"PWSvsQnv7KbKtSL8WpJthN8DacV1TxR8AO95FXvawfGVKtfgpYesXgWYn4jf","id":246,"user_type":"user","device_token":"jdskjuhdiuwqibuqwifuqwiufbciuqiuyeyriyri2y"}

class EmailLoginModel {
  EmailLoginModel({
    bool? error,
    String? message,
    Data? data,}){
    _error = error;
    _message = message;
    _data = data;
  }

  EmailLoginModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _error;
  String? _message;
  Data? _data;
  EmailLoginModel copyWith({  bool? error,
    String? message,
    Data? data,
  }) => EmailLoginModel(  error: error ?? _error,
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

/// api_token : "PWSvsQnv7KbKtSL8WpJthN8DacV1TxR8AO95FXvawfGVKtfgpYesXgWYn4jf"
/// id : 246
/// user_type : "user"
/// device_token : "jdskjuhdiuwqibuqwifuqwiufbciuqiuyeyriyri2y"

class Data {
  Data({
    String? apiToken,
    int? id,
    String? userType,
    String? deviceToken,}){
    _apiToken = apiToken;
    _id = id;
    _userType = userType;
    _deviceToken = deviceToken;
  }

  Data.fromJson(dynamic json) {
    _apiToken = json['api_token'];
    _id = json['id'];
    _userType = json['user_type'];
    _deviceToken = json['device_token'];
  }
  String? _apiToken;
  int? _id;
  String? _userType;
  String? _deviceToken;
  Data copyWith({  String? apiToken,
    int? id,
    String? userType,
    String? deviceToken,
  }) => Data(  apiToken: apiToken ?? _apiToken,
    id: id ?? _id,
    userType: userType ?? _userType,
    deviceToken: deviceToken ?? _deviceToken,
  );
  String? get apiToken => _apiToken;
  int? get id => _id;
  String? get userType => _userType;
  String? get deviceToken => _deviceToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['api_token'] = _apiToken;
    map['id'] = _id;
    map['user_type'] = _userType;
    map['device_token'] = _deviceToken;
    return map;
  }

}