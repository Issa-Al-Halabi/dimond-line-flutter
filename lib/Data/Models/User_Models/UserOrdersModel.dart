/// error : false
/// message : "Listed Succesfully "
/// data : {"insid_trips":[{"id":707,"user_id":360,"vehicle_id":66,"driver_id":242,"status":"pending","request_type":"delayed","pickup_latitude":"37.502755","pickup_longitude":"-122.0160033","drop_latitude":"37.676884112868436","drop_longitude":"-122.10664808750153","category_id":"1","from":null,"to":null,"dest_addr":"Hayward,Blossom Court","pickup_addr":"Alameda County,Newark","driver":{"id":242,"first_name":"fadi","last_name":"alayyas","phone":"956320147","profile_image":"https://diamond-line.com.sy/uploads/c93ad207-6573-4776-afbf-bdcf4951241e.jpg"},"vehicle":{"id":66,"color":"Black","car_model":"Sedan","vehicle_image":"https://diamond-line.com.sy/uploads/e33b9109-4cdb-4787-ba17-6692c98eacb7.jpeg","device_number":712}}],"outside_trips":[{"id":710,"user_id":360,"vehicle_id":66,"driver_id":242,"status":"accepted","request_type":null,"pickup_latitude":"37.502755","pickup_longitude":"-122.0160033","drop_latitude":"37.57463198412962","drop_longitude":"-121.91440109163524","category_id":"2","from":null,"to":null,"dest_addr":"Alameda County,Sunol","pickup_addr":"Alameda County,Newark","driver":{"id":242,"first_name":"fadi","last_name":"alayyas","phone":"956320147","profile_image":"https://diamond-line.com.sy/uploads/c93ad207-6573-4776-afbf-bdcf4951241e.jpg"},"vehicle":{"id":66,"color":"Black","car_model":"Sedan","vehicle_image":"https://diamond-line.com.sy/uploads/e33b9109-4cdb-4787-ba17-6692c98eacb7.jpeg","device_number":712}}]}

