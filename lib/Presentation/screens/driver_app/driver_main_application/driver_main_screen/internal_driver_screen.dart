import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/loader_widget.dart';
import 'package:flutter/services.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../Buisness_logic/provider/Driver_Provider/driver_status_provider.dart';
import '../../../../../Data/network/requests.dart';
import 'incity_driver_trips.dart';
import 'outcity_driver_trips.dart';

class InDriverMainScreen extends StatefulWidget {
  const InDriverMainScreen({Key? key}) : super(key: key);

  @override
  State<InDriverMainScreen> createState() => _InDriverMainScreenState();
}

class _InDriverMainScreenState extends State<InDriverMainScreen> {
  DateTime timeback = DateTime.now();
  bool _isNetworkAvail = true;
  String msg = '';
  bool isPending = false;
  late final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  final picker = ImagePicker();
  File? imageFile;
  double lat = 0.0;
  double lng = 0.0;
  late Position cl;
  String deviceNumber = '';
  int deviceNumb = 0;
  late SharedPreferences prefs;

  @override
  void initState() {
    _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
    initShared();
    callApi();
    super.initState();
  }

  callApi() async {
    await init();
    getLatAndLong();
  }

  Future initShared() async {
    prefs = await SharedPreferences.getInstance();
    deviceNumber = prefs.getString('deviceNumber') ?? '';
    print(deviceNumber);
    deviceNumb = int.parse(deviceNumber);
    print(deviceNumb);
  }

  Future<void> init() async {
    var creat3 =
        await Provider.of<DriverStatusProvider>(context, listen: false);
    await driverStatusApi(creat3);
  }

  /////////////////////////get lat long api //////////////////////////////////
  Future<void> getLatAndLong() async {
    cl = await Geolocator.getCurrentPosition().then((value) => value);
    lat = cl.latitude;
    lng = cl.longitude;
    if (lat != 0.0 || lng != 0.0) {
      getLocationApi(lat.toString(), lng.toString(), deviceNumb.toString());
    } else {
      print('no lat or lng');
      getLatAndLong();
    }
    if (mounted) {
      setState(() {});
    }
  }

  /////////////////////////get location api //////////////////////////////////
  Future<void> getLocationApi(String lat, String lng, String device_id) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      var data = await AppRequests.getLocationRequest(lat, lng, device_id);
      print(data);
      data = json.decode(data);
      // if (data["error"] == false) {
      //   setState(() {
      //     Future.delayed(const Duration(seconds: 2)).then((_) async {
      //     });
      //   });
      // } else {}
    } else {
      setSnackbar("nointernet".tr(), context);
    }
  }

  ////////////////////driver status api///////////////////////////
  Future<void> driverStatusApi(DriverStatusProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.driverStatus();
      print(creat.data.error);
      print(creat.data.message);
      if (creat.data.error == false) {
        Loader.hide();
        setState(() {
          isPending = false;
        });
      } else {
        Loader.hide();
        print(creat.data.message);
        setState(() {
          isPending = true;
          msg = creat.data.message.toString();
        });
      }
    } else {
      setSnackbar("nointernet".tr(), context);
      Future.delayed(const Duration(seconds: 2)).then((_) async {
        if (mounted) {
          setState(() {
            _isNetworkAvail = false;
          });
        }
      });
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
      content: Text(
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
      onWillPop: () async {
        if (Loader.isShown == true) {
          Loader.hide();
        }
        final differance = DateTime.now().difference(timeback);
        final isExitWarning = differance >= Duration(seconds: 2);
        timeback = DateTime.now();
        if (isExitWarning) {
          final Message = "Press back agin to Exit".tr();
          Fluttertoast.showToast(
              msg: Message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: white,
              textColor: primaryBlue,
              fontSize: 5.sp);
          return false;
        } else {
          Fluttertoast.cancel();
          SystemNavigator.pop();
          return true;
        }
      },
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
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      // height: 82.h,
                      height: 90.h,
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
                      child: isPending == true
                          ? RefreshIndicator(
                              color: primaryBlue,
                              key: _refreshIndicatorKey,
                              onRefresh: init,
                              child: Column(
                                children: [
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(msg,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 5.sp,
                                            color: primaryBlue,
                                          ),),
                                        TextButton(
                                          onPressed: init,
                                          child: myText(
                                            text: 'tap to refresh'.tr(),
                                            fontSize: 5.sp,
                                            color: lightBlue3,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ))
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    // height: 18.h,
                                    height: 24.h,
                                  ),
                                  ContainerWidget(
                                    text: 'driver trips'.tr(),
                                    h: 13.h,
                                    w: 85.w,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (BuildContext context,
                                              Animation<double> animation,
                                              Animation<double>
                                                  secondaryAnimation) {
                                            return OutsideCityDriverTrips();
                                          },
                                          transitionsBuilder:
                                              (BuildContext context,
                                                  Animation<double> animation,
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
                                    borderRadius: 20.0,
                                  ),
                                  SizedBox(
                                    height: 3.h,
                                  ),
                                  ContainerWidget(
                                    text: 'driver trips inside city'.tr(),
                                    h: 13.h,
                                    w: 85.w,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (BuildContext context,
                                              Animation<double> animation,
                                              Animation<double>
                                                  secondaryAnimation) {
                                            return InsideCityDriverTrips();
                                          },
                                          transitionsBuilder:
                                              (BuildContext context,
                                                  Animation<double> animation,
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
                                    borderRadius: 20.0,
                                  ),
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