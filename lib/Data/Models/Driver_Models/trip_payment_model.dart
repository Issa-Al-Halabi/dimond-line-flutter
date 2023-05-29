/// error : false
/// message : "Payment completed successfully"
/// data : {"method":"cash","booking_id":"98","driver_id":"55","amount":"2500","payment_status":"pending","updated_at":"2023-01-16T19:32:47.000000Z","created_at":"2023-01-16T19:32:47.000000Z","id":9}

class TripPaymentModel {
  TripPaymentModel({
      bool? error, 
      String? message, 
      Data? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  TripPaymentModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _error;
  String? _message;
  Data? _data;
TripPaymentModel copyWith({  bool? error,
  String? message,
  Data? data,
}) => TripPaymentModel(  error: error ?? _error,
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

/// method : "cash"
/// booking_id : "98"
/// driver_id : "55"
/// amount : "2500"
/// payment_status : "pending"
/// updated_at : "2023-01-16T19:32:47.000000Z"
/// created_at : "2023-01-16T19:32:47.000000Z"
/// id : 9

class Data {
  Data({
      String? method, 
      String? bookingId, 
      String? driverId, 
      String? amount, 
      String? paymentStatus, 
      String? updatedAt, 
      String? createdAt, 
      int? id,}){
    _method = method;
    _bookingId = bookingId;
    _driverId = driverId;
    _amount = amount;
    _paymentStatus = paymentStatus;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;
}

  Data.fromJson(dynamic json) {
    _method = json['method'];
    _bookingId = json['booking_id'];
    _driverId = json['driver_id'];
    _amount = json['amount'];
    _paymentStatus = json['payment_status'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
  }
  String? _method;
  String? _bookingId;
  String? _driverId;
  String? _amount;
  String? _paymentStatus;
  String? _updatedAt;
  String? _createdAt;
  int? _id;
Data copyWith({  String? method,
  String? bookingId,
  String? driverId,
  String? amount,
  String? paymentStatus,
  String? updatedAt,
  String? createdAt,
  int? id,
}) => Data(  method: method ?? _method,
  bookingId: bookingId ?? _bookingId,
  driverId: driverId ?? _driverId,
  amount: amount ?? _amount,
  paymentStatus: paymentStatus ?? _paymentStatus,
  updatedAt: updatedAt ?? _updatedAt,
  createdAt: createdAt ?? _createdAt,
  id: id ?? _id,
);
  String? get method => _method;
  String? get bookingId => _bookingId;
  String? get driverId => _driverId;
  String? get amount => _amount;
  String? get paymentStatus => _paymentStatus;
  String? get updatedAt => _updatedAt;
  String? get createdAt => _createdAt;
  int? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['method'] = _method;
    map['booking_id'] = _bookingId;
    map['driver_id'] = _driverId;
    map['amount'] = _amount;
    map['payment_status'] = _paymentStatus;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    return map;
  }

}