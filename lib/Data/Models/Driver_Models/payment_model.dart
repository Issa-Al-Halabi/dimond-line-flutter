// /// error : false
// /// message : "Listed Successfully"
// /// data : [{"id":"13","customer_id":null,"user_id":"246","vehicle_id":null,"type_id":"13","option_id":null,"driver_id":"242","category_id":"1","request_type":"moment","subcategory_id":"","from":null,"to":null,"direction":null,"date":"0000-00-00","bags":"0","time":"","pickup":null,"dropoff":null,"duration":null,"pickup_addr":"باب توما","dest_addr":"دمشق","note":null,"travellers":"1","status":"ended","payment":"0","pickup_latitude":"33.50142151266264","pickup_longitude":"36.32597210216678","drop_latitude":"","drop_longitude":"","km":"0.0","minutes":"0","cost":"0","start_time":"10:38:41","end_time":"10:39:01","created_at":"2023-01-23 08:00:06","updated_at":"2023-01-23 08:00:06","deleted_at":null,"booking_id":"169","method":"cash","transaction_id":null,"amount":"10000","transfer_image":null,"payment_status":"pending","payment_details":null},{"id":"14","customer_id":null,"user_id":"246","vehicle_id":null,"type_id":"13","option_id":null,"driver_id":"242","category_id":"1","request_type":"moment","subcategory_id":"","from":null,"to":null,"direction":null,"date":"0000-00-00","bags":"0","time":"","pickup":null,"dropoff":null,"duration":null,"pickup_addr":"باب توما","dest_addr":"دمشق","note":null,"travellers":"1","status":"ended","payment":"0","pickup_latitude":"33.50142151266264","pickup_longitude":"36.32597210216678","drop_latitude":"","drop_longitude":"","km":"0.0","minutes":"0","cost":"0","start_time":"10:38:41","end_time":"10:39:01","created_at":"2023-01-23 08:07:20","updated_at":"2023-01-23 08:07:20","deleted_at":null,"booking_id":"169","method":"cash","transaction_id":null,"amount":"1000","transfer_image":null,"payment_status":"pending","payment_details":null},{"id":"15","customer_id":null,"user_id":"246","vehicle_id":"69","type_id":null,"option_id":null,"driver_id":"242","category_id":"2","request_type":null,"subcategory_id":"18","from":null,"to":null,"direction":"round trip","date":"2022-07-15","bags":"3","time":"4:15:00 am","pickup":null,"dropoff":null,"duration":null,"pickup_addr":null,"dest_addr":null,"note":null,"travellers":"2","status":"started","payment":"0","pickup_latitude":"12.15","pickup_longitude":"264.5","drop_latitude":"598.2","drop_longitude":"10","km":"10281.671901929134","minutes":"0","cost":"25704180","start_time":"11:11:03","end_time":"14:37:48","created_at":"2023-01-23 08:16:17","updated_at":"2023-01-23 08:16:17","deleted_at":null,"booking_id":"167","method":"transfer","transaction_id":null,"amount":"20000","transfer_image":"6e0d81ab-5620-435e-adcb-13e2b47c7e8e.jpg","payment_status":"pending","payment_details":null}]
//
// class PaymentModel {
//   PaymentModel({
//       bool? error,
//       String? message,
//       List<Data>? data,}){
//     _error = error;
//     _message = message;
//     _data = data;
// }
//
//   PaymentModel.fromJson(dynamic json) {
//     _error = json['error'];
//     _message = json['message'];
//     if (json['data'] != null) {
//       _data = [];
//       json['data'].forEach((v) {
//         _data?.add(Data.fromJson(v));
//       });
//     }
//   }
//   bool? _error;
//   String? _message;
//   List<Data>? _data;
// PaymentModel copyWith({  bool? error,
//   String? message,
//   List<Data>? data,
// }) => PaymentModel(  error: error ?? _error,
//   message: message ?? _message,
//   data: data ?? _data,
// );
//   bool? get error => _error;
//   String? get message => _message;
//   List<Data>? get data => _data;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['error'] = _error;
//     map['message'] = _message;
//     if (_data != null) {
//       map['data'] = _data?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
//
// }
//
// /// id : "13"
// /// customer_id : null
// /// user_id : "246"
// /// vehicle_id : null
// /// type_id : "13"
// /// option_id : null
// /// driver_id : "242"
// /// category_id : "1"
// /// request_type : "moment"
// /// subcategory_id : ""
// /// from : null
// /// to : null
// /// direction : null
// /// date : "0000-00-00"
// /// bags : "0"
// /// time : ""
// /// pickup : null
// /// dropoff : null
// /// duration : null
// /// pickup_addr : "باب توما"
// /// dest_addr : "دمشق"
// /// note : null
// /// travellers : "1"
// /// status : "ended"
// /// payment : "0"
// /// pickup_latitude : "33.50142151266264"
// /// pickup_longitude : "36.32597210216678"
// /// drop_latitude : ""
// /// drop_longitude : ""
// /// km : "0.0"
// /// minutes : "0"
// /// cost : "0"
// /// start_time : "10:38:41"
// /// end_time : "10:39:01"
// /// created_at : "2023-01-23 08:00:06"
// /// updated_at : "2023-01-23 08:00:06"
// /// deleted_at : null
// /// booking_id : "169"
// /// method : "cash"
// /// transaction_id : null
// /// amount : "10000"
// /// transfer_image : null
// /// payment_status : "pending"
// /// payment_details : null
//
// class Data {
//   Data({
//       String? id,
//       dynamic customerId,
//       String? userId,
//       dynamic vehicleId,
//       String? typeId,
//       dynamic optionId,
//       String? driverId,
//       String? categoryId,
//       String? requestType,
//       String? subcategoryId,
//       dynamic from,
//       dynamic to,
//       dynamic direction,
//       String? date,
//       String? bags,
//       String? time,
//       dynamic pickup,
//       dynamic dropoff,
//       dynamic duration,
//       String? pickupAddr,
//       String? destAddr,
//       dynamic note,
//       String? travellers,
//       String? status,
//       String? payment,
//       String? pickupLatitude,
//       String? pickupLongitude,
//       String? dropLatitude,
//       String? dropLongitude,
//       String? km,
//       String? minutes,
//       String? cost,
//       String? startTime,
//       String? endTime,
//       String? createdAt,
//       String? updatedAt,
//       dynamic deletedAt,
//       String? bookingId,
//       String? method,
//       dynamic transactionId,
//       String? amount,
//       dynamic transferImage,
//       String? paymentStatus,
//       dynamic paymentDetails,}){
//     _id = id;
//     _customerId = customerId;
//     _userId = userId;
//     _vehicleId = vehicleId;
//     _typeId = typeId;
//     _optionId = optionId;
//     _driverId = driverId;
//     _categoryId = categoryId;
//     _requestType = requestType;
//     _subcategoryId = subcategoryId;
//     _from = from;
//     _to = to;
//     _direction = direction;
//     _date = date;
//     _bags = bags;
//     _time = time;
//     _pickup = pickup;
//     _dropoff = dropoff;
//     _duration = duration;
//     _pickupAddr = pickupAddr;
//     _destAddr = destAddr;
//     _note = note;
//     _travellers = travellers;
//     _status = status;
//     _payment = payment;
//     _pickupLatitude = pickupLatitude;
//     _pickupLongitude = pickupLongitude;
//     _dropLatitude = dropLatitude;
//     _dropLongitude = dropLongitude;
//     _km = km;
//     _minutes = minutes;
//     _cost = cost;
//     _startTime = startTime;
//     _endTime = endTime;
//     _createdAt = createdAt;
//     _updatedAt = updatedAt;
//     _deletedAt = deletedAt;
//     _bookingId = bookingId;
//     _method = method;
//     _transactionId = transactionId;
//     _amount = amount;
//     _transferImage = transferImage;
//     _paymentStatus = paymentStatus;
//     _paymentDetails = paymentDetails;
// }
//
//   Data.fromJson(dynamic json) {
//     _id = json['id'];
//     _customerId = json['customer_id'];
//     _userId = json['user_id'];
//     _vehicleId = json['vehicle_id'];
//     _typeId = json['type_id'];
//     _optionId = json['option_id'];
//     _driverId = json['driver_id'];
//     _categoryId = json['category_id'];
//     _requestType = json['request_type'];
//     _subcategoryId = json['subcategory_id'];
//     _from = json['from'];
//     _to = json['to'];
//     _direction = json['direction'];
//     _date = json['date'];
//     _bags = json['bags'];
//     _time = json['time'];
//     _pickup = json['pickup'];
//     _dropoff = json['dropoff'];
//     _duration = json['duration'];
//     _pickupAddr = json['pickup_addr'];
//     _destAddr = json['dest_addr'];
//     _note = json['note'];
//     _travellers = json['travellers'];
//     _status = json['status'];
//     _payment = json['payment'];
//     _pickupLatitude = json['pickup_latitude'];
//     _pickupLongitude = json['pickup_longitude'];
//     _dropLatitude = json['drop_latitude'];
//     _dropLongitude = json['drop_longitude'];
//     _km = json['km'];
//     _minutes = json['minutes'];
//     _cost = json['cost'];
//     _startTime = json['start_time'];
//     _endTime = json['end_time'];
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//     _deletedAt = json['deleted_at'];
//     _bookingId = json['booking_id'];
//     _method = json['method'];
//     _transactionId = json['transaction_id'];
//     _amount = json['amount'];
//     _transferImage = json['transfer_image'];
//     _paymentStatus = json['payment_status'];
//     _paymentDetails = json['payment_details'];
//   }
//   String? _id;
//   dynamic _customerId;
//   String? _userId;
//   dynamic _vehicleId;
//   String? _typeId;
//   dynamic _optionId;
//   String? _driverId;
//   String? _categoryId;
//   String? _requestType;
//   String? _subcategoryId;
//   dynamic _from;
//   dynamic _to;
//   dynamic _direction;
//   String? _date;
//   String? _bags;
//   String? _time;
//   dynamic _pickup;
//   dynamic _dropoff;
//   dynamic _duration;
//   String? _pickupAddr;
//   String? _destAddr;
//   dynamic _note;
//   String? _travellers;
//   String? _status;
//   String? _payment;
//   String? _pickupLatitude;
//   String? _pickupLongitude;
//   String? _dropLatitude;
//   String? _dropLongitude;
//   String? _km;
//   String? _minutes;
//   String? _cost;
//   String? _startTime;
//   String? _endTime;
//   String? _createdAt;
//   String? _updatedAt;
//   dynamic _deletedAt;
//   String? _bookingId;
//   String? _method;
//   dynamic _transactionId;
//   String? _amount;
//   dynamic _transferImage;
//   String? _paymentStatus;
//   dynamic _paymentDetails;
// Data copyWith({  String? id,
//   dynamic customerId,
//   String? userId,
//   dynamic vehicleId,
//   String? typeId,
//   dynamic optionId,
//   String? driverId,
//   String? categoryId,
//   String? requestType,
//   String? subcategoryId,
//   dynamic from,
//   dynamic to,
//   dynamic direction,
//   String? date,
//   String? bags,
//   String? time,
//   dynamic pickup,
//   dynamic dropoff,
//   dynamic duration,
//   String? pickupAddr,
//   String? destAddr,
//   dynamic note,
//   String? travellers,
//   String? status,
//   String? payment,
//   String? pickupLatitude,
//   String? pickupLongitude,
//   String? dropLatitude,
//   String? dropLongitude,
//   String? km,
//   String? minutes,
//   String? cost,
//   String? startTime,
//   String? endTime,
//   String? createdAt,
//   String? updatedAt,
//   dynamic deletedAt,
//   String? bookingId,
//   String? method,
//   dynamic transactionId,
//   String? amount,
//   dynamic transferImage,
//   String? paymentStatus,
//   dynamic paymentDetails,
// }) => Data(  id: id ?? _id,
//   customerId: customerId ?? _customerId,
//   userId: userId ?? _userId,
//   vehicleId: vehicleId ?? _vehicleId,
//   typeId: typeId ?? _typeId,
//   optionId: optionId ?? _optionId,
//   driverId: driverId ?? _driverId,
//   categoryId: categoryId ?? _categoryId,
//   requestType: requestType ?? _requestType,
//   subcategoryId: subcategoryId ?? _subcategoryId,
//   from: from ?? _from,
//   to: to ?? _to,
//   direction: direction ?? _direction,
//   date: date ?? _date,
//   bags: bags ?? _bags,
//   time: time ?? _time,
//   pickup: pickup ?? _pickup,
//   dropoff: dropoff ?? _dropoff,
//   duration: duration ?? _duration,
//   pickupAddr: pickupAddr ?? _pickupAddr,
//   destAddr: destAddr ?? _destAddr,
//   note: note ?? _note,
//   travellers: travellers ?? _travellers,
//   status: status ?? _status,
//   payment: payment ?? _payment,
//   pickupLatitude: pickupLatitude ?? _pickupLatitude,
//   pickupLongitude: pickupLongitude ?? _pickupLongitude,
//   dropLatitude: dropLatitude ?? _dropLatitude,
//   dropLongitude: dropLongitude ?? _dropLongitude,
//   km: km ?? _km,
//   minutes: minutes ?? _minutes,
//   cost: cost ?? _cost,
//   startTime: startTime ?? _startTime,
//   endTime: endTime ?? _endTime,
//   createdAt: createdAt ?? _createdAt,
//   updatedAt: updatedAt ?? _updatedAt,
//   deletedAt: deletedAt ?? _deletedAt,
//   bookingId: bookingId ?? _bookingId,
//   method: method ?? _method,
//   transactionId: transactionId ?? _transactionId,
//   amount: amount ?? _amount,
//   transferImage: transferImage ?? _transferImage,
//   paymentStatus: paymentStatus ?? _paymentStatus,
//   paymentDetails: paymentDetails ?? _paymentDetails,
// );
//   String? get id => _id;
//   dynamic get customerId => _customerId;
//   String? get userId => _userId;
//   dynamic get vehicleId => _vehicleId;
//   String? get typeId => _typeId;
//   dynamic get optionId => _optionId;
//   String? get driverId => _driverId;
//   String? get categoryId => _categoryId;
//   String? get requestType => _requestType;
//   String? get subcategoryId => _subcategoryId;
//   dynamic get from => _from;
//   dynamic get to => _to;
//   dynamic get direction => _direction;
//   String? get date => _date;
//   String? get bags => _bags;
//   String? get time => _time;
//   dynamic get pickup => _pickup;
//   dynamic get dropoff => _dropoff;
//   dynamic get duration => _duration;
//   String? get pickupAddr => _pickupAddr;
//   String? get destAddr => _destAddr;
//   dynamic get note => _note;
//   String? get travellers => _travellers;
//   String? get status => _status;
//   String? get payment => _payment;
//   String? get pickupLatitude => _pickupLatitude;
//   String? get pickupLongitude => _pickupLongitude;
//   String? get dropLatitude => _dropLatitude;
//   String? get dropLongitude => _dropLongitude;
//   String? get km => _km;
//   String? get minutes => _minutes;
//   String? get cost => _cost;
//   String? get startTime => _startTime;
//   String? get endTime => _endTime;
//   String? get createdAt => _createdAt;
//   String? get updatedAt => _updatedAt;
//   dynamic get deletedAt => _deletedAt;
//   String? get bookingId => _bookingId;
//   String? get method => _method;
//   dynamic get transactionId => _transactionId;
//   String? get amount => _amount;
//   dynamic get transferImage => _transferImage;
//   String? get paymentStatus => _paymentStatus;
//   dynamic get paymentDetails => _paymentDetails;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['customer_id'] = _customerId;
//     map['user_id'] = _userId;
//     map['vehicle_id'] = _vehicleId;
//     map['type_id'] = _typeId;
//     map['option_id'] = _optionId;
//     map['driver_id'] = _driverId;
//     map['category_id'] = _categoryId;
//     map['request_type'] = _requestType;
//     map['subcategory_id'] = _subcategoryId;
//     map['from'] = _from;
//     map['to'] = _to;
//     map['direction'] = _direction;
//     map['date'] = _date;
//     map['bags'] = _bags;
//     map['time'] = _time;
//     map['pickup'] = _pickup;
//     map['dropoff'] = _dropoff;
//     map['duration'] = _duration;
//     map['pickup_addr'] = _pickupAddr;
//     map['dest_addr'] = _destAddr;
//     map['note'] = _note;
//     map['travellers'] = _travellers;
//     map['status'] = _status;
//     map['payment'] = _payment;
//     map['pickup_latitude'] = _pickupLatitude;
//     map['pickup_longitude'] = _pickupLongitude;
//     map['drop_latitude'] = _dropLatitude;
//     map['drop_longitude'] = _dropLongitude;
//     map['km'] = _km;
//     map['minutes'] = _minutes;
//     map['cost'] = _cost;
//     map['start_time'] = _startTime;
//     map['end_time'] = _endTime;
//     map['created_at'] = _createdAt;
//     map['updated_at'] = _updatedAt;
//     map['deleted_at'] = _deletedAt;
//     map['booking_id'] = _bookingId;
//     map['method'] = _method;
//     map['transaction_id'] = _transactionId;
//     map['amount'] = _amount;
//     map['transfer_image'] = _transferImage;
//     map['payment_status'] = _paymentStatus;
//     map['payment_details'] = _paymentDetails;
//     return map;
//   }
//
// }

