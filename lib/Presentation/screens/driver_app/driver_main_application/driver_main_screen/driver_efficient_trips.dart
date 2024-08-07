import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_main_screen/trip_wait_for_payment_driver.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/inside_city_trips/trip_wait_for_payment.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../widgets/loader_widget.dart';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_main_screen/tracking_screen.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_main_screen/tracking_screen_outcity.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:diamond_line/constants.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../Buisness_logic/provider/Driver_Provider/driver_efficient_trips_provider.dart';
import '../../../../Functions/helper.dart';
import 'user_location.dart';

class EfficientDriverTrips extends StatefulWidget {
  const EfficientDriverTrips();

  @override
  State<EfficientDriverTrips> createState() => _EfficientDriverTripsState();
}

class _EfficientDriverTripsState extends State<EfficientDriverTrips> {
  bool _isNetworkAvail = true;
  late SharedPreferences prefs;
  bool isUpdate = false;
  int length = 0;
  int length1 = 0;
  int length2 = 0;
  bool isGetTrips = false;
  late List tripsList;
  late final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  late String type;

  @override
  void initState() {
    initShared();
    init();
    _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
    super.initState();
  }

  Future initShared() async {
    prefs = await SharedPreferences.getInstance();
    type = prefs.getString('type_of_customer') ?? '';
    print('type_of_customer');
    print(type);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> init() async {
    tripsList = [];
    var creat =
        await Provider.of<DriverOutcityTripsProvider>(context, listen: false);
    getDriverEfficientTripsApi(creat);
  }

  /////////////////////////// get driver trips Efficient api ///////////////////////////
  Future<void> getDriverEfficientTripsApi(
      DriverOutcityTripsProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.getDriverEfficirntTrips();
      if (creat.data.error == false) {
        length1 = creat.data.data!.tripsOutcity!.length;
        length2 = creat.data.data!.tripInside!.length;
        length = length1 + length2;
        print('------------------ $length');
        if (length1 != 0) {
          for (int i = 0; i < creat.data.data!.tripsOutcity!.length; i++) {
            setState(() {
              tripsList.add(creat.data.data!.tripsOutcity![i]);
              isGetTrips = true;
            });
          }
        }
        if (length2 != 0) {
          for (int i = 0; i < creat.data.data!.tripInside!.length; i++) {
            setState(() {
              tripsList.add(creat.data.data!.tripInside![i]);
              isGetTrips = true;
            });
          }
          print('layan tripsList');
          print(tripsList);
        } else {}
        Loader.hide();
        setState(() {
          Future.delayed(const Duration(seconds: 1)).then((_) async {});
        });
      } else {
        Loader.hide();
        setSnackbar(creat.data.message.toString(), context);
      }
    } else {
      setSnackbar("nointernet".tr(), context);
    }
  }

  /////////////////////////trip start api (incity trip) //////////////////////////////////
  Future<void> startTripApi(
    String trip_id,
    String pickupLatitude,
    String pickupLongitude,
    String dropLatitude,
    String dropLongitude,
    String start_time,
  ) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      var data = await AppRequests.startTripRequest(trip_id, start_time);
      print(data);
      data = json.decode(data);
      if (data["error"] == false) {
        Loader.hide();
        setSnackbar(data["message"].toString(), context);
        setState(() {
          print('layannnn');
          Future.delayed(const Duration(seconds: 3)).then((_) async {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return TrackingScreen(
                      tripId: trip_id,
                      pickupLatitude: pickupLatitude,
                      pickupLongitude: pickupLongitude,
                      dropLatitude: dropLatitude,
                      dropLongitude: dropLongitude);
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
        });
      } else {
        Loader.hide();
        setSnackbar(data["message"].toString(), context);
      }
    } else {
      setSnackbar("nointernet".tr(), context);
    }
  }

