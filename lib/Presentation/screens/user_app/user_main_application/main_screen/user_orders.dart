import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/user_dashboard.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../Buisness_logic/provider/User_Provider/user_orders_provider.dart';
import '../../../../../Data/network/requests.dart';
import '../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share/share.dart';
import '../../../../Functions/helper.dart';
import 'tracking_driver.dart';

class UserOrders extends StatefulWidget {
  const UserOrders({Key? key}) : super(key: key);

  @override
  State<UserOrders> createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> {
  bool _isNetworkAvail = true;
  late List ordersList;
  bool noTrips = false;
  String msg = '';
  late final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  @override
  void initState() {
    init();
    _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
    super.initState();
  }

  Future<void> init() async {
    ordersList = [];
    var creat = await Provider.of<UserOrderProvider>(context, listen: false);
    getUserOrdersApi(creat);
  }

  ////////////////////// user orders api (accepted trips) ///////////////////////
  Future<void> getUserOrdersApi(UserOrderProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(
        context,
        progressIndicator: LoaderWidget(),
      );
      await creat.getUserOrders();
      if (creat.data.error == false) {
        Loader.hide();
        for (int i = 0; i < creat.data.data!.insidTrips!.length; i++) {
          setState(() {
            ordersList.add(creat.data.data!.insidTrips![i]);
          });
        }
        for (int i = 0; i < creat.data.data!.outsideTrips!.length; i++) {
          setState(() {
            ordersList.add(creat.data.data!.outsideTrips![i]);
          });
        }
        for (int i = 0; i < ordersList.length; i++) {
          print(ordersList[i].id);
        }
        print('length');
        print(ordersList.length);
        setState(() {});
      } else {
        Loader.hide();
        setState(() {
          noTrips = true;
          msg = creat.data.message.toString();
        });
      }
    } else {
      setSnackbar("nointernet".tr(), context);
      print("nointernet");
    }
  }

