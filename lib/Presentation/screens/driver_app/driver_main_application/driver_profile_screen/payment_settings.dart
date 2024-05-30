// import 'package:connectivity/connectivity.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:diamond_line/Presentation/widgets/bottom_icons_driver.dart';
// import 'package:diamond_line/Presentation/widgets/container_widget.dart';
// import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
// import 'package:provider/provider.dart';
// import '../../../../../../constants.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../../Buisness_logic/provider/Driver_Provider/payment_provider.dart';
// import '../../../../Widgets/text.dart';
// import '../driver_main_screen/paymentScreen.dart';
//
// class PaymentSettings extends StatefulWidget {
//   const PaymentSettings({Key? key}) : super(key: key);
//
//   @override
//   State<PaymentSettings> createState() => _PaymentSettingsState();
// }
//
// class _PaymentSettingsState extends State<PaymentSettings> {
//
//   bool _isNetworkAvail = true;
//   late final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
//   late List tripsList;
//   String msg ='';
//
//
//   @override
//   void initState() {
//     init();
//     _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
//     super.initState();
//   }
//
//   Future<void> init() async {
//     tripsList = [];
//     var creat= await Provider.of<PaymentProvider>(context, listen: false);
//     await paymentApi(creat);
//   }
//
//   ////////////////////payment api///////////////////////////
//   //TODO
//   Future<void> paymentApi(PaymentProvider creat) async {
//     _isNetworkAvail = await isNetworkAvailable();
//     if (_isNetworkAvail) {
//       print("There is internet");
//       Loader.show(context, progressIndicator: LoaderWidget());
//       await creat.payment();
//       print(creat.data.error);
//       print(creat.data.message);
//       if (creat.data.error == false) {
//           for (int i = 0; i < creat.data.data!.length; i++) {
//             setState(() {
//               tripsList.add(creat.data.data![i]);
//             });
//         }
//         print('laaaaaaaayan');
//         print(tripsList);
//         Loader.hide();
//         setState(() {
//           msg = creat.data.message.toString();
//           // setSnackbar(msg, context);
//         });
//       } else {
//         Loader.hide();
//         print(creat.data.message);
//         setState(() {
//           msg = creat.data.message.toString();
//           setSnackbar(msg, context);
//         });
//       }
//     } else {
//       setSnackbar("nointernet".tr(), context);
//       Future.delayed(const Duration(seconds: 2)).then((_) async {
//         if (mounted) {
//           setState(() {
//             _isNetworkAvail = false;
//           });
//         }
//       });
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
//       content: Text(
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
//                   child: RefreshIndicator(
//                     color: primaryBlue,
//                     key: _refreshIndicatorKey,
//                     onRefresh: init,
//                     child: tripsList.length == 0
//                         ? Center(
//                         child: myText(
//                           //TODO
//                           // text: 'there are no trips to add a remitt'.tr(),
//                           text: msg.tr(),
//                           fontSize: 7.sp,
//                           color: primaryBlue,
//                           fontWeight: FontWeight.bold,
//                         ))
//                         : Column(
//                       children: [
//                         Expanded(
//                           flex: 8,
//                           child: ListView.builder(
//                               itemCount: tripsList.length,
//                               itemBuilder:
//                                   (BuildContext context, int index) {
//                                 return Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.center,
//                                   children: [
//                                     SizedBox(
//                                       width: 3.w,
//                                     ),
//                                     Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: 1.h),
//                                         child:
//                                         Container(
//                                           width: 80.w,
//                                           decoration: BoxDecoration(
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: Colors.grey
//                                                     .withOpacity(0.3),
//                                                 spreadRadius: 2,
//                                                 blurRadius: 7,
//                                                 offset:
//                                                 const Offset(0, 0),
//                                               ),
//                                             ],
//                                             borderRadius:
//                                             const BorderRadius.all(
//                                                 Radius.circular(20)),
//                                             color: backgroundColor,
//                                           ),
//                                           child: SingleChildScrollView(
//                                             child: Column(
//                                               children: [
//                                                 SizedBox(
//                                                   height: 1.h,
//                                                 ),
//                                                 tripsList[index]
//                                                     .categoryId
//                                                     .toString() !=
//                                                     '2'
//                                                     ? Center(
//                                                   child: myText(
//                                                       text: tripsList[
//                                                       index]
//                                                           .requestType
//                                                           .toString()
//                                                           .tr(),
//                                                       fontSize:
//                                                       5.sp,
//                                                       color:
//                                                       primaryBlue,
//                                                       fontWeight:
//                                                       FontWeight
//                                                           .w600),
//                                                 )
//                                                     : Container(),
//                                                 tripsList[index]
//                                                     .requestType !=
//                                                     'moment'
//                                                     ? ListTile(
//                                                     leading:
//                                                     const Icon(
//                                                       Icons
//                                                           .date_range,
//                                                       color:
//                                                       primaryBlue,
//                                                     ),
//                                                     title: Text(
//                                                       tripsList[index]
//                                                           .date
//                                                           .toString()
//                                                           .split(' ')
//                                                           .first,
//                                                       style:
//                                                       TextStyle(
//                                                         color: grey,
//                                                         fontSize:
//                                                         5.sp,
//                                                       ),
//                                                     ))
//                                                     :
//                                                 // Container(),
//                                                 ListTile(
//                                                     leading:
//                                                     const Icon(
//                                                       Icons
//                                                           .date_range,
//                                                       color:
//                                                       primaryBlue,
//                                                     ),
//                                                     title: Text(
//                                                       tripsList[index]
//                                                           .createdAt
//                                                           .toString()
//                                                           .split(' ')
//                                                           .first,
//                                                       style:
//                                                       TextStyle(
//                                                         color: grey,
//                                                         fontSize:
//                                                         5.sp,
//                                                       ),
//                                                     )),
//                                                 // tripsList[index].requestType.toString =='moment' ?
//                                                 tripsList[index]
//                                                     .requestType !=
//                                                     'moment'
//                                                     ? ListTile(
//                                                     leading:
//                                                     Image.asset(
//                                                       clock,
//                                                       color:
//                                                       primaryBlue,
//                                                     ),
//                                                     title: Text(
//                                                       tripsList[index]
//                                                           .time
//                                                           .toString(),
//                                                       style:
//                                                       TextStyle(
//                                                         color: grey,
//                                                         fontSize:
//                                                         5.sp,
//                                                       ),
//                                                     ))
//                                                     :
//                                                 // Container(),
//                                                 ListTile(
//                                                     leading:
//                                                     Image.asset(
//                                                       clock,
//                                                       color:
//                                                       primaryBlue,
//                                                     ),
//                                                     title: Text(
//                                                       tripsList[index]
//                                                           .createdAt
//                                                           .toString()
//                                                           .split(' ')
//                                                           .last,
//                                                       style:
//                                                       TextStyle(
//                                                         color: grey,
//                                                         fontSize:
//                                                         5.sp,
//                                                       ),
//                                                     )),
//                                                 ListTile(
//                                                     leading: const Icon(
//                                                       Icons.location_on,
//                                                       color: primaryBlue,
//                                                     ),
//                                                     title:
//                                                     tripsList[
//                                                     index]
//                                                         .categoryId
//                                                         .toString() ==
//                                                         '2'
//                                                         ?
//                                                     // tripsList[index]
//                                                     //     .requestType !=
//                                                     //     'moment'
//                                                     //     ?
//                                                     Text(
//                                                       // "from damascus to aleppo",
//                                                       // 'from damascus to'
//                                                       //     .tr() +
//                                                       //     ' ${tripsList[index].title.toString()}',
//                                                       'from'.tr() +
//                                                           ' ${tripsList[index].from.toString()}' +
//                                                           ' ' +
//                                                           'to'.tr() +
//                                                           ' ${tripsList[index].to.toString()}',
//                                                       style:
//                                                       TextStyle(
//                                                         color:
//                                                         grey,
//                                                         fontSize:
//                                                         5.sp,
//                                                       ),
//                                                     )
//                                                         : Text(
//                                                       // "from damascus to aleppo",
//                                                       'from'.tr() +
//                                                           ' ' +
//                                                           ' ${tripsList[index].pickupAddr.toString()}' +
//                                                           ' ' +
//                                                           'to'.tr() +
//                                                           ' ' +
//                                                           '${tripsList[index].destAddr.toString()}',
//                                                       style:
//                                                       TextStyle(
//                                                         color:
//                                                         grey,
//                                                         fontSize:
//                                                         5.sp,
//                                                       ),
//                                                     )),
//                                                 // tripsList[index]
//                                                 //     .categoryId
//                                                 //     .toString() ==
//                                                 //     '2'
//                                                 //     ? ListTile(
//                                                 //   leading:
//                                                 //   const Icon(
//                                                 //     Icons
//                                                 //         .directions,
//                                                 //     color:
//                                                 //     primaryBlue,
//                                                 //   ),
//                                                 //   title: Text(
//                                                 //     ' ${tripsList[index].direction.toString()}',
//                                                 //     style:
//                                                 //     TextStyle(
//                                                 //       color: grey,
//                                                 //       fontSize:
//                                                 //       5.sp,
//                                                 //     ),
//                                                 //   ),
//                                                 // )
//                                                 //     : Container(),
//                                                 // SizedBox(
//                                                 //   height: 1.h,
//                                                 // ),
//                                                 ListTile(
//                                                   leading: const Icon(
//                                                     Icons.money,
//                                                     color: primaryBlue,
//                                                   ),
//                                                   title: Text(
//                                                     // ' ${tripsList[index].cost.toString()}' +
//                                                     //     'sp'.tr(),
//                                                     formatter.format(int.parse(tripsList[index].cost.toString())) + 'sp'.tr(),
//                                                     style: TextStyle(
//                                                       color: grey,
//                                                       fontSize: 5.sp,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   height: 1.h,
//                                                 ),
//                                                 ContainerWidget(text: 'pay'.tr(),
//                                                     h: 5.h,
//                                                     w: 50.w,
//                                                     onTap: (){
//                                                   print(tripsList[index].id.toString());
//                                                       Navigator.of(context).push(
//                                                         PageRouteBuilder(
//                                                           pageBuilder: (BuildContext context,
//                                                               Animation<double> animation,
//                                                               Animation<double> secondaryAnimation) {
//                                                             return PaymentTripScreen(tripId: tripsList[index].id.toString(),);
//                                                           },
//                                                           transitionsBuilder: (BuildContext context,
//                                                               Animation<double> animation,
//                                                               Animation<double> secondaryAnimation,
//                                                               Widget child) {
//                                                             return Align(
//                                                               child: SizeTransition(
//                                                                 sizeFactor: animation,
//                                                                 child: child,
//                                                               ),
//                                                             );
//                                                           },
//                                                           transitionDuration:
//                                                           Duration(milliseconds: 500),
//                                                         ),
//                                                       );
//                                                     }),
//                                                 SizedBox(
//                                                   height: 3.h,
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                       //     :
//                                       // Container(),
//                                     ),
//                                     SizedBox(
//                                       width: 3.w,
//                                     )
//                                   ],
//                                 );
//                               }),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 3.h,
//                 ),
//                 BottomIconsDriver(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }