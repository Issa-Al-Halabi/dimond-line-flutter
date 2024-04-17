import 'package:flutter/cupertino.dart';

class InTripProvider extends ChangeNotifier {
  String tripStatus = "";
  Map<String, dynamic> tripData = {};

  setData(Map<String, dynamic> data) {
    tripData = data;
    tripStatus = data["status"];
    notifyListeners();
  }

  reset() {
    tripStatus = "";
  }
}
