/// error : false
/// message : "You have Registered Successfully!"
/// data : {"api_token":"GiEQ0WHCxcjNVnGZZU7B4XfDiXm50j2C5cC5RvXG0iNNd0prSkP8mZuJq6fY","user":{"first_name":"lemar000000000","last_name":"almahdi0000","father_name":"wael","mother_name":"soad","place_of_birth":"Homs","date_of_birth":"15/9/2022","phone":"0950162777","email":"lemaar770@gmail.com","user_type":"user","device_token":"jheduqwjkdnqwdjqiodhishhdfplfepwelpfuyeiuqeyiuyeiu","deleted_at":null,"updated_at":"2023-01-18T09:48:55.000000Z","created_at":"2023-01-18T09:48:55.000000Z","id":265,"roles":[{"id":7,"name":"user","guard_name":"web","created_at":"2022-09-04T06:45:49.000000Z","updated_at":"2022-09-04T06:45:49.000000Z","pivot":{"model_id":"265","role_id":"7","model_type":"App\\Model\\User"}}],"meta_data":[]}}

class UerRegisterModel {
  UerRegisterModel({
    bool? error,
    String? message,
    Data? data,
  }) {
    _error = error;
    _message = message;
    _data = data;
  }

  UerRegisterModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _error;
  String? _message;
  Data? _data;
  UerRegisterModel copyWith({
    bool? error,
    String? message,
    Data? data,
  }) =>
      UerRegisterModel(
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

/// api_token : "GiEQ0WHCxcjNVnGZZU7B4XfDiXm50j2C5cC5RvXG0iNNd0prSkP8mZuJq6fY"
/// user : {"first_name":"lemar000000000","last_name":"almahdi0000","father_name":"wael","mother_name":"soad","place_of_birth":"Homs","date_of_birth":"15/9/2022","phone":"0950162777","email":"lemaar770@gmail.com","user_type":"user","device_token":"jheduqwjkdnqwdjqiodhishhdfplfepwelpfuyeiuqeyiuyeiu","deleted_at":null,"updated_at":"2023-01-18T09:48:55.000000Z","created_at":"2023-01-18T09:48:55.000000Z","id":265,"roles":[{"id":7,"name":"user","guard_name":"web","created_at":"2022-09-04T06:45:49.000000Z","updated_at":"2022-09-04T06:45:49.000000Z","pivot":{"model_id":"265","role_id":"7","model_type":"App\\Model\\User"}}],"meta_data":[]}

class Data {
  Data({
    String? apiToken,
    User? user,
  }) {
    _apiToken = apiToken;
    _user = user;
  }

  Data.fromJson(dynamic json) {
    _apiToken = json['api_token'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  String? _apiToken;
  User? _user;
  Data copyWith({
    String? apiToken,
    User? user,
  }) =>
      Data(
        apiToken: apiToken ?? _apiToken,
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

/// first_name : "lemar000000000"
/// last_name : "almahdi0000"
/// father_name : "wael"
/// mother_name : "soad"
/// place_of_birth : "Homs"
/// date_of_birth : "15/9/2022"
/// phone : "0950162777"
/// email : "lemaar770@gmail.com"
/// user_type : "user"
/// device_token : "jheduqwjkdnqwdjqiodhishhdfplfepwelpfuyeiuqeyiuyeiu"
/// deleted_at : null
/// updated_at : "2023-01-18T09:48:55.000000Z"
/// created_at : "2023-01-18T09:48:55.000000Z"
/// id : 265
/// roles : [{"id":7,"name":"user","guard_name":"web","created_at":"2022-09-04T06:45:49.000000Z","updated_at":"2022-09-04T06:45:49.000000Z","pivot":{"model_id":"265","role_id":"7","model_type":"App\\Model\\User"}}]
/// meta_data : []

class User {
  User({
    String? firstName,
    String? lastName,
    String? fatherName,
    String? motherName,
    String? placeOfBirth,
    String? dateOfBirth,
    String? phone,
    String? email,
    String? userType,
    String? deviceToken,
    dynamic deletedAt,
    String? updatedAt,
    String? createdAt,
    int? id,
    List<Roles>? roles,
    // List<dynamic>? metaData,
  }) {
    _firstName = firstName;
    _lastName = lastName;
    _fatherName = fatherName;
    _motherName = motherName;
    _placeOfBirth = placeOfBirth;
    _dateOfBirth = dateOfBirth;
    _phone = phone;
    _email = email;
    _userType = userType;
    _deviceToken = deviceToken;
    _deletedAt = deletedAt;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;
    _roles = roles;
    // _metaData = metaData;
  }

  User.fromJson(dynamic json) {
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _fatherName = json['father_name'];
    _motherName = json['mother_name'];
    _placeOfBirth = json['place_of_birth'];
    _dateOfBirth = json['date_of_birth'];
    _phone = json['phone'];
    _email = json['email'];
    _userType = json['user_type'];
    _deviceToken = json['device_token'];
    _deletedAt = json['deleted_at'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
    if (json['roles'] != null) {
      _roles = [];
      json['roles'].forEach((v) {
        _roles?.add(Roles.fromJson(v));
      });
    }
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
  String? _placeOfBirth;
  String? _dateOfBirth;
  String? _phone;
  String? _email;
  String? _userType;
  String? _deviceToken;
  dynamic _deletedAt;
  String? _updatedAt;
  String? _createdAt;
  int? _id;
  List<Roles>? _roles;
  // List<dynamic>? _metaData;
  User copyWith({
    String? firstName,
    String? lastName,
    String? fatherName,
    String? motherName,
    String? placeOfBirth,
    String? dateOfBirth,
    String? phone,
    String? email,
    String? userType,
    String? deviceToken,
    dynamic deletedAt,
    String? updatedAt,
    String? createdAt,
    int? id,
    List<Roles>? roles,
    // List<dynamic>? metaData,
  }) =>
      User(
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        fatherName: fatherName ?? _fatherName,
        motherName: motherName ?? _motherName,
        placeOfBirth: placeOfBirth ?? _placeOfBirth,
        dateOfBirth: dateOfBirth ?? _dateOfBirth,
        phone: phone ?? _phone,
        email: email ?? _email,
        userType: userType ?? _userType,
        deviceToken: deviceToken ?? _deviceToken,
        deletedAt: deletedAt ?? _deletedAt,
        updatedAt: updatedAt ?? _updatedAt,
        createdAt: createdAt ?? _createdAt,
        id: id ?? _id,
        roles: roles ?? _roles,
        // metaData: metaData ?? _metaData,
      );
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get fatherName => _fatherName;
  String? get motherName => _motherName;
  String? get placeOfBirth => _placeOfBirth;
  String? get dateOfBirth => _dateOfBirth;
  String? get phone => _phone;
  String? get email => _email;
  String? get userType => _userType;
  String? get deviceToken => _deviceToken;
  dynamic get deletedAt => _deletedAt;
  String? get updatedAt => _updatedAt;
  String? get createdAt => _createdAt;
  int? get id => _id;
  List<Roles>? get roles => _roles;
  // List<dynamic>? get metaData => _metaData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['father_name'] = _fatherName;
    map['mother_name'] = _motherName;
    map['place_of_birth'] = _placeOfBirth;
    map['date_of_birth'] = _dateOfBirth;
    map['phone'] = _phone;
    map['email'] = _email;
    map['user_type'] = _userType;
    map['device_token'] = _deviceToken;
    map['deleted_at'] = _deletedAt;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    if (_roles != null) {
      map['roles'] = _roles?.map((v) => v.toJson()).toList();
    }
    // if (_metaData != null) {
    //   map['meta_data'] = _metaData?.map((v) => v.toJson()).toList();
    // }
    return map;
  }
}

/// id : 7
/// name : "user"
/// guard_name : "web"
/// created_at : "2022-09-04T06:45:49.000000Z"
/// updated_at : "2022-09-04T06:45:49.000000Z"
/// pivot : {"model_id":"265","role_id":"7","model_type":"App\\Model\\User"}

class Roles {
  Roles({
    int? id,
    String? name,
    String? guardName,
    String? createdAt,
    String? updatedAt,
    Pivot? pivot,
  }) {
    _id = id;
    _name = name;
    _guardName = guardName;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _pivot = pivot;
  }

  Roles.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _guardName = json['guard_name'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }
  int? _id;
  String? _name;
  String? _guardName;
  String? _createdAt;
  String? _updatedAt;
  Pivot? _pivot;
  Roles copyWith({
    int? id,
    String? name,
    String? guardName,
    String? createdAt,
    String? updatedAt,
    Pivot? pivot,
  }) =>
      Roles(
        id: id ?? _id,
        name: name ?? _name,
        guardName: guardName ?? _guardName,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        pivot: pivot ?? _pivot,
      );
  int? get id => _id;
  String? get name => _name;
  String? get guardName => _guardName;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  Pivot? get pivot => _pivot;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['guard_name'] = _guardName;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_pivot != null) {
      map['pivot'] = _pivot?.toJson();
    }
    return map;
  }
}

/// model_id : "265"
/// role_id : "7"
/// model_type : "App\\Model\\User"

class Pivot {
  Pivot({
    dynamic modelId,
    dynamic roleId,
    dynamic modelType,
  }) {
    _modelId = modelId;
    _roleId = roleId;
    _modelType = modelType;
  }

  Pivot.fromJson(dynamic json) {
    _modelId = json['model_id'];
    _roleId = json['role_id'];
    _modelType = json['model_type'];
  }
  dynamic _modelId;
  dynamic _roleId;
  dynamic _modelType;
  Pivot copyWith({
    dynamic modelId,
    dynamic roleId,
    dynamic modelType,
  }) =>
      Pivot(
        modelId: modelId ?? _modelId,
        roleId: roleId ?? _roleId,
        modelType: modelType ?? _modelType,
      );
  dynamic get modelId => _modelId;
  dynamic get roleId => _roleId;
  dynamic get modelType => _modelType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['model_id'] = _modelId;
    map['role_id'] = _roleId;
    map['model_type'] = _modelType;
    return map;
  }
}
