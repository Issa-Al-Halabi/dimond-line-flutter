import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:diamond_line/Data/network/requests.dart';
import '../../../Data/Models/Driver_Models/ChargeWalletModel.dart';

class ChargeWalletProvider extends ChangeNotifier {
  ChargeWalletModel data = ChargeWalletModel();
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

  chargeWallet(String method, String amount) async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.chargeWalletRequest(method, amount);
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }

  chargeWalletTransfer(String method, String amount, File imageFile) async {
    print("layan Test");
    isLoading = true;
    data = await AppRequests.chargeWalletTransferRequest(method, amount, imageFile);
    print("loaddding");
    isLoading = false;
    notifyListeners();
  }
}