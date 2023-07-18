/// error : false
/// data : [{"id":183,"status":"started","pickup_latitude":"33.485","pickup_longitude":"36.3408244","drop_latitude":"","drop_longitude":""},{"id":258,"status":"started","pickup_latitude":"33.4850002","pickup_longitude":"36.3408471","drop_latitude":"","drop_longitude":""},{"id":283,"status":"started","pickup_latitude":"37.4219983","pickup_longitude":"-122.084","drop_latitude":"","drop_longitude":""},{"id":321,"status":"started","pickup_latitude":"33.4850623","pickup_longitude":"36.3408948","drop_latitude":"","drop_longitude":""},{"id":325,"status":"started","pickup_latitude":"33.4850612","pickup_longitude":"36.3408951","drop_latitude":"","drop_longitude":""},{"id":344,"status":"started","pickup_latitude":"33.4850623","pickup_longitude":"36.3408946","drop_latitude":"33.65856570476369","drop_longitude":"36.323417611420155"},{"id":349,"status":"started","pickup_latitude":"37.4219983","pickup_longitude":"-122.084","drop_latitude":"0.0","drop_longitude":"0.0"}]

class StartedInsideTripsModel {
  StartedInsideTripsModel({
      bool? error, 
      List<Data>? data,}){
    _error = error;
    _data = data;
}

  StartedInsideTripsModel.fromJson(dynamic json) {
    _error = json['error'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _error;
  List<Data>? _data;
StartedInsideTripsModel copyWith({  bool? error,
  List<Data>? data,
}) => StartedInsideTripsModel(  error: error ?? _error,
  data: data ?? _data,
);
  bool? get error => _error;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 183
/// status : "started"
/// pickup_latitude : "33.485"
/// pickup_longitude : "36.3408244"
/// drop_latitude : ""
/// drop_longitude : ""

class Data {
  Data({
      int? id, 
      String? status, 
      String? pickupLatitude, 
      String? pickupLongitude, 
      String? dropLatitude, 
      String? dropLongitude,}){
    _id = id;
    _status = status;
    _pickupLatitude = pickupLatitude;
    _pickupLongitude = pickupLongitude;
    _dropLatitude = dropLatitude;
    _dropLongitude = dropLongitude;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _status = json['status'];
    _pickupLatitude = json['pickup_latitude'];
    _pickupLongitude = json['pickup_longitude'];
    _dropLatitude = json['drop_latitude'];
    _dropLongitude = json['drop_longitude'];
  }
  int? _id;
  String? _status;
  String? _pickupLatitude;
  String? _pickupLongitude;
  String? _dropLatitude;
  String? _dropLongitude;
Data copyWith({  int? id,
  String? status,
  String? pickupLatitude,
  String? pickupLongitude,
  String? dropLatitude,
  String? dropLongitude,
}) => Data(  id: id ?? _id,
  status: status ?? _status,
  pickupLatitude: pickupLatitude ?? _pickupLatitude,
  pickupLongitude: pickupLongitude ?? _pickupLongitude,
  dropLatitude: dropLatitude ?? _dropLatitude,
  dropLongitude: dropLongitude ?? _dropLongitude,
);
  int? get id => _id;
  String? get status => _status;
  String? get pickupLatitude => _pickupLatitude;
  String? get pickupLongitude => _pickupLongitude;
  String? get dropLatitude => _dropLatitude;
  String? get dropLongitude => _dropLongitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['status'] = _status;
    map['pickup_latitude'] = _pickupLatitude;
    map['pickup_longitude'] = _pickupLongitude;
    map['drop_latitude'] = _dropLatitude;
    map['drop_longitude'] = _dropLongitude;
    return map;
  }

}