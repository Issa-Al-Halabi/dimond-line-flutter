import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants.dart';


class Validators{

  static bool validateImage(String fileName ){
    if(fileName.toLowerCase().endsWith('png') ||
        fileName.toLowerCase().endsWith('jpeg') ||
        fileName.toLowerCase().endsWith('jpg')
    ){
      return true;
    }
    else return false;
  }

  static String? validateEmptyValue(String? value){
    if (value == null || value.isEmpty) {
      return 'The text is empty'.tr();
    }
    return null;
  }

  static String?  validateMaxValue(String? value , int number){
    if (value == null || value.isEmpty) {
      return 'empty'.tr();
    }
    else if (value.length > number ) {
      return 'long'.tr();
    }
    return null;
  }

  static String?  validateNumber(String? value){
    if (value == null || value.isEmpty) {
      return 'empty'.tr();
    }
    else if (value.length > 12 ) {
      return 'long'.tr();
    }
    else if (value.length < 8 ) {
      return 'short'.tr();
    }

    if (value.length == 9) {
      if (int.tryParse(value) != null) {
        print('kkkk');
        return null;
      } else {
        print('zzzz');
        return 'nonNumeric'.tr();
      }
    }
    // return null;
  }

  static String? validatePhoneNumber(String? value){
    if (value == null || value.isEmpty) {
      return 'empty'.tr();
    }
    if (value?.startsWith('9') == false) {
      return 'start 9'.tr();
    }
    // if( value.length == 9)
    //   return null;

    if (value.length == 9) {
      if (int.tryParse(value) != null) {
        return null;
      } else {
        return 'nonNumeric'.tr();
      }
    }
    else if (value.length < 9)
      return "short".tr();
    else
      return "long".tr();
  }



  static String? validateName(String? value){
    if (value == null || value.isEmpty) {
      return 'empty'.tr();
    }
    if( value.length <= 2)
      return "short".tr();

    if (!value.contains(RegExp(r'^[a-zA-Z]+$'))) {
      return 'nonAlphabetic'.tr();
    }

    else if ( value.length <= 15)
      return null;
    else
      return "long".tr();
  }


  static String? validateEmail(String? value){
    if (value == null || value.isEmpty) {
      return 'empty'.tr();
    }
    if( value.length <= 10)
      return "weak".tr();
    else if (value.length < 30)
      return null ;
    else
      return "long".tr();
  }

//   static String? validatePassword(String? value){
//     if (value == null || value.isEmpty) {
//       return 'empty'.tr();
//     }
//     if( value.length < 8)
//       return "short".tr();
//     else if (value.length >= 8)
//       return null;
// //    else
// //      return "plong".tr();
//   }


  static String? validatePassword(String? value){
    if (value == null || value.isEmpty) {
      return 'empty'.tr();
    }
    if( value.length < 8)
      return "short".tr();
    else if (value.length >= 8){
      RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
      if (!regex.hasMatch(value)) {
        final Message = "weak pass".tr();
        Fluttertoast.showToast(
            msg: Message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: primaryBlue,
            textColor: white,
            fontSize: 5.sp);
        return 'Enter valid password'.tr();
      } else {
        return null;
      }
    }
  }
}