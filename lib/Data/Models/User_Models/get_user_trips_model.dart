/// error : false
/// message : "Listed Successfuly"
/// data : [{"id":652,"customer_id":null,"user_id":246,"vehicle_id":69,"type_id":null,"option_id":null,"driver_id":null,"category_id":"2","request_type":null,"subcategory_id":"19","from":"Damascus","to":"Tartous","direction":"round trip","date":"2022-07-15","bags":3,"time":"4:15:00 am","pickup":null,"dropoff":null,"duration":null,"pickup_addr":null,"dest_addr":null,"note":null,"travellers":2,"status":"pending","payment":0,"pickup_latitude":"12.15","pickup_longitude":"264.5","drop_latitude":"598.2","drop_longitude":"10","km":"12","minutes":"5","cost":50950,"start_time":null,"end_time":null,"created_at":"2023-05-28 10:42:30","order_time":null,"updated_at":"2023-05-28 10:42:30","deleted_at":null,"is_tour":"Yes","tour_detail":[{"id":45,"trip_id":652,"start_time":"01:32:00","end_time":"09:32:00","status":"pending","cost":320000,"created_at":"2022-12-29T08:34:23.000000Z","updated_at":"2022-12-29T10:32:28.000000Z","deleted_at":null}],"can_cancle":"yes"},{"id":179,"customer_id":null,"user_id":246,"vehicle_id":69,"type_id":null,"option_id":null,"driver_id":242,"category_id":"2","request_type":null,"subcategory_id":"11","from":"opopweoripwrpi","to":"uhihiuhiuhoopopou","direction":"round trip","date":"2022-07-15","bags":3,"time":"4:15:00 am","pickup":null,"dropoff":null,"duration":null,"pickup_addr":null,"dest_addr":null,"note":null,"travellers":2,"status":"pending","payment":0,"pickup_latitude":"12.15","pickup_longitude":"264.5","drop_latitude":"598.2","drop_longitude":"10","km":"250","minutes":"6","cost":632200,"start_time":null,"end_time":null,"created_at":"2023-01-21 07:20:37","order_time":null,"updated_at":"2023-01-21 07:20:37","deleted_at":null,"is_tour":"No","can_cancle":"no"},{"id":177,"customer_id":null,"user_id":246,"vehicle_id":69,"type_id":null,"option_id":null,"driver_id":242,"category_id":"2","request_type":null,"subcategory_id":"11","from":"ffytfytfyf","to":"uhihiuhiuh","direction":"round trip","date":"2022-07-15","bags":3,"time":"4:15:00 am","pickup":null,"dropoff":null,"duration":null,"pickup_addr":null,"dest_addr":null,"note":null,"travellers":2,"status":"pending","payment":0,"pickup_latitude":"12.15","pickup_longitude":"264.5","drop_latitude":"598.2","drop_longitude":"10","km":"250","minutes":"6","cost":1264400,"start_time":null,"end_time":null,"created_at":"2023-01-19 14:37:46","order_time":null,"updated_at":"2023-01-19 14:37:46","deleted_at":null,"is_tour":"No","can_cancle":"no"},{"id":176,"customer_id":null,"user_id":246,"vehicle_id":69,"type_id":null,"option_id":null,"driver_id":242,"category_id":"2","request_type":null,"subcategory_id":"11","from":null,"to":null,"direction":"round trip","date":"2022-07-15","bags":3,"time":"4:15:00 am","pickup":null,"dropoff":null,"duration":null,"pickup_addr":null,"dest_addr":null,"note":null,"travellers":2,"status":"pending","payment":0,"pickup_latitude":"12.15","pickup_longitude":"264.5","drop_latitude":"598.2","drop_longitude":"10","km":"250","minutes":"6","cost":1264400,"start_time":null,"end_time":null,"created_at":"2023-01-19 14:37:31","order_time":null,"updated_at":"2023-01-19 14:37:31","deleted_at":null,"is_tour":"Yes","tour_detail":[{"id":46,"trip_id":176,"start_time":"21:00:00","end_time":"22:00:00","status":"pending","cost":40000,"created_at":"2023-01-23T08:57:26.000000Z","updated_at":"2023-01-23T08:57:26.000000Z","deleted_at":null}],"can_cancle":"no"}]

class GetUserTripsModel {
  GetUserTripsModel({
    bool? error,
    String? message,
    List<Data>? data,
  }) {
    _error = error;
    _message = message;
    _data = data;
  }

