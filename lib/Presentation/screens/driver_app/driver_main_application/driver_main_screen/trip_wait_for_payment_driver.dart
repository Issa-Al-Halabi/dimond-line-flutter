import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:diamond_line/Buisness_logic/provider/Driver_Provider/wait_for_payment_provider.dart';
import 'package:diamond_line/Presentation/Functions/firebase_notification.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_main_screen/trip_ended.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Functions/helper.dart';

class TripWaitForPaymentDriverScreen extends StatefulWidget {
  TripWaitForPaymentDriverScreen(
      {required this.tripId,
      required this.finalCost,
      required this.adminFare,
      required this.endTime,
      required this.finalDistance,
      Key? key})
      : super(key: key);

  final String tripId;
  final String finalCost;
  final String adminFare;
  final String endTime;
  final String finalDistance;

  @override
  State<TripWaitForPaymentDriverScreen> createState() =>
      TripWaitForPaymentDriverScreenState();
}

class TripWaitForPaymentDriverScreenState
    extends State<TripWaitForPaymentDriverScreen> {
  bool _isNetworkAvail = true;
  String msg = '';
  String rate = '';
  TextEditingController commmentController = TextEditingController();
  late SharedPreferences prefs;
  String typeOfDriver = '';
  bool is_loading = false;

  @override
  void initState() {
    initShared();

    super.initState();
  }

  Future initShared() async {
    prefs = await SharedPreferences.getInstance();
    typeOfDriver = prefs.getString('type_of_customer') ?? '';
    print('type_of_customer');
    print(typeOfDriver);
  }

  /////////////////////////trip end api //////////////////////////////////
  Future<void> endTripApi(
      String trip_id, String end_time, String finalDistance) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      Loader.show(context, progressIndicator: LoaderWidget());
      var data =
          await AppRequests.endTripRequest(trip_id, end_time, finalDistance);
      print(data);
      data = json.decode(data);
      if (data["error"] == false) {
        Loader.hide();
        setSnackbar(data["message"].toString(), context);
        setState(() {
          is_loading = true;
          // totalPrice = data["data"]["new_cost"].toString();
          // adminFare = data["data"]["admin_fare"].toString();
          // Navigator.of(context).push(
          // Provider.of<WaitForPaymentProvider>(context).reset();

          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return TripEndedScreen(
                  tripId: widget.tripId,
                  finalCost: data["data"]["new_cost"].toString(),
                  adminFare: data["data"]["admin_fare"].toString(),
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
              transitionDuration: Duration(milliseconds: 500),
            ),
          );
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
                            text: 'Wait the user to choose Payment method'.tr(),
                            fontSize: 6.sp,
                            color: primaryBlue,
                            align: TextAlign.center,
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              // color: backgroundColor,
                              color: white,
                              // primaryBlue,
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
                            height: 10.h,
                          ),
                          Container(
                            width: 70.w,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
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
                              // color: backgroundColor,
                              color: white,
                              // primaryBlue,
                            ),
                            child: Consumer<WaitForPaymentProvider>(
                                builder: (context, provider, child) {
                              if (provider.tripData.isNotEmpty &&
                                  widget.tripId == provider.tripId) {
                                String payment_status = provider.payment_status;
                                print(payment_status);

                                if (payment_status == "A" && !is_loading) {
                                  is_loading = true;
                                  endTripApi(widget.tripId, widget.endTime,
                                      widget.finalDistance);
                                }

                                String payment_method = provider.payment_method;
                                print(payment_method);

                                if (payment_method == "cash") {
                                  return provider.cashBuilder();
                                } else if (payment_method == "e_payment") {
                                  // fatora
                                  return provider.ePaymentBuilder();
                                }
                              }
                              return Text(
                                  "انتظر حتى يختار المستخدم عملية الدفع");
                            }),
                          ),
                          //cash
                          Container(
                            padding: EdgeInsets.all(10),
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
                            child: TextButton(
                              child: Text(
                                'تم الاستلام'.tr(),
                                style: TextStyle(
                                    color: backgroundColor, fontSize: 5.sp),
                              ),
                              onPressed: () {
                                endTripApi(widget.tripId, widget.endTime,
                                    widget.finalDistance);
                              },
                            ),
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