/// error : false
/// message : "Listed Successfully"
/// data : [{"id":13,"customer_id":null,"user_id":246,"vehicle_id":null,"type_id":13,"option_id":null,"driver_id":"242","category_id":"1","request_type":"moment","subcategory_id":"","from":null,"to":null,"direction":null,"date":"0000-00-00","bags":0,"time":"","pickup":null,"dropoff":null,"duration":null,"pickup_addr":"باب توما","dest_addr":"دمشق","note":null,"travellers":1,"status":"ended","payment":0,"pickup_latitude":"33.50142151266264","pickup_longitude":"36.32597210216678","drop_latitude":"","drop_longitude":"","km":"0.0","minutes":"0","cost":0,"start_time":"10:38:41","end_time":"10:39:01","created_at":"2023-01-23 09:00:06","updated_at":"2023-01-23 09:00:06","deleted_at":null,"booking_id":169,"method":"cash","transaction_id":null,"amount":10000,"transfer_image":null,"payment_status":"pending","payment_details":null},{"id":14,"customer_id":null,"user_id":246,"vehicle_id":null,"type_id":13,"option_id":null,"driver_id":"242","category_id":"1","request_type":"moment","subcategory_id":"","from":null,"to":null,"direction":null,"date":"0000-00-00","bags":0,"time":"","pickup":null,"dropoff":null,"duration":null,"pickup_addr":"باب توما","dest_addr":"دمشق","note":null,"travellers":1,"status":"ended","payment":0,"pickup_latitude":"33.50142151266264","pickup_longitude":"36.32597210216678","drop_latitude":"","drop_longitude":"","km":"0.0","minutes":"0","cost":0,"start_time":"10:38:41","end_time":"10:39:01","created_at":"2023-01-23 09:07:20","updated_at":"2023-01-23 09:07:20","deleted_at":null,"booking_id":169,"method":"cash","transaction_id":null,"amount":1000,"transfer_image":null,"payment_status":"pending","payment_details":null},{"id":15,"customer_id":null,"user_id":246,"vehicle_id":69,"type_id":null,"option_id":null,"driver_id":"242","category_id":"2","request_type":null,"subcategory_id":"18","from":null,"to":null,"direction":"round trip","date":"2022-07-15","bags":3,"time":"4:15:00 am","pickup":null,"dropoff":null,"duration":null,"pickup_addr":null,"dest_addr":null,"note":null,"travellers":2,"status":"ended","payment":0,"pickup_latitude":"12.15","pickup_longitude":"264.5","drop_latitude":"598.2","drop_longitude":"10","km":"0.0","minutes":"0","cost":-32400,"start_time":"11:11:03","end_time":"10:44:02","created_at":"2023-01-23 09:16:17","updated_at":"2023-01-23 09:16:17","deleted_at":null,"booking_id":167,"method":"transfer","transaction_id":null,"amount":20000,"transfer_image":"6e0d81ab-5620-435e-adcb-13e2b47c7e8e.jpg","payment_status":"pending","payment_details":null},{"id":22,"customer_id":null,"user_id":246,"vehicle_id":null,"type_id":13,"option_id":"\"7\"","driver_id":"242","category_id":"1","request_type":"delayed","subcategory_id":"","from":null,"to":null,"direction":null,"date":"2022-04-09","bags":0,"time":"5:12:00","pickup":null,"dropoff":null,"duration":null,"pickup_addr":"جرمانا","dest_addr":"الكراجات","note":null,"travellers":1,"status":"ended","payment":0,"pickup_latitude":"33.486788297118004","pickup_longitude":"36.33914034149961","drop_latitude":"","drop_longitude":"","km":"0.0","minutes":"32","cost":285,"start_time":"12:23:35","end_time":"12:24:11","created_at":"2023-01-26 10:26:45","updated_at":"2023-01-26 10:26:45","deleted_at":null,"booking_id":211,"method":"cash","transaction_id":null,"amount":2000,"transfer_image":null,"payment_status":"pending","payment_details":null}]

