/// message : " Completed Register Successfuly"
/// error : false

class DriverCompleteRegisterModel {
  DriverCompleteRegisterModel({
    String? message,
    bool? error,}){
    _message = message;
    _error = error;
  }

  DriverCompleteRegisterModel.fromJson(dynamic json) {
    _message = json['message'];
    _error = json['error'];
  }
  String? _message;
  bool? _error;
  DriverCompleteRegisterModel copyWith({  String? message,
    bool? error,
  }) => DriverCompleteRegisterModel(  message: message ?? _message,
    error: error ?? _error,
  );
  String? get message => _message;
  bool? get error => _error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['error'] = _error;
    return map;
  }

}