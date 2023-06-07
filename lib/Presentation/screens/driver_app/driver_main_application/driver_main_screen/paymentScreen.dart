// import 'dart:convert';
// import 'dart:io';
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:easy_localization/src/public_ext.dart';
// import 'package:flutter/material.dart';
import '../../../../widgets/loader_widget.dart';
// import 'package:diamond_line/Presentation/widgets/bottom_icons_driver.dart';
// import 'package:diamond_line/Presentation/widgets/text.dart';
// import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../../../Buisness_logic/provider/Driver_Provider/trip_payment_provider.dart';
// import '../../../../../constants.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'dart:async';
// import 'package:crypto/crypto.dart';
// import '../../../../widgets/container_widget.dart';
// import 'driver_dashboard.dart';
// import 'ecash_webview.dart';
// import 'external_driver_screen.dart';
// import 'internal_driver_screen.dart';
//
// class PaymentScreen extends StatefulWidget {
//   PaymentScreen({Key? key}) : super(key: key);
//
//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   bool _isNetworkAvail = true;
//   String type = '';
//   TextEditingController amountController = TextEditingController();
//   final picker = ImagePicker();
//   File? imageFile;
//   late SharedPreferences prefs;
//   String typeOfDriver = '';
//
//   @override
//   void initState() {
//     initShared();
//     super.initState();
//   }
//
//   Future initShared() async {
//     prefs = await SharedPreferences.getInstance();
//     typeOfDriver = prefs.getString('type_of_customer') ?? '';
//     print('type_of_customer');
//     print(typeOfDriver);
//   }
//
//   /////////////////////////// trip payment api //////////////////////////////////
//   Future<void> tripPaymentApi(
//       String method, String amount, TripPaymentProvider creat) async {
//     _isNetworkAvail = await isNetworkAvailable();
//     if (_isNetworkAvail) {
//       print("There is internet");
//       Loader.show(context, progressIndicator: LoaderWidget());
//       await creat.tripPayment(method, amount);
//       if (creat.data.error == false) {
//         Loader.hide();
//         setState(() {
//           setSnackbar(creat.data.message.toString(), context);
//           setSnackbar('your request is in process, please wait'.tr(), context);
//           Future.delayed(const Duration(seconds: 2)).then((_) async {
//             if (typeOfDriver == 'driver') {
//               Navigator.of(context).push(
//                 PageRouteBuilder(
//                   pageBuilder: (BuildContext context,
//                       Animation<double> animation,
//                       Animation<double> secondaryAnimation) {
//                     // return InDriverMainScreen();
//                     return DriverDashboard(driverType: 'driver',);
//                   },
//                   transitionsBuilder: (BuildContext context,
//                       Animation<double> animation,
//                       Animation<double> secondaryAnimation,
//                       Widget child) {
//                     return Align(
//                       child: SizeTransition(
//                         sizeFactor: animation,
//                         child: child,
//                       ),
//                     );
//                   },
//                   transitionDuration: Duration(milliseconds: 500),
//                 ),
//               );
//             } else {
//               Navigator.of(context).push(
//                 PageRouteBuilder(
//                   pageBuilder: (BuildContext context,
//                       Animation<double> animation,
//                       Animation<double> secondaryAnimation) {
//                     // return OutDriverMainScreen();
//                     return DriverDashboard(driverType: 'external_driver',);
//                   },
//                   transitionsBuilder: (BuildContext context,
//                       Animation<double> animation,
//                       Animation<double> secondaryAnimation,
//                       Widget child) {
//                     return Align(
//                       child: SizeTransition(
//                         sizeFactor: animation,
//                         child: child,
//                       ),
//                     );
//                   },
//                   transitionDuration: Duration(milliseconds: 500),
//                 ),
//               );
//             }
//           });
//         });
//       } else {
//         Loader.hide();
//         setState(() {
//           setSnackbar(creat.data.message.toString(), context);
//         });
//       }
//     } else {
//       setSnackbar("nointernet".tr(), context);
//     }
//   }
//
//   /////////////////////////// trip payment api //////////////////////////////////
//   Future<void> tripPaymentTransferApi(String method, String amount,
//       File imageFile, TripPaymentProvider creat) async {
//     _isNetworkAvail = await isNetworkAvailable();
//     if (_isNetworkAvail) {
//       print("There is internet");
//       Loader.show(context, progressIndicator: LoaderWidget());
//       await creat.tripPaymentTransfer(method, amount, imageFile);
//       if (creat.data.error == false) {
//         Loader.hide();
//         setState(() {
//           setSnackbar(creat.data.message.toString(), context);
//           Future.delayed(const Duration(seconds: 2)).then((_) async {
//             if (typeOfDriver == 'driver') {
//               Navigator.of(context).push(
//                 PageRouteBuilder(
//                   pageBuilder: (BuildContext context,
//                       Animation<double> animation,
//                       Animation<double> secondaryAnimation) {
//                     // return InDriverMainScreen();
//                     return DriverDashboard(driverType: 'driver',);
//                   },
//                   transitionsBuilder: (BuildContext context,
//                       Animation<double> animation,
//                       Animation<double> secondaryAnimation,
//                       Widget child) {
//                     return Align(
//                       child: SizeTransition(
//                         sizeFactor: animation,
//                         child: child,
//                       ),
//                     );
//                   },
//                   transitionDuration: Duration(milliseconds: 500),
//                 ),
//               );
//             } else {
//               Navigator.of(context).push(
//                 PageRouteBuilder(
//                   pageBuilder: (BuildContext context,
//                       Animation<double> animation,
//                       Animation<double> secondaryAnimation) {
//                     // return OutDriverMainScreen();
//                     return DriverDashboard(driverType: 'external_driver',);
//                   },
//                   transitionsBuilder: (BuildContext context,
//                       Animation<double> animation,
//                       Animation<double> secondaryAnimation,
//                       Widget child) {
//                     return Align(
//                       child: SizeTransition(
//                         sizeFactor: animation,
//                         child: child,
//                       ),
//                     );
//                   },
//                   transitionDuration: Duration(milliseconds: 500),
//                 ),
//               );
//             }
//           });
//         });
//       } else {
//         Loader.hide();
//         if (mounted) {
//           setState(() {
//             setSnackbar(creat.data.message.toString(), context);
//           });
//         }
//       }
//     } else {
//       setSnackbar("nointernet".tr(), context);
//     }
//   }
//
//   Future<bool> isNetworkAvailable() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.mobile) {
//       return true;
//     } else if (connectivityResult == ConnectivityResult.wifi) {
//       return true;
//     }
//     return false;
//   }
//
//   setSnackbar(String msg, BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       duration: Duration(seconds: 3),
//       content: new Text(
//         msg,
//         textAlign: TextAlign.center,
//         style: TextStyle(color: primaryBlue),
//       ),
//       backgroundColor: white,
//       elevation: 1.0,
//     ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: getScreenHeight(context),
//         width: getScreenWidth(context),
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(background),
//             fit: BoxFit.fill,
//           ),
//         ),
//         child: Padding(
//           padding: EdgeInsets.only(top: 9.h),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                   height: 82.h,
//                   width: getScreenWidth(context),
//                   decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         spreadRadius: 2,
//                         blurRadius: 7,
//                         offset: const Offset(0, 0),
//                       ),
//                     ],
//                     borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(20),
//                         topRight: Radius.circular(20)),
//                     color: backgroundColor,
//                   ),
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 3.w),
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: 10.h,
//                           ),
//                           Container(
//                             height: 7.h,
//                             width: 80.w,
//                             decoration: BoxDecoration(
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: primaryBlue.withOpacity(0.3),
//                                   spreadRadius: 2,
//                                   blurRadius: 7,
//                                   offset: const Offset(0, 0),
//                                 ),
//                               ],
//                               borderRadius:
//                                   const BorderRadius.all(Radius.circular(20)),
//                               color: backgroundColor,
//                             ),
//                             child: Center(
//                               child: myText(
//                                   text: 'choose the charge wallet'.tr(),
//                                   fontSize: 5.sp,
//                                   color: primaryBlue,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 5.h,
//                           ),
//                           RadioListTile(
//                             title: myText(
//                               text: "cash".tr(),
//                               fontSize: 5.sp,
//                               color: primaryBlue,
//                             ),
//                             value: "cash",
//                             groupValue: type,
//                             activeColor: primaryBlue,
//                             onChanged: (value) {
//                               setState(() {
//                                 type = "cash";
//                               });
//                             },
//                           ),
//                           // RadioListTile(
//                           //   title: myText(
//                           //     text: "ecash".tr(),
//                           //     fontSize: 5.sp,
//                           //     color: primaryBlue,
//                           //   ),
//                           //   value: "ecash",
//                           //   groupValue: type,
//                           //   activeColor: primaryBlue,
//                           //   onChanged: (value) {
//                           //     // setState(() {
//                           //     //   type = value.toString();
//                           //     // });
//                           //     setState(() {
//                           //       // type = "ecash".tr();
//                           //       type = "ecash";
//                           //     });
//                           //   },
//                           // ),
//                           RadioListTile(
//                             title: myText(
//                               text: "transfer".tr(),
//                               fontSize: 5.sp,
//                               color: primaryBlue,
//                             ),
//                             value: "transfer",
//                             groupValue: type,
//                             activeColor: primaryBlue,
//                             onChanged: (value) {
//                               // setState(() {
//                               //   type = value.toString();
//                               // });
//                               setState(() {
//                                 type = "transfer";
//                               });
//                             },
//                           ),
//                           SizedBox(
//                             height: 7.h,
//                           ),
//                           Center(
//                             child: Padding(
//                               padding: EdgeInsets.only(left: 10.w, right: 10.w),
//                               child: TextFormField(
//                                 controller: amountController,
//                                 keyboardType: TextInputType.number,
//                                 decoration: InputDecoration(
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         width: 1.0, color: lightBlue),
//                                     borderRadius: BorderRadius.circular(25),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         width: 1.0, color: lightBlue),
//                                     borderRadius: BorderRadius.circular(25),
//                                   ),
//                                   errorStyle:
//                                       TextStyle(fontSize: 4.sp, height: 0.01.h),
//                                   fillColor: Colors.white,
//                                   hintStyle: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 5.sp,
//                                   ),
//                                   suffixIcon: Icon(
//                                     Icons.money,
//                                     color: primaryBlue,
//                                     size: 25,
//                                   ),
//                                   hintText: 'tap your amount please'.tr(),
//                                 ),
//                                 onChanged: (value) {},
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10.h,
//                           ),
//                           Container(
//                             width: 40.w,
//                             height: 8.h,
//                             decoration: BoxDecoration(
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: primaryBlue.withOpacity(0.3),
//                                   spreadRadius: 2,
//                                   blurRadius: 7,
//                                   offset: const Offset(0, 0),
//                                 ),
//                               ],
//                               borderRadius:
//                                   const BorderRadius.all(Radius.circular(20)),
//                               color: primaryBlue,
//                             ),
//                             child: TextButton(
//                                 child: Text(
//                                   'submit'.tr(),
//                                   style: TextStyle(
//                                       color: backgroundColor, fontSize: 7.sp),
//                                 ),
//                                 onPressed: () async {
//                                   print(type);
//                                   print(amountController.text);
//                                   if (amountController.text != '') {
//                                     if (type == 'ecash') {
//                                       createPaymentEcash(
//                                           // widget.tripId
//                                           );
//                                     } else if (type == 'transfer') {
//                                       getDialog();
//                                     } else {
//                                       var creat =
//                                           Provider.of<TripPaymentProvider>(
//                                               context,
//                                               listen: false);
//                                       tripPaymentApi(
//                                           type, amountController.text, creat);
//                                     }
//                                   } else {
//                                     setSnackbar(
//                                         'The amount field is required'.tr(),
//                                         context);
//                                   }
//                                 }),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 // SizedBox(
//                 //   height: 3.h,
//                 // ),
//                 // BottomIconsDriver(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   String generateMd5(String data) {
//     var value = md5.convert(utf8.encode(data)).toString();
//     print(value);
//     return value;
//   }
//
// // e cash
//   Future<void> createPaymentEcash(// String tripId
//       ) async {
//     // int amount = totalPriceN.toInt();
//
//     // String baseUrl = 'https://checkout.ecash-pay.co',
//     String baseUrl = 'https://checkout.ecash-pay.com',
//         // MerchantId = '1SVIFW',
//         MerchantId = '9H6X9I',
//         // MerchantSecret = 'HS8K64XVOTS1F2XKEBKHCUH7R8UH9P12CEYKTRF2P9Y9WEOCJHNFXK54OEMCAXG1',
//         MerchantSecret =
//             'ILUDZGWVMJT9M6Y5DSOOLE889LZBJV8STZB7D2OJF1C56FLS0PLEV64CBDV3F7HL',
//         // TerminalKey ='RXUFG8',
//         TerminalKey = 'VWZV9T',
//         Amount = amountController.text.toString(),
//         // Amount = '1500',
//         //TODO
//         // tripRef = tripId,
//         tripRef = '',
//         // OrderRef = "108",
//         // CallBackUrl = 'https%3A%2F%2F7adyaty.com%2Fapp%2Fv1%2Fapi%2Fecash_payment',
//         CallBackUrl =
//             "https%3A%2F%2Fhadyati.sy%2Fapp%2Fv1%2Fapi%2Fecash_payment",
//         // RedirectUrl = 'https%3A%2F%2Fhadyati.sy%2Fhadyati%2F',
//         RedirectUrl = "https%3A%2F%2Fhadyati.sy%2Fhadyati%2F",
//         data = '$MerchantId$MerchantSecret$Amount$tripRef',
//         VerificationCode = generateMd5(data);
//     print('VerificationCode after crypto ' + VerificationCode);
//     VerificationCode = VerificationCode.toUpperCase();
//     print('VerificationCode after crypto and uppercase ' + VerificationCode);
//
//     String url =
//         '$baseUrl/Checkout/Card/$TerminalKey/$MerchantId/$VerificationCode/SYP/$Amount/EN/$tripRef/$RedirectUrl/$CallBackUrl';
//     // String url ='$baseUrl/Checkout/Card/$TerminalKey/$MerchantId/$VerificationCode/SYP/$Amount/EN/$OrderRef';
//     print('this url\n');
//     print(url);
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (BuildContext context) => EcashWebView(
//                 url: url,
//                 tripRef: tripRef,
//                 // tripId: tripId,
//                 //TODO
//                 tripId: '',
//                 total: Amount,
//                 VerificationCode: VerificationCode)));
//   }
//
//   void getDialog() {
//     AwesomeDialog(
//       context: context,
//       animType: AnimType.SCALE,
//       btnOkColor: primaryBlue,
//       dialogType: DialogType.NO_HEADER,
//       padding: const EdgeInsets.all(10),
//       body: StatefulBuilder(
//         builder: (context, setState) {
//           return Column(
//             children: [
//               SizedBox(
//                 height: 2.h,
//               ),
//               ContainerWidget(
//                   text: 'camera'.tr(),
//                   h: 6.h,
//                   w: 60.w,
//                   onTap: () async {
//                     var im = await picker.pickImage(source: ImageSource.camera);
//                     if (im != null) {
//                       setState(() {
//                         imageFile = File(im.path);
//                       });
//                       print('+++++++++++++');
//                       print(imageFile);
//                       print(type);
//                       print(amountController.text);
//                       var creat = Provider.of<TripPaymentProvider>(context,
//                           listen: false);
//                       tripPaymentTransferApi(
//                           type, amountController.text, imageFile!, creat);
//                     } else {
//                       setSnackbar('please select image'.tr(), context);
//                     }
//                   }),
//               SizedBox(
//                 height: 2.h,
//               ),
//               ContainerWidget(
//                   text: 'choose file'.tr(),
//                   h: 6.h,
//                   w: 60.w,
//                   onTap: () async {
//                     var im =
//                         await picker.pickImage(source: ImageSource.gallery);
//                     if (im != null) {
//                       setState(() {
//                         imageFile = File(im.path);
//                       });
//                       print('+++++++++++++');
//                       print(imageFile);
//                       var creat = Provider.of<TripPaymentProvider>(context,
//                           listen: false);
//                       tripPaymentTransferApi(
//                           type, amountController.text, imageFile!, creat);
//                     } else {
//                       setSnackbar('please select image'.tr(), context);
//                     }
//                   }),
//               SizedBox(
//                 height: 2.h,
//               ),
//             ],
//           );
//         },
//       ),
//     ).show();
//   }
// }