class PaymentModel {
  PaymentModel({
    bool? error,
    String? message,
    List<Data>? data,}){
    _error = error;
    _message = message;
    _data = data;
  }

  PaymentModel.fromJson(dynamic json) {
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
  PaymentModel copyWith({  bool? error,
    String? message,
    List<Data>? data,
  }) => PaymentModel(  error: error ?? _error,
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

/// id : 13
/// customer_id : null
/// user_id : 246
/// vehicle_id : null
/// type_id : 13
/// option_id : null
/// driver_id : "242"
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
/// status : "ended"
/// payment : 0
/// pickup_latitude : "33.50142151266264"
/// pickup_longitude : "36.32597210216678"
/// drop_latitude : ""
/// drop_longitude : ""
/// km : "0.0"
/// minutes : "0"
/// cost : 0
/// start_time : "10:38:41"
/// end_time : "10:39:01"
/// created_at : "2023-01-23 09:00:06"
/// updated_at : "2023-01-23 09:00:06"
/// deleted_at : null
/// booking_id : 169
/// method : "cash"
/// transaction_id : null
/// amount : 10000
/// transfer_image : null
/// payment_status : "pending"
/// payment_details : null

class Data {
  Data({
    int? id,
    dynamic customerId,
    int? userId,
    dynamic vehicleId,
    int? typeId,
    dynamic optionId,
    String? driverId,
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
    String? updatedAt,
    dynamic deletedAt,
    int? bookingId,
    String? method,
    dynamic transactionId,
    int? amount,
    dynamic transferImage,
    String? paymentStatus,
    dynamic paymentDetails,}){
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
    _bookingId = bookingId;
    _method = method;
    _transactionId = transactionId;
    _amount = amount;
    _transferImage = transferImage;
    _paymentStatus = paymentStatus;
    _paymentDetails = paymentDetails;
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
    _bookingId = json['booking_id'];
    _method = json['method'];
    _transactionId = json['transaction_id'];
    _amount = json['amount'];
    _transferImage = json['transfer_image'];
    _paymentStatus = json['payment_status'];
    _paymentDetails = json['payment_details'];
  }
  int? _id;
  dynamic _customerId;
  int? _userId;
  dynamic _vehicleId;
  int? _typeId;
  dynamic _optionId;
  String? _driverId;
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
  String? _updatedAt;
  dynamic _deletedAt;
  int? _bookingId;
  String? _method;
  dynamic _transactionId;
  int? _amount;
  dynamic _transferImage;
  String? _paymentStatus;
  dynamic _paymentDetails;
  Data copyWith({  int? id,
    dynamic customerId,
    int? userId,
    dynamic vehicleId,
    int? typeId,
    dynamic optionId,
    String? driverId,
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
    String? updatedAt,
    dynamic deletedAt,
    int? bookingId,
    String? method,
    dynamic transactionId,
    int? amount,
    dynamic transferImage,
    String? paymentStatus,
    dynamic paymentDetails,
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
    bookingId: bookingId ?? _bookingId,
    method: method ?? _method,
    transactionId: transactionId ?? _transactionId,
    amount: amount ?? _amount,
    transferImage: transferImage ?? _transferImage,
    paymentStatus: paymentStatus ?? _paymentStatus,
    paymentDetails: paymentDetails ?? _paymentDetails,
  );
  int? get id => _id;
  dynamic get customerId => _customerId;
  int? get userId => _userId;
  dynamic get vehicleId => _vehicleId;
  int? get typeId => _typeId;
  dynamic get optionId => _optionId;
  String? get driverId => _driverId;
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
  String? get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;
  int? get bookingId => _bookingId;
  String? get method => _method;
  dynamic get transactionId => _transactionId;
  int? get amount => _amount;
  dynamic get transferImage => _transferImage;
  String? get paymentStatus => _paymentStatus;
  dynamic get paymentDetails => _paymentDetails;

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
    map['booking_id'] = _bookingId;
    map['method'] = _method;
    map['transaction_id'] = _transactionId;
    map['amount'] = _amount;
    map['transfer_image'] = _transferImage;
    map['payment_status'] = _paymentStatus;
    map['payment_details'] = _paymentDetails;
    return map;
  }

}