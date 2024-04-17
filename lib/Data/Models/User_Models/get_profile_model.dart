/// error : false
/// message : "user found"
/// data : {"user":{"id":241,"user_id":null,"first_name":"ليان","last_name":"هدروس","email":"layan@gmail.com","user_type":"user","father_name":"اياس","mother_name":"هنادي","phone":"935681347","is_active":null,"in_service":null,"date_of_birth":"1998-07-11","place_of_birth":"دمشق","profile_image":"92fcb42d-8b0b-4498-b007-d48c2503738c.jpg","personal_identity":null,"driving_certificate":null,"car_mechanic":null,"car_insurance":null,"car_image":null,"group_id":null,"device_token":"e27lb7F9QdK8joG3xjlkix:APA91bF_wxLWnEzuGnHMpAl8CVCszzle2B0jTupRXsuud77SJBzuIblrogj7JgQHE1QHcUBhPBqv7hoHQ0A_CU-hmNZTAspgLXgA9E6nt7P0iRrMQphZtbHvjBDF0hcVvw2GFTQdKyJy","created_at":"2022-12-28T09:57:25.000000Z","updated_at":"2023-04-19T11:22:53.000000Z","deleted_at":null,"metas":[{"id":193,"user_id":241,"type":"NULL","key":"address","value":null,"deleted_at":null,"created_at":"2023-01-17T15:15:03.000000Z","updated_at":"2023-01-17T15:15:03.000000Z"},{"id":299,"user_id":241,"type":"NULL","key":"national_number","value":null,"deleted_at":null,"created_at":"2023-04-09T11:44:37.000000Z","updated_at":"2023-04-09T11:44:37.000000Z"},{"id":300,"user_id":241,"type":"NULL","key":"id_entry","value":null,"deleted_at":null,"created_at":"2023-04-09T11:44:37.000000Z","updated_at":"2023-04-09T11:44:37.000000Z"},{"id":301,"user_id":241,"type":"NULL","key":"passport_number","value":null,"deleted_at":null,"created_at":"2023-04-09T11:44:37.000000Z","updated_at":"2023-04-09T11:44:37.000000Z"}],"meta_data":{"address":null,"national_number":null,"id_entry":null,"passport_number":null}},"image":"https://diamond-line.com.sy/uploads/92fcb42d-8b0b-4498-b007-d48c2503738c.jpg"}

class GetProfileModel {
  GetProfileModel({
    bool? error,
    String? message,
    Data? data,
  }) {
    _error = error;
    _message = message;
    _data = data;
  }

  GetProfileModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _error;
  String? _message;
  Data? _data;
  GetProfileModel copyWith({
    bool? error,
    String? message,
    Data? data,
  }) =>
      GetProfileModel(
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

/// user : {"id":241,"user_id":null,"first_name":"ليان","last_name":"هدروس","email":"layan@gmail.com","user_type":"user","father_name":"اياس","mother_name":"هنادي","phone":"935681347","is_active":null,"in_service":null,"date_of_birth":"1998-07-11","place_of_birth":"دمشق","profile_image":"92fcb42d-8b0b-4498-b007-d48c2503738c.jpg","personal_identity":null,"driving_certificate":null,"car_mechanic":null,"car_insurance":null,"car_image":null,"group_id":null,"device_token":"e27lb7F9QdK8joG3xjlkix:APA91bF_wxLWnEzuGnHMpAl8CVCszzle2B0jTupRXsuud77SJBzuIblrogj7JgQHE1QHcUBhPBqv7hoHQ0A_CU-hmNZTAspgLXgA9E6nt7P0iRrMQphZtbHvjBDF0hcVvw2GFTQdKyJy","created_at":"2022-12-28T09:57:25.000000Z","updated_at":"2023-04-19T11:22:53.000000Z","deleted_at":null,"metas":[{"id":193,"user_id":241,"type":"NULL","key":"address","value":null,"deleted_at":null,"created_at":"2023-01-17T15:15:03.000000Z","updated_at":"2023-01-17T15:15:03.000000Z"},{"id":299,"user_id":241,"type":"NULL","key":"national_number","value":null,"deleted_at":null,"created_at":"2023-04-09T11:44:37.000000Z","updated_at":"2023-04-09T11:44:37.000000Z"},{"id":300,"user_id":241,"type":"NULL","key":"id_entry","value":null,"deleted_at":null,"created_at":"2023-04-09T11:44:37.000000Z","updated_at":"2023-04-09T11:44:37.000000Z"},{"id":301,"user_id":241,"type":"NULL","key":"passport_number","value":null,"deleted_at":null,"created_at":"2023-04-09T11:44:37.000000Z","updated_at":"2023-04-09T11:44:37.000000Z"}],"meta_data":{"address":null,"national_number":null,"id_entry":null,"passport_number":null}}
/// image : "https://diamond-line.com.sy/uploads/92fcb42d-8b0b-4498-b007-d48c2503738c.jpg"

class Data {
  Data({
    User? user,
    String? image,
  }) {
    _user = user;
    _image = image;
  }

  Data.fromJson(dynamic json) {
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _image = json['image'];
  }
  User? _user;
  String? _image;
  Data copyWith({
    User? user,
    String? image,
  }) =>
      Data(
        user: user ?? _user,
        image: image ?? _image,
      );
  User? get user => _user;
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    map['image'] = _image;
    return map;
  }
}

/// id : 241
/// user_id : null
/// first_name : "ليان"
/// last_name : "هدروس"
/// email : "layan@gmail.com"
/// user_type : "user"
/// father_name : "اياس"
/// mother_name : "هنادي"
/// phone : "935681347"
/// is_active : null
/// in_service : null
/// date_of_birth : "1998-07-11"
/// place_of_birth : "دمشق"
/// profile_image : "92fcb42d-8b0b-4498-b007-d48c2503738c.jpg"
/// personal_identity : null
/// driving_certificate : null
/// car_mechanic : null
/// car_insurance : null
/// car_image : null
/// group_id : null
/// device_token : "e27lb7F9QdK8joG3xjlkix:APA91bF_wxLWnEzuGnHMpAl8CVCszzle2B0jTupRXsuud77SJBzuIblrogj7JgQHE1QHcUBhPBqv7hoHQ0A_CU-hmNZTAspgLXgA9E6nt7P0iRrMQphZtbHvjBDF0hcVvw2GFTQdKyJy"
/// created_at : "2022-12-28T09:57:25.000000Z"
/// updated_at : "2023-04-19T11:22:53.000000Z"
/// deleted_at : null
/// metas : [{"id":193,"user_id":241,"type":"NULL","key":"address","value":null,"deleted_at":null,"created_at":"2023-01-17T15:15:03.000000Z","updated_at":"2023-01-17T15:15:03.000000Z"},{"id":299,"user_id":241,"type":"NULL","key":"national_number","value":null,"deleted_at":null,"created_at":"2023-04-09T11:44:37.000000Z","updated_at":"2023-04-09T11:44:37.000000Z"},{"id":300,"user_id":241,"type":"NULL","key":"id_entry","value":null,"deleted_at":null,"created_at":"2023-04-09T11:44:37.000000Z","updated_at":"2023-04-09T11:44:37.000000Z"},{"id":301,"user_id":241,"type":"NULL","key":"passport_number","value":null,"deleted_at":null,"created_at":"2023-04-09T11:44:37.000000Z","updated_at":"2023-04-09T11:44:37.000000Z"}]
/// meta_data : {"address":null,"national_number":null,"id_entry":null,"passport_number":null}

class User {
  User({
    int? id,
    dynamic userId,
    String? firstName,
    String? lastName,
    String? email,
    String? userType,
    String? fatherName,
    String? motherName,
    String? phone,
    dynamic isActive,
    dynamic inService,
    String? dateOfBirth,
    String? placeOfBirth,
    String? profileImage,
    dynamic personalIdentity,
    dynamic drivingCertificate,
    dynamic carMechanic,
    dynamic carInsurance,
    dynamic carImage,
    dynamic groupId,
    String? deviceToken,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    List<Metas>? metas,
    MetaData? metaData,
  }) {
    _id = id;
    _userId = userId;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _userType = userType;
    _fatherName = fatherName;
    _motherName = motherName;
    _phone = phone;
    _isActive = isActive;
    _inService = inService;
    _dateOfBirth = dateOfBirth;
    _placeOfBirth = placeOfBirth;
    _profileImage = profileImage;
    _personalIdentity = personalIdentity;
    _drivingCertificate = drivingCertificate;
    _carMechanic = carMechanic;
    _carInsurance = carInsurance;
    _carImage = carImage;
    _groupId = groupId;
    _deviceToken = deviceToken;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
    _metas = metas;
    _metaData = metaData;
  }

