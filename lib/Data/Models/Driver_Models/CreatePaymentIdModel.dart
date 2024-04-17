/// error : false
/// message : "Information created Sucessfully"
/// data : {"driver_id":"242","amount":"30","updated_at":"2023-05-09T11:38:04.000000Z","created_at":"2023-05-09T11:38:04.000000Z","id":2}

class CreatePaymentIdModel {
  CreatePaymentIdModel({
    bool? error,
    String? message,
    Data? data,
  }) {
    _error = error;
    _message = message;
    _data = data;
  }

  CreatePaymentIdModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _error;
  String? _message;
  Data? _data;
  CreatePaymentIdModel copyWith({
    bool? error,
    String? message,
    Data? data,
  }) =>
      CreatePaymentIdModel(
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

/// driver_id : "242"
/// amount : "30"
/// updated_at : "2023-05-09T11:38:04.000000Z"
/// created_at : "2023-05-09T11:38:04.000000Z"
/// id : 2

class Data {
  Data({
    String? driverId,
    String? amount,
    String? updatedAt,
    String? createdAt,
    int? id,
  }) {
    _driverId = driverId;
    _amount = amount;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;
  }

  Data.fromJson(dynamic json) {
    _driverId = json['driver_id'];
    _amount = json['amount'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
  }
  String? _driverId;
  String? _amount;
  String? _updatedAt;
  String? _createdAt;
  int? _id;
  Data copyWith({
    String? driverId,
    String? amount,
    String? updatedAt,
    String? createdAt,
    int? id,
  }) =>
      Data(
        driverId: driverId ?? _driverId,
        amount: amount ?? _amount,
        updatedAt: updatedAt ?? _updatedAt,
        createdAt: createdAt ?? _createdAt,
        id: id ?? _id,
      );
  String? get driverId => _driverId;
  String? get amount => _amount;
  String? get updatedAt => _updatedAt;
  String? get createdAt => _createdAt;
  int? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['driver_id'] = _driverId;
    map['amount'] = _amount;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    return map;
  }
}
