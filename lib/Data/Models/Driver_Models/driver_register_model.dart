/// error : false
/// message : "You have Registered Successfully!"
/// data : {"api_token":"73yDoweu9SmwQsMzkTvXGxYghSoZEzLmo3KDnRlmmx1Cau9wDIePfQKLOGUs","user":{"car_mechanic":"f99f37d7-9323-4c68-b53d-fb844c5d7f5b.png","car_insurance":"304c3f2e-2da4-4cde-afe5-a50eb7449886.png","first_name":"yutynk","last_name":"skdhaud","id_entry":"635870","national_number":"369850","phone":"25098968","email":"nourfrey1@gmail.com","user_type":"external_driver","is_active":"pending","deleted_at":null,"updated_at":"2023-01-15T07:48:40.000000Z","created_at":"2023-01-15T07:48:40.000000Z","id":264,"roles":[{"id":4,"name":"Driver","guard_name":"web","created_at":"2022-09-02T15:33:46.000000Z","updated_at":"2022-09-04T06:45:19.000000Z","pivot":{"model_id":"264","role_id":"4","model_type":"App\\Model\\User"}}],"meta_data":[]}}

class DriverRegisterModel {
  DriverRegisterModel({
    bool? error,
    String? message,
    Data? data,}){
    _error = error;
    _message = message;
    _data = data;
  }

  DriverRegisterModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _error;
  String? _message;
  Data? _data;
  DriverRegisterModel copyWith({  bool? error,
    String? message,
    Data? data,
  }) => DriverRegisterModel(  error: error ?? _error,
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

/// api_token : "73yDoweu9SmwQsMzkTvXGxYghSoZEzLmo3KDnRlmmx1Cau9wDIePfQKLOGUs"
/// user : {"car_mechanic":"f99f37d7-9323-4c68-b53d-fb844c5d7f5b.png","car_insurance":"304c3f2e-2da4-4cde-afe5-a50eb7449886.png","first_name":"yutynk","last_name":"skdhaud","id_entry":"635870","national_number":"369850","phone":"25098968","email":"nourfrey1@gmail.com","user_type":"external_driver","is_active":"pending","deleted_at":null,"updated_at":"2023-01-15T07:48:40.000000Z","created_at":"2023-01-15T07:48:40.000000Z","id":264,"roles":[{"id":4,"name":"Driver","guard_name":"web","created_at":"2022-09-02T15:33:46.000000Z","updated_at":"2022-09-04T06:45:19.000000Z","pivot":{"model_id":"264","role_id":"4","model_type":"App\\Model\\User"}}],"meta_data":[]}

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

/// car_mechanic : "f99f37d7-9323-4c68-b53d-fb844c5d7f5b.png"
/// car_insurance : "304c3f2e-2da4-4cde-afe5-a50eb7449886.png"
/// first_name : "yutynk"
/// last_name : "skdhaud"
/// id_entry : "635870"
/// national_number : "369850"
/// phone : "25098968"
/// email : "nourfrey1@gmail.com"
/// user_type : "external_driver"
/// is_active : "pending"
/// deleted_at : null
/// updated_at : "2023-01-15T07:48:40.000000Z"
/// created_at : "2023-01-15T07:48:40.000000Z"
/// id : 264
/// roles : [{"id":4,"name":"Driver","guard_name":"web","created_at":"2022-09-02T15:33:46.000000Z","updated_at":"2022-09-04T06:45:19.000000Z","pivot":{"model_id":"264","role_id":"4","model_type":"App\\Model\\User"}}]
/// meta_data : []

class User {
  User({
    String? carMechanic,
    String? carInsurance,
    String? firstName,
    String? lastName,
    String? idEntry,
    String? nationalNumber,
    String? phone,
    String? email,
    String? userType,
    String? isActive,
    dynamic deletedAt,
    String? updatedAt,
    String? createdAt,
    int? id,
    List<Roles>? roles,
    // List<dynamic>? metaData,
  }){
    _carMechanic = carMechanic;
    _carInsurance = carInsurance;
    _firstName = firstName;
    _lastName = lastName;
    _idEntry = idEntry;
    _nationalNumber = nationalNumber;
    _phone = phone;
    _email = email;
    _userType = userType;
    _isActive = isActive;
    _deletedAt = deletedAt;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;
    _roles = roles;
    // _metaData = metaData;
  }

  User.fromJson(dynamic json) {
    _carMechanic = json['car_mechanic'];
    _carInsurance = json['car_insurance'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _idEntry = json['id_entry'];
    _nationalNumber = json['national_number'];
    _phone = json['phone'];
    _email = json['email'];
    _userType = json['user_type'];
    _isActive = json['is_active'];
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
  String? _carMechanic;
  String? _carInsurance;
  String? _firstName;
  String? _lastName;
  String? _idEntry;
  String? _nationalNumber;
  String? _phone;
  String? _email;
  String? _userType;
  String? _isActive;
  dynamic _deletedAt;
  String? _updatedAt;
  String? _createdAt;
  int? _id;
  List<Roles>? _roles;
  // List<dynamic>? _metaData;
  User copyWith({  String? carMechanic,
    String? carInsurance,
    String? firstName,
    String? lastName,
    String? idEntry,
    String? nationalNumber,
    String? phone,
    String? email,
    String? userType,
    String? isActive,
    dynamic deletedAt,
    String? updatedAt,
    String? createdAt,
    int? id,
    List<Roles>? roles,
    // List<dynamic>? metaData,
  }) => User(  carMechanic: carMechanic ?? _carMechanic,
    carInsurance: carInsurance ?? _carInsurance,
    firstName: firstName ?? _firstName,
    lastName: lastName ?? _lastName,
    idEntry: idEntry ?? _idEntry,
    nationalNumber: nationalNumber ?? _nationalNumber,
    phone: phone ?? _phone,
    email: email ?? _email,
    userType: userType ?? _userType,
    isActive: isActive ?? _isActive,
    deletedAt: deletedAt ?? _deletedAt,
    updatedAt: updatedAt ?? _updatedAt,
    createdAt: createdAt ?? _createdAt,
    id: id ?? _id,
    roles: roles ?? _roles,
    // metaData: metaData ?? _metaData,
  );
  String? get carMechanic => _carMechanic;
  String? get carInsurance => _carInsurance;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get idEntry => _idEntry;
  String? get nationalNumber => _nationalNumber;
  String? get phone => _phone;
  String? get email => _email;
  String? get userType => _userType;
  String? get isActive => _isActive;
  dynamic get deletedAt => _deletedAt;
  String? get updatedAt => _updatedAt;
  String? get createdAt => _createdAt;
  int? get id => _id;
  List<Roles>? get roles => _roles;
  // List<dynamic>? get metaData => _metaData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['car_mechanic'] = _carMechanic;
    map['car_insurance'] = _carInsurance;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['id_entry'] = _idEntry;
    map['national_number'] = _nationalNumber;
    map['phone'] = _phone;
    map['email'] = _email;
    map['user_type'] = _userType;
    map['is_active'] = _isActive;
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

/// id : 4
/// name : "Driver"
/// guard_name : "web"
/// created_at : "2022-09-02T15:33:46.000000Z"
/// updated_at : "2022-09-04T06:45:19.000000Z"
/// pivot : {"model_id":"264","role_id":"4","model_type":"App\\Model\\User"}

class Roles {
  Roles({
    int? id,
    String? name,
    String? guardName,
    String? createdAt,
    String? updatedAt,
    Pivot? pivot,}){
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
  Roles copyWith({  int? id,
    String? name,
    String? guardName,
    String? createdAt,
    String? updatedAt,
    Pivot? pivot,
  }) => Roles(  id: id ?? _id,
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

/// model_id : "264"
/// role_id : "4"
/// model_type : "App\\Model\\User"

class Pivot {
  Pivot({
    dynamic modelId,
    dynamic roleId,
    dynamic modelType,}){
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
  Pivot copyWith({  dynamic modelId,
    dynamic roleId,
    dynamic modelType,
  }) => Pivot(  modelId: modelId ?? _modelId,
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