  GetUserTripsModel.fromJson(dynamic json) {
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
  GetUserTripsModel copyWith({
    bool? error,
    String? message,
    List<Data>? data,
  }) =>
      GetUserTripsModel(
        error: error ?? _error,
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

/// id : 652
/// customer_id : null
/// user_id : 246
/// vehicle_id : 69
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
/// bags : 3
/// time : "4:15:00 am"
/// pickup : null
/// dropoff : null
/// duration : null
/// pickup_addr : null
/// dest_addr : null
/// note : null
/// travellers : 2
/// status : "pending"
/// payment : 0
/// pickup_latitude : "12.15"
/// pickup_longitude : "264.5"
/// drop_latitude : "598.2"
/// drop_longitude : "10"
/// km : "12"
/// minutes : "5"
/// cost : 50950
/// start_time : null
/// end_time : null
/// created_at : "2023-05-28 10:42:30"
/// order_time : null
/// updated_at : "2023-05-28 10:42:30"
/// deleted_at : null
/// is_tour : "Yes"
/// tour_detail : [{"id":45,"trip_id":652,"start_time":"01:32:00","end_time":"09:32:00","status":"pending","cost":320000,"created_at":"2022-12-29T08:34:23.000000Z","updated_at":"2022-12-29T10:32:28.000000Z","deleted_at":null}]
/// can_cancle : "yes"

class Data {
  Data({
    int? id,
    dynamic customerId,
    int? userId,
    int? vehicleId,
    dynamic typeId,
    dynamic optionId,
    dynamic driverId,
    String? categoryId,
    dynamic requestType,
    String? subcategoryId,
    String? from,
    String? to,
    String? direction,
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
    dynamic startTime,
    dynamic endTime,
    String? createdAt,
    dynamic orderTime,
    String? updatedAt,
    dynamic deletedAt,
    String? isTour,
    List<TourDetail>? tourDetail,
    String? canCancle,
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
    _isTour = isTour;
    _tourDetail = tourDetail;
    _canCancle = canCancle;
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
    _orderTime = json['order_time'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
    _isTour = json['is_tour'];
    if (json['tour_detail'] != null) {
      _tourDetail = [];
      json['tour_detail'].forEach((v) {
        _tourDetail?.add(TourDetail.fromJson(v));
      });
    }
    _canCancle = json['can_cancle'];
  }
  int? _id;
  dynamic _customerId;
  int? _userId;
  int? _vehicleId;
  dynamic _typeId;
  dynamic _optionId;
  dynamic _driverId;
  String? _categoryId;
  dynamic _requestType;
  String? _subcategoryId;
  String? _from;
  String? _to;
  String? _direction;
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
  dynamic _startTime;
  dynamic _endTime;
  String? _createdAt;
  dynamic _orderTime;
  String? _updatedAt;
  dynamic _deletedAt;
  String? _isTour;
  List<TourDetail>? _tourDetail;
  String? _canCancle;
  Data copyWith({
    int? id,
    dynamic customerId,
    int? userId,
    int? vehicleId,
    dynamic typeId,
    dynamic optionId,
    dynamic driverId,
    String? categoryId,
    dynamic requestType,
    String? subcategoryId,
    String? from,
    String? to,
    String? direction,
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
    dynamic startTime,
    dynamic endTime,
    String? createdAt,
    dynamic orderTime,
    String? updatedAt,
    dynamic deletedAt,
    String? isTour,
    List<TourDetail>? tourDetail,
    String? canCancle,
  }) =>
      Data(
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
        isTour: isTour ?? _isTour,
        tourDetail: tourDetail ?? _tourDetail,
        canCancle: canCancle ?? _canCancle,
      );
  int? get id => _id;
  dynamic get customerId => _customerId;
  int? get userId => _userId;
  int? get vehicleId => _vehicleId;
  dynamic get typeId => _typeId;
  dynamic get optionId => _optionId;
  dynamic get driverId => _driverId;
  String? get categoryId => _categoryId;
  dynamic get requestType => _requestType;
  String? get subcategoryId => _subcategoryId;
  String? get from => _from;
  String? get to => _to;
  String? get direction => _direction;
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
  dynamic get startTime => _startTime;
  dynamic get endTime => _endTime;
  String? get createdAt => _createdAt;
  dynamic get orderTime => _orderTime;
  String? get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;
  String? get isTour => _isTour;
  List<TourDetail>? get tourDetail => _tourDetail;
  String? get canCancle => _canCancle;

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
    map['is_tour'] = _isTour;
    if (_tourDetail != null) {
      map['tour_detail'] = _tourDetail?.map((v) => v.toJson()).toList();
    }
    map['can_cancle'] = _canCancle;
    return map;
  }
}

/// id : 45
/// trip_id : 652
/// start_time : "01:32:00"
/// end_time : "09:32:00"
/// status : "pending"
/// cost : 320000
/// created_at : "2022-12-29T08:34:23.000000Z"
/// updated_at : "2022-12-29T10:32:28.000000Z"
/// deleted_at : null

class TourDetail {
  TourDetail({
    int? id,
    int? tripId,
    String? startTime,
    String? endTime,
    String? status,
    int? cost,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
  }) {
    _id = id;
    _tripId = tripId;
    _startTime = startTime;
    _endTime = endTime;
    _status = status;
    _cost = cost;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
  }

  TourDetail.fromJson(dynamic json) {
    _id = json['id'];
    _tripId = json['trip_id'];
    _startTime = json['start_time'];
    _endTime = json['end_time'];
    _status = json['status'];
    _cost = json['cost'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
  }
  int? _id;
  int? _tripId;
  String? _startTime;
  String? _endTime;
  String? _status;
  int? _cost;
  String? _createdAt;
  String? _updatedAt;
  dynamic _deletedAt;
  TourDetail copyWith({
    int? id,
    int? tripId,
    String? startTime,
    String? endTime,
    String? status,
    int? cost,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
  }) =>
      TourDetail(
        id: id ?? _id,
        tripId: tripId ?? _tripId,
        startTime: startTime ?? _startTime,
        endTime: endTime ?? _endTime,
        status: status ?? _status,
        cost: cost ?? _cost,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        deletedAt: deletedAt ?? _deletedAt,
      );
  int? get id => _id;
  int? get tripId => _tripId;
  String? get startTime => _startTime;
  String? get endTime => _endTime;
  String? get status => _status;
  int? get cost => _cost;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['trip_id'] = _tripId;
    map['start_time'] = _startTime;
    map['end_time'] = _endTime;
    map['status'] = _status;
    map['cost'] = _cost;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    return map;
  }
}
