// import 'dart:convert';
// /// error : false
// /// message : "Listed Successfuly"
// /// data : [{"id":11,"category_id":"2","type_id":"2","title":"Aleppo","created_at":"2022-10-18T09:33:11.000000Z","updated_at":"2022-10-18T09:33:11.000000Z","deleted_at":"0000-00-00 00:00:00"},{"id":12,"category_id":"2","type_id":"2","title":"Homs","created_at":"2022-10-18T09:33:22.000000Z","updated_at":"2022-10-18T09:33:22.000000Z","deleted_at":"0000-00-00 00:00:00"},{"id":13,"category_id":"2","type_id":"2","title":"Hama","created_at":"2022-10-18T13:07:30.000000Z","updated_at":"2022-10-18T13:07:30.000000Z","deleted_at":"0000-00-00 00:00:00"},{"id":14,"category_id":"2","type_id":"2","title":"Damascus","created_at":"2022-10-18T13:07:58.000000Z","updated_at":"2022-10-18T13:09:21.000000Z","deleted_at":"0000-00-00 00:00:00"},{"id":15,"category_id":"2","type_id":"2","title":"Lattakia","created_at":"2022-10-18T13:08:15.000000Z","updated_at":"2022-10-18T13:08:55.000000Z","deleted_at":"0000-00-00 00:00:00"}]
//
// GetGovermentModel getGovermentModelFromJson(String str) => GetGovermentModel.fromJson(json.decode(str));
// String getGovermentModelToJson(GetGovermentModel data) => json.encode(data.toJson());
// class GetGovermentModel {
//   GetGovermentModel({
//       bool? error,
//       String? message,
//       List<Data>? data,}){
//     _error = error;
//     _message = message;
//     _data = data;
// }
//
//   GetGovermentModel.fromJson(dynamic json) {
//     _error = json['error'];
//     _message = json['message'];
//     if (json['data'] != null) {
//       _data = [];
//       json['data'].forEach((v) {
//         _data?.add(Data.fromJson(v));
//       });
//     }
//   }
//   bool? _error;
//   String? _message;
//   List<Data>? _data;
// GetGovermentModel copyWith({  bool? error,
//   String? message,
//   List<Data>? data,
// }) => GetGovermentModel(  error: error ?? _error,
//   message: message ?? _message,
//   data: data ?? _data,
// );
//   bool? get error => _error;
//   String? get message => _message;
//   List<Data>? get data => _data;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['error'] = _error;
//     map['message'] = _message;
//     if (_data != null) {
//       map['data'] = _data?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
//
// }
//
// /// id : 11
// /// category_id : "2"
// /// type_id : "2"
// /// title : "Aleppo"
// /// created_at : "2022-10-18T09:33:11.000000Z"
// /// updated_at : "2022-10-18T09:33:11.000000Z"
// /// deleted_at : "0000-00-00 00:00:00"
//
// Data dataFromJson(String str) => Data.fromJson(json.decode(str));
// String dataToJson(Data data) => json.encode(data.toJson());
// class Data {
//   Data({
//       num? id,
//       String? categoryId,
//       String? typeId,
//       String? title,
//       String? createdAt,
//       String? updatedAt,
//       String? deletedAt,}){
//     _id = id;
//     _categoryId = categoryId;
//     _typeId = typeId;
//     _title = title;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//     _deletedAt = deletedAt;
// }
//
//   Data.fromJson(dynamic json) {
//     _id = json['id'];
//     _categoryId = json['category_id'];
//     _typeId = json['type_id'];
//     _title = json['title'];
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//     _deletedAt = json['deleted_at'];
//   }
//   num? _id;
//   String? _categoryId;
//   String? _typeId;
//   String? _title;
//   String? _createdAt;
//   String? _updatedAt;
//   String? _deletedAt;
// Data copyWith({  num? id,
//   String? categoryId,
//   String? typeId,
//   String? title,
//   String? createdAt,
//   String? updatedAt,
//   String? deletedAt,
// }) => Data(  id: id ?? _id,
//   categoryId: categoryId ?? _categoryId,
//   typeId: typeId ?? _typeId,
//   title: title ?? _title,
//   createdAt: createdAt ?? _createdAt,
//   updatedAt: updatedAt ?? _updatedAt,
//   deletedAt: deletedAt ?? _deletedAt,
// );
//   num? get id => _id;
//   String? get categoryId => _categoryId;
//   String? get typeId => _typeId;
//   String? get title => _title;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;
//   String? get deletedAt => _deletedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['category_id'] = _categoryId;
//     map['type_id'] = _typeId;
//     map['title'] = _title;
//     map['created_at'] = _createdAt;
//     map['updated_at'] = _updatedAt;
//     map['deleted_at'] = _deletedAt;
//     return map;
//   }
//
// }

/// error : false
/// message : "Listed Successfuly"
/// data : [{"id":18,"category_id":2,"type_id":"2","title":"Damascus دمشق","created_at":"2023-01-17T11:33:13.000000Z","updated_at":"2023-01-17T11:33:13.000000Z","deleted_at":"0000-00-00 00:00:00"},{"id":19,"category_id":2,"type_id":"2","title":"Tartous طرطوس","created_at":"2023-01-19T08:53:45.000000Z","updated_at":"2023-01-19T08:53:45.000000Z","deleted_at":"0000-00-00 00:00:00"},{"id":20,"category_id":2,"type_id":"2","title":"Aleppo حلب","created_at":"2023-01-19T08:54:03.000000Z","updated_at":"2023-01-19T08:54:03.000000Z","deleted_at":"0000-00-00 00:00:00"}]

class GetGovermentModel {
  GetGovermentModel({
    bool? error,
    String? message,
    List<Data>? data,
  }) {
    _error = error;
    _message = message;
    _data = data;
  }

  GetGovermentModel.fromJson(dynamic json) {
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
  GetGovermentModel copyWith({
    bool? error,
    String? message,
    List<Data>? data,
  }) =>
      GetGovermentModel(
        error: error ?? _error,
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

/// id : 18
/// category_id : 2
/// type_id : "2"
/// title : "Damascus دمشق"
/// created_at : "2023-01-17T11:33:13.000000Z"
/// updated_at : "2023-01-17T11:33:13.000000Z"
/// deleted_at : "0000-00-00 00:00:00"

class Data {
  Data({
    int? id,
    // int? categoryId,
    dynamic categoryId,
    String? typeId,
    String? title,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
  }) {
    _id = id;
    _categoryId = categoryId;
    _typeId = typeId;
    _title = title;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _categoryId = json['category_id'];
    _typeId = json['type_id'];
    _title = json['title'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
  }
  int? _id;
  // int? _categoryId;
  dynamic _categoryId;
  String? _typeId;
  String? _title;
  String? _createdAt;
  String? _updatedAt;
  String? _deletedAt;
  Data copyWith({
    int? id,
    int? categoryId,
    String? typeId,
    String? title,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
  }) =>
      Data(
        id: id ?? _id,
        categoryId: categoryId ?? _categoryId,
        typeId: typeId ?? _typeId,
        title: title ?? _title,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        deletedAt: deletedAt ?? _deletedAt,
      );
  int? get id => _id;
  // int? get categoryId => _categoryId;
  dynamic get categoryId => _categoryId;
  String? get typeId => _typeId;
  String? get title => _title;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get deletedAt => _deletedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['category_id'] = _categoryId;
    map['type_id'] = _typeId;
    map['title'] = _title;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    return map;
  }
}