  /////////////////////////trip start api (outcity trip) //////////////////////////////////
  Future<void> startTripOutcityApi(
    String trip_id,
    String pickupLatitude,
    String pickupLongitude,
    String dropLatitude,
    String dropLongitude,
    String start_time,
  ) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      var data = await AppRequests.startTripRequest(trip_id, start_time);
      print(data);
      data = json.decode(data);
      if (data["error"] == false) {
        Loader.hide();
        setSnackbar(data["message"].toString(), context);
        setState(() {
          Future.delayed(const Duration(seconds: 3)).then((_) async {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return TrackingScreenOutside(
                      tripId: trip_id,
                      pickupLatitude: pickupLatitude,
                      pickupLongitude: pickupLongitude,
                      dropLatitude: dropLatitude,
                      dropLongitude: dropLongitude);
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
        });
      } else {
        Loader.hide();
        setSnackbar(data["message"].toString(), context);
      }
    } else {
      setSnackbar("nointernet".tr(), context);
    }
  }

  ////////////////// driverArriveApi //////////////////////////
  Future<void> driverArriveApi(String trip_id, int index) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      Loader.show(context, progressIndicator: LoaderWidget());
      var data = await AppRequests.arriveDriverRequest(trip_id);
      Loader.hide();
      // to get trips status again
      init();
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RefreshIndicator(
                    color: primaryBlue,
                    key: _refreshIndicatorKey,
                    onRefresh: init,
                    child: Container(
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
                        child: (length == 0 && length2 == 0)
                            ? Center(
                                child: Column(
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Image.asset(
                                    noData,
                                    fit: BoxFit.fill,
                                    height: 30.h,
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(
                                    'there are no trips'.tr(),
                                    style: TextStyle(
                                        fontFamily: 'cairo',
                                        color: primaryBlue,
                                        fontSize: 6.sp),
                                  )
                                ],
                              ))
                            : Container(
                                height: 25.h,
                                width: getScreenWidth(context),
                                child: ListView.builder(
                                    itemCount: length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                // top: 1.h,
                                                bottom: 7.h,
                                                left: 2.w,
                                                right: 2.w),
                                            child: Container(
                                              width: 90.w,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: primaryBlue
                                                        .withOpacity(0.3),
                                                    spreadRadius: 2,
                                                    blurRadius: 7,
                                                    offset: Offset(0, 0),
                                                  ),
                                                ],
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                color: white,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 3.w, right: 3.w),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 1.h,
                                                    ),
                                                    tripsList[index]
                                                                .categoryId ==
                                                            '2'
                                                        ? Row(
                                                            children: [
                                                              Image.asset(from,
                                                                  height: 6.h,
                                                                  width: 6.w),
                                                              SizedBox(
                                                                width: 5.w,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  '${tripsList[index].from}',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        // grey,
                                                                        primaryBlue,
                                                                    fontSize:
                                                                        5.sp,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Row(
                                                            children: [
                                                              Image.asset(from,
                                                                  height: 6.h,
                                                                  width: 6.w),
                                                              SizedBox(
                                                                width: 5.w,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  '${tripsList[index].pickupAddr.toString()}',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        primaryBlue,
                                                                    fontSize:
                                                                        5.sp,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                    SizedBox(
                                                      height: 1.h,
                                                    ),
                                                    tripsList[index]
                                                                .categoryId ==
                                                            '2'
                                                        ? Row(
                                                            children: [
                                                              Image.asset(to,
                                                                  height: 6.h,
                                                                  width: 6.w),
                                                              SizedBox(
                                                                width: 5.w,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  '${tripsList[index].to}',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        primaryBlue,
                                                                    fontSize:
                                                                        5.sp,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Row(
                                                            children: [
                                                              Image.asset(to,
                                                                  height: 6.h,
                                                                  width: 6.w),
                                                              SizedBox(
                                                                width: 5.w,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  '${tripsList[index].destAddr.toString()}',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        primaryBlue,
                                                                    fontSize:
                                                                        5.sp,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                    SizedBox(
                                                      height: 1.h,
                                                    ),
                                                    tripsList[index]
                                                                .categoryId ==
                                                            '2'
                                                        ? Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .directions,
                                                                color:
                                                                    primaryBlue,
                                                              ),
                                                              SizedBox(
                                                                width: 5.w,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  '${tripsList[index].direction}',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        primaryBlue,
                                                                    fontSize:
                                                                        5.sp,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Container(),
                                                    SizedBox(
                                                      height: 1.h,
                                                    ),
                                                    // location of user
                                                    tripsList[index]
                                                                .categoryId ==
                                                            '2'
                                                        ? Row(
                                                            children: [
                                                              Image.asset(
                                                                  location,
                                                                  height: 6.h,
                                                                  width: 6.w),
                                                              SizedBox(
                                                                width: 5.w,
                                                              ),
                                                              Expanded(
                                                                child: InkWell(
                                                                  child: Text(
                                                                    '${tripsList[index].from}',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          lightBlue4,
                                                                      fontSize:
                                                                          5.sp,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .underline,
                                                                    ),
                                                                  ),
                                                                  onTap: () {
                                                                    print(tripsList[
                                                                            index]
                                                                        .pickupLatitude);
                                                                    print(tripsList[
                                                                            index]
                                                                        .pickupLongitude);
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(
                                                                      PageRouteBuilder(
                                                                        pageBuilder: (BuildContext context,
                                                                            Animation<double>
                                                                                animation,
                                                                            Animation<double>
                                                                                secondaryAnimation) {
                                                                          return UserLocationScreen(
                                                                            pickupLongitude:
                                                                                tripsList[index].pickupLongitude,
                                                                            pickupLatitude:
                                                                                tripsList[index].pickupLatitude,
                                                                            dropLatitude:
                                                                                tripsList[index].dropLatitude,
                                                                            dropLongitude:
                                                                                tripsList[index].dropLongitude,
                                                                          );
                                                                        },
                                                                        transitionsBuilder: (BuildContext context,
                                                                            Animation<double>
                                                                                animation,
                                                                            Animation<double>
                                                                                secondaryAnimation,
                                                                            Widget
                                                                                child) {
                                                                          return Align(
                                                                            child:
                                                                                SizeTransition(
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
                                                              ),
                                                            ],
                                                          )
                                                        : Row(
                                                            children: [
                                                              Image.asset(
                                                                  location,
                                                                  height: 6.h,
                                                                  width: 6.w),
                                                              SizedBox(
                                                                width: 5.w,
                                                              ),
                                                              Expanded(
                                                                child: InkWell(
                                                                  child: Text(
                                                                    '${tripsList[index].pickupAddr.toString()}',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          // grey,
                                                                          lightBlue4,
                                                                      // primaryBlue,
                                                                      fontSize:
                                                                          5.sp,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .underline,
                                                                    ),
                                                                  ),
                                                                  onTap: () {
                                                                    print(tripsList[
                                                                            index]
                                                                        .pickupLatitude);
                                                                    print(tripsList[
                                                                            index]
                                                                        .pickupLongitude);
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(
                                                                      PageRouteBuilder(
                                                                        pageBuilder: (BuildContext context,
                                                                            Animation<double>
                                                                                animation,
                                                                            Animation<double>
                                                                                secondaryAnimation) {
                                                                          return UserLocationScreen(
                                                                            pickupLongitude:
                                                                                tripsList[index].pickupLongitude,
                                                                            pickupLatitude:
                                                                                tripsList[index].pickupLatitude,
                                                                            dropLatitude:
                                                                                tripsList[index].dropLatitude,
                                                                            dropLongitude:
                                                                                tripsList[index].dropLongitude,
                                                                          );
                                                                        },
                                                                        transitionsBuilder: (BuildContext context,
                                                                            Animation<double>
                                                                                animation,
                                                                            Animation<double>
                                                                                secondaryAnimation,
                                                                            Widget
                                                                                child) {
                                                                          return Align(
                                                                            child:
                                                                                SizeTransition(
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
                                                              ),
                                                            ],
                                                          ),

                                                    // todo
                                                    Row(
                                                      children: [
                                                        Image.asset(name,
                                                            height: 6.h,
                                                            width: 6.w),
                                                        SizedBox(
                                                          width: 5.w,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            '${tripsList[index].firstName.toString()}' +
                                                                '\t' +
                                                                '${tripsList[index].lastName.toString()}',
                                                            style: TextStyle(
                                                              color:
                                                                  primaryBlue,
                                                              fontSize: 5.sp,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5.w,
                                                        ),
                                                        Expanded(
                                                          child: InkWell(
                                                            child: Text(
                                                              '${tripsList[index].phone.toString()}',
                                                              style: TextStyle(
                                                                color:
                                                                    lightBlue4,
                                                                fontSize: 5.sp,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              launchUrl(Uri.parse(
                                                                  "tel://+963 ${tripsList[index].phone.toString()}"));
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    /////////////////////
                                                    SizedBox(
                                                      height: 3.h,
                                                    ),
                                                    tripsList[index]
                                                                .categoryId ==
                                                            '2'
                                                        ? tripsList[index]
                                                                    .status ==
                                                                'accepted'
                                                            ? Center(
                                                                child:
                                                                    ContainerWidget(
                                                                  text: 'arrive'
                                                                      .tr(),
                                                                  h: 5.h,
                                                                  w: 35.w,
                                                                  onTap: () {
                                                                    print(tripsList[
                                                                            index]
                                                                        .id
                                                                        .toString());
                                                                    driverArriveApi(
                                                                        tripsList[index]
                                                                            .id
                                                                            .toString(),
                                                                        index);
                                                                  },
                                                                ),
                                                              )
                                                            : tripsList[index]
                                                                        .status ==
                                                                    'arrived'
                                                                ? Center(
                                                                    child:
                                                                        ContainerWidget(
                                                                      text: 'start'
                                                                          .tr(),
                                                                      h: 5.h,
                                                                      w: 35.w,
                                                                      onTap:
                                                                          () {
                                                                        print(tripsList[index]
                                                                            .status);
                                                                        print(tripsList[index]
                                                                            .categoryId);
                                                                        print(tripsList[index]
                                                                            .id);
                                                                        print(tripsList[index]
                                                                            .pickupLatitude);
                                                                        print(tripsList[index]
                                                                            .pickupLongitude);
                                                                        print(tripsList[index]
                                                                            .dropLatitude);
                                                                        print(tripsList[index]
                                                                            .dropLongitude);
                                                                        DateTime
                                                                            t =
                                                                            DateTime.now();
                                                                        print(
                                                                            t);
                                                                        String
                                                                            start_time =
                                                                            '${t.hour}:${t.minute}:${t.second}';
                                                                        print(
                                                                            start_time);
                                                                        startTripOutcityApi(
                                                                            tripsList[index].id.toString(),
                                                                            tripsList[index].pickupLatitude,
                                                                            tripsList[index].pickupLongitude,
                                                                            tripsList[index].dropLatitude,
                                                                            tripsList[index].dropLongitude,
                                                                            start_time);
                                                                      },
                                                                    ),
                                                                  )
                                                                : Center(
                                                                    child:
                                                                        ContainerWidget(
                                                                      text: 'end'
                                                                          .tr(),
                                                                      h: 5.h,
                                                                      w: 35.w,
                                                                      onTap:
                                                                          () {
                                                                        print(tripsList[index]
                                                                            .status);
                                                                        print(tripsList[index]
                                                                            .categoryId);
                                                                        Navigator.of(context)
                                                                            .push(
                                                                          PageRouteBuilder(
                                                                            pageBuilder: (BuildContext context,
                                                                                Animation<double> animation,
                                                                                Animation<double> secondaryAnimation) {
                                                                              return TrackingScreenOutside(
                                                                                tripId: tripsList[index].id.toString(),
                                                                                pickupLatitude: tripsList[index].pickupLatitude,
                                                                                pickupLongitude: tripsList[index].pickupLongitude,
                                                                                dropLatitude: tripsList[index].dropLatitude,
                                                                                dropLongitude: tripsList[index].dropLongitude,
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
                                                                    ),
                                                                  )
                                                        : tripsList[index]
                                                                    .status ==
                                                                'arrived'
                                                            ? Center(
                                                                child:
                                                                    ContainerWidget(
                                                                  text: 'start'
                                                                      .tr(),
                                                                  h: 5.h,
                                                                  w: 35.w,
                                                                  onTap: () {
                                                                    print(tripsList[
                                                                            index]
                                                                        .status);
                                                                    print(tripsList[
                                                                            index]
                                                                        .categoryId);
                                                                    print(tripsList[
                                                                            index]
                                                                        .id);
                                                                    print(tripsList[
                                                                            index]
                                                                        .pickupLatitude);
                                                                    print(tripsList[
                                                                            index]
                                                                        .pickupLongitude);
                                                                    print(tripsList[
                                                                            index]
                                                                        .dropLatitude);
                                                                    print(tripsList[
                                                                            index]
                                                                        .dropLongitude);
                                                                    DateTime t =
                                                                        DateTime
                                                                            .now();
                                                                    print(t);
                                                                    String
                                                                        start_time =
                                                                        '${t.hour}:${t.minute}:${t.second}';
                                                                    print(
                                                                        start_time);
                                                                    startTripApi(
                                                                        tripsList[index]
                                                                            .id
                                                                            .toString(),
                                                                        tripsList[index]
                                                                            .pickupLatitude,
                                                                        tripsList[index]
                                                                            .pickupLongitude,
                                                                        tripsList[index]
                                                                            .dropLatitude,
                                                                        tripsList[index]
                                                                            .dropLongitude,
                                                                        start_time);
                                                                  },
                                                                ),
                                                              )
                                                            : tripsList[index]
                                                                        .status ==
                                                                    'wait for payment'
                                                                ? Center(
                                                                    child:
                                                                        ContainerWidget(
                                                                      text: 'go to payment page'
                                                                          .tr(),
                                                                      h: 5.h,
                                                                      w: 65.w,
                                                                      onTap:
                                                                          () {
                                                                        print(tripsList[index]
                                                                            .id
                                                                            .toString());
                                                                        Navigator.of(context)
                                                                            .push(
                                                                          PageRouteBuilder(
                                                                            pageBuilder: (BuildContext context,
                                                                                Animation<double> animation,
                                                                                Animation<double> secondaryAnimation) {
                                                                              return TripWaitForPaymentDriverScreen(
                                                                                  adminFare: "0",
                                                                                  // adminFare: tripsList[index].endTime.toString(),
                                                                                  endTime: tripsList[index].endTime.toString(),
                                                                                  finalDistance: tripsList[index].km.toString(),
                                                                                  tripId: tripsList[index].id.toString(),
                                                                                  finalCost: tripsList[index].cost.toString());
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
                                                                    ),
                                                                  )
                                                                : Center(
                                                                    child:
                                                                        ContainerWidget(
                                                                      text: 'arrive'
                                                                          .tr(),
                                                                      h: 5.h,
                                                                      w: 35.w,
                                                                      onTap:
                                                                          () {
                                                                        print(tripsList[index]
                                                                            .id
                                                                            .toString());
                                                                        driverArriveApi(
                                                                            tripsList[index].id.toString(),
                                                                            index);
                                                                      },
                                                                    ),
                                                                  ),
                                                    SizedBox(
                                                      height: 2.h,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          // SizedBox(
                                          //   width: 5.w,
                                          // ),
                                        ],
                                      );
                                    }),
                              )),
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