  User.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _email = json['email'];
    _userType = json['user_type'];
    _fatherName = json['father_name'];
    _motherName = json['mother_name'];
    _phone = json['phone'];
    _isActive = json['is_active'];
    _inService = json['in_service'];
    _dateOfBirth = json['date_of_birth'];
    _placeOfBirth = json['place_of_birth'];
    _profileImage = json['profile_image'];
    _personalIdentity = json['personal_identity'];
    _drivingCertificate = json['driving_certificate'];
    _carMechanic = json['car_mechanic'];
    _carInsurance = json['car_insurance'];
    _carImage = json['car_image'];
    _groupId = json['group_id'];
    _deviceToken = json['device_token'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
    if (json['metas'] != null) {
      _metas = [];
      json['metas'].forEach((v) {
        _metas?.add(Metas.fromJson(v));
      });
    }
    _metaData =
        json['meta_data'] != null ? MetaData.fromJson(json['meta_data']) : null;
  }
  int? _id;
  dynamic _userId;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _userType;
  String? _fatherName;
  String? _motherName;
  String? _phone;
  dynamic _isActive;
  dynamic _inService;
  String? _dateOfBirth;
  String? _placeOfBirth;
  String? _profileImage;
  dynamic _personalIdentity;
  dynamic _drivingCertificate;
  dynamic _carMechanic;
  dynamic _carInsurance;
  dynamic _carImage;
  dynamic _groupId;
  String? _deviceToken;
  String? _createdAt;
  String? _updatedAt;
  dynamic _deletedAt;
  List<Metas>? _metas;
  MetaData? _metaData;
  User copyWith({
    int? id,
    dynamic userId,
    String? firstName,
    String? lastName,
    String? email,
    String? userType,
    String? fatherName,
    String? motherName,
    String? phone,
    dynamic isActive,
    dynamic inService,
    String? dateOfBirth,
    String? placeOfBirth,
    String? profileImage,
    dynamic personalIdentity,
    dynamic drivingCertificate,
    dynamic carMechanic,
    dynamic carInsurance,
    dynamic carImage,
    dynamic groupId,
    String? deviceToken,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    List<Metas>? metas,
    MetaData? metaData,
  }) =>
      User(
        id: id ?? _id,
        userId: userId ?? _userId,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        email: email ?? _email,
        userType: userType ?? _userType,
        fatherName: fatherName ?? _fatherName,
        motherName: motherName ?? _motherName,
        phone: phone ?? _phone,
        isActive: isActive ?? _isActive,
        inService: inService ?? _inService,
        dateOfBirth: dateOfBirth ?? _dateOfBirth,
        placeOfBirth: placeOfBirth ?? _placeOfBirth,
        profileImage: profileImage ?? _profileImage,
        personalIdentity: personalIdentity ?? _personalIdentity,
        drivingCertificate: drivingCertificate ?? _drivingCertificate,
        carMechanic: carMechanic ?? _carMechanic,
        carInsurance: carInsurance ?? _carInsurance,
        carImage: carImage ?? _carImage,
        groupId: groupId ?? _groupId,
        deviceToken: deviceToken ?? _deviceToken,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        deletedAt: deletedAt ?? _deletedAt,
        metas: metas ?? _metas,
        metaData: metaData ?? _metaData,
      );
  int? get id => _id;
  dynamic get userId => _userId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get userType => _userType;
  String? get fatherName => _fatherName;
  String? get motherName => _motherName;
  String? get phone => _phone;
  dynamic get isActive => _isActive;
  dynamic get inService => _inService;
  String? get dateOfBirth => _dateOfBirth;
  String? get placeOfBirth => _placeOfBirth;
  String? get profileImage => _profileImage;
  dynamic get personalIdentity => _personalIdentity;
  dynamic get drivingCertificate => _drivingCertificate;
  dynamic get carMechanic => _carMechanic;
  dynamic get carInsurance => _carInsurance;
  dynamic get carImage => _carImage;
  dynamic get groupId => _groupId;
  String? get deviceToken => _deviceToken;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;
  List<Metas>? get metas => _metas;
  MetaData? get metaData => _metaData;

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
    map['phone'] = _phone;
    map['is_active'] = _isActive;
    map['in_service'] = _inService;
    map['date_of_birth'] = _dateOfBirth;
    map['place_of_birth'] = _placeOfBirth;
    map['profile_image'] = _profileImage;
    map['personal_identity'] = _personalIdentity;
    map['driving_certificate'] = _drivingCertificate;
    map['car_mechanic'] = _carMechanic;
    map['car_insurance'] = _carInsurance;
    map['car_image'] = _carImage;
    map['group_id'] = _groupId;
    map['device_token'] = _deviceToken;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    if (_metas != null) {
      map['metas'] = _metas?.map((v) => v.toJson()).toList();
    }
    if (_metaData != null) {
      map['meta_data'] = _metaData?.toJson();
    }
    return map;
  }
}

