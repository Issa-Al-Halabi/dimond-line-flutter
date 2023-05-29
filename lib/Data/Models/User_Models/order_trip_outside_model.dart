import 'dart:convert';
/// error : false
/// message : "Your trip has been created"

OrderTripOutsideModel orderTripOutsideModelFromJson(String str) => OrderTripOutsideModel.fromJson(json.decode(str));
String orderTripOutsideModelToJson(OrderTripOutsideModel data) => json.encode(data.toJson());
class OrderTripOutsideModel {
  OrderTripOutsideModel({
      bool? error, 
      String? message,}){
    _error = error;
    _message = message;
}

  OrderTripOutsideModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
  }
  bool? _error;
  String? _message;
OrderTripOutsideModel copyWith({  bool? error,
  String? message,
}) => OrderTripOutsideModel(  error: error ?? _error,
  message: message ?? _message,
);
  bool? get error => _error;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    return map;
  }

}