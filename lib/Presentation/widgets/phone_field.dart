// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:intl_phone_field/phone_number.dart';
// import '../../constants.dart';

// class PhoneField extends StatefulWidget {
//   PhoneField({required this.initCountryCode, required this.onchange, Key? key})
//       : super(key: key);

//   final String? initCountryCode;
//   ValueChanged<PhoneNumber>? onchange;

//   @override
//   State<PhoneField> createState() => _PhoneFieldState();
// }

// class _PhoneFieldState extends State<PhoneField> {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           height: 7.h,
//           width: 80.w,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 // color: yellow,
//                 ///////
//                 color: Colors.grey.withOpacity(0.3),
//                 spreadRadius: 2,
//                 blurRadius: 7,
//                 offset: Offset(0, 0),
//               ),
//             ],
//             borderRadius: BorderRadius.all(Radius.circular(15)),
//           ),
//         ),
//         SizedBox(
//           height: 9.h,
//           width: 80.w,
//           child: Padding(
//             padding: EdgeInsets.only(left: 5.w),
//             child: IntlPhoneField(
//               initialCountryCode: widget.initCountryCode,
//               onChanged: widget.onchange,
//               cursorColor: primaryBlue,
//               controller: phoneController,
//               decoration: InputDecoration(
//                 focusedBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsetsDirectional.only(top: 2.h),
//                 ////////
//                 suffixIcon: IconButton(
//                   // icon: ImageIcon(
//                   //     AssetImage(exit),
//                   //     color: grey,
//                   //     size: iconSize,

//                   //   ),
//                   icon: Icon(Icons.exit_to_app, color: grey, size: iconSize,),
//                     onPressed: (){
//                       setState(() {
//                         phoneController.text = '';
//                       });

//                     },),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }



import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../../constants.dart';

class PhoneField extends StatefulWidget {
  PhoneField({required this.txt,required this.onSaved, this.validateFunction, Key? key})
      : super(key: key);
  TextEditingController txt = TextEditingController();
  String? Function(String?)? onSaved ;
  String? Function(String?)? validateFunction;

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 7.h,
      width: 80.w,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(

            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(child: Image.asset(syria)),
        Expanded(child: Text('+963')),
        Expanded(
          flex: 3,
          // child: TextFormField(
          //   controller: phoneController,
          //   decoration: InputDecoration(
          //   focusedBorder: InputBorder.none,
          //   enabledBorder: InputBorder.none,
          //   border: InputBorder.none,
          //   contentPadding: EdgeInsetsDirectional.only(top: 2.h),
          //   ),
          //   // onChanged: (value){
          //   //   setState(() {
          //   //     phoneController.text=value;
          //   //   });
          //   //   print(phoneController.text);
          //   // },
          //   onSaved: (value){
          //     setState(() {
          //       phoneController.text=value!;
          //     });
          //     print(phoneController.text);

          //   },
          // ),
      child: TextFormField(
              controller: widget.txt,
              maxLength: 9,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                contentPadding: EdgeInsetsDirectional.only(top: 4.h),
                errorStyle: TextStyle(fontSize: 4.sp, height: 0.01.h),
                fillColor: Colors.white,
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 5.sp,
                ),
                suffixIcon: IconButton(
                  alignment: Alignment.bottomCenter,
                  icon:  const Icon(
                          Icons.exit_to_app,
                          color: Colors.grey,
                        ),
                  onPressed: () {
                    setState(() {
                      phoneController.text = '';
                      print(phoneController.text);
                    });
                  },
                ),
                border: InputBorder.none,
              ),
              validator: widget.validateFunction,
              onSaved: widget.onSaved,
              // onChanged: (value) {
              //   phoneController.text=value;
              //   print(phoneController.text);
              // },
            ),
        ),
      ],
    ),
    );
  }
}
