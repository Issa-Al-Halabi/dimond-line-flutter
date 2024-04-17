/// error : false
/// message : "Listed Successfuly"
/// data : [{"id":58,"category_id":2,"subcategory_id":15,"make_id":null,"model_id":null,"class_id":"external_vehicle","color_id":null,"year":"2011","group_id":null,"lic_exp_date":null,"reg_exp_date":null,"vehicle_image":"https://diamond-line.com.sy/uploads/4b88885e-7a75-4bc9-9c5e-03ffd78bfbbb.jpg","color":"White","type":null,"device_number":653,"engine_type":null,"car_number":"65325","car_model":"Audi","horse_power":null,"vin":null,"license_plate":null,"mileage":null,"in_service":1,"user_id":null,"created_at":"2022-12-28 10:06:54","updated_at":"2022-12-28 10:06:54","deleted_at":null,"int_mileage":null,"type_id":13,"seats":6,"bags":5,"vehicletype":"ECO","base_km":2000,"base_time":295,"cost":28134}]

class FilterVechileModel {
  FilterVechileModel({
    bool? error,
    String? message,
    List<Data>? data,
  }) {
    _error = error;
    _message = message;
    _data = data;
  }

  FilterVechileModel.fromJson(dynamic json) {
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
  FilterVechileModel copyWith({
    bool? error,
    String? message,
    List<Data>? data,
  }) =>
      FilterVechileModel(
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

/// id : 58
/// category_id : 2
/// subcategory_id : 15
/// make_id : null
/// model_id : null
/// class_id : "external_vehicle"
/// color_id : null
/// year : "2011"
/// group_id : null
/// lic_exp_date : null
/// reg_exp_date : null
/// vehicle_image : "https://diamond-line.com.sy/uploads/4b88885e-7a75-4bc9-9c5e-03ffd78bfbbb.jpg"
/// color : "White"
/// type : null
/// device_number : 653
/// engine_type : null
/// car_number : "65325"
/// car_model : "Audi"
/// horse_power : null
/// vin : null
/// license_plate : null
/// mileage : null
/// in_service : 1
/// user_id : null
/// created_at : "2022-12-28 10:06:54"
/// updated_at : "2022-12-28 10:06:54"
/// deleted_at : null
/// int_mileage : null
/// type_id : 13
/// seats : 6
/// bags : 5
/// vehicletype : "ECO"
/// base_km : 2000
/// base_time : 295
/// cost : 28134

class Data {
  Data({
    int? id,
    int? categoryId,
    int? subcategoryId,
    dynamic makeId,
    dynamic modelId,
    String? classId,
    dynamic colorId,
    String? year,
    dynamic groupId,
    dynamic licExpDate,
    dynamic regExpDate,
    String? vehicleImage,
    String? color,
    dynamic type,
    int? deviceNumber,
    dynamic engineType,
    String? carNumber,
    String? carModel,
    dynamic horsePower,
    dynamic vin,
    dynamic licensePlate,
    dynamic mileage,
    int? inService,
    dynamic userId,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    dynamic intMileage,
    int? typeId,
    int? seats,
    int? bags,
    String? vehicletype,
    int? baseKm,
    int? baseTime,
    dynamic cost,
  }) {
    _id = id;
    _categoryId = categoryId;
    _subcategoryId = subcategoryId;
    _makeId = makeId;
    _modelId = modelId;
    _classId = classId;
    _colorId = colorId;
    _year = year;
    _groupId = groupId;
    _licExpDate = licExpDate;
    _regExpDate = regExpDate;
    _vehicleImage = vehicleImage;
    _color = color;
    _type = type;
    _deviceNumber = deviceNumber;
    _engineType = engineType;
    _carNumber = carNumber;
    _carModel = carModel;
    _horsePower = horsePower;
    _vin = vin;
    _licensePlate = licensePlate;
    _mileage = mileage;
    _inService = inService;
    _userId = userId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
    _intMileage = intMileage;
    _typeId = typeId;
    _seats = seats;
    _bags = bags;
    _vehicletype = vehicletype;
    _baseKm = baseKm;
    _baseTime = baseTime;
    _cost = cost;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _categoryId = json['category_id'];
    _subcategoryId = json['subcategory_id'];
    _makeId = json['make_id'];
    _modelId = json['model_id'];
    _classId = json['class_id'];
    _colorId = json['color_id'];
    _year = json['year'];
    _groupId = json['group_id'];
    _licExpDate = json['lic_exp_date'];
    _regExpDate = json['reg_exp_date'];
    _vehicleImage = json['vehicle_image'];
    _color = json['color'];
    _type = json['type'];
    _deviceNumber = json['device_number'];
    _engineType = json['engine_type'];
    _carNumber = json['car_number'];
    _carModel = json['car_model'];
    _horsePower = json['horse_power'];
    _vin = json['vin'];
    _licensePlate = json['license_plate'];
    _mileage = json['mileage'];
    _inService = json['in_service'];
    _userId = json['user_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
    _intMileage = json['int_mileage'];
    _typeId = json['type_id'];
    _seats = json['seats'];
    _bags = json['bags'];
    _vehicletype = json['vehicletype'];
    _baseKm = json['base_km'];
    _baseTime = json['base_time'];
    _cost = json['cost'];
  }
  int? _id;
  int? _categoryId;
  int? _subcategoryId;
  dynamic _makeId;
  dynamic _modelId;
  String? _classId;
  dynamic _colorId;
  String? _year;
  dynamic _groupId;
  dynamic _licExpDate;
  dynamic _regExpDate;
  String? _vehicleImage;
  String? _color;
  dynamic _type;
  int? _deviceNumber;
  dynamic _engineType;
  String? _carNumber;
  String? _carModel;
  dynamic _horsePower;
  dynamic _vin;
  dynamic _licensePlate;
  dynamic _mileage;
  int? _inService;
  dynamic _userId;
  String? _createdAt;
  String? _updatedAt;
  dynamic _deletedAt;
  dynamic _intMileage;
  int? _typeId;
  int? _seats;
  int? _bags;
  String? _vehicletype;
  int? _baseKm;
  int? _baseTime;
  dynamic _cost;
  Data copyWith({
    int? id,
    int? categoryId,
    int? subcategoryId,
    dynamic makeId,
    dynamic modelId,
    String? classId,
    dynamic colorId,
    String? year,
    dynamic groupId,
    dynamic licExpDate,
    dynamic regExpDate,
    String? vehicleImage,
    String? color,
    dynamic type,
    int? deviceNumber,
    dynamic engineType,
    String? carNumber,
    String? carModel,
    dynamic horsePower,
    dynamic vin,
    dynamic licensePlate,
    dynamic mileage,
    int? inService,
    dynamic userId,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    dynamic intMileage,
    int? typeId,
    int? seats,
    int? bags,
    String? vehicletype,
    int? baseKm,
    int? baseTime,
    dynamic cost,
  }) =>
      Data(
        id: id ?? _id,
        categoryId: categoryId ?? _categoryId,
        subcategoryId: subcategoryId ?? _subcategoryId,
        makeId: makeId ?? _makeId,
        modelId: modelId ?? _modelId,
        classId: classId ?? _classId,
        colorId: colorId ?? _colorId,
        year: year ?? _year,
        groupId: groupId ?? _groupId,
        licExpDate: licExpDate ?? _licExpDate,
        regExpDate: regExpDate ?? _regExpDate,
        vehicleImage: vehicleImage ?? _vehicleImage,
        color: color ?? _color,
        type: type ?? _type,
        deviceNumber: deviceNumber ?? _deviceNumber,
        engineType: engineType ?? _engineType,
        carNumber: carNumber ?? _carNumber,
        carModel: carModel ?? _carModel,
        horsePower: horsePower ?? _horsePower,
        vin: vin ?? _vin,
        licensePlate: licensePlate ?? _licensePlate,
        mileage: mileage ?? _mileage,
        inService: inService ?? _inService,
        userId: userId ?? _userId,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        deletedAt: deletedAt ?? _deletedAt,
        intMileage: intMileage ?? _intMileage,
        typeId: typeId ?? _typeId,
        seats: seats ?? _seats,
        bags: bags ?? _bags,
        vehicletype: vehicletype ?? _vehicletype,
        baseKm: baseKm ?? _baseKm,
        baseTime: baseTime ?? _baseTime,
        cost: cost ?? _cost,
      );
  int? get id => _id;
  int? get categoryId => _categoryId;
  int? get subcategoryId => _subcategoryId;
  dynamic get makeId => _makeId;
  dynamic get modelId => _modelId;
  String? get classId => _classId;
  dynamic get colorId => _colorId;
  String? get year => _year;
  dynamic get groupId => _groupId;
  dynamic get licExpDate => _licExpDate;
  dynamic get regExpDate => _regExpDate;
  String? get vehicleImage => _vehicleImage;
  String? get color => _color;
  dynamic get type => _type;
  int? get deviceNumber => _deviceNumber;
  dynamic get engineType => _engineType;
  String? get carNumber => _carNumber;
  String? get carModel => _carModel;
  dynamic get horsePower => _horsePower;
  dynamic get vin => _vin;
  dynamic get licensePlate => _licensePlate;
  dynamic get mileage => _mileage;
  int? get inService => _inService;
  dynamic get userId => _userId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;
  dynamic get intMileage => _intMileage;
  int? get typeId => _typeId;
  int? get seats => _seats;
  int? get bags => _bags;
  String? get vehicletype => _vehicletype;
  int? get baseKm => _baseKm;
  int? get baseTime => _baseTime;
  dynamic get cost => _cost;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['category_id'] = _categoryId;
    map['subcategory_id'] = _subcategoryId;
    map['make_id'] = _makeId;
    map['model_id'] = _modelId;
    map['class_id'] = _classId;
    map['color_id'] = _colorId;
    map['year'] = _year;
    map['group_id'] = _groupId;
    map['lic_exp_date'] = _licExpDate;
    map['reg_exp_date'] = _regExpDate;
    map['vehicle_image'] = _vehicleImage;
    map['color'] = _color;
    map['type'] = _type;
    map['device_number'] = _deviceNumber;
    map['engine_type'] = _engineType;
    map['car_number'] = _carNumber;
    map['car_model'] = _carModel;
    map['horse_power'] = _horsePower;
    map['vin'] = _vin;
    map['license_plate'] = _licensePlate;
    map['mileage'] = _mileage;
    map['in_service'] = _inService;
    map['user_id'] = _userId;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    map['int_mileage'] = _intMileage;
    map['type_id'] = _typeId;
    map['seats'] = _seats;
    map['bags'] = _bags;
    map['vehicletype'] = _vehicletype;
    map['base_km'] = _baseKm;
    map['base_time'] = _baseTime;
    map['cost'] = _cost;
    return map;
  }
}
