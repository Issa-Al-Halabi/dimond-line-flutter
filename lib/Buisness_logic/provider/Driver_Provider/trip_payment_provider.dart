import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/network/requests.dart';
import '../../../Data/Models/Driver_Models/trip_payment_model.dart';

class TripPaymentProvider extends ChangeNotifier {
  TripPaymentModel data = TripPaymentModel();
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

  tripPayment(
      // String trip_id,
      String method, String amount) async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.tripPaymentRequest(
        // trip_id,
        method, amount);
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }

  tripPaymentTransfer(
      // String trip_id,
      String method, String amount, File imageFile) async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.tripPaymentTransferRequest(
        // trip_id,
        method, amount, imageFile);
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}