/// address : null
/// national_number : null
/// id_entry : null
/// passport_number : null

class MetaData {
  MetaData({
    dynamic address,
    dynamic nationalNumber,
    dynamic idEntry,
    dynamic passportNumber,
  }) {
    _address = address;
    _nationalNumber = nationalNumber;
    _idEntry = idEntry;
    _passportNumber = passportNumber;
  }

  MetaData.fromJson(dynamic json) {
    _address = json['address'];
    _nationalNumber = json['national_number'];
    _idEntry = json['id_entry'];
    _passportNumber = json['passport_number'];
  }
  dynamic _address;
  dynamic _nationalNumber;
  dynamic _idEntry;
  dynamic _passportNumber;
  MetaData copyWith({
    dynamic address,
    dynamic nationalNumber,
    dynamic idEntry,
    dynamic passportNumber,
  }) =>
      MetaData(
        address: address ?? _address,
        nationalNumber: nationalNumber ?? _nationalNumber,
        idEntry: idEntry ?? _idEntry,
        passportNumber: passportNumber ?? _passportNumber,
      );
  dynamic get address => _address;
  dynamic get nationalNumber => _nationalNumber;
  dynamic get idEntry => _idEntry;
  dynamic get passportNumber => _passportNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = _address;
    map['national_number'] = _nationalNumber;
    map['id_entry'] = _idEntry;
    map['passport_number'] = _passportNumber;
    return map;
  }
}

/// id : 193
/// user_id : 241
/// type : "NULL"
/// key : "address"
/// value : null
/// deleted_at : null
/// created_at : "2023-01-17T15:15:03.000000Z"
/// updated_at : "2023-01-17T15:15:03.000000Z"

class Metas {
  Metas({
    int? id,
    int? userId,
    String? type,
    String? key,
    dynamic value,
    dynamic deletedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _userId = userId;
    _type = type;
    _key = key;
    _value = value;
    _deletedAt = deletedAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Metas.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _type = json['type'];
    _key = json['key'];
    _value = json['value'];
    _deletedAt = json['deleted_at'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  int? _id;
  int? _userId;
  String? _type;
  String? _key;
  dynamic _value;
  dynamic _deletedAt;
  String? _createdAt;
  String? _updatedAt;
  Metas copyWith({
    int? id,
    int? userId,
    String? type,
    String? key,
    dynamic value,
    dynamic deletedAt,
    String? createdAt,
    String? updatedAt,
  }) =>
      Metas(
        id: id ?? _id,
        userId: userId ?? _userId,
        type: type ?? _type,
        key: key ?? _key,
        value: value ?? _value,
        deletedAt: deletedAt ?? _deletedAt,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  int? get id => _id;
  int? get userId => _userId;
  String? get type => _type;
  String? get key => _key;
  dynamic get value => _value;
  dynamic get deletedAt => _deletedAt;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['type'] = _type;
    map['key'] = _key;
    map['value'] = _value;
    map['deleted_at'] = _deletedAt;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