class UserOrdersModel {
  UserOrdersModel({
      bool? error, 
      String? message, 
      Data? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  UserOrdersModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _error;
  String? _message;
  Data? _data;
UserOrdersModel copyWith({  bool? error,
  String? message,
  Data? data,
}) => UserOrdersModel(  error: error ?? _error,
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

/// insid_trips : [{"id":707,"user_id":360,"vehicle_id":66,"driver_id":242,"status":"pending","request_type":"delayed","pickup_latitude":"37.502755","pickup_longitude":"-122.0160033","drop_latitude":"37.676884112868436","drop_longitude":"-122.10664808750153","category_id":"1","from":null,"to":null,"dest_addr":"Hayward,Blossom Court","pickup_addr":"Alameda County,Newark","driver":{"id":242,"first_name":"fadi","last_name":"alayyas","phone":"956320147","profile_image":"https://diamond-line.com.sy/uploads/c93ad207-6573-4776-afbf-bdcf4951241e.jpg"},"vehicle":{"id":66,"color":"Black","car_model":"Sedan","vehicle_image":"https://diamond-line.com.sy/uploads/e33b9109-4cdb-4787-ba17-6692c98eacb7.jpeg","device_number":712}}]
/// outside_trips : [{"id":710,"user_id":360,"vehicle_id":66,"driver_id":242,"status":"accepted","request_type":null,"pickup_latitude":"37.502755","pickup_longitude":"-122.0160033","drop_latitude":"37.57463198412962","drop_longitude":"-121.91440109163524","category_id":"2","from":null,"to":null,"dest_addr":"Alameda County,Sunol","pickup_addr":"Alameda County,Newark","driver":{"id":242,"first_name":"fadi","last_name":"alayyas","phone":"956320147","profile_image":"https://diamond-line.com.sy/uploads/c93ad207-6573-4776-afbf-bdcf4951241e.jpg"},"vehicle":{"id":66,"color":"Black","car_model":"Sedan","vehicle_image":"https://diamond-line.com.sy/uploads/e33b9109-4cdb-4787-ba17-6692c98eacb7.jpeg","device_number":712}}]

class Data {
  Data({
      List<InsidTrips>? insidTrips, 
      List<OutsideTrips>? outsideTrips,}){
    _insidTrips = insidTrips;
    _outsideTrips = outsideTrips;
}

  Data.fromJson(dynamic json) {
    if (json['insid_trips'] != null) {
      _insidTrips = [];
      json['insid_trips'].forEach((v) {
        _insidTrips?.add(InsidTrips.fromJson(v));
      });
    }
    if (json['outside_trips'] != null) {
      _outsideTrips = [];
      json['outside_trips'].forEach((v) {
        _outsideTrips?.add(OutsideTrips.fromJson(v));
      });
    }
  }
  List<InsidTrips>? _insidTrips;
  List<OutsideTrips>? _outsideTrips;
Data copyWith({  List<InsidTrips>? insidTrips,
  List<OutsideTrips>? outsideTrips,
}) => Data(  insidTrips: insidTrips ?? _insidTrips,
  outsideTrips: outsideTrips ?? _outsideTrips,
);
  List<InsidTrips>? get insidTrips => _insidTrips;
  List<OutsideTrips>? get outsideTrips => _outsideTrips;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_insidTrips != null) {
      map['insid_trips'] = _insidTrips?.map((v) => v.toJson()).toList();
    }
    if (_outsideTrips != null) {
      map['outside_trips'] = _outsideTrips?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 710
/// user_id : 360
/// vehicle_id : 66
/// driver_id : 242
/// status : "accepted"
/// request_type : null
/// pickup_latitude : "37.502755"
/// pickup_longitude : "-122.0160033"
/// drop_latitude : "37.57463198412962"
/// drop_longitude : "-121.91440109163524"
/// category_id : "2"
/// from : null
/// to : null
/// dest_addr : "Alameda County,Sunol"
/// pickup_addr : "Alameda County,Newark"
/// driver : {"id":242,"first_name":"fadi","last_name":"alayyas","phone":"956320147","profile_image":"https://diamond-line.com.sy/uploads/c93ad207-6573-4776-afbf-bdcf4951241e.jpg"}
/// vehicle : {"id":66,"color":"Black","car_model":"Sedan","vehicle_image":"https://diamond-line.com.sy/uploads/e33b9109-4cdb-4787-ba17-6692c98eacb7.jpeg","device_number":712}

class OutsideTrips {
  OutsideTrips({
      int? id, 
      int? userId, 
      int? vehicleId, 
      int? driverId, 
      String? status, 
      dynamic requestType, 
      String? pickupLatitude, 
      String? pickupLongitude, 
      String? dropLatitude, 
      String? dropLongitude, 
      String? categoryId, 
      dynamic from, 
      dynamic to, 
      String? destAddr, 
      String? pickupAddr, 
      Driver? driver, 
      Vehicle? vehicle,}){
    _id = id;
    _userId = userId;
    _vehicleId = vehicleId;
    _driverId = driverId;
    _status = status;
    _requestType = requestType;
    _pickupLatitude = pickupLatitude;
    _pickupLongitude = pickupLongitude;
    _dropLatitude = dropLatitude;
    _dropLongitude = dropLongitude;
    _categoryId = categoryId;
    _from = from;
    _to = to;
    _destAddr = destAddr;
    _pickupAddr = pickupAddr;
    _driver = driver;
    _vehicle = vehicle;
}

  OutsideTrips.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _vehicleId = json['vehicle_id'];
    _driverId = json['driver_id'];
    _status = json['status'];
    _requestType = json['request_type'];
    _pickupLatitude = json['pickup_latitude'];
    _pickupLongitude = json['pickup_longitude'];
    _dropLatitude = json['drop_latitude'];
    _dropLongitude = json['drop_longitude'];
    _categoryId = json['category_id'];
    _from = json['from'];
    _to = json['to'];
    _destAddr = json['dest_addr'];
    _pickupAddr = json['pickup_addr'];
    _driver = json['driver'] != null ? Driver.fromJson(json['driver']) : null;
    _vehicle = json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
  }
  int? _id;
  int? _userId;
  int? _vehicleId;
  int? _driverId;
  String? _status;
  dynamic _requestType;
  String? _pickupLatitude;
  String? _pickupLongitude;
  String? _dropLatitude;
  String? _dropLongitude;
  String? _categoryId;
  dynamic _from;
  dynamic _to;
  String? _destAddr;
  String? _pickupAddr;
  Driver? _driver;
  Vehicle? _vehicle;
OutsideTrips copyWith({  int? id,
  int? userId,
  int? vehicleId,
  int? driverId,
  String? status,
  dynamic requestType,
  String? pickupLatitude,
  String? pickupLongitude,
  String? dropLatitude,
  String? dropLongitude,
  String? categoryId,
  dynamic from,
  dynamic to,
  String? destAddr,
  String? pickupAddr,
  Driver? driver,
  Vehicle? vehicle,
}) => OutsideTrips(  id: id ?? _id,
  userId: userId ?? _userId,
  vehicleId: vehicleId ?? _vehicleId,
  driverId: driverId ?? _driverId,
  status: status ?? _status,
  requestType: requestType ?? _requestType,
  pickupLatitude: pickupLatitude ?? _pickupLatitude,
  pickupLongitude: pickupLongitude ?? _pickupLongitude,
  dropLatitude: dropLatitude ?? _dropLatitude,
  dropLongitude: dropLongitude ?? _dropLongitude,
  categoryId: categoryId ?? _categoryId,
  from: from ?? _from,
  to: to ?? _to,
  destAddr: destAddr ?? _destAddr,
  pickupAddr: pickupAddr ?? _pickupAddr,
  driver: driver ?? _driver,
  vehicle: vehicle ?? _vehicle,
);
  int? get id => _id;
  int? get userId => _userId;
  int? get vehicleId => _vehicleId;
  int? get driverId => _driverId;
  String? get status => _status;
  dynamic get requestType => _requestType;
  String? get pickupLatitude => _pickupLatitude;
  String? get pickupLongitude => _pickupLongitude;
  String? get dropLatitude => _dropLatitude;
  String? get dropLongitude => _dropLongitude;
  String? get categoryId => _categoryId;
  dynamic get from => _from;
  dynamic get to => _to;
  String? get destAddr => _destAddr;
  String? get pickupAddr => _pickupAddr;
  Driver? get driver => _driver;
  Vehicle? get vehicle => _vehicle;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['vehicle_id'] = _vehicleId;
    map['driver_id'] = _driverId;
    map['status'] = _status;
    map['request_type'] = _requestType;
    map['pickup_latitude'] = _pickupLatitude;
    map['pickup_longitude'] = _pickupLongitude;
    map['drop_latitude'] = _dropLatitude;
    map['drop_longitude'] = _dropLongitude;
    map['category_id'] = _categoryId;
    map['from'] = _from;
    map['to'] = _to;
    map['dest_addr'] = _destAddr;
    map['pickup_addr'] = _pickupAddr;
    if (_driver != null) {
      map['driver'] = _driver?.toJson();
    }
    if (_vehicle != null) {
      map['vehicle'] = _vehicle?.toJson();
    }
    return map;
  }

}

/// id : 66
/// color : "Black"
/// car_model : "Sedan"
/// vehicle_image : "https://diamond-line.com.sy/uploads/e33b9109-4cdb-4787-ba17-6692c98eacb7.jpeg"
/// device_number : 712

class Vehicle {
  Vehicle({
      int? id, 
      String? color, 
      String? carModel, 
      String? vehicleImage, 
      int? deviceNumber,}){
    _id = id;
    _color = color;
    _carModel = carModel;
    _vehicleImage = vehicleImage;
    _deviceNumber = deviceNumber;
}

  Vehicle.fromJson(dynamic json) {
    _id = json['id'];
    _color = json['color'];
    _carModel = json['car_model'];
    _vehicleImage = json['vehicle_image'];
    _deviceNumber = json['device_number'];
  }
  int? _id;
  String? _color;
  String? _carModel;
  String? _vehicleImage;
  int? _deviceNumber;
Vehicle copyWith({  int? id,
  String? color,
  String? carModel,
  String? vehicleImage,
  int? deviceNumber,
}) => Vehicle(  id: id ?? _id,
  color: color ?? _color,
  carModel: carModel ?? _carModel,
  vehicleImage: vehicleImage ?? _vehicleImage,
  deviceNumber: deviceNumber ?? _deviceNumber,
);
  int? get id => _id;
  String? get color => _color;
  String? get carModel => _carModel;
  String? get vehicleImage => _vehicleImage;
  int? get deviceNumber => _deviceNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['color'] = _color;
    map['car_model'] = _carModel;
    map['vehicle_image'] = _vehicleImage;
    map['device_number'] = _deviceNumber;
    return map;
  }

}

/// id : 242
/// first_name : "fadi"
/// last_name : "alayyas"
/// phone : "956320147"
/// profile_image : "https://diamond-line.com.sy/uploads/c93ad207-6573-4776-afbf-bdcf4951241e.jpg"

class Driver {
  Driver({
      int? id, 
      String? firstName, 
      String? lastName, 
      String? phone, 
      String? profileImage,}){
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _phone = phone;
    _profileImage = profileImage;
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
Driver copyWith({  int? id,
  String? firstName,
  String? lastName,
  String? phone,
  String? profileImage,
}) => Driver(  id: id ?? _id,
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

}

/// id : 707
/// user_id : 360
/// vehicle_id : 66
/// driver_id : 242
/// status : "pending"
/// request_type : "delayed"
/// pickup_latitude : "37.502755"
/// pickup_longitude : "-122.0160033"
/// drop_latitude : "37.676884112868436"
/// drop_longitude : "-122.10664808750153"
/// category_id : "1"
/// from : null
/// to : null
/// dest_addr : "Hayward,Blossom Court"
/// pickup_addr : "Alameda County,Newark"
/// driver : {"id":242,"first_name":"fadi","last_name":"alayyas","phone":"956320147","profile_image":"https://diamond-line.com.sy/uploads/c93ad207-6573-4776-afbf-bdcf4951241e.jpg"}
/// vehicle : {"id":66,"color":"Black","car_model":"Sedan","vehicle_image":"https://diamond-line.com.sy/uploads/e33b9109-4cdb-4787-ba17-6692c98eacb7.jpeg","device_number":712}

class InsidTrips {
  InsidTrips({
      int? id, 
      int? userId, 
      int? vehicleId, 
      int? driverId, 
      String? status, 
      String? requestType, 
      String? pickupLatitude, 
      String? pickupLongitude, 
      String? dropLatitude, 
      String? dropLongitude, 
      String? categoryId, 
      dynamic from, 
      dynamic to, 
      String? destAddr, 
      String? pickupAddr, 
      Driver? driver, 
      Vehicle? vehicle,}){
    _id = id;
    _userId = userId;
    _vehicleId = vehicleId;
    _driverId = driverId;
    _status = status;
    _requestType = requestType;
    _pickupLatitude = pickupLatitude;
    _pickupLongitude = pickupLongitude;
    _dropLatitude = dropLatitude;
    _dropLongitude = dropLongitude;
    _categoryId = categoryId;
    _from = from;
    _to = to;
    _destAddr = destAddr;
    _pickupAddr = pickupAddr;
    _driver = driver;
    _vehicle = vehicle;
}

  InsidTrips.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _vehicleId = json['vehicle_id'];
    _driverId = json['driver_id'];
    _status = json['status'];
    _requestType = json['request_type'];
    _pickupLatitude = json['pickup_latitude'];
    _pickupLongitude = json['pickup_longitude'];
    _dropLatitude = json['drop_latitude'];
    _dropLongitude = json['drop_longitude'];
    _categoryId = json['category_id'];
    _from = json['from'];
    _to = json['to'];
    _destAddr = json['dest_addr'];
    _pickupAddr = json['pickup_addr'];
    _driver = json['driver'] != null ? Driver.fromJson(json['driver']) : null;
    _vehicle = json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
  }
  int? _id;
  int? _userId;
  int? _vehicleId;
  int? _driverId;
  String? _status;
  String? _requestType;
  String? _pickupLatitude;
  String? _pickupLongitude;
  String? _dropLatitude;
  String? _dropLongitude;
  String? _categoryId;
  dynamic _from;
  dynamic _to;
  String? _destAddr;
  String? _pickupAddr;
  Driver? _driver;
  Vehicle? _vehicle;
InsidTrips copyWith({  int? id,
  int? userId,
  int? vehicleId,
  int? driverId,
  String? status,
  String? requestType,
  String? pickupLatitude,
  String? pickupLongitude,
  String? dropLatitude,
  String? dropLongitude,
  String? categoryId,
  dynamic from,
  dynamic to,
  String? destAddr,
  String? pickupAddr,
  Driver? driver,
  Vehicle? vehicle,
}) => InsidTrips(  id: id ?? _id,
  userId: userId ?? _userId,
  vehicleId: vehicleId ?? _vehicleId,
  driverId: driverId ?? _driverId,
  status: status ?? _status,
  requestType: requestType ?? _requestType,
  pickupLatitude: pickupLatitude ?? _pickupLatitude,
  pickupLongitude: pickupLongitude ?? _pickupLongitude,
  dropLatitude: dropLatitude ?? _dropLatitude,
  dropLongitude: dropLongitude ?? _dropLongitude,
  categoryId: categoryId ?? _categoryId,
  from: from ?? _from,
  to: to ?? _to,
  destAddr: destAddr ?? _destAddr,
  pickupAddr: pickupAddr ?? _pickupAddr,
  driver: driver ?? _driver,
  vehicle: vehicle ?? _vehicle,
);
  int? get id => _id;
  int? get userId => _userId;
  int? get vehicleId => _vehicleId;
  int? get driverId => _driverId;
  String? get status => _status;
  String? get requestType => _requestType;
  String? get pickupLatitude => _pickupLatitude;
  String? get pickupLongitude => _pickupLongitude;
  String? get dropLatitude => _dropLatitude;
  String? get dropLongitude => _dropLongitude;
  String? get categoryId => _categoryId;
  dynamic get from => _from;
  dynamic get to => _to;
  String? get destAddr => _destAddr;
  String? get pickupAddr => _pickupAddr;
  Driver? get driver => _driver;
  Vehicle? get vehicle => _vehicle;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['vehicle_id'] = _vehicleId;
    map['driver_id'] = _driverId;
    map['status'] = _status;
    map['request_type'] = _requestType;
    map['pickup_latitude'] = _pickupLatitude;
    map['pickup_longitude'] = _pickupLongitude;
    map['drop_latitude'] = _dropLatitude;
    map['drop_longitude'] = _dropLongitude;
    map['category_id'] = _categoryId;
    map['from'] = _from;
    map['to'] = _to;
    map['dest_addr'] = _destAddr;
    map['pickup_addr'] = _pickupAddr;
    if (_driver != null) {
      map['driver'] = _driver?.toJson();
    }
    if (_vehicle != null) {
      map['vehicle'] = _vehicle?.toJson();
    }
    return map;
  }

}

// /// id : 66
// /// color : "Black"
// /// car_model : "Sedan"
// /// vehicle_image : "https://diamond-line.com.sy/uploads/e33b9109-4cdb-4787-ba17-6692c98eacb7.jpeg"
// /// device_number : 712
//
// class Vehicle {
//   Vehicle({
//       int? id,
//       String? color,
//       String? carModel,
//       String? vehicleImage,
//       int? deviceNumber,}){
//     _id = id;
//     _color = color;
//     _carModel = carModel;
//     _vehicleImage = vehicleImage;
//     _deviceNumber = deviceNumber;
// }
//
//   Vehicle.fromJson(dynamic json) {
//     _id = json['id'];
//     _color = json['color'];
//     _carModel = json['car_model'];
//     _vehicleImage = json['vehicle_image'];
//     _deviceNumber = json['device_number'];
//   }
//   int? _id;
//   String? _color;
//   String? _carModel;
//   String? _vehicleImage;
//   int? _deviceNumber;
// Vehicle copyWith({  int? id,
//   String? color,
//   String? carModel,
//   String? vehicleImage,
//   int? deviceNumber,
// }) => Vehicle(  id: id ?? _id,
//   color: color ?? _color,
//   carModel: carModel ?? _carModel,
//   vehicleImage: vehicleImage ?? _vehicleImage,
//   deviceNumber: deviceNumber ?? _deviceNumber,
// );
//   int? get id => _id;
//   String? get color => _color;
//   String? get carModel => _carModel;
//   String? get vehicleImage => _vehicleImage;
//   int? get deviceNumber => _deviceNumber;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['color'] = _color;
//     map['car_model'] = _carModel;
//     map['vehicle_image'] = _vehicleImage;
//     map['device_number'] = _deviceNumber;
//     return map;
//   }
//
// }
//
// /// id : 242
// /// first_name : "fadi"
// /// last_name : "alayyas"
// /// phone : "956320147"
// /// profile_image : "https://diamond-line.com.sy/uploads/c93ad207-6573-4776-afbf-bdcf4951241e.jpg"
//
// class Driver {
//   Driver({
//       int? id,
//       String? firstName,
//       String? lastName,
//       String? phone,
//       String? profileImage,}){
//     _id = id;
//     _firstName = firstName;
//     _lastName = lastName;
//     _phone = phone;
//     _profileImage = profileImage;
// }
//
//   Driver.fromJson(dynamic json) {
//     _id = json['id'];
//     _firstName = json['first_name'];
//     _lastName = json['last_name'];
//     _phone = json['phone'];
//     _profileImage = json['profile_image'];
//   }
//   int? _id;
//   String? _firstName;
//   String? _lastName;
//   String? _phone;
//   String? _profileImage;
// Driver copyWith({  int? id,
//   String? firstName,
//   String? lastName,
//   String? phone,
//   String? profileImage,
// }) => Driver(  id: id ?? _id,
//   firstName: firstName ?? _firstName,
//   lastName: lastName ?? _lastName,
//   phone: phone ?? _phone,
//   profileImage: profileImage ?? _profileImage,
// );
//   int? get id => _id;
//   String? get firstName => _firstName;
//   String? get lastName => _lastName;
//   String? get phone => _phone;
//   String? get profileImage => _profileImage;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['first_name'] = _firstName;
//     map['last_name'] = _lastName;
//     map['phone'] = _phone;
//     map['profile_image'] = _profileImage;
//     return map;
//   }
//
// }