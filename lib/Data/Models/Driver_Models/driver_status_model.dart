// /// error : false
// /// message : "Listed Successfully"
// /// data : {"status":"active","device_number":"276"}
//
// class DriverStatusModel {
//   DriverStatusModel({
//     bool? error,
//     String? message,
//     Data? data,}){
//     _error = error;
//     _message = message;
//     _data = data;
//   }
//
//   DriverStatusModel.fromJson(dynamic json) {
//     _error = json['error'];
//     _message = json['message'];
//     _data = json['data'] != null ? Data.fromJson(json['data']) : null;
//   }
//   bool? _error;
//   String? _message;
//   Data? _data;
//   DriverStatusModel copyWith({  bool? error,
//     String? message,
//     Data? data,
//   }) => DriverStatusModel(  error: error ?? _error,
//     message: message ?? _message,
//     data: data ?? _data,
//   );
//   bool? get error => _error;
//   String? get message => _message;
//   Data? get data => _data;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['error'] = _error;
//     map['message'] = _message;
//     if (_data != null) {
//       map['data'] = _data?.toJson();
//     }
//     return map;
//   }
//
// }
//
// /// status : "active"
// /// device_number : "276"
//
// class Data {
//   Data({
//     String? status,
//     dynamic deviceNumber,}){
//     _status = status;
//     _deviceNumber = deviceNumber;
//   }
//
//   Data.fromJson(dynamic json) {
//     _status = json['status'];
//     _deviceNumber = json['device_number'];
//   }
//   String? _status;
//   dynamic _deviceNumber;
//   Data copyWith({  String? status,
//     String? deviceNumber,
//   }) => Data(  status: status ?? _status,
//     deviceNumber: deviceNumber ?? _deviceNumber,
//   );
//   String? get status => _status;
//   dynamic get deviceNumber => _deviceNumber;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['status'] = _status;
//     map['device_number'] = _deviceNumber;
//     return map;
//   }
//
// }

import 'dart:convert';

/// error : false
/// message : "Listed Successfully"
/// data : {"status":"active","device_number":273}

class DriverStatusModel {
  DriverStatusModel({
    bool? error,
    String? message,
    Data? data,
  }) {
    _error = error;
    _message = message;
    _data = data;
  }

  DriverStatusModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _error;
  String? _message;
  Data? _data;
  DriverStatusModel copyWith({
    bool? error,
    String? message,
    Data? data,
  }) =>
      DriverStatusModel(
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

/// status : "active"
/// device_number : 273

class Data {
  Data({
    String? status,
    int? deviceNumber,
  }) {
    _status = status;
    _deviceNumber = deviceNumber;
  }

  Data.fromJson(dynamic json) {
    _status = json['status'];
    _deviceNumber = json['device_number'];
  }
  String? _status;
  int? _deviceNumber;
  Data copyWith({
    String? status,
    int? deviceNumber,
  }) =>
      Data(
        status: status ?? _status,
        deviceNumber: deviceNumber ?? _deviceNumber,
      );
  String? get status => _status;
  int? get deviceNumber => _deviceNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['device_number'] = _deviceNumber;
    return map;
  }
}
