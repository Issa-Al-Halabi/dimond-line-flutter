import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../Data/Models/Driver_Models/driver_trips_model.dart';
import '../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Functions/helper.dart';
import 'driver_dashboard.dart';
import 'user_location.dart';

String? sourceAddress = '';
String? destinationAddress = '';
List<LatLng> latLngList = [];

class TripInfoOutcityScreen extends StatefulWidget {
  TripInfoOutcityScreen(
      {required this.idTrip,
      required this.pickupAddTrip,
      required this.destAddrTrip,
      required this.fNameTrip,
      required this.lNameTrip,
      required this.phoneTrip,
      required this.priceTrip,
      required this.minTrip,
      required this.kmTrip,
      required this.pickupLatitude,
      required this.pickupLongitude,
      required this.dropLatitude,
      required this.dropLongitude,
      required this.profileImage,
      required this.hasExpense,
      required this.expensesList,
      this.time = '',
      this.date = '',
      Key? key})
      : super(key: key);

  String idTrip;
  String pickupAddTrip;
  String destAddrTrip;
  String fNameTrip;
  String lNameTrip;
  String phoneTrip;
  String priceTrip;
  String minTrip;
  String kmTrip;
  String time;
  String date;
  String hasExpense;
  String profileImage;
  String pickupLatitude, pickupLongitude, dropLatitude, dropLongitude;
  List<ExpenseDetail> expensesList = [];

  @override
  State<TripInfoOutcityScreen> createState() => _TripInfoOutcityScreenState();
}

