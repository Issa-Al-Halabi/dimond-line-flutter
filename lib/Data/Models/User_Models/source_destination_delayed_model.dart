/// error : false
/// message : "Listed Successfully"
/// data : [{"id":13,"vehicletype":"ECO","icon":"https://diamond-line.com.sy/uploads/vehicle_type_1673950646.png","base_km":2200,"base_time":285,"cost":3500,"limit_distance":4,"price":14420}]

class SourceDestinationDelayedModel {
  SourceDestinationDelayedModel({
    bool? error,
    String? message,
    List<Data>? data,
  }) {
    _error = error;
    _message = message;
    _data = data;
  }

  SourceDestinationDelayedModel.fromJson(dynamic json) {
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
  SourceDestinationDelayedModel copyWith({
    bool? error,
    String? message,
    List<Data>? data,
  }) =>
      SourceDestinationDelayedModel(
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

/// id : 13
/// vehicletype : "ECO"
/// icon : "https://diamond-line.com.sy/uploads/vehicle_type_1673950646.png"
/// base_km : 2200
/// base_time : 285
/// cost : 3500
/// limit_distance : 4
/// price : 14420

class Data {
  Data({
    int? id,
    String? vehicletype,
    String? icon,
    int? baseKm,
    int? baseTime,
    int? cost,
    int? limitDistance,
    int? price,
  }) {
    _id = id;
    _vehicletype = vehicletype;
    _icon = icon;
    _baseKm = baseKm;
    _baseTime = baseTime;
    _cost = cost;
    _limitDistance = limitDistance;
    _price = price;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _vehicletype = json['vehicletype'];
    _icon = json['icon'];
    _baseKm = json['base_km'];
    _baseTime = json['base_time'];
    _cost = json['cost'];
    _limitDistance = json['limit_distance'];
    _price = json['price'];
  }
  int? _id;
  String? _vehicletype;
  String? _icon;
  int? _baseKm;
  int? _baseTime;
  int? _cost;
  int? _limitDistance;
  int? _price;
  Data copyWith({
    int? id,
    String? vehicletype,
    String? icon,
    int? baseKm,
    int? baseTime,
    int? cost,
    int? limitDistance,
    int? price,
  }) =>
      Data(
        id: id ?? _id,
        vehicletype: vehicletype ?? _vehicletype,
        icon: icon ?? _icon,
        baseKm: baseKm ?? _baseKm,
        baseTime: baseTime ?? _baseTime,
        cost: cost ?? _cost,
        limitDistance: limitDistance ?? _limitDistance,
        price: price ?? _price,
      );
  int? get id => _id;
  String? get vehicletype => _vehicletype;
  String? get icon => _icon;
  int? get baseKm => _baseKm;
  int? get baseTime => _baseTime;
  int? get cost => _cost;
  int? get limitDistance => _limitDistance;
  int? get price => _price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['vehicletype'] = _vehicletype;
    map['icon'] = _icon;
    map['base_km'] = _baseKm;
    map['base_time'] = _baseTime;
    map['cost'] = _cost;
    map['limit_distance'] = _limitDistance;
    map['price'] = _price;
    return map;
  }
}
