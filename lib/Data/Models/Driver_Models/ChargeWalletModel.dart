/// error : false
/// message : "The balance has been charged successfully"
/// data : {"id":3,"driver_id":"242","amount":8000,"new_amount":"3200","method":"transfer","transfare_image":"5517eb2b-63ba-4f9c-9b26-ef027238c7b8.jpg","created_at":"2022-12-12T09:08:39.000000Z","updated_at":"2023-05-02T13:29:56.000000Z"}

class ChargeWalletModel {
  ChargeWalletModel({
    bool? error,
    String? message,
    Data? data,
  }) {
    _error = error;
    _message = message;
    _data = data;
  }

  ChargeWalletModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _error;
  String? _message;
  Data? _data;
  ChargeWalletModel copyWith({
    bool? error,
    String? message,
    Data? data,
  }) =>
      ChargeWalletModel(
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

/// id : 3
/// driver_id : "242"
/// amount : 8000
/// new_amount : "3200"
/// method : "transfer"
/// transfare_image : "5517eb2b-63ba-4f9c-9b26-ef027238c7b8.jpg"
/// created_at : "2022-12-12T09:08:39.000000Z"
/// updated_at : "2023-05-02T13:29:56.000000Z"

class Data {
  Data({
    int? id,
    String? driverId,
    int? amount,
    String? newAmount,
    String? method,
    String? transfareImage,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _driverId = driverId;
    _amount = amount;
    _newAmount = newAmount;
    _method = method;
    _transfareImage = transfareImage;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _driverId = json['driver_id'];
    _amount = json['amount'];
    _newAmount = json['new_amount'];
    _method = json['method'];
    _transfareImage = json['transfare_image'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  int? _id;
  String? _driverId;
  int? _amount;
  String? _newAmount;
  String? _method;
  String? _transfareImage;
  String? _createdAt;
  String? _updatedAt;
  Data copyWith({
    int? id,
    String? driverId,
    int? amount,
    String? newAmount,
    String? method,
    String? transfareImage,
    String? createdAt,
    String? updatedAt,
  }) =>
      Data(
        id: id ?? _id,
        driverId: driverId ?? _driverId,
        amount: amount ?? _amount,
        newAmount: newAmount ?? _newAmount,
        method: method ?? _method,
        transfareImage: transfareImage ?? _transfareImage,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
  int? get id => _id;
  String? get driverId => _driverId;
  int? get amount => _amount;
  String? get newAmount => _newAmount;
  String? get method => _method;
  String? get transfareImage => _transfareImage;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['driver_id'] = _driverId;
    map['amount'] = _amount;
    map['new_amount'] = _newAmount;
    map['method'] = _method;
    map['transfare_image'] = _transfareImage;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