class _TripInfoOutcityScreenState extends State<TripInfoOutcityScreen> {
  bool _isNetworkAvail = true;
  String typeOfDriver = '';
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initShared();
    sourceAddress = widget.pickupAddTrip;
    destinationAddress = widget.destAddrTrip;
  }

  Future initShared() async {
    prefs = await SharedPreferences.getInstance();
    typeOfDriver = await prefs.getString('type_of_customer') ?? '';
    print('type_of_customer');
    print(typeOfDriver);
  }

  /////////////////////////acceptTrip api //////////////////////////////////
  Future<void> acceptTripApi(
    String trip_id,
    String pickupLatitude,
    String pickupLongitude,
    String dropLatitude,
    String dropLongitude,
  ) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      var data = await AppRequests.acceptTripRequest(trip_id);
      print(data);
      data = json.decode(data);
      if (data["error"] == false) {
        Loader.hide();
        setSnackbar(data["message"].toString(), context);
        setState(() {
          Future.delayed(const Duration(seconds: 3)).then((_) async {
            if (typeOfDriver == 'driver') {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return DriverDashboard(driverType: 'driver',
                      index: 1,);
                  },
                  transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child) {
                    return Align(
                      child: SizeTransition(
                        sizeFactor: animation,
                        child: child,
                      ),
                    );
                  },
                  transitionDuration: Duration(milliseconds: 500),
                ),
              );
            }
            else {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return DriverDashboard(driverType: 'external_driver',
                    index: 1,);
                  },
                  transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child) {
                    return Align(
                      child: SizeTransition(
                        sizeFactor: animation,
                        child: child,
                      ),
                    );
                  },
                  transitionDuration: Duration(milliseconds: 500),
                ),
              );
            }
          });
        });
      } else {
        Loader.hide();
        setSnackbar(data["message"].toString(), context);
      }
    } else {
      setSnackbar("nointernet".tr(), context);
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

  getDialog(String image) async {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return FadeInImage(
                image: NetworkImage(image),
                height: 30.h,
                width: 90.w,
                imageErrorBuilder: (context, error, stackTrace) =>
                    erroWidget(100),
                placeholder: placeHolder(100),
              );
            }),
          );
        }).then((val) {});
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              width: 90.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                              ),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      Center(
                                          child: myText(
                                        text: 'info'.tr(),
                                        fontSize: 7.sp,
                                        color: primaryBlue,
                                      )),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Center(
                                        child: Container(
                                          height: 1.h,
                                          width: 70.w,
                                          decoration: BoxDecoration(
                                            color: lightBlue2,
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset(name,
                                              height: 6.h, width: 6.w),
                                          Text(
                                            '${widget.fNameTrip}' +
                                                ' ' +
                                                '${widget.lNameTrip}',
                                            style: TextStyle(
                                              color: primaryBlue,
                                              fontSize: 5.sp,
                                            ),
                                          ),
                                          InkWell(
                                              child: FadeInImage(
                                                image: NetworkImage(widget
                                                    .profileImage
                                                    .toString()),
                                                height: 10.h,
                                                width: 10.w,
                                                fit: BoxFit.contain,
                                                imageErrorBuilder: (context,
                                                        error, stackTrace) =>
                                                    erroWidget(100),
                                                placeholder: placeHolder(100),
                                              ),
                                              onTap: () {
                                                getDialog(widget.profileImage
                                                    .toString());
                                              }),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset(from,
                                              height: 6.h, width: 6.w),
                                            myText(
                                              text: '${widget.pickupAddTrip}',
                                              fontSize: 5.sp,
                                              color: primaryBlue,
                                            ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset(to,
                                              height: 6.h, width: 6.w),
                                            myText(
                                                text: '${widget.destAddrTrip}',
                                                fontSize: 5.sp,
                                                color: primaryBlue),
                                        ],
                                      ),
                                      widget.date != ''
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Image.asset(date,
                                                    height: 6.h, width: 6.w),
                                                SizedBox(
                                                  width: 12.w,
                                                ),
                                                myText(
                                                  text: widget.date,
                                                  fontSize: 5.sp,
                                                  color: primaryBlue,
                                                ),
                                              ],
                                            )
                                          : SizedBox(
                                              height: 0.h,
                                            ),
                                      widget.time != ''
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Image.asset(time,
                                                    height: 6.h, width: 6.w),
                                                SizedBox(
                                                  width: 12.w,
                                                ),
                                                myText(
                                                  text: widget.time,
                                                  fontSize: 5.sp,
                                                  color: primaryBlue,
                                                ),
                                              ],
                                            )
                                          : SizedBox(
                                              height: 0.h,
                                            ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset(km,
                                              height: 6.h, width: 6.w),
                                          SizedBox(
                                            width: 14.w,
                                          ),
                                          myText(
                                              text: '${widget.kmTrip}' +
                                                  ' ' +
                                                  'km2'.tr(),
                                              fontSize: 5.sp,
                                              color: primaryBlue),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset(time,
                                              height: 6.h, width: 6.w),
                                          SizedBox(
                                            width: 14.w,
                                          ),
                                          myText(
                                              text: '${widget.minTrip}' +
                                                  ' ' +
                                                  'min2'.tr(),
                                              fontSize: 5.sp,
                                              color: primaryBlue),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset(price,
                                              height: 6.h, width: 6.w),
                                          SizedBox(
                                            width: 14.w,
                                          ),
                                          myText(
                                              text: formatter.format(int.parse(
                                                      widget.priceTrip)) +
                                                  'sp'.tr(),
                                              fontSize: 5.sp,
                                              color: primaryBlue),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset(phone,
                                              height: 6.h, width: 6.w),
                                          InkWell(
                                            child: Text(
                                              '${widget.phoneTrip}',
                                              style: TextStyle(
                                                color: lightBlue4,
                                                fontSize: 5.sp,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                            onTap: () {
                                              launchUrl(Uri.parse(
                                                  "tel://+963 ${widget.phoneTrip}"));
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset(location,
                                              height: 6.h, width: 6.w),
                                          InkWell(
                                            child: Text(
                                              '${widget.pickupAddTrip}',
                                              style: TextStyle(
                                                color: lightBlue4,
                                                fontSize: 5.sp,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                            onTap: () {
                                              print(widget.pickupLatitude);
                                              print(widget.pickupLongitude);
                                              Navigator.of(context).push(
                                                PageRouteBuilder(
                                                  pageBuilder: (BuildContext
                                                          context,
                                                      Animation<double> animation,
                                                      Animation<double>
                                                          secondaryAnimation) {
                                                    return UserLocationScreen(
                                                      pickupLongitude:
                                                          widget.pickupLongitude,
                                                      pickupLatitude:
                                                          widget.pickupLatitude,
                                                      dropLatitude:
                                                          widget.dropLatitude,
                                                      dropLongitude:
                                                          widget.dropLongitude,
                                                    );
                                                  },
                                                  transitionsBuilder:
                                                      (BuildContext context,
                                                          Animation<double>
                                                              animation,
                                                          Animation<double>
                                                              secondaryAnimation,
                                                          Widget child) {
                                                    return Align(
                                                      child: SizeTransition(
                                                        sizeFactor: animation,
                                                        child: child,
                                                      ),
                                                    );
                                                  },
                                                  transitionDuration:
                                                      Duration(milliseconds: 500),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      widget.hasExpense == 'Yes'
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Icon(Icons.money,
                                                color: primaryBlue),
                                                Text(
                                                  'expens'.tr(),
                                                  style: TextStyle(
                                                    color: primaryBlue,
                                                    fontSize: 5.sp,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(),

                                      widget.hasExpense == 'Yes'
                                          ?
                                          Column(
                                              children: List.generate(
                                                  widget.expensesList[0].type!
                                                      .length,
                                                  (index) => Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          myText(
                                                              text: widget
                                                                      .expensesList[
                                                                          0]
                                                                      .type![index] +
                                                                  ' ',
                                                              fontSize: 5.sp,
                                                              color: primaryBlue),
                                                          myText(
                                                              text: formatter.format(
                                                                      int.parse(widget
                                                                          .expensesList[
                                                                              0]
                                                                          .price![index])) +
                                                                  'sp'.tr() +
                                                                  ' ',
                                                              fontSize: 5.sp,
                                                              color: primaryBlue)
                                                        ],
                                                      )),
                                            )
                                          : Container(),
                                      SizedBox(
                                        height: 4.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Center(
                                child: ContainerWidget(
                                    text: 'accept'.tr(),
                                    h: 6.h,
                                    w: 60.w,
                                    onTap: () {
                                      acceptTripApi(
                                        widget.idTrip,
                                        widget.pickupLatitude,
                                        widget.pickupLongitude,
                                        widget.dropLatitude,
                                        widget.dropLongitude,
                                      );
                                    })),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}