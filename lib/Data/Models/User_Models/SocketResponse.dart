/// driver_first_name : "layan"
/// driver_last_name : "eias"
/// driver_profile_image : "https://diamond-line.com.sy/uploads/c93ad207-6573-4776-afbf-bdcf4951241e.jpg"
/// driver_phone : "935681347"
/// vehicel_device_number : 725
/// vehicel_car_model : "sedan"
/// vehicel_color : "red"
/// vehicel_image : "https://diamond-line.com.sy/uploads/c93ad207-6573-4776-afbf-bdcf4951241e.jpg"
/// pickupLatitude : "3.656556"
/// pickupLongitude : "3.255225"
/// dropLatitude : "3.11111"
/// dropLongitude : "3.55555"
/// status : "pending"
/// id : 707

class SocketResponse {
  SocketResponse({
      String? driverFirstName, 
      String? driverLastName, 
      String? driverProfileImage, 
      String? driverPhone, 
      int? vehicelDeviceNumber, 
      String? vehicelCarModel, 
      String? vehicelColor, 
      String? vehicelImage, 
      String? pickupLatitude, 
      String? pickupLongitude, 
      String? dropLatitude, 
      String? dropLongitude, 
      String? status, 
      int? id,}){
    _driverFirstName = driverFirstName;
    _driverLastName = driverLastName;
    _driverProfileImage = driverProfileImage;
    _driverPhone = driverPhone;
    _vehicelDeviceNumber = vehicelDeviceNumber;
    _vehicelCarModel = vehicelCarModel;
    _vehicelColor = vehicelColor;
    _vehicelImage = vehicelImage;
    _pickupLatitude = pickupLatitude;
    _pickupLongitude = pickupLongitude;
    _dropLatitude = dropLatitude;
    _dropLongitude = dropLongitude;
    _status = status;
    _id = id;
}

  set driverFirstName(String? value) {
    _driverFirstName = value;
  }

  SocketResponse.fromJson(dynamic json) {
    _driverFirstName = json['driver_first_name'];
    _driverLastName = json['driver_last_name'];
    _driverProfileImage = json['driver_profile_image'];
    _driverPhone = json['driver_phone'];
    _vehicelDeviceNumber = json['vehicel_device_number'];
    _vehicelCarModel = json['vehicel_car_model'];
    _vehicelColor = json['vehicel_color'];
    _vehicelImage = json['vehicel_image'];
    _pickupLatitude = json['pickupLatitude'];
    _pickupLongitude = json['pickupLongitude'];
    _dropLatitude = json['dropLatitude'];
    _dropLongitude = json['dropLongitude'];
    _status = json['status'];
    _id = json['id'];
  }
  String? _driverFirstName;
  String? _driverLastName;
  String? _driverProfileImage;
  String? _driverPhone;
  int? _vehicelDeviceNumber;
  String? _vehicelCarModel;
  String? _vehicelColor;
  String? _vehicelImage;
  String? _pickupLatitude;
  String? _pickupLongitude;
  String? _dropLatitude;
  String? _dropLongitude;
  String? _status;
  int? _id;
SocketResponse copyWith({  String? driverFirstName,
  String? driverLastName,
  String? driverProfileImage,
  String? driverPhone,
  int? vehicelDeviceNumber,
  String? vehicelCarModel,
  String? vehicelColor,
  String? vehicelImage,
  String? pickupLatitude,
  String? pickupLongitude,
  String? dropLatitude,
  String? dropLongitude,
  String? status,
  int? id,
}) => SocketResponse(  driverFirstName: driverFirstName ?? _driverFirstName,
  driverLastName: driverLastName ?? _driverLastName,
  driverProfileImage: driverProfileImage ?? _driverProfileImage,
  driverPhone: driverPhone ?? _driverPhone,
  vehicelDeviceNumber: vehicelDeviceNumber ?? _vehicelDeviceNumber,
  vehicelCarModel: vehicelCarModel ?? _vehicelCarModel,
  vehicelColor: vehicelColor ?? _vehicelColor,
  vehicelImage: vehicelImage ?? _vehicelImage,
  pickupLatitude: pickupLatitude ?? _pickupLatitude,
  pickupLongitude: pickupLongitude ?? _pickupLongitude,
  dropLatitude: dropLatitude ?? _dropLatitude,
  dropLongitude: dropLongitude ?? _dropLongitude,
  status: status ?? _status,
  id: id ?? _id,
);
  String? get driverFirstName => _driverFirstName;
  String? get driverLastName => _driverLastName;
  String? get driverProfileImage => _driverProfileImage;
  String? get driverPhone => _driverPhone;
  int? get vehicelDeviceNumber => _vehicelDeviceNumber;
  String? get vehicelCarModel => _vehicelCarModel;
  String? get vehicelColor => _vehicelColor;
  String? get vehicelImage => _vehicelImage;
  String? get pickupLatitude => _pickupLatitude;
  String? get pickupLongitude => _pickupLongitude;
  String? get dropLatitude => _dropLatitude;
  String? get dropLongitude => _dropLongitude;
  String? get status => _status;
  int? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['driver_first_name'] = _driverFirstName;
    map['driver_last_name'] = _driverLastName;
    map['driver_profile_image'] = _driverProfileImage;
    map['driver_phone'] = _driverPhone;
    map['vehicel_device_number'] = _vehicelDeviceNumber;
    map['vehicel_car_model'] = _vehicelCarModel;
    map['vehicel_color'] = _vehicelColor;
    map['vehicel_image'] = _vehicelImage;
    map['pickupLatitude'] = _pickupLatitude;
    map['pickupLongitude'] = _pickupLongitude;
    map['dropLatitude'] = _dropLatitude;
    map['dropLongitude'] = _dropLongitude;
    map['status'] = _status;
    map['id'] = _id;
    return map;
  }

  set driverLastName(String? value) {
    _driverLastName = value;
  }

  set driverProfileImage(String? value) {
    _driverProfileImage = value;
  }

  set driverPhone(String? value) {
    _driverPhone = value;
  }

  set vehicelDeviceNumber(int? value) {
    _vehicelDeviceNumber = value;
  }

  set vehicelCarModel(String? value) {
    _vehicelCarModel = value;
  }

  set vehicelColor(String? value) {
    _vehicelColor = value;
  }

  set vehicelImage(String? value) {
    _vehicelImage = value;
  }

  set pickupLatitude(String? value) {
    _pickupLatitude = value;
  }

  set pickupLongitude(String? value) {
    _pickupLongitude = value;
  }

  set dropLatitude(String? value) {
    _dropLatitude = value;
  }

  set dropLongitude(String? value) {
    _dropLongitude = value;
  }

  set status(String? value) {
    _status = value;
  }

  set id(int? value) {
    _id = value;
  }
}