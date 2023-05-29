import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/network/requests.dart';
import '../../../Data/Models/Driver_Models/ChargeWalletModel.dart';
import '../../../Data/Models/Driver_Models/CreatePaymentIdModel.dart';

class CreatePaymentIdProvider extends ChangeNotifier {
  CreatePaymentIdModel data = CreatePaymentIdModel();
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

  createId(String amount) async {
    isLoading = true;
    data = await AppRequests.createPaymentIdRequest(amount);
    isLoading = false;
    notifyListeners();
  }
}