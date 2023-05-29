import 'dart:convert';
/// error : false
/// message : "Listed Successfully!"
/// data : [{"id":3,"type_id":"14","price":"1000","name":"tabbon","is_enable":"1","created_at":"2022-12-07T08:51:37.000000Z","updated_at":"2022-12-07T08:51:37.000000Z"}]

GetTypeOptionModel getTypeOptionModelFromJson(String str) => GetTypeOptionModel.fromJson(json.decode(str));
String getTypeOptionModelToJson(GetTypeOptionModel data) => json.encode(data.toJson());
class GetTypeOptionModel {
  GetTypeOptionModel({
      bool? error, 
      String? message, 
      List<Data>? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  GetTypeOptionModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _error;
  String? _message;
  List<Data>? _data;
GetTypeOptionModel copyWith({  bool? error,
  String? message,
  List<Data>? data,
}) => GetTypeOptionModel(  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get error => _error;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 3
/// type_id : "14"
/// price : "1000"
/// name : "tabbon"
/// is_enable : "1"
/// created_at : "2022-12-07T08:51:37.000000Z"
/// updated_at : "2022-12-07T08:51:37.000000Z"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      num? id,
      dynamic typeId,
      dynamic price,
      String? name,
      dynamic isEnable,
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _typeId = typeId;
    _price = price;
    _name = name;
    _isEnable = isEnable;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _typeId = json['type_id'];
    _price = json['price'];
    _name = json['name'];
    _isEnable = json['is_enable'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  dynamic _typeId;
  dynamic _price;
  String? _name;
  dynamic _isEnable;
  String? _createdAt;
  String? _updatedAt;
Data copyWith({  num? id,
  dynamic typeId,
  dynamic price,
  String? name,
  dynamic isEnable,
  String? createdAt,
  String? updatedAt,
}) => Data(  id: id ?? _id,
  typeId: typeId ?? _typeId,
  price: price ?? _price,
  name: name ?? _name,
  isEnable: isEnable ?? _isEnable,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  dynamic get typeId => _typeId;
  dynamic get price => _price;
  String? get name => _name;
  dynamic get isEnable => _isEnable;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['type_id'] = _typeId;
    map['price'] = _price;
    map['name'] = _name;
    map['is_enable'] = _isEnable;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}