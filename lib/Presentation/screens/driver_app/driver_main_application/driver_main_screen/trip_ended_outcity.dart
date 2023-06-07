import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_profile_screen/expenses.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Functions/helper.dart';
import 'driver_dashboard.dart';
import 'outcity_driver_trips.dart';

class TripOutCityEndedScreen extends StatefulWidget {
  TripOutCityEndedScreen(
      {required this.tripId, required this.finalCost, required this.adminFare, Key? key})
      : super(key: key);

  String tripId;
  String finalCost;
  String adminFare;

  @override
  State<TripOutCityEndedScreen> createState() => _TripOutCityEndedScreenState();
}

class _TripOutCityEndedScreenState extends State<TripOutCityEndedScreen> {
  bool _isNetworkAvail = true;
  String msg = '';
  String rate = '';
  TextEditingController commmentController = TextEditingController();
  List<String> types = [];
  List<String> prices = [];
  TextEditingController typeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  int count = 0;
  late SharedPreferences prefs;
  String typeOfDriver = '';

  @override
  void initState() {
    initShared();
    super.initState();
  }

  Future initShared() async {
    prefs = await SharedPreferences.getInstance();
    typeOfDriver = await prefs.getString('type_of_customer') ?? '';
    print('type_of_customer');
    print(typeOfDriver);
  }

  /////////////////////////// get rating api //////////////////////////////////
  Future<void> getRatingApi(
      String trip_id, String review_text, String ratings) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      print(trip_id);
      print(review_text);
      print(ratings);
      print(userIdForTripOutcity);
      Loader.show(context, progressIndicator: LoaderWidget());
      var data = await AppRequests.reviewDriverRequest(
          trip_id, review_text, ratings, userIdForTripOutcity!);
      data = json.decode(data);
      print(data["error"]);
      if (data["error"] == false) {
        Loader.hide();
        if (mounted) {
          setState(() {
            msg = data["message"];
            setSnackbar(msg, context);
            print(msg);
          });
        }
      } else {
        Loader.hide();
        if (mounted) {
          setState(() {
            msg = data["message"];
            setSnackbar(msg, context);
            print(msg);
          });
        }
      }
    } else {
      setSnackbar("nointernet".tr(), context);
    }
  }

  /////////////////////////// add expenses api //////////////////////////////////
  Future<void> addExpensesApi(String trip_id, List type, List price) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      var data = await AppRequests.tripExpensesRequest(trip_id, type, price);
      data = json.decode(data);
      print(data["error"]);
      if (data["error"] == false) {
        Loader.hide();
        if (mounted) {
          setState(() {
            msg = data["message"];
            setSnackbar(msg, context);
            print(msg);
          });
        }
      } else {
        Loader.hide();
        if (mounted) {
          setState(() {
            msg = data["message"];
            setSnackbar(msg, context);
            print(msg);
          });
        }
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
                            height: 2.h,
                          ),
                          Center(
                              child: myText(
                                text: 'we arrived'.tr(),
                                fontSize: 6.sp,
                                color: primaryBlue,
                              )),
                          SizedBox(
                            height: 1.h,
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
                          SizedBox(
                            height: 4.h,
                          ),
                          myText(
                              text: 'final cost'.tr(),
                              fontSize: 5.sp,
                              color: primaryBlue),
                          SizedBox(
                            height: 1.h,
                          ),
                      Container(
                        height: 7.h,
                        width: 70.w,
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
                              Radius.circular(20)),
                          color: white,
                        ),
                        child: Center(
                          child: myText(
                              text: formatter
                                      .format(
                                      double.parse(widget.finalCost))
                                      .toString() +
                                  'sp'.tr(),
                              fontSize: 6.sp,
                              color: primaryBlue,
                              fontWeight: FontWeight.w600),
                        ),
                      ),

                          SizedBox(
                            height: 2.h,
                          ),
                          myText(
                              text: 'admin fare'.tr(),
                              fontSize: 5.sp,
                              color: primaryBlue),
                          SizedBox(
                            height: 1.h,
                          ),
                          Container(
                            height: 7.h,
                            width: 70.w,
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
                                  Radius.circular(20)),
                              // color: backgroundColor,
                              color: white,
                              // primaryBlue,
                            ),
                            child: Center(
                              child: myText(
                                  text: formatter
                                      .format(
                                      double.parse(widget.adminFare))
                                      .toString() +
                                      'sp'.tr(),
                                  fontSize: 6.sp,
                                  color: primaryBlue,
                              fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          typeOfDriver == 'driver'
                              ? InkWell(
                                  child: Container(
                                      height: 7.h,
                                      width: 70.w,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: grey.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 7,
                                            offset: const Offset(0, 0),
                                          ),
                                        ],
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        color: primaryBlue2
                                      ),
                                      child: Center(
                                          child: myText(
                                              text: 'add expenses'.tr(),
                                              fontSize: 6.sp,
                                              color: white))),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation) {
                                          return Expenses(
                                            tripId: widget.tripId,
                                          );
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
                                        transitionDuration:
                                            Duration(milliseconds: 500),
                                      ),
                                    );
                                  },
                                )
                              : Container(height: 0.h),
                          SizedBox(
                            height: 3.h,
                          ),
                          myText(
                              text: 'rate the user please'.tr(),
                              fontSize: 5.sp,
                              color: primaryBlue),
                          SizedBox(
                            height: 1.h,
                          ),
                          RatingBar.builder(
                            initialRating: 1,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 35,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                              setState(() {
                                rate = rating.toString();
                              });
                            },
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.w, right: 10.w),
                              child: TextFormField(
                                controller: commmentController,
                                // obscureText: true,
                                decoration: InputDecoration(
                                  errorStyle:
                                      TextStyle(fontSize: 4.sp, height: 0.01.h),
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 5.sp,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.edit,
                                    color: grey,
                                    size: 25,
                                  ),
                                  hintText: 'tap your comment please'.tr(),
                                ),
                                onChanged: (value) {},
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Container(
                            width: 30.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                              color: backgroundColor,
                            ),
                            child: TextButton(
                              child: Text(
                                'send rate'.tr(),
                                style: TextStyle(
                                    color: primaryBlue, fontSize: 4.5.sp),
                              ),
                              onPressed: () {
                                print(commmentController.text);
                                print(rate);
                                print(widget.tripId);
                                getRatingApi(
                                    widget.tripId, commmentController.text, rate);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Container(
                            width: 35.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: primaryBlue.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              color: primaryBlue,
                            ),
                            child: Center(
                              child: TextButton(
                                child: Text(
                                  'exit'.tr(),
                                  style: TextStyle(
                                      color: backgroundColor, fontSize: 5.sp),
                                ),
                                onPressed: () {
                                  if (typeOfDriver == 'driver') {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double> secondaryAnimation) {
                                          return DriverDashboard(driverType: 'driver');
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
                                  } else {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double> secondaryAnimation) {
                                          return DriverDashboard(driverType: 'external_driver',);
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
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                        ],
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