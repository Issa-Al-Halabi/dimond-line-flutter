/// error : false
/// message : "Listed Successfully"
/// data : {"trips_outcity":[{"id":168,"customer_id":null,"user_id":246,"vehicle_id":65,"type_id":null,"option_id":null,"driver_id":242,"category_id":"2","request_type":null,"subcategory_id":"18","from":null,"to":null,"direction":null,"date":"2023-01-17","bags":1,"time":"18:30 pm","pickup":null,"dropoff":null,"duration":null,"pickup_addr":null,"dest_addr":null,"note":null,"travellers":1,"status":"started","payment":0,"pickup_latitude":"33.5138073","pickup_longitude":"36.2765279","drop_latitude":"36.2021047","drop_longitude":"37.1342603","km":"0.0","minutes":"250.23333333333332","cost":103740,"start_time":"13:12:22","end_time":"13:36:23","created_at":"2023-01-17 16:50:05","order_time":null,"updated_at":"2023-02-05 12:19:49","deleted_at":"2023-02-05 12:19:49","first_name":"Isabella","last_name":"Britt","phone":"968531420"},{"id":167,"customer_id":null,"user_id":246,"vehicle_id":65,"type_id":null,"option_id":null,"driver_id":242,"category_id":"2","request_type":null,"subcategory_id":"19","from":null,"to":null,"direction":"round trip","date":"2022-07-15","bags":3,"time":"4:15:00 am","pickup":null,"dropoff":null,"duration":null,"pickup_addr":null,"dest_addr":null,"note":null,"travellers":2,"status":"accepted","payment":0,"pickup_latitude":"12.15","pickup_longitude":"264.5","drop_latitude":"598.2","drop_longitude":"10","km":"9","minutes":"0","cost":712500,"start_time":"06:30:00","end_time":"18:00:00","created_at":"2023-01-17 15:53:10","order_time":null,"updated_at":"2023-06-15 10:49:00","deleted_at":null,"first_name":"Isabella","last_name":"Britt","phone":"968531420"}],"trip_inside":[{"id":169,"customer_id":null,"user_id":246,"vehicle_id":null,"type_id":13,"option_id":null,"driver_id":242,"category_id":"1","request_type":"moment","subcategory_id":"","from":null,"to":null,"direction":null,"date":"0000-00-00","bags":0,"time":"","pickup":null,"dropoff":null,"duration":null,"pickup_addr":"باب توما","dest_addr":"دمشق","note":null,"travellers":1,"status":"accepted","payment":0,"pickup_latitude":"33.50142151266264","pickup_longitude":"36.32597210216678","drop_latitude":"","drop_longitude":"","km":"26.734238146181962","minutes":"0","cost":10000,"start_time":"10:56:16","end_time":"10:59:49","created_at":"2023-01-18 09:37:39","order_time":null,"updated_at":"2023-03-27 07:59:50","deleted_at":null,"first_name":"Isabella","last_name":"Britt","phone":"968531420"}]}

class DriverEfficientTripsModel {
  DriverEfficientTripsModel({
    bool? error,
    String? message,
    Data? data,
  }) {
    _error = error;
    _message = message;
    _data = data;
  }

  DriverEfficientTripsModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _error;
  String? _message;
  Data? _data;
  DriverEfficientTripsModel copyWith({
    bool? error,
    String? message,
    Data? data,
  }) =>
      DriverEfficientTripsModel(
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

/// trips_outcity : [{"id":168,"customer_id":null,"user_id":246,"vehicle_id":65,"type_id":null,"option_id":null,"driver_id":242,"category_id":"2","request_type":null,"subcategory_id":"18","from":null,"to":null,"direction":null,"date":"2023-01-17","bags":1,"time":"18:30 pm","pickup":null,"dropoff":null,"duration":null,"pickup_addr":null,"dest_addr":null,"note":null,"travellers":1,"status":"started","payment":0,"pickup_latitude":"33.5138073","pickup_longitude":"36.2765279","drop_latitude":"36.2021047","drop_longitude":"37.1342603","km":"0.0","minutes":"250.23333333333332","cost":103740,"start_time":"13:12:22","end_time":"13:36:23","created_at":"2023-01-17 16:50:05","order_time":null,"updated_at":"2023-02-05 12:19:49","deleted_at":"2023-02-05 12:19:49","first_name":"Isabella","last_name":"Britt","phone":"968531420"},{"id":167,"customer_id":null,"user_id":246,"vehicle_id":65,"type_id":null,"option_id":null,"driver_id":242,"category_id":"2","request_type":null,"subcategory_id":"19","from":null,"to":null,"direction":"round trip","date":"2022-07-15","bags":3,"time":"4:15:00 am","pickup":null,"dropoff":null,"duration":null,"pickup_addr":null,"dest_addr":null,"note":null,"travellers":2,"status":"accepted","payment":0,"pickup_latitude":"12.15","pickup_longitude":"264.5","drop_latitude":"598.2","drop_longitude":"10","km":"9","minutes":"0","cost":712500,"start_time":"06:30:00","end_time":"18:00:00","created_at":"2023-01-17 15:53:10","order_time":null,"updated_at":"2023-06-15 10:49:00","deleted_at":null,"first_name":"Isabella","last_name":"Britt","phone":"968531420"}]
/// trip_inside : [{"id":169,"customer_id":null,"user_id":246,"vehicle_id":null,"type_id":13,"option_id":null,"driver_id":242,"category_id":"1","request_type":"moment","subcategory_id":"","from":null,"to":null,"direction":null,"date":"0000-00-00","bags":0,"time":"","pickup":null,"dropoff":null,"duration":null,"pickup_addr":"باب توما","dest_addr":"دمشق","note":null,"travellers":1,"status":"accepted","payment":0,"pickup_latitude":"33.50142151266264","pickup_longitude":"36.32597210216678","drop_latitude":"","drop_longitude":"","km":"26.734238146181962","minutes":"0","cost":10000,"start_time":"10:56:16","end_time":"10:59:49","created_at":"2023-01-18 09:37:39","order_time":null,"updated_at":"2023-03-27 07:59:50","deleted_at":null,"first_name":"Isabella","last_name":"Britt","phone":"968531420"}]

class Data {
  Data({
    List<TripsOutcity>? tripsOutcity,
    List<TripInside>? tripInside,
  }) {
    _tripsOutcity = tripsOutcity;
    _tripInside = tripInside;
  }

  Data.fromJson(dynamic json) {
    if (json['trips_outcity'] != null) {
      _tripsOutcity = [];
      json['trips_outcity'].forEach((v) {
        _tripsOutcity?.add(TripsOutcity.fromJson(v));
      });
    }
    if (json['trip_inside'] != null) {
      _tripInside = [];
      json['trip_inside'].forEach((v) {
        _tripInside?.add(TripInside.fromJson(v));
      });
    }
  }
  List<TripsOutcity>? _tripsOutcity;
  List<TripInside>? _tripInside;
  Data copyWith({
    List<TripsOutcity>? tripsOutcity,
    List<TripInside>? tripInside,
  }) =>
      Data(
        tripsOutcity: tripsOutcity ?? _tripsOutcity,
        tripInside: tripInside ?? _tripInside,
      );
  List<TripsOutcity>? get tripsOutcity => _tripsOutcity;
  List<TripInside>? get tripInside => _tripInside;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_tripsOutcity != null) {
      map['trips_outcity'] = _tripsOutcity?.map((v) => v.toJson()).toList();
    }
    if (_tripInside != null) {
      map['trip_inside'] = _tripInside?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 169
/// customer_id : null
/// user_id : 246
/// vehicle_id : null
/// type_id : 13
/// option_id : null
/// driver_id : 242
/// category_id : "1"
/// request_type : "moment"
/// subcategory_id : ""
/// from : null
/// to : null
/// direction : null
/// date : "0000-00-00"
/// bags : 0
/// time : ""
/// pickup : null
/// dropoff : null
/// duration : null
/// pickup_addr : "باب توما"
/// dest_addr : "دمشق"
/// note : null
/// travellers : 1
/// status : "accepted"
/// payment : 0
/// pickup_latitude : "33.50142151266264"
/// pickup_longitude : "36.32597210216678"
/// drop_latitude : ""
/// drop_longitude : ""
/// km : "26.734238146181962"
/// minutes : "0"
/// cost : 10000
/// start_time : "10:56:16"
/// end_time : "10:59:49"
/// created_at : "2023-01-18 09:37:39"
/// order_time : null
/// updated_at : "2023-03-27 07:59:50"
/// deleted_at : null
/// first_name : "Isabella"
/// last_name : "Britt"
/// phone : "968531420"

class TripInside {
  TripInside({
    int? id,
    dynamic customerId,
    int? userId,
    dynamic vehicleId,
    int? typeId,
    dynamic optionId,
    int? driverId,
    String? categoryId,
    String? requestType,
    String? subcategoryId,
    dynamic from,
    dynamic to,
    dynamic direction,
    String? date,
    int? bags,
    String? time,
    dynamic pickup,
    dynamic dropoff,
    dynamic duration,
    String? pickupAddr,
    String? destAddr,
    dynamic note,
    int? travellers,
    String? status,
    int? payment,
    String? pickupLatitude,
    String? pickupLongitude,
    String? dropLatitude,
    String? dropLongitude,
    String? km,
    String? minutes,
    int? cost,
    String? startTime,
    String? endTime,
    String? createdAt,
    dynamic orderTime,
    String? updatedAt,
    dynamic deletedAt,
    String? firstName,
    String? lastName,
    String? phone,
  }) {
    _id = id;
    _customerId = customerId;
    _userId = userId;
    _vehicleId = vehicleId;
    _typeId = typeId;
    _optionId = optionId;
    _driverId = driverId;
    _categoryId = categoryId;
    _requestType = requestType;
    _subcategoryId = subcategoryId;
    _from = from;
    _to = to;
    _direction = direction;
    _date = date;
    _bags = bags;
    _time = time;
    _pickup = pickup;
    _dropoff = dropoff;
    _duration = duration;
    _pickupAddr = pickupAddr;
    _destAddr = destAddr;
    _note = note;
    _travellers = travellers;
    _status = status;
    _payment = payment;
    _pickupLatitude = pickupLatitude;
    _pickupLongitude = pickupLongitude;
    _dropLatitude = dropLatitude;
    _dropLongitude = dropLongitude;
    _km = km;
    _minutes = minutes;
    _cost = cost;
    _startTime = startTime;
    _endTime = endTime;
    _createdAt = createdAt;
    _orderTime = orderTime;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
    _firstName = firstName;
    _lastName = lastName;
    _phone = phone;
  }

  TripInside.fromJson(dynamic json) {
    _id = json['id'];
    _customerId = json['customer_id'];
    _userId = json['user_id'];
    _vehicleId = json['vehicle_id'];
    _typeId = json['type_id'];
    _optionId = json['option_id'];
    _driverId = json['driver_id'];
    _categoryId = json['category_id'];
    _requestType = json['request_type'];
    _subcategoryId = json['subcategory_id'];
    _from = json['from'];
    _to = json['to'];
    _direction = json['direction'];
    _date = json['date'];
    _bags = json['bags'];
    _time = json['time'];
    _pickup = json['pickup'];
    _dropoff = json['dropoff'];
    _duration = json['duration'];
    _pickupAddr = json['pickup_addr'];
    _destAddr = json['dest_addr'];
    _note = json['note'];
    _travellers = json['travellers'];
    _status = json['status'];
    _payment = json['payment'];
    _pickupLatitude = json['pickup_latitude'];
    _pickupLongitude = json['pickup_longitude'];
    _dropLatitude = json['drop_latitude'];
    _dropLongitude = json['drop_longitude'];
    _km = json['km'];
    _minutes = json['minutes'];
    _cost = json['cost'];
    _startTime = json['start_time'];
    _endTime = json['end_time'];
    _createdAt = json['created_at'];
    _orderTime = json['order_time'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _phone = json['phone'];
  }
  int? _id;
  dynamic _customerId;
  int? _userId;
  dynamic _vehicleId;
  int? _typeId;
  dynamic _optionId;
  int? _driverId;
  String? _categoryId;
  String? _requestType;
  String? _subcategoryId;
  dynamic _from;
  dynamic _to;
  dynamic _direction;
  String? _date;
  int? _bags;
  String? _time;
  dynamic _pickup;
  dynamic _dropoff;
  dynamic _duration;
  String? _pickupAddr;
  String? _destAddr;
  dynamic _note;
  int? _travellers;
  String? _status;
  int? _payment;
  String? _pickupLatitude;
  String? _pickupLongitude;
  String? _dropLatitude;
  String? _dropLongitude;
  String? _km;
  String? _minutes;
  int? _cost;
  String? _startTime;
  String? _endTime;
  String? _createdAt;
  dynamic _orderTime;
  String? _updatedAt;
  dynamic _deletedAt;
  String? _firstName;
  String? _lastName;
  String? _phone;
  TripInside copyWith({
    int? id,
    dynamic customerId,
    int? userId,
    dynamic vehicleId,
    int? typeId,
    dynamic optionId,
    int? driverId,
    String? categoryId,
    String? requestType,
    String? subcategoryId,
    dynamic from,
    dynamic to,
    dynamic direction,
    String? date,
    int? bags,
    String? time,
    dynamic pickup,
    dynamic dropoff,
    dynamic duration,
    String? pickupAddr,
    String? destAddr,
    dynamic note,
    int? travellers,
    String? status,
    int? payment,
    String? pickupLatitude,
    String? pickupLongitude,
    String? dropLatitude,
    String? dropLongitude,
    String? km,
    String? minutes,
    int? cost,
    String? startTime,
    String? endTime,
    String? createdAt,
    dynamic orderTime,
    String? updatedAt,
    dynamic deletedAt,
    String? firstName,
    String? lastName,
    String? phone,
  }) =>
      TripInside(
        id: id ?? _id,
        customerId: customerId ?? _customerId,
        userId: userId ?? _userId,
        vehicleId: vehicleId ?? _vehicleId,
        typeId: typeId ?? _typeId,
        optionId: optionId ?? _optionId,
        driverId: driverId ?? _driverId,
        categoryId: categoryId ?? _categoryId,
        requestType: requestType ?? _requestType,
        subcategoryId: subcategoryId ?? _subcategoryId,
        from: from ?? _from,
        to: to ?? _to,
        direction: direction ?? _direction,
        date: date ?? _date,
        bags: bags ?? _bags,
        time: time ?? _time,
        pickup: pickup ?? _pickup,
        dropoff: dropoff ?? _dropoff,
        duration: duration ?? _duration,
        pickupAddr: pickupAddr ?? _pickupAddr,
        destAddr: destAddr ?? _destAddr,
        note: note ?? _note,
        travellers: travellers ?? _travellers,
        status: status ?? _status,
        payment: payment ?? _payment,
        pickupLatitude: pickupLatitude ?? _pickupLatitude,
        pickupLongitude: pickupLongitude ?? _pickupLongitude,
        dropLatitude: dropLatitude ?? _dropLatitude,
        dropLongitude: dropLongitude ?? _dropLongitude,
        km: km ?? _km,
        minutes: minutes ?? _minutes,
        cost: cost ?? _cost,
        startTime: startTime ?? _startTime,
        endTime: endTime ?? _endTime,
        createdAt: createdAt ?? _createdAt,
        orderTime: orderTime ?? _orderTime,
        updatedAt: updatedAt ?? _updatedAt,
        deletedAt: deletedAt ?? _deletedAt,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        phone: phone ?? _phone,
      );
  int? get id => _id;
  dynamic get customerId => _customerId;
  int? get userId => _userId;
  dynamic get vehicleId => _vehicleId;
  int? get typeId => _typeId;
  dynamic get optionId => _optionId;
  int? get driverId => _driverId;
  String? get categoryId => _categoryId;
  String? get requestType => _requestType;
  String? get subcategoryId => _subcategoryId;
  dynamic get from => _from;
  dynamic get to => _to;
  dynamic get direction => _direction;
  String? get date => _date;
  int? get bags => _bags;
  String? get time => _time;
  dynamic get pickup => _pickup;
  dynamic get dropoff => _dropoff;
  dynamic get duration => _duration;
  String? get pickupAddr => _pickupAddr;
  String? get destAddr => _destAddr;
  dynamic get note => _note;
  int? get travellers => _travellers;
  String? get status => _status;
  int? get payment => _payment;
  String? get pickupLatitude => _pickupLatitude;
  String? get pickupLongitude => _pickupLongitude;
  String? get dropLatitude => _dropLatitude;
  String? get dropLongitude => _dropLongitude;
  String? get km => _km;
  String? get minutes => _minutes;
  int? get cost => _cost;
  String? get startTime => _startTime;
  String? get endTime => _endTime;
  String? get createdAt => _createdAt;
  dynamic get orderTime => _orderTime;
  String? get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get phone => _phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['customer_id'] = _customerId;
    map['user_id'] = _userId;
    map['vehicle_id'] = _vehicleId;
    map['type_id'] = _typeId;
    map['option_id'] = _optionId;
    map['driver_id'] = _driverId;
    map['category_id'] = _categoryId;
    map['request_type'] = _requestType;
    map['subcategory_id'] = _subcategoryId;
    map['from'] = _from;
    map['to'] = _to;
    map['direction'] = _direction;
    map['date'] = _date;
    map['bags'] = _bags;
    map['time'] = _time;
    map['pickup'] = _pickup;
    map['dropoff'] = _dropoff;
    map['duration'] = _duration;
    map['pickup_addr'] = _pickupAddr;
    map['dest_addr'] = _destAddr;
    map['note'] = _note;
    map['travellers'] = _travellers;
    map['status'] = _status;
    map['payment'] = _payment;
    map['pickup_latitude'] = _pickupLatitude;
    map['pickup_longitude'] = _pickupLongitude;
    map['drop_latitude'] = _dropLatitude;
    map['drop_longitude'] = _dropLongitude;
    map['km'] = _km;
    map['minutes'] = _minutes;
    map['cost'] = _cost;
    map['start_time'] = _startTime;
    map['end_time'] = _endTime;
    map['created_at'] = _createdAt;
    map['order_time'] = _orderTime;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['phone'] = _phone;
    return map;
  }
}

/// id : 168
/// customer_id : null
/// user_id : 246
/// vehicle_id : 65
/// type_id : null
/// option_id : null
/// driver_id : 242
/// category_id : "2"
/// request_type : null
/// subcategory_id : "18"
/// from : null
/// to : null
/// direction : null
/// date : "2023-01-17"
/// bags : 1
/// time : "18:30 pm"
/// pickup : null
/// dropoff : null
/// duration : null
/// pickup_addr : null
/// dest_addr : null
/// note : null
/// travellers : 1
/// status : "started"
/// payment : 0
/// pickup_latitude : "33.5138073"
/// pickup_longitude : "36.2765279"
/// drop_latitude : "36.2021047"
/// drop_longitude : "37.1342603"
/// km : "0.0"
/// minutes : "250.23333333333332"
/// cost : 103740
/// start_time : "13:12:22"
/// end_time : "13:36:23"
/// created_at : "2023-01-17 16:50:05"
/// order_time : null
/// updated_at : "2023-02-05 12:19:49"
/// deleted_at : "2023-02-05 12:19:49"
/// first_name : "Isabella"
/// last_name : "Britt"
/// phone : "968531420"

class TripsOutcity {
  TripsOutcity({
    int? id,
    dynamic customerId,
    int? userId,
    int? vehicleId,
    dynamic typeId,
    dynamic optionId,
    int? driverId,
    String? categoryId,
    dynamic requestType,
    String? subcategoryId,
    dynamic from,
    dynamic to,
    dynamic direction,
    String? date,
    int? bags,
    String? time,
    dynamic pickup,
    dynamic dropoff,
    dynamic duration,
    dynamic pickupAddr,
    dynamic destAddr,
    dynamic note,
    int? travellers,
    String? status,
    int? payment,
    String? pickupLatitude,
    String? pickupLongitude,
    String? dropLatitude,
    String? dropLongitude,
    String? km,
    String? minutes,
    int? cost,
    String? startTime,
    String? endTime,
    String? createdAt,
    dynamic orderTime,
    String? updatedAt,
    String? deletedAt,
    String? firstName,
    String? lastName,
    String? phone,
  }) {
    _id = id;
    _customerId = customerId;
    _userId = userId;
    _vehicleId = vehicleId;
    _typeId = typeId;
    _optionId = optionId;
    _driverId = driverId;
    _categoryId = categoryId;
    _requestType = requestType;
    _subcategoryId = subcategoryId;
    _from = from;
    _to = to;
    _direction = direction;
    _date = date;
    _bags = bags;
    _time = time;
    _pickup = pickup;
    _dropoff = dropoff;
    _duration = duration;
    _pickupAddr = pickupAddr;
    _destAddr = destAddr;
    _note = note;
    _travellers = travellers;
    _status = status;
    _payment = payment;
    _pickupLatitude = pickupLatitude;
    _pickupLongitude = pickupLongitude;
    _dropLatitude = dropLatitude;
    _dropLongitude = dropLongitude;
    _km = km;
    _minutes = minutes;
    _cost = cost;
    _startTime = startTime;
    _endTime = endTime;
    _createdAt = createdAt;
    _orderTime = orderTime;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
    _firstName = firstName;
    _lastName = lastName;
    _phone = phone;
  }

  TripsOutcity.fromJson(dynamic json) {
    _id = json['id'];
    _customerId = json['customer_id'];
    _userId = json['user_id'];
    _vehicleId = json['vehicle_id'];
    _typeId = json['type_id'];
    _optionId = json['option_id'];
    _driverId = json['driver_id'];
    _categoryId = json['category_id'];
    _requestType = json['request_type'];
    _subcategoryId = json['subcategory_id'];
    _from = json['from'];
    _to = json['to'];
    _direction = json['direction'];
    _date = json['date'];
    _bags = json['bags'];
    _time = json['time'];
    _pickup = json['pickup'];
    _dropoff = json['dropoff'];
    _duration = json['duration'];
    _pickupAddr = json['pickup_addr'];
    _destAddr = json['dest_addr'];
    _note = json['note'];
    _travellers = json['travellers'];
    _status = json['status'];
    _payment = json['payment'];
    _pickupLatitude = json['pickup_latitude'];
    _pickupLongitude = json['pickup_longitude'];
    _dropLatitude = json['drop_latitude'];
    _dropLongitude = json['drop_longitude'];
    _km = json['km'];
    _minutes = json['minutes'];
    _cost = json['cost'];
    _startTime = json['start_time'];
    _endTime = json['end_time'];
    _createdAt = json['created_at'];
    _orderTime = json['order_time'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _phone = json['phone'];
  }
  int? _id;
  dynamic _customerId;
  int? _userId;
  int? _vehicleId;
  dynamic _typeId;
  dynamic _optionId;
  int? _driverId;
  String? _categoryId;
  dynamic _requestType;
  String? _subcategoryId;
  dynamic _from;
  dynamic _to;
  dynamic _direction;
  String? _date;
  int? _bags;
  String? _time;
  dynamic _pickup;
  dynamic _dropoff;
  dynamic _duration;
  dynamic _pickupAddr;
  dynamic _destAddr;
  dynamic _note;
  int? _travellers;
  String? _status;
  int? _payment;
  String? _pickupLatitude;
  String? _pickupLongitude;
  String? _dropLatitude;
  String? _dropLongitude;
  String? _km;
  String? _minutes;
  int? _cost;
  String? _startTime;
  String? _endTime;
  String? _createdAt;
  dynamic _orderTime;
  String? _updatedAt;
  String? _deletedAt;
  String? _firstName;
  String? _lastName;
  String? _phone;
  TripsOutcity copyWith({
    int? id,
    dynamic customerId,
    int? userId,
    int? vehicleId,
    dynamic typeId,
    dynamic optionId,
    int? driverId,
    String? categoryId,
    dynamic requestType,
    String? subcategoryId,
    dynamic from,
    dynamic to,
    dynamic direction,
    String? date,
    int? bags,
    String? time,
    dynamic pickup,
    dynamic dropoff,
    dynamic duration,
    dynamic pickupAddr,
    dynamic destAddr,
    dynamic note,
    int? travellers,
    String? status,
    int? payment,
    String? pickupLatitude,
    String? pickupLongitude,
    String? dropLatitude,
    String? dropLongitude,
    String? km,
    String? minutes,
    int? cost,
    String? startTime,
    String? endTime,
    String? createdAt,
    dynamic orderTime,
    String? updatedAt,
    String? deletedAt,
    String? firstName,
    String? lastName,
    String? phone,
  }) =>
      TripsOutcity(
        id: id ?? _id,
        customerId: customerId ?? _customerId,
        userId: userId ?? _userId,
        vehicleId: vehicleId ?? _vehicleId,
        typeId: typeId ?? _typeId,
        optionId: optionId ?? _optionId,
        driverId: driverId ?? _driverId,
        categoryId: categoryId ?? _categoryId,
        requestType: requestType ?? _requestType,
        subcategoryId: subcategoryId ?? _subcategoryId,
        from: from ?? _from,
        to: to ?? _to,
        direction: direction ?? _direction,
        date: date ?? _date,
        bags: bags ?? _bags,
        time: time ?? _time,
        pickup: pickup ?? _pickup,
        dropoff: dropoff ?? _dropoff,
        duration: duration ?? _duration,
        pickupAddr: pickupAddr ?? _pickupAddr,
        destAddr: destAddr ?? _destAddr,
        note: note ?? _note,
        travellers: travellers ?? _travellers,
        status: status ?? _status,
        payment: payment ?? _payment,
        pickupLatitude: pickupLatitude ?? _pickupLatitude,
        pickupLongitude: pickupLongitude ?? _pickupLongitude,
        dropLatitude: dropLatitude ?? _dropLatitude,
        dropLongitude: dropLongitude ?? _dropLongitude,
        km: km ?? _km,
        minutes: minutes ?? _minutes,
        cost: cost ?? _cost,
        startTime: startTime ?? _startTime,
        endTime: endTime ?? _endTime,
        createdAt: createdAt ?? _createdAt,
        orderTime: orderTime ?? _orderTime,
        updatedAt: updatedAt ?? _updatedAt,
        deletedAt: deletedAt ?? _deletedAt,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        phone: phone ?? _phone,
      );
  int? get id => _id;
  dynamic get customerId => _customerId;
  int? get userId => _userId;
  int? get vehicleId => _vehicleId;
  dynamic get typeId => _typeId;
  dynamic get optionId => _optionId;
  int? get driverId => _driverId;
  String? get categoryId => _categoryId;
  dynamic get requestType => _requestType;
  String? get subcategoryId => _subcategoryId;
  dynamic get from => _from;
  dynamic get to => _to;
  dynamic get direction => _direction;
  String? get date => _date;
  int? get bags => _bags;
  String? get time => _time;
  dynamic get pickup => _pickup;
  dynamic get dropoff => _dropoff;
  dynamic get duration => _duration;
  dynamic get pickupAddr => _pickupAddr;
  dynamic get destAddr => _destAddr;
  dynamic get note => _note;
  int? get travellers => _travellers;
  String? get status => _status;
  int? get payment => _payment;
  String? get pickupLatitude => _pickupLatitude;
  String? get pickupLongitude => _pickupLongitude;
  String? get dropLatitude => _dropLatitude;
  String? get dropLongitude => _dropLongitude;
  String? get km => _km;
  String? get minutes => _minutes;
  int? get cost => _cost;
  String? get startTime => _startTime;
  String? get endTime => _endTime;
  String? get createdAt => _createdAt;
  dynamic get orderTime => _orderTime;
  String? get updatedAt => _updatedAt;
  String? get deletedAt => _deletedAt;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get phone => _phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['customer_id'] = _customerId;
    map['user_id'] = _userId;
    map['vehicle_id'] = _vehicleId;
    map['type_id'] = _typeId;
    map['option_id'] = _optionId;
    map['driver_id'] = _driverId;
    map['category_id'] = _categoryId;
    map['request_type'] = _requestType;
    map['subcategory_id'] = _subcategoryId;
    map['from'] = _from;
    map['to'] = _to;
    map['direction'] = _direction;
    map['date'] = _date;
    map['bags'] = _bags;
    map['time'] = _time;
    map['pickup'] = _pickup;
    map['dropoff'] = _dropoff;
    map['duration'] = _duration;
    map['pickup_addr'] = _pickupAddr;
    map['dest_addr'] = _destAddr;
    map['note'] = _note;
    map['travellers'] = _travellers;
    map['status'] = _status;
    map['payment'] = _payment;
    map['pickup_latitude'] = _pickupLatitude;
    map['pickup_longitude'] = _pickupLongitude;
    map['drop_latitude'] = _dropLatitude;
    map['drop_longitude'] = _dropLongitude;
    map['km'] = _km;
    map['minutes'] = _minutes;
    map['cost'] = _cost;
    map['start_time'] = _startTime;
    map['end_time'] = _endTime;
    map['created_at'] = _createdAt;
    map['order_time'] = _orderTime;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['phone'] = _phone;
    return map;
  }
}
