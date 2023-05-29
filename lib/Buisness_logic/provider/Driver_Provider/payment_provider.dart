import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/network/requests.dart';
import '../../../Data/Models/Driver_Models/payment_model.dart';

class PaymentProvider extends ChangeNotifier {
  PaymentModel data = PaymentModel();
  late bool isLoading = true;
  late bool hasError = false;
  static late String token;

  changeIsLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void changeHasError() {
    hasError = !hasError;
    notifyListeners();
  }

  payment() async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.paymentRequest();
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
