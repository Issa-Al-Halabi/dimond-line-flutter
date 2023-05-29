import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/network/requests.dart';
import '../../../Data/Models/Driver_Models/CheckPaymentStatusModel.dart';

class CheckPaymentStatusProvider extends ChangeNotifier {
  CheckPaymentStatusModel data = CheckPaymentStatusModel();
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

  checkPayment(String payment_id) async {
    isLoading = true;
    data = await AppRequests.getEcashPaymentStatusRequest(payment_id);
    isLoading = false;
    notifyListeners();
  }
}