  ////////////////// cancel trip api //////////////////////////
  Future<void> cancelTrip(String trip_id) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      Loader.show(context, progressIndicator: LoaderWidget());
      var data = await AppRequests.cancelTripRequest(trip_id);
      data = json.decode(data);
      if (data["error"] == false) {
        Loader.hide();
        setState(() {
          setSnackbar(data["message"].toString(), context);
          Future.delayed(const Duration(seconds: 1)).then((_) async {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => UserDashboard()));
          });
        });
      } else {
        Loader.hide();
        setSnackbar(data["message"].toString(), context);
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
    print("user_orders");
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
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
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
                      child: noTrips == false
                          ? RefreshIndicator(
                              color: primaryBlue,
                              key: _refreshIndicatorKey,
                              onRefresh: init,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: ListView.builder(
                                        itemCount: ordersList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (ordersList[index]
                                                  .status
                                                  .toString() ==
                                              'pending') {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 3.w,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 1.h,
                                                  ),
                                                  child: Container(
                                                    // height: 66.h,
                                                    width: 80.w,
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
                                                          spreadRadius: 2,
                                                          blurRadius: 7,
                                                          offset: const Offset(
                                                              0, 0),
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  20)),
                                                      color: backgroundColor,
                                                    ),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: 1.h,
                                                          ),
                                                          myText(
                                                              text:
                                                                  'your trip is pending'
                                                                      .tr(),
                                                              fontSize: 5.5.sp,
                                                              color:
                                                                  // primaryBlue,
                                                                  Colors
                                                                      .black54,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          SizedBox(
                                                            height: 2.h,
                                                          ),
                                                          ordersList[index]
                                                                      .categoryId
                                                                      .toString() ==
                                                                  '2'
                                                              ? Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              2.w),
                                                                  child: Text(
                                                                    'from'.tr() +
                                                                        ' ${ordersList[index].from.toString()}' +
                                                                        ' ' +
                                                                        'to'.tr() +
                                                                        ' ' +
                                                                        '${ordersList[index].to.toString()}',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          primaryBlue,
                                                                      fontSize:
                                                                          4.5.sp,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              2.w),
                                                                  child: Text(
                                                                    'from'.tr() +
                                                                        ' ' +
                                                                        ' ${ordersList[index].pickupAddr.toString()}' +
                                                                        '\n' +
                                                                        'to'.tr() +
                                                                        ' ' +
                                                                        '${ordersList[index].destAddr.toString()}',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          primaryBlue,
                                                                      fontSize:
                                                                          4.5.sp,
                                                                    ),
                                                                  ),
                                                                ),
                                                          SizedBox(
                                                            height: 1.h,
                                                          ),
                                                          ContainerWidget(
                                                              text:
                                                                  'cancel'.tr(),
                                                              h: 6.h,
                                                              w: 40.w,
                                                              onTap: () async {
                                                                print(
                                                                    'call api cancel');
                                                                print(ordersList[
                                                                        index]
                                                                    .id
                                                                    .toString());
                                                                await cancelTrip(
                                                                    ordersList[
                                                                            index]
                                                                        .id
                                                                        .toString());
                                                              }),
                                                          SizedBox(
                                                            height: 2.h,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 3.w,
                                                )
                                              ],
                                            );
                                          } else {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 3.w,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 1.h,
                                                  ),
                                                  child: Container(
                                                    // height: 66.h,
                                                    width: 80.w,
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
                                                          spreadRadius: 2,
                                                          blurRadius: 7,
                                                          offset: const Offset(
                                                              0, 0),
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  20)),
                                                      color: backgroundColor,
                                                    ),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 1.h,
                                                          ),
                                                          ordersList[index]
                                                                      .status
                                                                      .toString() ==
                                                                  'started'
                                                              ? myText(
                                                                  text:
                                                                      'your trip is started'
                                                                          .tr(),
                                                                  fontSize:
                                                                      5.5.sp,
                                                                  color: Colors
                                                                      .black54,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)
                                                              : myText(
                                                                  text:
                                                                      'your trip is accepted'
                                                                          .tr(),
                                                                  fontSize:
                                                                      5.5.sp,
                                                                  color: Colors
                                                                      .black54,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                          SizedBox(
                                                            height: 2.h,
                                                          ),
                                                          ordersList[index]
                                                                      .categoryId
                                                                      .toString() ==
                                                                  '2'
                                                              ? Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              2.w),
                                                                  child: Text(
                                                                    'from'.tr() +
                                                                        ' ${ordersList[index].from.toString()}' +
                                                                        ' ' +
                                                                        'to'.tr() +
                                                                        ' ' +
                                                                        '${ordersList[index].to.toString()}',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          primaryBlue,
                                                                      fontSize:
                                                                          4.5.sp,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              2.w),
                                                                  child: Text(
                                                                    'from'.tr() +
                                                                        ' ' +
                                                                        ' ${ordersList[index].pickupAddr.toString()}' +
                                                                        '\n' +
                                                                        'to'.tr() +
                                                                        ' ' +
                                                                        '${ordersList[index].destAddr.toString()}',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          primaryBlue,
                                                                      fontSize:
                                                                          4.5.sp,
                                                                    ),
                                                                  ),
                                                                ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        2.w),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Text(
                                                                      ' ${ordersList[index]
                                                                              // .firstName
                                                                              .driver.firstName.toString()}' +
                                                                          ' ' +
                                                                          '${ordersList[index]
                                                                              // .lastName
                                                                              .driver.lastName.toString()}',
                                                                      style:
                                                                          TextStyle(
                                                                        color:
                                                                            primaryBlue,
                                                                        fontSize:
                                                                            5.sp,
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      child:
                                                                          Text(
                                                                        ' ${ordersList[index].driver.phone.toString()}',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              primaryBlue,
                                                                          fontSize:
                                                                              5.sp,
                                                                          decoration:
                                                                              TextDecoration.underline,
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        launchUrl(
                                                                            Uri.parse("tel://+963 ${ordersList[index].driver.phone.toString()}"));
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                                InkWell(
                                                                    child:
                                                                        FadeInImage(
                                                                      image: NetworkImage(ordersList[
                                                                              index]
                                                                          .driver
                                                                          .profileImage
                                                                          .toString()),
                                                                      height:
                                                                          10.h,
                                                                      width:
                                                                          10.w,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                      imageErrorBuilder: (context,
                                                                              error,
                                                                              stackTrace) =>
                                                                          erroWidget(
                                                                              100),
                                                                      placeholder:
                                                                          placeHolder(
                                                                              100),
                                                                    ),
                                                                    onTap: () {
                                                                      getDialog(ordersList[
                                                                              index]
                                                                          .driver
                                                                          .profileImage
                                                                          .toString());
                                                                    }),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 1.h,
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        2.w),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Text(
                                                                      ' ${ordersList[index].vehicle.carModel.toString()}',
                                                                      style:
                                                                          TextStyle(
                                                                        color:
                                                                            primaryBlue,
                                                                        fontSize:
                                                                            5.sp,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      ' ${ordersList[index].vehicle.color.toString()}',
                                                                      style:
                                                                          TextStyle(
                                                                        color:
                                                                            primaryBlue,
                                                                        fontSize:
                                                                            5.sp,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                InkWell(
                                                                  child:
                                                                      FadeInImage(
                                                                    image: NetworkImage(ordersList[
                                                                            index]
                                                                        .vehicle
                                                                        .vehicleImage
                                                                        .toString()),
                                                                    height:
                                                                        10.h,
                                                                    width: 10.w,
                                                                    fit: BoxFit
                                                                        .contain,
                                                                    imageErrorBuilder: (context,
                                                                            error,
                                                                            stackTrace) =>
                                                                        erroWidget(
                                                                            20),
                                                                    placeholder:
                                                                        placeHolder(
                                                                            20),
                                                                  ),
                                                                  onTap: () {
                                                                    getDialog(ordersList[
                                                                            index]
                                                                        .vehicle
                                                                        .vehicleImage
                                                                        .toString());
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 2.h,
                                                          ),
                                                          ContainerWidget(
                                                              text:
                                                                  'share'.tr(),
                                                              h: 6.h,
                                                              w: 40.w,
                                                              onTap: () {
                                                                var str = "AppName"
                                                                        .tr() +
                                                                    "\n\n" +
                                                                    "I with"
                                                                        .tr() +
                                                                    "\n"
                                                                        "${ordersList[index].driver.firstName.toString()}"
                                                                        "\t"
                                                                        "${ordersList[index].driver.lastName.toString()}\n"
                                                                        "${ordersList[index].driver.phone.toString()}\n"
                                                                        "${ordersList[index].vehicle.carModel.toString()}\n"
                                                                        "${ordersList[index].vehicle.color.toString()}";
                                                                Share.share(
                                                                    str);

                                                                print(str);
                                                              }),
                                                          SizedBox(
                                                            height: 2.h,
                                                          ),
                                                          ContainerWidget(
                                                              text:
                                                                  'track driver'
                                                                      .tr(),
                                                              h: 6.h,
                                                              w: 40.w,
                                                              onTap: () {
                                                                print(ordersList[
                                                                        index]
                                                                    .id
                                                                    .toString());
                                                                print(ordersList[
                                                                        index]
                                                                    .pickupLatitude
                                                                    .toString());
                                                                print(ordersList[
                                                                        index]
                                                                    .pickupLongitude
                                                                    .toString());
                                                                print(ordersList[
                                                                        index]
                                                                    .vehicle
                                                                    .deviceNumber
                                                                    .toString());
                                                                print(ordersList[
                                                                        index]
                                                                    .dropLatitude
                                                                    .toString());
                                                                print(ordersList[
                                                                        index]
                                                                    .dropLongitude
                                                                    .toString());
                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                  PageRouteBuilder(
                                                                    pageBuilder: (BuildContext context,
                                                                        Animation<double>
                                                                            animation,
                                                                        Animation<double>
                                                                            secondaryAnimation) {
                                                                      return TrackingDriverScreen(
                                                                          tripId: ordersList[index]
                                                                              .id
                                                                              .toString(),
                                                                          driverDeviceNumb: ordersList[index]
                                                                              .vehicle
                                                                              .deviceNumber
                                                                              .toString(),
                                                                          pickupLatitude: ordersList[index]
                                                                              .pickupLatitude,
                                                                          pickupLongitude: ordersList[index]
                                                                              .pickupLongitude,
                                                                          dropLatitude: ordersList[index]
                                                                              .dropLatitude,
                                                                          dropLongitude:
                                                                              ordersList[index].dropLongitude);
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
                                                                          sizeFactor:
                                                                              animation,
                                                                          child:
                                                                              child,
                                                                        ),
                                                                      );
                                                                    },
                                                                    transitionDuration:
                                                                        Duration(
                                                                            milliseconds:
                                                                                500),
                                                                  ),
                                                                );
                                                              }),
                                                          SizedBox(
                                                            height: 2.h,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 3.w,
                                                )
                                              ],
                                            );
                                          }
                                        }),
                                  ),
                                  // SizedBox(height: 6.h,),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              color: primaryBlue,
                              key: _refreshIndicatorKey,
                              onRefresh: init,
                              child: Center(
                                  child: Column(
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  // Image.asset(
                                  //   noData,
                                  //   fit: BoxFit
                                  //       .fill,
                                  //   height:
                                  //   30.h,
                                  // ),

                                  msg == 'There are no requests yet'
                                      ? Image.asset(
                                          noData,
                                          fit: BoxFit.fill,
                                          height: 30.h,
                                        )
                                      : Lottie.asset(
                                          lookingDriver,
                                          height: 30.h,
                                          width: 50.w,
                                        ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(
                                    // 'Your Request has not been approved'
                                    //     .tr(),
                                    msg.tr(),
                                    style: TextStyle(
                                        fontFamily: 'cairo',
                                        color: primaryBlue,
                                        fontSize: 6.sp),
                                    textAlign: TextAlign.center,
                                  ),
                                  msg == 'There are no requests yet'
                                      ? Text('')
                                      : TextButton(
                                          onPressed: init,
                                          child: myText(
                                            text: 'tap to refresh'.tr(),
                                            fontSize: 5.sp,
                                            color: lightBlue3,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ],
                              )))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
