import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import '../../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/filter_vechile_provider.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/outside_city_trips/select_car_outcity.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:diamond_line/Presentation/widgets/container_widget2.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../Functions/helper.dart';

class OutsideCityScreen extends StatefulWidget {
  OutsideCityScreen(
      {this.categoryId,
      this.subCategoryId,
      this.distance,
      this.timeOfTrip,
      this.fromLat,
      this.fromLon,
      this.toLat,
      this.toLon,
      this.to,
      Key? key})
      : super(key: key);

  String? subCategoryId;

  String? categoryId;
  String? timeOfTrip;
  String? distance;
  String? fromLat;
  String? fromLon;
  String? toLat;
  String? toLon;
  String? to;

  @override
  State<OutsideCityScreen> createState() => _OutsideCityScreenState();
}

class _OutsideCityScreenState extends State<OutsideCityScreen> {
  String? type;
  bool showTime = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  bool showDate = false;
  DateTime selectedDate = DateTime.now();
  bool _isNetworkAvail = true;
  List vechileType = [];
  List vechileImage = [];
  List vechileId = [];
  List carModel = [];
  List priceList = [];
  int filteredLength = 0;

  ///////////////////////// filter vechiles api //////////////////////////////////
  Future<void> checkNetwork(String category_id, String subcategory_id,
      String seats, String bags, filterVechileProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.getFilterVechilesCategory(category_id, subcategory_id, seats,
          bags, widget.distance.toString(), widget.timeOfTrip.toString());
      if (creat.data.error == false) {
        Loader.hide();
        print('@@@@@@@@@@@@@');
        print(creat.data.data!.length);
        print('@@@@@@@@@@@@@');

        vechileImage.clear();
        vechileType.clear();
        vechileId.clear();
        carModel.clear();
        priceList.clear();

        for (int i = 0; i < creat.data.data!.length; i++) {
          setState(() {
            vechileImage.add(creat.data.data![i].vehicleImage);
            vechileType.add(creat.data.data![i].vehicletype);
            vechileId.add(creat.data.data![i].id.toString());
            carModel.add(creat.data.data![i].carModel);
            priceList.add(creat.data.data![i].cost);
          });
        }
        filteredLength = creat.data.data!.length;
        setState(() {
          log({
            "vechileImage": vechileImage,
            "vechileType": vechileType,
            "carModel": carModel,
            "seats": seats,
            "bags": bags,
            "filteredLength": filteredLength,
            "date": getDate(),
            "time": getTime(selectedTime),
            "to": widget.to!,
            "categoryId": widget.categoryId!,
            "subCategoryId": widget.subCategoryId!,
            "vechileId": vechileId,
            "fromLat": widget.fromLat,
            "fromLon": widget.fromLon,
            "distance": widget.distance,
            "timeOfTrip": widget.timeOfTrip,
            "toLat": widget.toLat,
            "toLon": widget.toLon,
            "priceList": priceList,
          }.toString());

          Future.delayed(const Duration(seconds: 1)).then((_) async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SelectCarOutCity(
                  vechileImage: vechileImage,
                  vechileType: vechileType,
                  carModel: carModel,
                  seats: seats,
                  bags: bags,
                  filteredLength: filteredLength,
                  date: getDate(),
                  time: getTime(selectedTime),
                  to: widget.to!,
                  categoryId: widget.categoryId!,
                  subCategoryId: widget.subCategoryId!,
                  vechileId: vechileId,
                  fromLat: widget.fromLat,
                  fromLon: widget.fromLon,
                  distance: widget.distance,
                  timeOfTrip: widget.timeOfTrip,
                  toLat: widget.toLat,
                  toLon: widget.toLon,
                  priceList: priceList,
                ),
              ),
            );
          });
        });
      } else {
        Loader.hide();
        setSnackbar(creat.data.message.toString(), context);
      }
    } else {
      setSnackbar("nointernet".tr(), context);
      print("nointernet");
    }
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

  setSnackbar(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 3),
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: primaryBlue),
      ),
      backgroundColor: white,
      elevation: 1.0,
    ));
  }

  String getTime(TimeOfDay tod) {
    return '${tod.hour}:${tod.minute} ${tod.period.toString().split('.')[1]}';
  }

  //  Select for Time
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
      });
    }
    return selectedTime;
  }

  String getDate() {
    if (selectedDate == null) {
      return 'select date'.tr();
    } else {
      print('selectedDate $selectedDate');
      return DateFormat('yyyy-MM-dd', 'en_US').format(selectedDate);
    }
  }

  // Select for Date
  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      // firstDate: DateTime(2000),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
    return selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPopLoader,
      child: Scaffold(
        body: Container(
            height: getScreenHeight(context),
            width: getScreenWidth(context),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(background),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 9.h),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 82.h,
                      width: getScreenWidth(context),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 0),
                          ),
                        ],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: backgroundColor,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5.h,
                            ),
                            myText(
                              // text: 'inside'.tr(),
                              text: 'outside city'.tr(),
                              fontSize: 7.sp,
                              color: primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            const Divider(
                              color: lightBlue2,
                              thickness: 7,
                              indent: 35,
                              endIndent: 45,
                            ),
                            SizedBox(
                              height: 6.h,
                            ),
                            Container(
                              height: 6.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                                color: backgroundColor,
                              ),
                              child: DropdownButton(
                                underline: DropdownButtonHideUnderline(
                                    child: Container()),
                                isExpanded: true,
                                hint: Padding(
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: Text(
                                    'person'.tr(),
                                    style:
                                        TextStyle(color: grey, fontSize: 4.sp),
                                  ),
                                ),
                                value: dropDownValue,
                                icon: Padding(
                                  padding: EdgeInsets.only(right: 1.w),
                                  child: const Icon(Icons.keyboard_arrow_down),
                                ),
                                items: personItems.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Padding(
                                        padding: EdgeInsets.only(left: 1.w),
                                        child:
                                            Text('person'.tr() + " " + items)),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    dropDownValue = val.toString();
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Container(
                              height: 6.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100)),
                                color: backgroundColor,
                              ),
                              child: DropdownButton(
                                underline: DropdownButtonHideUnderline(
                                    child: Container()),
                                isExpanded: true,
                                hint: Padding(
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: Text(
                                    'bags'.tr(),
                                    style:
                                        TextStyle(color: grey, fontSize: 4.sp),
                                  ),
                                ),
                                value: dropDownValue2,
                                icon: Padding(
                                  padding: EdgeInsets.only(right: 2.w),
                                  child: const Icon(Icons.keyboard_arrow_down),
                                ),
                                items: bagsItems.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Padding(
                                        padding: EdgeInsets.only(left: 1.w),
                                        child: Text('bags'.tr() + " " + items)),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    dropDownValue2 = val.toString();
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 2.h),
                            const Divider(
                              color: lightBlue2,
                              thickness: 7,
                              indent: 35,
                              endIndent: 45,
                            ),
                            SizedBox(height: 2.h),
                            ContainerWidget2(
                              text: 'select date'.tr(),
                              h: 6.h,
                              w: 80.w,
                              onTap: () {
                                _selectDate(context);
                                showDate = true;
                              },
                              color: backgroundColor,
                              textColor: lightBlue,
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            showDate
                                ? Center(
                                    child: myText(
                                    text: getDate(),
                                    fontSize: 4.sp,
                                    color: primaryBlue,
                                  ))
                                : const SizedBox(),
                            SizedBox(
                              height: 2.h,
                            ),
                            ContainerWidget2(
                              text: 'select time'.tr(),
                              h: 6.h,
                              w: 80.w,
                              onTap: () {
                                _selectTime(context);
                                showTime = true;
                              },
                              color: backgroundColor,
                              textColor: lightBlue,
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            showTime
                                ? Center(
                                    child: myText(
                                    text: getTime(selectedTime),
                                    fontSize: 4.sp,
                                    color: primaryBlue,
                                  ))
                                : const SizedBox(),
                            SizedBox(height: 5.h),
                            ContainerWidget(
                              text: 'done'.tr(),
                              h: 6.h,
                              w: 60.w,
                              onTap: () async {
                                print('selectedTime');
                                print(selectedTime);
                                print(selectedDate);
                                if (selectedTime != DateTime.now() &&
                                    selectedDate != DateTime.now() &&
                                    dropDownValue != null &&
                                    dropDownValue2 != null) {
                                  var creat =
                                      await Provider.of<filterVechileProvider>(
                                          context,
                                          listen: false);

                                  checkNetwork(
                                    widget.categoryId!,
                                    widget.subCategoryId!,
                                    dropDownValue.toString(),
                                    dropDownValue2.toString(),
                                    creat,
                                  );
                                } else {
                                  setSnackbar(
                                      'please enter all fields'.tr(), context);
                                }
                              },
                              color: backgroundColor,
                            ),
                            SizedBox(height: 6.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
