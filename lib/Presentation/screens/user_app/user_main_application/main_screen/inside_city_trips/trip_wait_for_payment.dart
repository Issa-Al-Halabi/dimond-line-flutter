import 'package:connectivity/connectivity.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/inside_city_trips/trip_ended.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../constants.dart';
import '../../../../../Functions/helper.dart';
import '../../../../../widgets/loader_widget.dart';

class TripWaitForPaymentUserScreen extends StatefulWidget {
  TripWaitForPaymentUserScreen(
      {required this.tripId, required this.finalCost, Key? key})
      : super(key: key);

  String tripId;
  String finalCost;

  @override
  State<TripWaitForPaymentUserScreen> createState() =>
      _TripEndedUserScreenState();
}

class _TripEndedUserScreenState extends State<TripWaitForPaymentUserScreen> {
  bool _isNetworkAvail = true;
  String msg = '';
  String rate = '';
  TextEditingController commmentController = TextEditingController();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
  }

  /////////////////////////// create Fatora Payment api //////////////////////////////////
  Future<void> createFatoraPaymentRequest() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      var data = await AppRequests.createFatoraPaymentRequest(
        booking_id: widget.tripId,
        amount: widget.finalCost,
      );

      if (data != null && data["error"] == false) {
        Loader.hide();
        if (mounted) {
          final Uri fatoraPaymentUrl = Uri.parse(data["data"]["url"]);
          print(fatoraPaymentUrl);
          if (await canLaunchUrl(fatoraPaymentUrl)) {
            await launchUrl(fatoraPaymentUrl);
          } else {
            setSnackbar("حدث خطا ما عند الاتصال بوابة الدفع", context);
          }
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

  /////////////////////////// pay In Cash api //////////////////////////////////
  Future<void> choosePaymentMethodRequest(String payment_method) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      var data = await AppRequests.choosePaymentMethodRequest(
        booking_id: widget.tripId,
        payment_method: payment_method,
      );

      if (data != null && payment_method == "cash") {
        Loader.hide();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => TripEndedUserScreen(
                      finalCost: widget.finalCost,
                      tripId: widget.tripId,
                    )),
          );
        });
      } else {
        Loader.hide();
        if (mounted) {
          setState(() {
            msg = "حدث خطأ ما";
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
                            text: 'Choose Your Payment Way'.tr(),
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

                          // fatora

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
                                'Fatora Payment'.tr(),
                                style: TextStyle(
                                    color: backgroundColor, fontSize: 5.sp),
                              ),
                              onPressed: () {
                                choosePaymentMethodRequest("e_payment");
                                createFatoraPaymentRequest();
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
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
                                'Cash Payment'.tr(),
                                style: TextStyle(
                                    color: backgroundColor, fontSize: 5.sp),
                              ),
                              onPressed: () {
                                choosePaymentMethodRequest("cash");
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
