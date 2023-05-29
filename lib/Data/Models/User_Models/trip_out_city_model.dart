/// error : false
/// message : "Your trip has been created"
/// data : [{"id":248,"customer_id":null,"user_id":"251","vehicle_id":"69","type_id":null,"option_id":null,"driver_id":null,"category_id":"2","request_type":null,"subcategory_id":"19","from":"Damascus","to":"Tartous","direction":"round trip","date":"2022-07-15","bags":"3","time":"4:15:00 am","pickup":null,"dropoff":null,"duration":null,"pickup_addr":null,"dest_addr":null,"note":null,"travellers":"2","status":"pending","payment":"0","pickup_latitude":"12.15","pickup_longitude":"264.5","drop_latitude":"598.2","drop_longitude":"10","km":"250","minutes":"6","cost":"632200","start_time":null,"end_time":null,"created_at":"2023-01-29T09:09:45.000000Z","updated_at":"2023-01-29T09:09:45.000000Z","deleted_at":null,"metas":[],"meta_data":[]}]

class TripOutCityModel {
  TripOutCityModel({
    bool? error,
    String? message,
    List<Data>? data,}){
    _error = error;
    _message = message;
    _data = data;
  }

  TripOutCityModel.fromJson(dynamic json) {
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
  TripOutCityModel copyWith({  bool? error,
    String? message,
    List<Data>? data,
  }) => TripOutCityModel(  error: error ?? _error,
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

/// id : 248
/// customer_id : null
/// user_id : "251"
/// vehicle_id : "69"
/// type_id : null
/// option_id : null
/// driver_id : null
/// category_id : "2"
/// request_type : null
/// subcategory_id : "19"
/// from : "Damascus"
/// to : "Tartous"
/// direction : "round trip"
/// date : "2022-07-15"
/// bags : "3"
/// time : "4:15:00 am"
/// pickup : null
/// dropoff : null
/// duration : null
/// pickup_addr : null
/// dest_addr : null
/// note : null
/// travellers : "2"
/// status : "pending"
/// payment : "0"
/// pickup_latitude : "12.15"
/// pickup_longitude : "264.5"
/// drop_latitude : "598.2"
/// drop_longitude : "10"
/// km : "250"
/// minutes : "6"
/// cost : "632200"
/// start_time : null
/// end_time : null
/// created_at : "2023-01-29T09:09:45.000000Z"
/// updated_at : "2023-01-29T09:09:45.000000Z"
/// deleted_at : null
/// metas : []
/// meta_data : []

class Data {
  Data({
    dynamic id,
    dynamic customerId,
    dynamic userId,
    dynamic vehicleId,
    dynamic typeId,
    dynamic optionId,
    dynamic driverId,
    dynamic categoryId,
    dynamic requestType,
    dynamic subcategoryId,
    String? from,
    String? to,
    String? direction,
    String? date,
    dynamic bags,
    String? time,
    dynamic pickup,
    dynamic dropoff,
    dynamic duration,
    dynamic pickupAddr,
    dynamic destAddr,
    dynamic note,
    dynamic travellers,
    dynamic status,
    dynamic payment,
    dynamic pickupLatitude,
    dynamic pickupLongitude,
    dynamic dropLatitude,
    dynamic dropLongitude,
    dynamic km,
    dynamic minutes,
    dynamic cost,
    dynamic startTime,
    dynamic endTime,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    // List<dynamic>? metas,
    // List<dynamic>? metaData,
  }){
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
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
    // _metas = metas;
    // _metaData = metaData;
  }

  Data.fromJson(dynamic json) {
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
  dynamic _id;
  dynamic _customerId;
  dynamic _userId;
  dynamic _vehicleId;
  dynamic _typeId;
  dynamic _optionId;
  dynamic _driverId;
  dynamic _categoryId;
  dynamic _requestType;
  String? _subcategoryId;
  String? _from;
  String? _to;
  String? _direction;
  String? _date;
  dynamic _bags;
  String? _time;
  dynamic _pickup;
  dynamic _dropoff;
  dynamic _duration;
  dynamic _pickupAddr;
  dynamic _destAddr;
  dynamic _note;
  dynamic _travellers;
  dynamic _status;
  dynamic _payment;
  dynamic _pickupLatitude;
  dynamic _pickupLongitude;
  dynamic _dropLatitude;
  dynamic _dropLongitude;
  dynamic _km;
  dynamic _minutes;
  dynamic _cost;
  dynamic _startTime;
  dynamic _endTime;
  String? _createdAt;
  String? _updatedAt;
  dynamic _deletedAt;
  // List<dynamic>? _metas;
  // List<dynamic>? _metaData;
  Data copyWith({
    dynamic id,
    dynamic customerId,
    dynamic userId,
    dynamic vehicleId,
    dynamic typeId,
    dynamic optionId,
    dynamic driverId,
    dynamic categoryId,
    dynamic requestType,
    dynamic subcategoryId,
    String? from,
    String? to,
    String? direction,
    String? date,
    dynamic bags,
    String? time,
    dynamic pickup,
    dynamic dropoff,
    dynamic duration,
    dynamic pickupAddr,
    dynamic destAddr,
    dynamic note,
    dynamic travellers,
    dynamic status,
    dynamic payment,
    dynamic pickupLatitude,
    dynamic pickupLongitude,
    dynamic dropLatitude,
    dynamic dropLongitude,
    dynamic km,
    dynamic minutes,
    dynamic cost,
    dynamic startTime,
    dynamic endTime,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    // List<dynamic>? metas,
    // List<dynamic>? metaData,
  }) => Data(  id: id ?? _id,
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
    updatedAt: updatedAt ?? _updatedAt,
    deletedAt: deletedAt ?? _deletedAt,
    // metas: metas ?? _metas,
    // metaData: metaData ?? _metaData,
  );
  dynamic get id => _id;
  dynamic get customerId => _customerId;
  dynamic get userId => _userId;
  dynamic get vehicleId => _vehicleId;
  dynamic get typeId => _typeId;
  dynamic get optionId => _optionId;
  dynamic get driverId => _driverId;
  dynamic get categoryId => _categoryId;
  dynamic get requestType => _requestType;
  dynamic get subcategoryId => _subcategoryId;
  String? get from => _from;
  String? get to => _to;
  String? get direction => _direction;
  String? get date => _date;
  dynamic get bags => _bags;
  String? get time => _time;
  dynamic get pickup => _pickup;
  dynamic get dropoff => _dropoff;
  dynamic get duration => _duration;
  dynamic get pickupAddr => _pickupAddr;
  dynamic get destAddr => _destAddr;
  dynamic get note => _note;
  dynamic get travellers => _travellers;
  dynamic get status => _status;
  dynamic get payment => _payment;
  dynamic get pickupLatitude => _pickupLatitude;
  dynamic get pickupLongitude => _pickupLongitude;
  dynamic get dropLatitude => _dropLatitude;
  dynamic get dropLongitude => _dropLongitude;
  dynamic get km => _km;
  dynamic get minutes => _minutes;
  dynamic get cost => _cost;
  dynamic get startTime => _startTime;
  dynamic get endTime => _endTime;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;
  // List<dynamic>? get metas => _metas;
  // List<dynamic>? get metaData => _metaData;

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