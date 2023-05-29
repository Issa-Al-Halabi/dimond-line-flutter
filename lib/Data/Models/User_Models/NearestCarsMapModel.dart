/// error : false
/// message : "Listed Successfuly"
/// data : [{"id":242,"vehicle_id":71,"device_id":6584,"driver_id":"242","latitude":"33.487512159283106","longitude":"36.354328556899134","created_at":"2022-12-28 10:02:16","deleted_at":null,"updated_at":"2023-05-24 08:28:10","vehicle_image":"b94bf701-4ef6-4f53-82d4-4fa93144995d.jpg","color":"brown","car_number":"3654","car_model":"ssososo","user_id":null,"first_name":"fadi","last_name":"alayyass","email":"giqu@mailinator.com","password":"$2y$10$zyapYMNWIng1mceuhd6wgeXpcTm7dhCcaNPyjOVLUEjeEWn/l6hMC","user_type":"external_driver","father_name":null,"mother_name":null,"phone":"956320147","is_active":"active","in_service":"off","date_of_birth":"2000-06-21","place_of_birth":"Corporis iste qui ni","profile_image":"c93ad207-6573-4776-afbf-bdcf4951241e.jpg","personal_identity":"4f9419a6-a5e7-477c-b723-9c9f4688d2a6.jpg","driving_certificate":"e5385e38-953a-45ad-ab47-4a742893e266.jpg","car_mechanic":"ab028151-f7c1-4f41-9f9d-1ee8d4e9c95a.jpg","car_insurance":"1aa4b263-2fd5-4a44-9b2b-59dd819aff7a.jpg","car_image":"5db5a83b-0523-4331-909c-e2c45f51d858.jpg","group_id":null,"api_token":"ltjviuCPlz6rxFflXv9OwPyD3I44UcZuF4QTEufucC0pNnWo7Z0f5npovgR1","device_token":null,"remember_token":null,"distance":0.17086689053929094},{"id":270,"vehicle_id":72,"device_id":273,"driver_id":"270","latitude":"33.4849993","longitude":"36.3408486","created_at":"2023-01-29 13:30:45","deleted_at":null,"updated_at":"2023-01-29 14:06:51","vehicle_image":null,"color":"bink","car_number":"2147483647","car_model":"van","user_id":null,"first_name":"abdullah","last_name":"awwad","email":"123@gmail.com","password":"$2y$10$gDnaxK2YsjtNgUWPCymY2eeF39QAOLItX6ZIpk22WbjQMIIXBduV6","user_type":"external_driver","father_name":null,"mother_name":null,"phone":"989202088","is_active":"active","in_service":"off","date_of_birth":null,"place_of_birth":null,"profile_image":"","personal_identity":"19a4f381-05e1-4ea1-b1cd-521947df9d87.jpg","driving_certificate":"68cd9c4a-1e00-4039-8768-921a66e69d14.jpg","car_mechanic":"068fee15-8b71-4cde-be61-23dd25948bac.jpg","car_insurance":"8af3cb7d-f75b-4685-8257-33e9d5a00ba3.jpg","car_image":"28558c1b-ea3d-4607-96ec-dbdece20276d.jpg","group_id":null,"api_token":"PFWVdx7p10lamRzfmGO2lfQRfBFhaCV1UNmlK7lNBHbuQ6lnFdFFkEwxrjDf","device_token":"dh83Q1xATZWBaGfYIvKid3:APA91bFz9MNoW7i2Dey8yu8Z4TesW_DbpClnyLamkxj9z_6bEdmLUX_5E9OmlLlRi8AaPZCbxF9f1rL7EroduPLFaxQaKAkFjrpSUOtA1tnrpCRS6aD-0w59stn-o0Y1IemiuiPeHEj1","remember_token":null,"distance":0.7545957402085621}]

