import 'dart:convert';
/// error : false
/// message : "You have Registered Successfully!"
/// data : {"api_token":"UlRyNaIx8whhwnPAxdRwgmyXvoSx4i6EDAWsv8t2bOEq3sWSmZBZ6354XDm3","user":{"first_name":"hala","last_name":"hedros","father_name":"eias","mother_name":"hanady","id_entry":"5811244477","national_number":"124444111","place_of_birth":"homs","date_of_birth":"9/24/2022","phone":"0999911117","email":"halbklla@gmail.c","user_type":"user","deleted_at":null,"updated_at":"2022-09-29T09:37:58.000000Z","created_at":"2022-09-29T09:37:58.000000Z","id":158,"meta_data":[]}}

IdCardRegisterModel idCardRegisterModelFromJson(String str) => IdCardRegisterModel.fromJson(json.decode(str));
String idCardRegisterModelToJson(IdCardRegisterModel data) => json.encode(data.toJson());
class IdCardRegisterModel {
  IdCardRegisterModel({
      bool? error, 
      String? message, 
      Data? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  IdCardRegisterModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _error;
  String? _message;
  Data? _data;
IdCardRegisterModel copyWith({  bool? error,
  String? message,
  Data? data,
}) => IdCardRegisterModel(  error: error ?? _error,
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

/// api_token : "UlRyNaIx8whhwnPAxdRwgmyXvoSx4i6EDAWsv8t2bOEq3sWSmZBZ6354XDm3"
/// user : {"first_name":"hala","last_name":"hedros","father_name":"eias","mother_name":"hanady","id_entry":"5811244477","national_number":"124444111","place_of_birth":"homs","date_of_birth":"9/24/2022","phone":"0999911117","email":"halbklla@gmail.c","user_type":"user","deleted_at":null,"updated_at":"2022-09-29T09:37:58.000000Z","created_at":"2022-09-29T09:37:58.000000Z","id":158,"meta_data":[]}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? apiToken, 
      User? user,}){
    _apiToken = apiToken;
    _user = user;
}

  Data.fromJson(dynamic json) {
    _apiToken = json['api_token'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? _apiToken;
  User? _user;
Data copyWith({  String? apiToken,
  User? user,
}) => Data(  apiToken: apiToken ?? _apiToken,
  user: user ?? _user,
);
  String? get apiToken => _apiToken;
  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['api_token'] = _apiToken;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    return map;
  }

}

/// first_name : "hala"
/// last_name : "hedros"
/// father_name : "eias"
/// mother_name : "hanady"
/// id_entry : "5811244477"
/// national_number : "124444111"
/// place_of_birth : "homs"
/// date_of_birth : "9/24/2022"
/// phone : "0999911117"
/// email : "halbklla@gmail.c"
/// user_type : "user"
/// deleted_at : null
/// updated_at : "2022-09-29T09:37:58.000000Z"
/// created_at : "2022-09-29T09:37:58.000000Z"
/// id : 158
/// meta_data : []

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());
class User {
  User({
      String? firstName, 
      String? lastName, 
      String? fatherName, 
      String? motherName, 
      String? idEntry, 
      String? nationalNumber, 
      String? placeOfBirth, 
      String? dateOfBirth, 
      String? phone, 
      String? email, 
      String? userType, 
      dynamic deletedAt, 
      String? updatedAt, 
      String? createdAt, 
      num? id, 
      List<dynamic>? metaData,}){
    _firstName = firstName;
    _lastName = lastName;
    _fatherName = fatherName;
    _motherName = motherName;
    _idEntry = idEntry;
    _nationalNumber = nationalNumber;
    _placeOfBirth = placeOfBirth;
    _dateOfBirth = dateOfBirth;
    _phone = phone;
    _email = email;
    _userType = userType;
    _deletedAt = deletedAt;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;
    // _metaData = metaData;
}

  User.fromJson(dynamic json) {
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _fatherName = json['father_name'];
    _motherName = json['mother_name'];
    _idEntry = json['id_entry'];
    _nationalNumber = json['national_number'];
    _placeOfBirth = json['place_of_birth'];
    _dateOfBirth = json['date_of_birth'];
    _phone = json['phone'];
    _email = json['email'];
    _userType = json['user_type'];
    _deletedAt = json['deleted_at'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
    // if (json['meta_data'] != null) {
    //   _metaData = [];
    //   json['meta_data'].forEach((v) {
    //     _metaData?.add(Dynamic.fromJson(v));
    //   });
    // }
  }
  String? _firstName;
  String? _lastName;
  String? _fatherName;
  String? _motherName;
  String? _idEntry;
  String? _nationalNumber;
  String? _placeOfBirth;
  String? _dateOfBirth;
  String? _phone;
  String? _email;
  String? _userType;
  dynamic _deletedAt;
  String? _updatedAt;
  String? _createdAt;
  num? _id;
  // List<dynamic>? _metaData;
User copyWith({  String? firstName,
  String? lastName,
  String? fatherName,
  String? motherName,
  String? idEntry,
  String? nationalNumber,
  String? placeOfBirth,
  String? dateOfBirth,
  String? phone,
  String? email,
  String? userType,
  dynamic deletedAt,
  String? updatedAt,
  String? createdAt,
  num? id,
  // List<dynamic>? metaData,
}) => User(  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  fatherName: fatherName ?? _fatherName,
  motherName: motherName ?? _motherName,
  idEntry: idEntry ?? _idEntry,
  nationalNumber: nationalNumber ?? _nationalNumber,
  placeOfBirth: placeOfBirth ?? _placeOfBirth,
  dateOfBirth: dateOfBirth ?? _dateOfBirth,
  phone: phone ?? _phone,
  email: email ?? _email,
  userType: userType ?? _userType,
  deletedAt: deletedAt ?? _deletedAt,
  updatedAt: updatedAt ?? _updatedAt,
  createdAt: createdAt ?? _createdAt,
  id: id ?? _id,
  // metaData: metaData ?? _metaData,
);
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get fatherName => _fatherName;
  String? get motherName => _motherName;
  String? get idEntry => _idEntry;
  String? get nationalNumber => _nationalNumber;
  String? get placeOfBirth => _placeOfBirth;
  String? get dateOfBirth => _dateOfBirth;
  String? get phone => _phone;
  String? get email => _email;
  String? get userType => _userType;
  dynamic get deletedAt => _deletedAt;
  String? get updatedAt => _updatedAt;
  String? get createdAt => _createdAt;
  num? get id => _id;
  // List<dynamic>? get metaData => _metaData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['father_name'] = _fatherName;
    map['mother_name'] = _motherName;
    map['id_entry'] = _idEntry;
    map['national_number'] = _nationalNumber;
    map['place_of_birth'] = _placeOfBirth;
    map['date_of_birth'] = _dateOfBirth;
    map['phone'] = _phone;
    map['email'] = _email;
    map['user_type'] = _userType;
    map['deleted_at'] = _deletedAt;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    // if (_metaData != null) {
    //   map['meta_data'] = _metaData?.map((v) => v.toJson()).toList();
    // }
    return map;
  }

}