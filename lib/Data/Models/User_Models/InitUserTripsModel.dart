/// success : true
/// data : [{"id":672,"status":"arrived","request_type":"delayed","pickup_latitude":"37.502755","pickup_longitude":"-122.0160033","drop_latitude":"37.57535847642711","drop_longitude":"-121.90615329891443","vehicle_id":66,"driver_id":242,"vehicle":{"id":66,"vehicle_image":"http://127.0.0.1:8000/uploads/e33b9109-4cdb-4787-ba17-6692c98eacb7.jpeg","color":"Black","device_number":712,"car_model":"Sedan"},"driver":{"id":242,"first_name":"fadi","last_name":"alayyas","phone":"956320147","profile_image":"c93ad207-6573-4776-afbf-bdcf4951241e.jpg"}},{"id":673,"status":"started","request_type":"moment","pickup_latitude":"37.502755","pickup_longitude":"-122.0160033","drop_latitude":"37.39593886574218","drop_longitude":"-122.15425729751587","vehicle_id":66,"driver_id":242,"vehicle":{"id":66,"vehicle_image":"http://127.0.0.1:8000/uploads/e33b9109-4cdb-4787-ba17-6692c98eacb7.jpeg","color":"Black","device_number":712,"car_model":"Sedan"},"driver":{"id":242,"first_name":"fadi","last_name":"alayyas","phone":"956320147","profile_image":"c93ad207-6573-4776-afbf-bdcf4951241e.jpg"}}]

class InitUserTripsModel {
  InitUserTripsModel({
    bool? success,
    List<Data>? data,
  }) {
    _success = success;
    _data = data;
  }

  InitUserTripsModel.fromJson(dynamic json) {
    _success = json['success'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _success;
  List<Data>? _data;
  InitUserTripsModel copyWith({
    bool? success,
    List<Data>? data,
  }) =>
      InitUserTripsModel(
        success: success ?? _success,
        data: data ?? _data,
      );
  bool? get success => _success;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 672
/// status : "arrived"
/// request_type : "delayed"
/// pickup_latitude : "37.502755"
/// pickup_longitude : "-122.0160033"
/// drop_latitude : "37.57535847642711"
/// drop_longitude : "-121.90615329891443"
/// vehicle_id : 66
/// driver_id : 242
/// vehicle : {"id":66,"vehicle_image":"http://127.0.0.1:8000/uploads/e33b9109-4cdb-4787-ba17-6692c98eacb7.jpeg","color":"Black","device_number":712,"car_model":"Sedan"}
/// driver : {"id":242,"first_name":"fadi","last_name":"alayyas","phone":"956320147","profile_image":"c93ad207-6573-4776-afbf-bdcf4951241e.jpg"}

class Data {
  Data({
    int? id,
    String? status,
    String? requestType,
    String? pickupLatitude,
    String? pickupLongitude,
    String? dropLatitude,
    String? dropLongitude,
    int? vehicleId,
    int? driverId,
    Vehicle? vehicle,
    Driver? driver,
  }) {
    _id = id;
    _status = status;
    _requestType = requestType;
    _pickupLatitude = pickupLatitude;
    _pickupLongitude = pickupLongitude;
    _dropLatitude = dropLatitude;
    _dropLongitude = dropLongitude;
    _vehicleId = vehicleId;
    _driverId = driverId;
    _vehicle = vehicle;
    _driver = driver;
  }

  set status(String? value) {
    _status = value;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _status = json['status'];
    _requestType = json['request_type'];
    _pickupLatitude = json['pickup_latitude'];
    _pickupLongitude = json['pickup_longitude'];
    _dropLatitude = json['drop_latitude'];
    _dropLongitude = json['drop_longitude'];
    _vehicleId = json['vehicle_id'];
    _driverId = json['driver_id'];
    _vehicle =
        json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
    _driver = json['driver'] != null ? Driver.fromJson(json['driver']) : null;
  }
  int? _id;
  String? _status;
  String? _requestType;
  String? _pickupLatitude;
  String? _pickupLongitude;
  String? _dropLatitude;
  String? _dropLongitude;
  int? _vehicleId;
  int? _driverId;
  Vehicle? _vehicle;
  Driver? _driver;
  Data copyWith({
    int? id,
    String? status,
    String? requestType,
    String? pickupLatitude,
    String? pickupLongitude,
    String? dropLatitude,
    String? dropLongitude,
    int? vehicleId,
    int? driverId,
    Vehicle? vehicle,
    Driver? driver,
  }) =>
      Data(
        id: id ?? _id,
        status: status ?? _status,
        requestType: requestType ?? _requestType,
        pickupLatitude: pickupLatitude ?? _pickupLatitude,
        pickupLongitude: pickupLongitude ?? _pickupLongitude,
        dropLatitude: dropLatitude ?? _dropLatitude,
        dropLongitude: dropLongitude ?? _dropLongitude,
        vehicleId: vehicleId ?? _vehicleId,
        driverId: driverId ?? _driverId,
        vehicle: vehicle ?? _vehicle,
        driver: driver ?? _driver,
      );
  int? get id => _id;
  String? get status => _status;
  String? get requestType => _requestType;
  String? get pickupLatitude => _pickupLatitude;
  String? get pickupLongitude => _pickupLongitude;
  String? get dropLatitude => _dropLatitude;
  String? get dropLongitude => _dropLongitude;
  int? get vehicleId => _vehicleId;
  int? get driverId => _driverId;
  Vehicle? get vehicle => _vehicle;
  Driver? get driver => _driver;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['status'] = _status;
    map['request_type'] = _requestType;
    map['pickup_latitude'] = _pickupLatitude;
    map['pickup_longitude'] = _pickupLongitude;
    map['drop_latitude'] = _dropLatitude;
    map['drop_longitude'] = _dropLongitude;
    map['vehicle_id'] = _vehicleId;
    map['driver_id'] = _driverId;
    if (_vehicle != null) {
      map['vehicle'] = _vehicle?.toJson();
    }
    if (_driver != null) {
      map['driver'] = _driver?.toJson();
    }
    return map;
  }
}

/// id : 242
/// first_name : "fadi"
/// last_name : "alayyas"
/// phone : "956320147"
/// profile_image : "c93ad207-6573-4776-afbf-bdcf4951241e.jpg"

class Driver {
  Driver({
    int? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? profileImage,
  }) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _phone = phone;
    _profileImage = profileImage;
  }

  set firstName(String? value) {
    _firstName = value;
  }

  Driver.fromJson(dynamic json) {
    _id = json['id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _phone = json['phone'];
    _profileImage = json['profile_image'];
  }
  int? _id;
  String? _firstName;
  String? _lastName;
  String? _phone;
  String? _profileImage;
  Driver copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? profileImage,
  }) =>
      Driver(
        id: id ?? _id,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        phone: phone ?? _phone,
        profileImage: profileImage ?? _profileImage,
      );
  int? get id => _id;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get phone => _phone;
  String? get profileImage => _profileImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['phone'] = _phone;
    map['profile_image'] = _profileImage;
    return map;
  }

  set lastName(String? value) {
    _lastName = value;
  }

  set phone(String? value) {
    _phone = value;
  }

  set profileImage(String? value) {
    _profileImage = value;
  }
}

