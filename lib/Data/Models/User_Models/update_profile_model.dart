import 'dart:convert';
/// error : false
/// message : "Profile has been Updated Successfully!"
/// data : {"id":159,"user_id":null,"first_name":"hala","last_name":"hedros","email":"ha4lbklla@gmail.c","user_type":"user","father_name":"eias","mother_name":"hanady","id_entry":"58141244477","national_number":"1244444111","phone":"0999914117","is_active":null,"date_of_birth":"2002/9/8","place_of_birth":"damas","passport_number":null,"profile_image":null,"personal_identity":null,"driving_certificate":null,"car_mechanic":null,"car_insurance":null,"car_image":null,"group_id":null,"created_at":"2022-09-29T09:46:41.000000Z","updated_at":"2022-09-29T12:11:51.000000Z","deleted_at":null,"metas":[],"meta_data":[]}

UpdateProfileModel updateProfileModelFromJson(String str) => UpdateProfileModel.fromJson(json.decode(str));
String updateProfileModelToJson(UpdateProfileModel data) => json.encode(data.toJson());
class UpdateProfileModel {
  UpdateProfileModel({
      bool? error, 
      String? message, 
      Data? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  UpdateProfileModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _error;
  String? _message;
  Data? _data;
UpdateProfileModel copyWith({  bool? error,
  String? message,
  Data? data,
}) => UpdateProfileModel(  error: error ?? _error,
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

/// id : 159
/// user_id : null
/// first_name : "hala"
/// last_name : "hedros"
/// email : "ha4lbklla@gmail.c"
/// user_type : "user"
/// father_name : "eias"
/// mother_name : "hanady"
/// id_entry : "58141244477"
/// national_number : "1244444111"
/// phone : "0999914117"
/// is_active : null
/// date_of_birth : "2002/9/8"
/// place_of_birth : "damas"
/// passport_number : null
/// profile_image : null
/// personal_identity : null
/// driving_certificate : null
/// car_mechanic : null
/// car_insurance : null
/// car_image : null
/// group_id : null
/// created_at : "2022-09-29T09:46:41.000000Z"
/// updated_at : "2022-09-29T12:11:51.000000Z"
/// deleted_at : null
/// metas : []
/// meta_data : []

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      num? id, 
      dynamic userId, 
      String? firstName, 
      String? lastName, 
      String? email, 
      String? userType, 
      String? fatherName, 
      String? motherName, 
      String? idEntry, 
      String? nationalNumber, 
      String? phone, 
      dynamic isActive, 
      String? dateOfBirth, 
      String? placeOfBirth, 
      dynamic passportNumber, 
      dynamic profileImage, 
      dynamic personalIdentity, 
      dynamic drivingCertificate, 
      dynamic carMechanic, 
      dynamic carInsurance, 
      dynamic carImage, 
      dynamic groupId, 
      String? createdAt, 
      String? updatedAt, 
      dynamic deletedAt, 
      // List<dynamic>? metas, 
      // List<dynamic>? metaData,
      }){
    _id = id;
    _userId = userId;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _userType = userType;
    _fatherName = fatherName;
    _motherName = motherName;
    _idEntry = idEntry;
    _nationalNumber = nationalNumber;
    _phone = phone;
    _isActive = isActive;
    _dateOfBirth = dateOfBirth;
    _placeOfBirth = placeOfBirth;
    _passportNumber = passportNumber;
    _profileImage = profileImage;
    _personalIdentity = personalIdentity;
    _drivingCertificate = drivingCertificate;
    _carMechanic = carMechanic;
    _carInsurance = carInsurance;
    _carImage = carImage;
    _groupId = groupId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
    // _metas = metas;
    // _metaData = metaData;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _email = json['email'];
    _userType = json['user_type'];
    _fatherName = json['father_name'];
    _motherName = json['mother_name'];
    _idEntry = json['id_entry'];
    _nationalNumber = json['national_number'];
    _phone = json['phone'];
    _isActive = json['is_active'];
    _dateOfBirth = json['date_of_birth'];
    _placeOfBirth = json['place_of_birth'];
    _passportNumber = json['passport_number'];
    _profileImage = json['profile_image'];
    _personalIdentity = json['personal_identity'];
    _drivingCertificate = json['driving_certificate'];
    _carMechanic = json['car_mechanic'];
    _carInsurance = json['car_insurance'];
    _carImage = json['car_image'];
    _groupId = json['group_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
    // if (json['metas'] != null) {
    //   _metas = [];
    //   json['metas'].forEach((v) {
    //     _metas?.add(Dynamic.fromJson(v));
    //   });
    // }
    // if (json['meta_data'] != null) {
    //   _metaData = [];
    //   json['meta_data'].forEach((v) {
    //     _metaData?.add(Dynamic.fromJson(v));
    //   });
    // }
  }
  num? _id;
  dynamic _userId;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _userType;
  String? _fatherName;
  String? _motherName;
  String? _idEntry;
  String? _nationalNumber;
  String? _phone;
  dynamic _isActive;
  String? _dateOfBirth;
  String? _placeOfBirth;
  dynamic _passportNumber;
  dynamic _profileImage;
  dynamic _personalIdentity;
  dynamic _drivingCertificate;
  dynamic _carMechanic;
  dynamic _carInsurance;
  dynamic _carImage;
  dynamic _groupId;
  String? _createdAt;
  String? _updatedAt;
  dynamic _deletedAt;
  // List<dynamic>? _metas;
  // List<dynamic>? _metaData;
Data copyWith({  num? id,
  dynamic userId,
  String? firstName,
  String? lastName,
  String? email,
  String? userType,
  String? fatherName,
  String? motherName,
  String? idEntry,
  String? nationalNumber,
  String? phone,
  dynamic isActive,
  String? dateOfBirth,
  String? placeOfBirth,
  dynamic passportNumber,
  dynamic profileImage,
  dynamic personalIdentity,
  dynamic drivingCertificate,
  dynamic carMechanic,
  dynamic carInsurance,
  dynamic carImage,
  dynamic groupId,
  String? createdAt,
  String? updatedAt,
  dynamic deletedAt,
  // List<dynamic>? metas,
  // List<dynamic>? metaData,
}) => Data(  id: id ?? _id,
  userId: userId ?? _userId,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  email: email ?? _email,
  userType: userType ?? _userType,
  fatherName: fatherName ?? _fatherName,
  motherName: motherName ?? _motherName,
  idEntry: idEntry ?? _idEntry,
  nationalNumber: nationalNumber ?? _nationalNumber,
  phone: phone ?? _phone,
  isActive: isActive ?? _isActive,
  dateOfBirth: dateOfBirth ?? _dateOfBirth,
  placeOfBirth: placeOfBirth ?? _placeOfBirth,
  passportNumber: passportNumber ?? _passportNumber,
  profileImage: profileImage ?? _profileImage,
  personalIdentity: personalIdentity ?? _personalIdentity,
  drivingCertificate: drivingCertificate ?? _drivingCertificate,
  carMechanic: carMechanic ?? _carMechanic,
  carInsurance: carInsurance ?? _carInsurance,
  carImage: carImage ?? _carImage,
  groupId: groupId ?? _groupId,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  deletedAt: deletedAt ?? _deletedAt,
  // metas: metas ?? _metas,
  // metaData: metaData ?? _metaData,
);
  num? get id => _id;
  dynamic get userId => _userId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get userType => _userType;
  String? get fatherName => _fatherName;
  String? get motherName => _motherName;
  String? get idEntry => _idEntry;
  String? get nationalNumber => _nationalNumber;
  String? get phone => _phone;
  dynamic get isActive => _isActive;
  String? get dateOfBirth => _dateOfBirth;
  String? get placeOfBirth => _placeOfBirth;
  dynamic get passportNumber => _passportNumber;
  dynamic get profileImage => _profileImage;
  dynamic get personalIdentity => _personalIdentity;
  dynamic get drivingCertificate => _drivingCertificate;
  dynamic get carMechanic => _carMechanic;
  dynamic get carInsurance => _carInsurance;
  dynamic get carImage => _carImage;
  dynamic get groupId => _groupId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;
  // List<dynamic>? get metas => _metas;
  // List<dynamic>? get metaData => _metaData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['email'] = _email;
    map['user_type'] = _userType;
    map['father_name'] = _fatherName;
    map['mother_name'] = _motherName;
    map['id_entry'] = _idEntry;
    map['national_number'] = _nationalNumber;
    map['phone'] = _phone;
    map['is_active'] = _isActive;
    map['date_of_birth'] = _dateOfBirth;
    map['place_of_birth'] = _placeOfBirth;
    map['passport_number'] = _passportNumber;
    map['profile_image'] = _profileImage;
    map['personal_identity'] = _personalIdentity;
    map['driving_certificate'] = _drivingCertificate;
    map['car_mechanic'] = _carMechanic;
    map['car_insurance'] = _carInsurance;
    map['car_image'] = _carImage;
    map['group_id'] = _groupId;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    // if (_metas != null) {
    //   map['metas'] = _metas?.map((v) => v.toJson()).toList();
    // }
    // if (_metaData != null) {
    //   map['meta_data'] = _metaData?.map((v) => v.toJson()).toList();
    // }
    return map;
  }

}