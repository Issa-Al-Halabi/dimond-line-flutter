/// error : false
/// message : "Success"
/// data : {"id":81,"driver_id":"242","is_success":1,"message":null,"amount":"3666.00","token":"0960C0514BF0576063D815924C2A30B8","transaction_number":"1604235696","created_at":"2023-06-12T08:42:10.000000Z","updated_at":"2023-06-12T08:43:08.000000Z","deleted_at":null}

class CheckPaymentStatusModel {
  CheckPaymentStatusModel({
    bool? error,
    String? message,
    Data? data,
  }) {
    _error = error;
    _message = message;
    _data = data;
  }

  CheckPaymentStatusModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _error;
  String? _message;
  Data? _data;
  CheckPaymentStatusModel copyWith({
    bool? error,
    String? message,
    Data? data,
  }) =>
      CheckPaymentStatusModel(
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

/// id : 81
/// driver_id : "242"
/// is_success : 1
/// message : null
/// amount : "3666.00"
/// token : "0960C0514BF0576063D815924C2A30B8"
/// transaction_number : "1604235696"
/// created_at : "2023-06-12T08:42:10.000000Z"
/// updated_at : "2023-06-12T08:43:08.000000Z"
/// deleted_at : null

class Data {
  Data({
    int? id,
    String? driverId,
    int? isSuccess,
    dynamic message,
    String? amount,
    String? token,
    String? transactionNumber,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
  }) {
    _id = id;
    _driverId = driverId;
    _isSuccess = isSuccess;
    _message = message;
    _amount = amount;
    _token = token;
    _transactionNumber = transactionNumber;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _driverId = json['driver_id'];
    _isSuccess = json['is_success'];
    _message = json['message'];
    _amount = json['amount'];
    _token = json['token'];
    _transactionNumber = json['transaction_number'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
  }
  int? _id;
  String? _driverId;
  int? _isSuccess;
  dynamic _message;
  String? _amount;
  String? _token;
  String? _transactionNumber;
  String? _createdAt;
  String? _updatedAt;
  dynamic _deletedAt;
  Data copyWith({
    int? id,
    String? driverId,
    int? isSuccess,
    dynamic message,
    String? amount,
    String? token,
    String? transactionNumber,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
  }) =>
      Data(
        id: id ?? _id,
        driverId: driverId ?? _driverId,
        isSuccess: isSuccess ?? _isSuccess,
        message: message ?? _message,
        amount: amount ?? _amount,
        token: token ?? _token,
        transactionNumber: transactionNumber ?? _transactionNumber,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        deletedAt: deletedAt ?? _deletedAt,
      );
  int? get id => _id;
  String? get driverId => _driverId;
  int? get isSuccess => _isSuccess;
  dynamic get message => _message;
  String? get amount => _amount;
  String? get token => _token;
  String? get transactionNumber => _transactionNumber;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['driver_id'] = _driverId;
    map['is_success'] = _isSuccess;
    map['message'] = _message;
    map['amount'] = _amount;
    map['token'] = _token;
    map['transaction_number'] = _transactionNumber;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    return map;
  }
}
