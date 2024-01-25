import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants.dart';
import '../Widgets/text.dart';

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

Future<bool> willPopLoader() async {
  if (Loader.isShown == true) {
    Loader.hide();
    return true;
  } else {
    return true;
  }
}

// // Future<void> requestGalleryPermission() async {
// Future<bool> requestGalleryPermission() async {
//   // Check if permission is already granted
//   var status = await Permission.photos.status;
//
//   if (status.isGranted) {
//     // Permission is already granted
//     // You can now proceed to access the gallery
//     // ...
//     return true;
//   } else {
//     // Permission is not granted, request it
//     var result = await Permission.photos.request();
//
//     if (result.isGranted) {
//       // Permission granted
//       // You can now proceed to access the gallery
//       // ...
//       return true;
//     } else {
//       // Permission denied
//       // Handle accordingly (e.g., show a message to the user)
//       return false;
//     }
//   }
// }

// Future<void> requestGalleryPermission() async {
Future<bool> requestGalleryPermission() async {
  // Check if permission is already granted
  var status = await Permission.photos.status;

  if (status.isGranted) {
    // Permission is already granted
    // You can now proceed to access the gallery
    // ...
    return true;
  } else {
    // Permission is not granted, request it
    // var result = await Permission.photos.request();
    var result;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt! <= 32) {
        /// use [Permissions.storage.status]
         result = await Permission.storage.request();
      }  else {
        /// use [Permissions.photos.status]
         result = await Permission.photos.request();
      }
    }

    if (result.isGranted) {
      // Permission granted
      // You can now proceed to access the gallery
      // ...
      return true;
    } else {
      // Permission denied
      // Handle accordingly (e.g., show a message to the user)
      return false;
    }
  }
}

Future<bool> isAndroid13() async {
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  if (androidInfo.version.sdkInt! <= 32) {
    return false;
  }  else {
    return true;
  }
}

Future<PermissionStatus> requestCameraPermission() async {
  return await Permission.camera.request();
}


showWarningGalleryDialog(BuildContext context){
  showDialog(
      context: context,
      builder:  (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return AlertDialog(
            content: Container(
              height: 28.h,
              width: 50.w,
              child: Column(
                children: [
                  const SizedBox(
                    height: 3.0,
                  ),
                  myText(
                    text: 'enable gallery'.tr(),
                    fontSize: 5.sp,
                    color: primaryBlue,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child:  Container(
                      height: 5.h,
                      width: 30.w,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 0),
                          ),
                        ],
                        borderRadius: const BorderRadius.all( Radius.circular(20)),
                        color: primaryBlue,
                      ),
                      child: Center(child: myText(text: 'ok'.tr(), fontSize: 4.sp, color: Colors.white,)),
                    ),
                  ),
                  const SizedBox(
                    height: 3.0,
                  ),
                ],
              ),
            ),
          );
        });
      }
  );
}

