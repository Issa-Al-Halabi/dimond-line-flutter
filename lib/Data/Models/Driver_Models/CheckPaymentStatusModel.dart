/// error : false
/// message : "Success"
/// data : {"id":1,"driver_id":"242","is_success":null,"message":null,"amount":30,"token":null,"transaction_number":null,"created_at":"2023-05-09T11:26:30.000000Z","updated_at":"2023-05-09T11:26:30.000000Z","deleted_at":null}

class CheckPaymentStatusModel {
  CheckPaymentStatusModel({
      bool? error, 
      String? message, 
      Data? data,}){
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
CheckPaymentStatusModel copyWith({  bool? error,
  String? message,
  Data? data,
}) => CheckPaymentStatusModel(  error: error ?? _error,
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

/// id : 1
/// driver_id : "242"
/// is_success : null
/// message : null
/// amount : 30
/// token : null
/// transaction_number : null
/// created_at : "2023-05-09T11:26:30.000000Z"
/// updated_at : "2023-05-09T11:26:30.000000Z"
/// deleted_at : null

class Data {
  Data({
      int? id, 
      String? driverId, 
      dynamic isSuccess, 
      dynamic message, 
      int? amount, 
      dynamic token, 
      dynamic transactionNumber, 
      String? createdAt, 
      String? updatedAt, 
      dynamic deletedAt,}){
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
  dynamic _isSuccess;
  dynamic _message;
  int? _amount;
  dynamic _token;
  dynamic _transactionNumber;
  String? _createdAt;
  String? _updatedAt;
  dynamic _deletedAt;
Data copyWith({  int? id,
  String? driverId,
  dynamic isSuccess,
  dynamic message,
  int? amount,
  dynamic token,
  dynamic transactionNumber,
  String? createdAt,
  String? updatedAt,
  dynamic deletedAt,
}) => Data(  id: id ?? _id,
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
  dynamic get isSuccess => _isSuccess;
  dynamic get message => _message;
  int? get amount => _amount;
  dynamic get token => _token;
  dynamic get transactionNumber => _transactionNumber;
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