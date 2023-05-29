import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

placeHolder(double height) {
  return AssetImage(
    'assets/images/logo.png',
  );
}

erroWidget(double size) {
  return Image.asset(
    'assets/images/logo.png',
    height: 12.h,
    width: 25.w,

    // height: size,
    // width: size,
  );
}

Future<bool> isNetworkAvailable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}