/// id : 66
/// vehicle_image : "http://127.0.0.1:8000/uploads/e33b9109-4cdb-4787-ba17-6692c98eacb7.jpeg"
/// color : "Black"
/// device_number : 712
/// car_model : "Sedan"

class Vehicle {
  Vehicle({
    int? id,
    String? vehicleImage,
    String? color,
    int? deviceNumber,
    String? carModel,
  }) {
    _id = id;
    _vehicleImage = vehicleImage;
    _color = color;
    _deviceNumber = deviceNumber;
    _carModel = carModel;
  }

  set vehicleImage(String? value) {
    _vehicleImage = value;
  }

  Vehicle.fromJson(dynamic json) {
    _id = json['id'];
    _vehicleImage = json['vehicle_image'];
    _color = json['color'];
    _deviceNumber = json['device_number'];
    _carModel = json['car_model'];
  }
  int? _id;
  String? _vehicleImage;
  String? _color;
  int? _deviceNumber;
  String? _carModel;
  Vehicle copyWith({
    int? id,
    String? vehicleImage,
    String? color,
    int? deviceNumber,
    String? carModel,
  }) =>
      Vehicle(
        id: id ?? _id,
        vehicleImage: vehicleImage ?? _vehicleImage,
        color: color ?? _color,
        deviceNumber: deviceNumber ?? _deviceNumber,
        carModel: carModel ?? _carModel,
      );
  int? get id => _id;
  String? get vehicleImage => _vehicleImage;
  String? get color => _color;
  int? get deviceNumber => _deviceNumber;
  String? get carModel => _carModel;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['vehicle_image'] = _vehicleImage;
    map['color'] = _color;
    map['device_number'] = _deviceNumber;
    map['car_model'] = _carModel;
    return map;
  }

  set color(String? value) {
    _color = value;
  }

  set deviceNumber(int? value) {
    _deviceNumber = value;
  }

  set carModel(String? value) {
    _carModel = value;
  }
}
