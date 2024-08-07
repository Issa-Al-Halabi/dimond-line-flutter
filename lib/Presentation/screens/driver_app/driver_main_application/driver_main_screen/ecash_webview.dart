import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_main_screen/driver_dashboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/loader_widget.dart';
import 'package:diamond_line/constants.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../../Buisness_logic/provider/Driver_Provider/check_payment_status_provider.dart';
import '../../../../../Data/network/requests.dart';

class EcashWebView extends StatefulWidget {
  EcashWebView(
      {required this.url,
      required this.paymentId,
      required this.total,
      required this.VerificationCode,
      Key? key})
      : super(key: key);
  String url;
  String paymentId;
  String total;
  String VerificationCode;

  @override
  State<EcashWebView> createState() => _EcashWebViewState();
}

class _EcashWebViewState extends State<EcashWebView> {
  final _key = UniqueKey();
  DateTime currentBackPressTime = DateTime.now();
  bool isloading = true;
  bool _isNetworkAvail = true;
  String res = '';
  String typeOfDriver = '';
  late SharedPreferences prefs;

  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  Future initShared() async {
    prefs = await SharedPreferences.getInstance();
    typeOfDriver = prefs.getString('type_of_customer') ?? '';
    print('type_of_customer');
    print(typeOfDriver);
  }

  @override
  void dispose() {
    Loader.hide();
    super.dispose();
  }

  ///////////////////////get ecash status/////////////////////////
  Future<void> checkPayment(CheckPaymentStatusProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      print(widget.paymentId);
      await creat.checkPayment(widget.paymentId);
      if (creat.data.error == false) {
        Loader.hide();
        String transactionNo = creat.data.data!.transactionNumber.toString();
        String msg = creat.data.message.toString();
        String isSuccess = creat.data.data!.isSuccess.toString();
        print(transactionNo);
        print(msg);
        print(widget.paymentId);
        print('*******is success');
        print(isSuccess);
        if (isSuccess == "1") {
          setSnackbar('Payment success'.tr(), context);
          if (typeOfDriver == 'driver') {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return DriverDashboard(
                    driverType: 'driver',
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
          } else {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return DriverDashboard(
                    driverType: 'external_driver',
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
          }
        } else {
          // setSnackbar('Payment Failed Please try again'.tr(), context);
          deletePaymentIdApi();
        }
        setState(() {});
      } else {
        Loader.hide();
        deletePaymentIdApi();
        setSnackbar(creat.data.message.toString(), context);
      }
    } else {
      setSnackbar("nointernet".tr(), context);
    }
  }

  Future<void> deletePaymentIdApi() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      // Loader.show(context, progressIndicator: LoaderWidget());
      var data = await AppRequests.deletePaymentIdRequest(widget.paymentId);
      data = json.decode(data);
      if (data["error"] == false) {
        // Loader.hide();
        setState(() {
          print("delete");
          if (typeOfDriver == 'driver') {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return DriverDashboard(
                    driverType: 'driver',
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
          } else {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return DriverDashboard(
                    driverType: 'external_driver',
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
          }
        });
      } else {
        // Loader.hide();
        // setSnackbar(data["message"].toString(), context);
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

  Future<bool> onWillPop() async {
    if (Loader.isShown == true) {
      Loader.hide();
    }
    final differance = DateTime.now().difference(currentBackPressTime);
    final isExitWarning = differance >= Duration(seconds: 2);
    currentBackPressTime = DateTime.now();
    if (isExitWarning) {
      final Message =
          "Don't press back while doing payment!\n Double tap back button to exit";
      Fluttertoast.showToast(
        msg: Message,
        fontSize: 18,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: primaryBlue,
        textColor: Colors.white,
      );
      return false;
    } else {
      var creat =
          await Provider.of<CheckPaymentStatusProvider>(context, listen: false);
      checkPayment(creat);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
        ),
        leadingWidth: 110,
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Column(
          children: [
            Expanded(
                child: WebView(
              key: _key,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget.url,
            ))
          ],
        ),
      ),
    );
  }
}
