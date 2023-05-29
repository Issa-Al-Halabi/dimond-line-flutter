import 'dart:convert';
/// error : false
/// message : "Listed Successfuly"
/// data : [{"id":"4","category_id":"6","title":"Lebanon","created_at":"2022-09-18 11:42:09","updated_at":"2022-09-18 11:42:09","deleted_at":"0000-00-00 00:00:00"},{"id":"5","category_id":"6","title":"Jordan","created_at":"2022-09-18 11:42:22","updated_at":"2022-09-19 05:37:03","deleted_at":"0000-00-00 00:00:00"}]

GetSubCategoryModel getSubCategoryModelFromJson(String str) => GetSubCategoryModel.fromJson(json.decode(str));
String getSubCategoryModelToJson(GetSubCategoryModel data) => json.encode(data.toJson());
class GetSubCategoryModel {
  GetSubCategoryModel({
      bool? error, 
      String? message, 
      List<Data>? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  GetSubCategoryModel.fromJson(dynamic json) {
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
GetSubCategoryModel copyWith({  bool? error,
  String? message,
  List<Data>? data,
}) => GetSubCategoryModel(  error: error ?? _error,
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

/// id : "4"
/// category_id : "6"
/// title : "Lebanon"
/// created_at : "2022-09-18 11:42:09"
/// updated_at : "2022-09-18 11:42:09"
/// deleted_at : "0000-00-00 00:00:00"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? id, 
      String? categoryId, 
      String? title, 
      String? createdAt, 
      String? updatedAt, 
      String? deletedAt,}){
    _id = id;
    _categoryId = categoryId;
    _title = title;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _categoryId = json['category_id'];
    _title = json['title'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
  }
  String? _id;
  String? _categoryId;
  String? _title;
  String? _createdAt;
  String? _updatedAt;
  String? _deletedAt;
Data copyWith({  String? id,
  String? categoryId,
  String? title,
  String? createdAt,
  String? updatedAt,
  String? deletedAt,
}) => Data(  id: id ?? _id,
  categoryId: categoryId ?? _categoryId,
  title: title ?? _title,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  deletedAt: deletedAt ?? _deletedAt,
);
  String? get id => _id;
  String? get categoryId => _categoryId;
  String? get title => _title;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get deletedAt => _deletedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['category_id'] = _categoryId;
    map['title'] = _title;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    return map;
  }

}





// import 'dart:convert';
// /// id : "7"
// /// category_id : "6"
// /// type_id : "1"
// /// title : "Lebanon"
// /// created_at : "2022-10-18 08:36:44"
// /// updated_at : "2022-10-18 08:36:44"
// /// deleted_at : "0000-00-00 00:00:00"

// GetSubCategoryModel getSubCategoryModelFromJson(String str) => GetSubCategoryModel.fromJson(json.decode(str));
// String getSubCategoryModelToJson(GetSubCategoryModel data) => json.encode(data.toJson());
// class GetSubCategoryModel {
//   GetSubCategoryModel({
//       String? id, 
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

//   GetSubCategoryModel.fromJson(dynamic json) {
//     _id = json['id'];
//     _categoryId = json['category_id'];
//     _typeId = json['type_id'];
//     _title = json['title'];
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//     _deletedAt = json['deleted_at'];
//   }
//   String? _id;
//   String? _categoryId;
//   String? _typeId;
//   String? _title;
//   String? _createdAt;
//   String? _updatedAt;
//   String? _deletedAt;
// GetSubCategoryModel copyWith({  String? id,
//   String? categoryId,
//   String? typeId,
//   String? title,
//   String? createdAt,
//   String? updatedAt,
//   String? deletedAt,
// }) => GetSubCategoryModel(  id: id ?? _id,
//   categoryId: categoryId ?? _categoryId,
//   typeId: typeId ?? _typeId,
//   title: title ?? _title,
//   createdAt: createdAt ?? _createdAt,
//   updatedAt: updatedAt ?? _updatedAt,
//   deletedAt: deletedAt ?? _deletedAt,
// );
//   String? get id => _id;
//   String? get categoryId => _categoryId;
//   String? get typeId => _typeId;
//   String? get title => _title;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;
//   String? get deletedAt => _deletedAt;

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

// }