class NearestCarsMapModel {
  NearestCarsMapModel({
      bool? error, 
      String? message, 
      List<Data>? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  NearestCarsMapModel.fromJson(dynamic json) {
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
NearestCarsMapModel copyWith({  bool? error,
  String? message,
  List<Data>? data,
}) => NearestCarsMapModel(  error: error ?? _error,
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

/// id : 242
/// vehicle_id : 71
/// device_id : 6584
/// driver_id : "242"
/// latitude : "33.487512159283106"
/// longitude : "36.354328556899134"
/// created_at : "2022-12-28 10:02:16"
/// deleted_at : null
/// updated_at : "2023-05-24 08:28:10"
/// vehicle_image : "b94bf701-4ef6-4f53-82d4-4fa93144995d.jpg"
/// color : "brown"
/// car_number : "3654"
/// car_model : "ssososo"
/// user_id : null
/// first_name : "fadi"
/// last_name : "alayyass"
/// email : "giqu@mailinator.com"
/// password : "$2y$10$zyapYMNWIng1mceuhd6wgeXpcTm7dhCcaNPyjOVLUEjeEWn/l6hMC"
/// user_type : "external_driver"
/// father_name : null
/// mother_name : null
/// phone : "956320147"
/// is_active : "active"
/// in_service : "off"
/// date_of_birth : "2000-06-21"
/// place_of_birth : "Corporis iste qui ni"
/// profile_image : "c93ad207-6573-4776-afbf-bdcf4951241e.jpg"
/// personal_identity : "4f9419a6-a5e7-477c-b723-9c9f4688d2a6.jpg"
/// driving_certificate : "e5385e38-953a-45ad-ab47-4a742893e266.jpg"
/// car_mechanic : "ab028151-f7c1-4f41-9f9d-1ee8d4e9c95a.jpg"
/// car_insurance : "1aa4b263-2fd5-4a44-9b2b-59dd819aff7a.jpg"
/// car_image : "5db5a83b-0523-4331-909c-e2c45f51d858.jpg"
/// group_id : null
/// api_token : "ltjviuCPlz6rxFflXv9OwPyD3I44UcZuF4QTEufucC0pNnWo7Z0f5npovgR1"
/// device_token : null
/// remember_token : null
/// distance : 0.17086689053929094

class Data {
  Data({
      int? id, 
      int? vehicleId, 
      int? deviceId, 
      String? driverId, 
      String? latitude, 
      String? longitude, 
      String? createdAt, 
      dynamic deletedAt, 
      String? updatedAt, 
      String? vehicleImage, 
      String? color, 
      String? carNumber, 
      String? carModel, 
      dynamic userId, 
      String? firstName, 
      String? lastName, 
      String? email, 
      String? password, 
      String? userType, 
      dynamic fatherName, 
      dynamic motherName, 
      String? phone, 
      String? isActive, 
      String? inService, 
      String? dateOfBirth, 
      String? placeOfBirth, 
      String? profileImage, 
      String? personalIdentity, 
      String? drivingCertificate, 
      String? carMechanic, 
      String? carInsurance, 
      String? carImage, 
      dynamic groupId, 
      String? apiToken, 
      dynamic deviceToken, 
      dynamic rememberToken,
     dynamic distance,}){
    _id = id;
    _vehicleId = vehicleId;
    _deviceId = deviceId;
    _driverId = driverId;
    _latitude = latitude;
    _longitude = longitude;
    _createdAt = createdAt;
    _deletedAt = deletedAt;
    _updatedAt = updatedAt;
    _vehicleImage = vehicleImage;
    _color = color;
    _carNumber = carNumber;
    _carModel = carModel;
    _userId = userId;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _password = password;
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
    _apiToken = apiToken;
    _deviceToken = deviceToken;
    _rememberToken = rememberToken;
    _distance = distance;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _vehicleId = json['vehicle_id'];
    _deviceId = json['device_id'];
    _driverId = json['driver_id'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _createdAt = json['created_at'];
    _deletedAt = json['deleted_at'];
    _updatedAt = json['updated_at'];
    _vehicleImage = json['vehicle_image'];
    _color = json['color'];
    _carNumber = json['car_number'];
    _carModel = json['car_model'];
    _userId = json['user_id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _email = json['email'];
    _password = json['password'];
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
    _apiToken = json['api_token'];
    _deviceToken = json['device_token'];
    _rememberToken = json['remember_token'];
    _distance = json['distance'];
  }
  int? _id;
  int? _vehicleId;
  int? _deviceId;
  String? _driverId;
  String? _latitude;
  String? _longitude;
  String? _createdAt;
  dynamic _deletedAt;
  String? _updatedAt;
  String? _vehicleImage;
  String? _color;
  String? _carNumber;
  String? _carModel;
  dynamic _userId;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _password;
  String? _userType;
  dynamic _fatherName;
  dynamic _motherName;
  String? _phone;
  String? _isActive;
  String? _inService;
  String? _dateOfBirth;
  String? _placeOfBirth;
  String? _profileImage;
  String? _personalIdentity;
  String? _drivingCertificate;
  String? _carMechanic;
  String? _carInsurance;
  String? _carImage;
  dynamic _groupId;
  String? _apiToken;
  dynamic _deviceToken;
  dynamic _rememberToken;
  dynamic _distance;
Data copyWith({  int? id,
  int? vehicleId,
  int? deviceId,
  String? driverId,
  String? latitude,
  String? longitude,
  String? createdAt,
  dynamic deletedAt,
  String? updatedAt,
  String? vehicleImage,
  String? color,
  String? carNumber,
  String? carModel,
  dynamic userId,
  String? firstName,
  String? lastName,
  String? email,
  String? password,
  String? userType,
  dynamic fatherName,
  dynamic motherName,
  String? phone,
  String? isActive,
  String? inService,
  String? dateOfBirth,
  String? placeOfBirth,
  String? profileImage,
  String? personalIdentity,
  String? drivingCertificate,
  String? carMechanic,
  String? carInsurance,
  String? carImage,
  dynamic groupId,
  String? apiToken,
  dynamic deviceToken,
  dynamic rememberToken,
  dynamic distance,
}) => Data(  id: id ?? _id,
  vehicleId: vehicleId ?? _vehicleId,
  deviceId: deviceId ?? _deviceId,
  driverId: driverId ?? _driverId,
  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
  createdAt: createdAt ?? _createdAt,
  deletedAt: deletedAt ?? _deletedAt,
  updatedAt: updatedAt ?? _updatedAt,
  vehicleImage: vehicleImage ?? _vehicleImage,
  color: color ?? _color,
  carNumber: carNumber ?? _carNumber,
  carModel: carModel ?? _carModel,
  userId: userId ?? _userId,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  email: email ?? _email,
  password: password ?? _password,
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
  apiToken: apiToken ?? _apiToken,
  deviceToken: deviceToken ?? _deviceToken,
  rememberToken: rememberToken ?? _rememberToken,
  distance: distance ?? _distance,
);
  int? get id => _id;
  int? get vehicleId => _vehicleId;
  int? get deviceId => _deviceId;
  String? get driverId => _driverId;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get createdAt => _createdAt;
  dynamic get deletedAt => _deletedAt;
  String? get updatedAt => _updatedAt;
  String? get vehicleImage => _vehicleImage;
  String? get color => _color;
  String? get carNumber => _carNumber;
  String? get carModel => _carModel;
  dynamic get userId => _userId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get password => _password;
  String? get userType => _userType;
  dynamic get fatherName => _fatherName;
  dynamic get motherName => _motherName;
  String? get phone => _phone;
  String? get isActive => _isActive;
  String? get inService => _inService;
  String? get dateOfBirth => _dateOfBirth;
  String? get placeOfBirth => _placeOfBirth;
  String? get profileImage => _profileImage;
  String? get personalIdentity => _personalIdentity;
  String? get drivingCertificate => _drivingCertificate;
  String? get carMechanic => _carMechanic;
  String? get carInsurance => _carInsurance;
  String? get carImage => _carImage;
  dynamic get groupId => _groupId;
  String? get apiToken => _apiToken;
  dynamic get deviceToken => _deviceToken;
  dynamic get rememberToken => _rememberToken;
  dynamic get distance => _distance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['vehicle_id'] = _vehicleId;
    map['device_id'] = _deviceId;
    map['driver_id'] = _driverId;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['created_at'] = _createdAt;
    map['deleted_at'] = _deletedAt;
    map['updated_at'] = _updatedAt;
    map['vehicle_image'] = _vehicleImage;
    map['color'] = _color;
    map['car_number'] = _carNumber;
    map['car_model'] = _carModel;
    map['user_id'] = _userId;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['email'] = _email;
    map['password'] = _password;
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
    map['api_token'] = _apiToken;
    map['device_token'] = _deviceToken;
    map['remember_token'] = _rememberToken;
    map['distance'] = _distance;
    return map;
  }

}