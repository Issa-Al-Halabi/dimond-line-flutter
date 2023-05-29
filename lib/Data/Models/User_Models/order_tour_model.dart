import 'dart:convert';
/// error : false
/// message : "Your tour has been created"
/// data : {"trip_id":"34","start_time":"8:12:00","end_time":"9:00:00","status":"pending","updated_at":"2022-11-09T07:29:40.000000Z","created_at":"2022-11-09T07:29:40.000000Z","id":5}

OrderTourModel orderTourModelFromJson(String str) => OrderTourModel.fromJson(json.decode(str));
String orderTourModelToJson(OrderTourModel data) => json.encode(data.toJson());
class OrderTourModel {
  OrderTourModel({
      bool? error, 
      String? message, 
      Data? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  OrderTourModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _error;
  String? _message;
  Data? _data;
OrderTourModel copyWith({  bool? error,
  String? message,
  Data? data,
}) => OrderTourModel(  error: error ?? _error,
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

/// trip_id : "34"
/// start_time : "8:12:00"
/// end_time : "9:00:00"
/// status : "pending"
/// updated_at : "2022-11-09T07:29:40.000000Z"
/// created_at : "2022-11-09T07:29:40.000000Z"
/// id : 5

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? tripId, 
      String? startTime, 
      String? endTime, 
      String? status, 
      String? updatedAt, 
      String? createdAt, 
      num? id,}){
    _tripId = tripId;
    _startTime = startTime;
    _endTime = endTime;
    _status = status;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;
}

  Data.fromJson(dynamic json) {
    _tripId = json['trip_id'];
    _startTime = json['start_time'];
    _endTime = json['end_time'];
    _status = json['status'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
  }
  String? _tripId;
  String? _startTime;
  String? _endTime;
  String? _status;
  String? _updatedAt;
  String? _createdAt;
  num? _id;
Data copyWith({  String? tripId,
  String? startTime,
  String? endTime,
  String? status,
  String? updatedAt,
  String? createdAt,
  num? id,
}) => Data(  tripId: tripId ?? _tripId,
  startTime: startTime ?? _startTime,
  endTime: endTime ?? _endTime,
  status: status ?? _status,
  updatedAt: updatedAt ?? _updatedAt,
  createdAt: createdAt ?? _createdAt,
  id: id ?? _id,
);
  String? get tripId => _tripId;
  String? get startTime => _startTime;
  String? get endTime => _endTime;
  String? get status => _status;
  String? get updatedAt => _updatedAt;
  String? get createdAt => _createdAt;
  num? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['trip_id'] = _tripId;
    map['start_time'] = _startTime;
    map['end_time'] = _endTime;
    map['status'] = _status;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    return map;
  }

}