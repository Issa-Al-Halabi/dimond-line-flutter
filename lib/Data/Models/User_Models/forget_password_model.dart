/// error : false
/// message : "password updated Successfully!."
/// data : {"id":242,"api_token":"ltjviuCPlz6rxFflXv9OwPyD3I44UcZuF4QTEufucC0pNnWo7Z0f5npovgR1","user_type":"external_driver","device_token":"jheduqwjkdnqwdjqiodhishhdfplfepwelpfuyeiuqeyiuyeiu","device_number":"276"}

class ForgetPasswordModel {
  ForgetPasswordModel({
    bool? error,
    String? message,
    Data? data,
  }) {
    _error = error;
    _message = message;
    _data = data;
  }

  ForgetPasswordModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _error;
  String? _message;
  Data? _data;
  ForgetPasswordModel copyWith({
    bool? error,
    String? message,
    Data? data,
  }) =>
      ForgetPasswordModel(
        error: error ?? _error,
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

/// id : 242
/// api_token : "ltjviuCPlz6rxFflXv9OwPyD3I44UcZuF4QTEufucC0pNnWo7Z0f5npovgR1"
/// user_type : "external_driver"
/// device_token : "jheduqwjkdnqwdjqiodhishhdfplfepwelpfuyeiuqeyiuyeiu"
/// device_number : "276"

class Data {
  Data({
    int? id,
    String? apiToken,
    String? userType,
    String? deviceToken,
    String? deviceNumber,
  }) {
    _id = id;
    _apiToken = apiToken;
    _userType = userType;
    _deviceToken = deviceToken;
    _deviceNumber = deviceNumber;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _apiToken = json['api_token'];
    _userType = json['user_type'];
    _deviceToken = json['device_token'];
    _deviceNumber = json['device_number'];
  }
  int? _id;
  String? _apiToken;
  String? _userType;
  String? _deviceToken;
  String? _deviceNumber;
  Data copyWith({
    int? id,
    String? apiToken,
    String? userType,
    String? deviceToken,
    String? deviceNumber,
  }) =>
      Data(
        id: id ?? _id,
        apiToken: apiToken ?? _apiToken,
        userType: userType ?? _userType,
        deviceToken: deviceToken ?? _deviceToken,
        deviceNumber: deviceNumber ?? _deviceNumber,
      );
  int? get id => _id;
  String? get apiToken => _apiToken;
  String? get userType => _userType;
  String? get deviceToken => _deviceToken;
  String? get deviceNumber => _deviceNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['api_token'] = _apiToken;
    map['user_type'] = _userType;
    map['device_token'] = _deviceToken;
    map['device_number'] = _deviceNumber;
    return map;
  }
}
