// import 'package:connectivity/connectivity.dart';
// import 'package:easy_localization/src/public_ext.dart';
// import 'package:flutter/material.dart';
import '../../../../widgets/loader_widget.dart';
// import 'package:diamond_line/Buisness_logic/provider/User_Provider/filter_vechile_provider.dart';
// import 'package:diamond_line/Presentation/widgets/bottom_icons.dart';
// import 'package:diamond_line/Presentation/widgets/container_widget.dart';
// import 'package:diamond_line/Presentation/widgets/container_widget2.dart';
// import 'package:diamond_line/Presentation/widgets/text.dart';
// import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
// import 'package:provider/provider.dart';
// import '../../../../../../constants.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'select_car.dart';
//
// class OutsideScreen extends StatefulWidget {
//   OutsideScreen({required this.categoryId, required this.subCategoryIdList, required this.titleList, Key? key}) : super(key: key);
//
//   String categoryId;
//   var subCategoryIdList;
//   var titleList;
//
//   @override
//   State<OutsideScreen> createState() => _OutsideScreenState();
// }
//
// class _OutsideScreenState extends State<OutsideScreen> {
//   String type = '';
//   bool showTime = false;
//   TimeOfDay selectedTime = TimeOfDay.now();
//   bool showDate = false;
//   DateTime selectedDate = DateTime.now();
//   bool _isNetworkAvail = true;
//   List vechileType =[];
//   List vechileImage =[];
//   List vechileId =[];
//   int filteredLength = 0;
//   String subCategory ='';
//   String to ='';
//
//
//   ///////////////////////// filter vechiles api //////////////////////////////////
//   Future<void> checkNetwork(String category_id, String subcategory_id, String seats, String bags, filterVechileProvider creat) async {
//     _isNetworkAvail = await isNetworkAvailable();
//     if (_isNetworkAvail) {
//       print("There is internet");
//       Loader.show(context, progressIndicator: LoaderWidget());
//       await creat.getFilterVechilesCategory(category_id, subcategory_id, seats, bags);
//       if (creat.data.error == false) {
//         Loader.hide();
//         for (int i =0 ; i< creat.data.data!.length; i++){
//           setState(() {
//             vechileImage.add(creat.data.data![i].vehicleImage);
//           vechileType.add(creat.data.data![i].vehicletype);
//           vechileId.add(creat.data.data![i].id);
//           });
//         }
//         print(vechileImage);
//         print(vechileType);
//         filteredLength = creat.data.data!.length;
//         setState(() {
//           Future.delayed(const Duration(seconds: 1)).then((_) async {
//             Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
//                                        SelectCar(
//                                         vechileImage : vechileImage,
//                                         vechileType : vechileType,
//                                         seats: seats,
//                                         bags: bags,
//                                         filteredLength: filteredLength,
//                                         date: getDate(),
//                                         // time: selectedTime.format(context),
//                                         time: getTime(selectedTime),
//                                         to: to,
//                                         categoryId: widget.categoryId,
//                                         subCategoryId: subCategory,
//                                         vechileId: vechileId,
//                                        )));
//           });
//         });
//       } else {
//         Loader.hide();
//         setSnackbar(creat.data.message.toString(), context);
//       }
//     } else {
//       setSnackbar("nointernet".tr(), context);
//       print("nointernet");
//     }
//   }
//
//     Future<bool> isNetworkAvailable() async {
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
//   String getTime(TimeOfDay tod) {
//     final now = DateTime.now();
//     final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
//     final format = DateFormat.jm();
//     return format.format(dt);
//   }
//
//   //  Select for Time
//   Future<TimeOfDay> _selectTime(BuildContext context) async {
//     final selected = await showTimePicker(
//       context: context,
//       initialTime: selectedTime,
//     );
//     if (selected != null && selected != selectedTime) {
//       setState(() {
//         selectedTime = selected;
//       });
//     }
//     return selectedTime;
//   }
//
//   String getDate() {
//     if (selectedDate == null) {
//       return 'select date';
//     } else {
//       return DateFormat('dd, MM, yyyy').format(selectedDate);
//     }
//   }
//
//   // Select for Date
//   Future<DateTime> _selectDate(BuildContext context) async {
//     final selected = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
// //      firstDate: DateTime(2000),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2030),
//     );
//     if (selected != null && selected != selectedDate) {
//       setState(() {
//         selectedDate = selected;
//       });
//     }
//     return selectedDate;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//           height: getScreenHeight(context),
//           width: getScreenWidth(context),
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(background),
//               fit: BoxFit.fill,
//             ),
//           ),
//           child: Padding(
//             padding: EdgeInsets.only(top: 9.h),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Container(
//                     height: 82.h,
//                     width: getScreenWidth(context),
//                     decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.3),
//                           spreadRadius: 2,
//                           blurRadius: 7,
//                           offset: const Offset(0, 0),
//                         ),
//                       ],
//                       borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(20),
//                           topRight: Radius.circular(20)),
//                       color: backgroundColor,
//                     ),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: 5.h,
//                           ),
//                           myText(
//                             text: 'outside'.tr(),
//                             fontSize: 7.sp,
//                             color: primaryBlue,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           SizedBox(
//                             height: 2.h,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Expanded(
//                                 child: RadioListTile(
//                                   title: myText(
//                                     // text: "jordan".tr(),
//                                     text: widget.titleList[0],
//                                     fontSize: 5.sp,
//                                     color: primaryBlue,
//                                   ),
//                                   value: "Jordan".tr(),
//                                   groupValue: type,
//                                   activeColor: primaryBlue,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       type = value.toString();
//                                       to = widget.titleList[0];
//                                       // print(type);
//                                       subCategory = widget.subCategoryIdList[0];
//                                       print(subCategory);
//                                     });
//                                   },
//                                 ),
//                               ),
//                               Expanded(
//                                 child: RadioListTile(
//                                   title: myText(
//                                     // text: "lebanon".tr(),
//                                     text: widget.titleList[1],
//                                     fontSize: 5.sp,
//                                     color: primaryBlue,
//                                   ),
//                                   value: "Lebanon".tr(),
//                                   groupValue: type,
//                                   activeColor: primaryBlue,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       type = value.toString();
//                                       to = widget.titleList[1];
//                                       subCategory = widget.subCategoryIdList[1];
//                                       print(subCategory);
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const Divider(
//                             color: lightBlue2,
//                             thickness: 7,
//                             indent: 35,
//                             endIndent: 45,
//                           ),
//                           SizedBox(
//                             height: 2.h,
//                           ),
//                           // Container(
//                           //   height: 6.h,
//                           //   width: 80.w,
//                           //   decoration: BoxDecoration(
//                           //     boxShadow: [
//                           //       BoxShadow(
//                           //         color: Colors.grey.withOpacity(0.3),
//                           //         spreadRadius: 2,
//                           //         blurRadius: 7,
//                           //         offset: Offset(0, 0),
//                           //       ),
//                           //     ],
//                           //     borderRadius:
//                           //         const BorderRadius.all(Radius.circular(100)),
//                           //     color: backgroundColor,
//                           //   ),
//                           //   child: DropdownButton(
//                           //     underline:
//                           //         DropdownButtonHideUnderline(child: Container()),
//                           //     isExpanded: true,
//                           //     hint: Padding(
//                           //       padding: EdgeInsets.only(left: 5.w),
//                           //       child: Text(
//                           //         'from'.tr(),
//                           //         style: TextStyle(color: grey, fontSize: 4.sp),
//                           //       ),
//                           //     ),
//                           //     value: dropDownValueFrom,
//                           //     icon: Padding(
//                           //       padding: EdgeInsets.only(right: 1.w),
//                           //       child: const Icon(Icons.keyboard_arrow_down),
//                           //     ),
//                           //     items: fromItems.map((String items) {
//                           //       return DropdownMenuItem(
//                           //         value: items,
//                           //         child: Padding(
//                           //             padding: EdgeInsets.only(left: 1.w),
//                           //             child: Text(items.tr())),
//                           //       );
//                           //     }).toList(),
//                           //     onChanged: (val) {
//                           //       setState(() {
//                           //         dropDownValueFrom = val.toString();
//                           //       });
//                           //     },
//                           //   ),
//                           // ),
//
//                           SizedBox(
//                             height: 2.h,
//                           ),
//                           Container(
//                             height: 6.h,
//                             width: 80.w,
//                             decoration: BoxDecoration(
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.3),
//                                   spreadRadius: 2,
//                                   blurRadius: 7,
//                                   offset: const Offset(0, 0),
//                                 ),
//                               ],
//                               borderRadius:
//                                   const BorderRadius.all(Radius.circular(100)),
//                               color: backgroundColor,
//                             ),
//                             child: DropdownButton(
//                               underline: DropdownButtonHideUnderline(
//                                   child: Container()),
//                               isExpanded: true,
//                               hint: Padding(
//                                 padding: EdgeInsets.only(left: 5.w),
//                                 child: Text(
//                                   'person'.tr(),
//                                   style: TextStyle(color: grey, fontSize: 4.sp),
//                                 ),
//                               ),
//                               value: dropDownValue,
//                               icon: Padding(
//                                 padding: EdgeInsets.only(right: 1.w),
//                                 child: const Icon(Icons.keyboard_arrow_down),
//                               ),
//                               items: personItems.map((String items) {
//                                 return DropdownMenuItem(
//                                   value: items,
//                                   child: Padding(
//                                       padding: EdgeInsets.only(left: 1.w),
//                                       child: Text(items)),
//                                 );
//                               }).toList(),
//                               onChanged: (val) {
//                                 setState(() {
//                                   dropDownValue = val.toString();
//                                 });
//                               },
//                             ),
//                           ),
//                           SizedBox(
//                             height: 2.h,
//                           ),
//                           Container(
//                             height: 6.h,
//                             width: 80.w,
//                             decoration: BoxDecoration(
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.grey.withOpacity(0.3),
//                                   spreadRadius: 2,
//                                   blurRadius: 7,
//                                   offset: Offset(0, 0),
//                                 ),
//                               ],
//                               borderRadius:
//                                   const BorderRadius.all(Radius.circular(100)),
//                               color: backgroundColor,
//                             ),
//                             child: DropdownButton(
//                               underline: DropdownButtonHideUnderline(
//                                   child: Container()),
//                               isExpanded: true,
//                               hint: Padding(
//                                 padding: EdgeInsets.only(left: 5.w),
//                                 child: Text(
//                                   'bags'.tr(),
//                                   style: TextStyle(color: grey, fontSize: 4.sp),
//                                 ),
//                               ),
//                               value: dropDownValue2,
//                               icon: Padding(
//                                 padding: EdgeInsets.only(right: 2.w),
//                                 child: const Icon(Icons.keyboard_arrow_down),
//                               ),
//                               items: bagsItems.map((String items) {
//                                 return DropdownMenuItem(
//                                   value: items,
//                                   child: Padding(
//                                       padding: EdgeInsets.only(left: 1.w),
//                                       child: Text(items)),
//                                 );
//                               }).toList(),
//                               onChanged: (val) {
//                                 setState(() {
//                                   dropDownValue2 = val.toString();
//                                 });
//                               },
//                             ),
//                           ),
//                           SizedBox(
//                             height: 2.h,
//                           ),
//                           const Divider(
//                             color: lightBlue2,
//                             thickness: 7,
//                             indent: 35,
//                             endIndent: 45,
//                           ),
//                           SizedBox(
//                             height: 2.h,
//                           ),
//                           ContainerWidget2(
//                             text: 'select date'.tr(),
//                             h: 6.h,
//                             w: 80.w,
//                             onTap: () {
//                               _selectDate(context);
//                               showDate = true;
//                             },
//                             color: backgroundColor,
//                             textColor: lightBlue,
//                           ),
//                           showDate
//                               ? Center(child: Text(getDate()))
//                               : const SizedBox(),
//                           SizedBox(
//                             height: 2.h,
//                           ),
//                           ContainerWidget2(
//                             text: 'select time'.tr(),
//                             h: 6.h,
//                             w: 80.w,
//                             onTap: () {
//                               _selectTime(context);
//                               showTime = true;
//                             },
//                             color: backgroundColor,
//                             textColor: lightBlue,
//                           ),
//                           showTime
//                               ? Center(child: Text(getTime(selectedTime)))
//                               : const SizedBox(),
//                           SizedBox(
//                             height: 5.h,
//                           ),
//                           ContainerWidget(
//                             text: 'done'.tr(),
//                             h: 6.h,
//                             w: 80.w,
//                             onTap:()  async {
//                               print('*******************');
//                               print(to);
//                               print('selectedTime');
//                               print(selectedTime);
//                               if (widget.categoryId != '' && subCategory != '' && dropDownValue != null && dropDownValue2 != null){
//                               print(subCategory);
//                               var filterVechiles = await Provider.of<filterVechileProvider>(context, listen: false);
//                                     print('checkNetwork');
//                                     checkNetwork(widget.categoryId, subCategory, dropDownValue!, dropDownValue2!,filterVechiles);
//                             }
//                             else{
//                               setSnackbar('please enter all fields'.tr(), context);
//                             }
//                             },
//                             color: backgroundColor,
//                           ),
//                           SizedBox(
//                             height: 2.h,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 3.h,
//                   ),
//                   // Row(
//                   //   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   //   children: [
//                   //         InkWell(
//                   //         child: ImageIcon(
//                   //           const AssetImage(choices),
//                   //           color: backgroundColor,
//                   //           size: iconSize,
//                   //         ),
//                   //         onTap: (){
//                   //           Navigator.pushNamed(context, 'user_settings');
//                   //         },
//                   //       ),
//                   //     ImageIcon(
//                   //       const AssetImage(notification),
//                   //       color: backgroundColor,
//                   //       size: iconSize,
//                   //     ),
//                   //     ImageIcon(
//                   //     const AssetImage(search),
//                   //     color: backgroundColor,
//                   //     size: iconSize,
//                   //   ),
//                   //   ],
//                   // ),
//                   BottomIcons(),
//                 ],
//               ),
//             ),
//           )),
//     );
//   }
// }
