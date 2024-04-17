import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_main_screen/trip_ended_outcity.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_main_screen/trip_information_outcity.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../Buisness_logic/provider/Driver_Provider/driver_trips_provider.dart';
import '../../../../../Data/Models/Driver_Models/driver_trips_model.dart';
import '../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Functions/helper.dart';

String? userIdForTripOutcity = '';

class OutsideCityDriverTrips extends StatefulWidget {
  const OutsideCityDriverTrips({Key? key}) : super(key: key);

  @override
  State<OutsideCityDriverTrips> createState() => _OutsideCityDriverTripsState();
}

class _OutsideCityDriverTripsState extends State<OutsideCityDriverTrips> {
  bool _isNetworkAvail = true;
  late final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  int length = 0;
  bool isGetTrips = false;
  late List tripsList;
  var distance;
  String idTrip = '';
  String pickupAddTrip = '';
  String destAddrTrip = '';
  String fNameTrip = '';
  String lNameTrip = '';
  String phoneTrip = '';
  String priceTrip = '';
  String minTrip = '';
  String kmTrip = '';
  String userId = '';
  String requestType = '';
  String time = '';
  String date = '';
  String totalPriceOutcity = '';
  String adminFare = '';
  late SharedPreferences prefs;
  List<double> latList = [];
  List<double> lngList = [];
  List<ExpenseDetail> expensesList = [];

  @override
  void initState() {
    init();
    initShared();
    _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
    super.initState();
  }

  Future initShared() async {
    prefs = await SharedPreferences.getInstance();
    // read
    List<String> savedStrList = prefs.getStringList('latList') ?? [];
    latList = savedStrList.map((i) => double.parse(i)).toList();
    List<String> savedStrList2 = prefs.getStringList('lngList') ?? [];
    lngList = savedStrList2.map((i) => double.parse(i)).toList();
    print('latList and lngList from sharedPreference');
    print("${latList.toString()}");
    print("${lngList.toString()}");
  }

  Future<void> init() async {
    tripsList = [];
    var creat =
        await Provider.of<GetDriverTripsProvider>(context, listen: false);
    getDriverTripsApi(creat);
  }

  //////////////////////////// get driver trips outside city api ///////////////////////////
  Future<void> getDriverTripsApi(GetDriverTripsProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.getDriverTrips();
      if (creat.data.error == false) {
        length = creat.data.data!.tripsOutcity!.length;
        if (length != 0) {
          for (int i = 0; i < creat.data.data!.tripsOutcity!.length; i++) {
            setState(() {
              tripsList.add(creat.data.data!.tripsOutcity![i]);
              isGetTrips = true;
            });
          }
        }
        Loader.hide();
        setState(() {
          Future.delayed(const Duration(seconds: 1)).then((_) async {});
        });
      } else {
        Loader.hide();
        isGetTrips = true;
      }
    } else {
      setSnackbar("nointernet".tr(), context);
    }
  }

  void navigate(
    String trip_id,
    String pickupLatitude,
    String pickupLongitude,
    String dropLatitude,
    String dropLongitude,
    String profileImage,
    String hasExpense,
    String date,
    String time,
  ) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return TripInfoOutcityScreen(
              idTrip: idTrip,
              pickupAddTrip: pickupAddTrip,
              destAddrTrip: destAddrTrip,
              fNameTrip: fNameTrip,
              lNameTrip: lNameTrip,
              phoneTrip: phoneTrip,
              priceTrip: priceTrip,
              minTrip: minTrip,
              kmTrip: kmTrip,
              pickupLatitude: pickupLatitude,
              pickupLongitude: pickupLongitude,
              dropLatitude: dropLatitude,
              dropLongitude: dropLongitude,
              profileImage: profileImage,
              hasExpense: hasExpense,
              expensesList: expensesList,
              date: date,
              time: time);
        },
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
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

  Future<void> endTripApi(
    String trip_id,
    String end_time,
    String finalDistance,
  ) async {
    _isNetworkAvail = await isNetworkAvailable();
    print(trip_id);
    print(end_time);
    print(finalDistance);
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      var data =
          await AppRequests.endTripRequest(trip_id, end_time, finalDistance);
      print(data);
      data = json.decode(data);
      if (data["error"] == false) {
        Loader.hide();
        setSnackbar(data["message"].toString(), context);
        setState(() {
          totalPriceOutcity = data["data"]["new_cost"].toString();
          print('new cost' + totalPriceOutcity);
          adminFare = data["data"]["admin_fare"].toString();
          print('adminFare' + adminFare);
          Future.delayed(const Duration(seconds: 3)).then((_) async {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return TripOutCityEndedScreen(
                    tripId: trip_id,
                    finalCost: totalPriceOutcity,
                    adminFare: adminFare,
                    // titleOfTrip: title
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

  getDistance(double latcurrent, double lancurrent, double lat, double lng) {
    distance = Geolocator.distanceBetween(
      latcurrent,
      lancurrent,
      lat,
      lng,
    );
    distance = distance / 1000;
    print('distance' + distance.toString());
    return distance.toString();
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
                    child: RefreshIndicator(
                      color: primaryBlue,
                      key: _refreshIndicatorKey,
                      onRefresh: init,
                      child: length == 0
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
                          : Column(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: ListView.builder(
                                      itemCount: tripsList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 1.h),
                                              child: Container(
                                                width: 80.w,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      spreadRadius: 2,
                                                      blurRadius: 7,
                                                      offset:
                                                          const Offset(0, 0),
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20)),
                                                  color: backgroundColor,
                                                ),
                                                child: SingleChildScrollView(
                                                    child: Column(
                                                  children: [
                                                    ListTile(
                                                        leading: const Icon(
                                                          Icons.date_range,
                                                          color: primaryBlue,
                                                        ),
                                                        title: Text(
                                                          tripsList[index]
                                                              .date
                                                              .toString()
                                                              .split(' ')
                                                              .first,
                                                          style: TextStyle(
                                                            color: grey,
                                                            fontSize: 5.sp,
                                                          ),
                                                        )),
                                                    ListTile(
                                                        leading: Image.asset(
                                                          clock,
                                                          color: primaryBlue,
                                                        ),
                                                        title: Text(
                                                          tripsList[index]
                                                              .time
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: grey,
                                                            fontSize: 5.sp,
                                                          ),
                                                        )),
                                                    ListTile(
                                                        leading: const Icon(
                                                          Icons.holiday_village,
                                                          color: primaryBlue,
                                                        ),
                                                        title: Text(
                                                          'from'.tr() +
                                                              ' ${tripsList[index].from.toString()}' +
                                                              ' ' +
                                                              'to'.tr() +
                                                              ' ${tripsList[index].to.toString()}',
                                                          style: TextStyle(
                                                            color: grey,
                                                            fontSize: 5.sp,
                                                          ),
                                                        )),
                                                    ListTile(
                                                        leading: const Icon(
                                                          Icons.directions,
                                                          color: primaryBlue,
                                                        ),
                                                        title: Text(
                                                          tripsList[index]
                                                              .direction
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: grey,
                                                            fontSize: 5.sp,
                                                          ),
                                                        )),
                                                    ListTile(
                                                        leading: const Icon(
                                                          Icons.money,
                                                          color: primaryBlue,
                                                        ),
                                                        title: Text(
                                                          formatter.format(int
                                                                  .parse(tripsList[
                                                                          index]
                                                                      .cost
                                                                      .toString())) +
                                                              'sp'.tr(),
                                                          style: TextStyle(
                                                            color: grey,
                                                            fontSize: 5.sp,
                                                          ),
                                                        )),
                                                    tripsList[index].isTour ==
                                                            'Yes'
                                                        ? Column(
                                                            children: [
                                                              myText(
                                                                text:
                                                                    'tour'.tr(),
                                                                fontSize: 6.sp,
                                                                color:
                                                                    primaryBlue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              SizedBox(
                                                                height: 1.h,
                                                              ),
                                                              ListTile(
                                                                  leading: Image
                                                                      .asset(
                                                                    clock,
                                                                    color:
                                                                        primaryBlue,
                                                                  ),
                                                                  title: Text(
                                                                    'from'.tr() +
                                                                        ' ' +
                                                                        '${tripsList[index].tourDetail[0].startTime.toString()}' +
                                                                        '\n' +
                                                                        'to'.tr() +
                                                                        ' ' +
                                                                        '${tripsList[index].tourDetail[0].endTime.toString()}',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          grey,
                                                                      fontSize:
                                                                          5.sp,
                                                                    ),
                                                                  )),
                                                              ListTile(
                                                                  leading:
                                                                      const Icon(
                                                                    Icons.money,
                                                                    color:
                                                                        primaryBlue,
                                                                  ),
                                                                  title: Text(
                                                                    formatter.format(int.parse(tripsList[index]
                                                                            .tourDetail[0]
                                                                            // .cost))+
                                                                            .cost
                                                                            .toString())) +
                                                                        'sp'.tr(),
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          grey,
                                                                      fontSize:
                                                                          5.sp,
                                                                    ),
                                                                  ))
                                                            ],
                                                          )
                                                        : Container(),
                                                    SizedBox(
                                                      height: 2.h,
                                                    ),
                                                    tripsList[index]
                                                                .hasExpense ==
                                                            'Yes'
                                                        ? Column(
                                                            children: [
                                                              myText(
                                                                text: 'expens'
                                                                    .tr(),
                                                                fontSize: 6.sp,
                                                                color:
                                                                    primaryBlue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              SizedBox(
                                                                height: 1.h,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            2.w),
                                                                child: Column(
                                                                  children: List
                                                                      .generate(
                                                                          tripsList[index]
                                                                              .expenseDetail[
                                                                                  0]
                                                                              .type
                                                                              .length,
                                                                          (index2) =>
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  myText(text: tripsList[index].expenseDetail[0].type[index2] + ' ', fontSize: 5.sp, color: primaryBlue),
                                                                                  myText(text: formatter.format(int.parse(tripsList[index].expenseDetail[0].price[index2])) + 'sp'.tr() + ' ', fontSize: 5.sp, color: primaryBlue)
                                                                                ],
                                                                              )),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Container(),
                                                    SizedBox(
                                                      height: 1.h,
                                                    ),
                                                    Center(
                                                      child: ContainerWidget(
                                                        text: 'seeMore'.tr(),
                                                        h: 5.h,
                                                        w: 40.w,
                                                        onTap: () {
                                                          setState(() {
                                                            pickupAddTrip =
                                                                tripsList[index]
                                                                    .from
                                                                    .toString();
                                                            destAddrTrip =
                                                                tripsList[index]
                                                                    .to
                                                                    .toString();
                                                            fNameTrip =
                                                                tripsList[index]
                                                                    .firstName
                                                                    .toString();
                                                            lNameTrip =
                                                                tripsList[index]
                                                                    .lastName
                                                                    .toString();
                                                            phoneTrip =
                                                                tripsList[index]
                                                                    .phone
                                                                    .toString();
                                                            priceTrip =
                                                                tripsList[index]
                                                                    .cost
                                                                    .toString();
                                                            minTrip =
                                                                tripsList[index]
                                                                    .minutes
                                                                    .toString();
                                                            kmTrip =
                                                                tripsList[index]
                                                                    .km
                                                                    .toString();
                                                            idTrip =
                                                                tripsList[index]
                                                                    .id
                                                                    .toString();
                                                            userIdForTripOutcity =
                                                                tripsList[index]
                                                                    .userId
                                                                    .toString();
                                                          });
                                                          print('trip id ' +
                                                              tripsList[index]
                                                                  .id
                                                                  .toString());
                                                          DateTime t =
                                                              DateTime.now();
                                                          String start_time =
                                                              '${t.hour}:${t.minute}:${t.second}';
                                                          print(start_time);
                                                          if (tripsList[index]
                                                                  .hasExpense
                                                                  .toString() ==
                                                              'Yes') {
                                                            expensesList =
                                                                tripsList[index]
                                                                    .expenseDetail;
                                                          }
                                                          navigate(
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
                                                            tripsList[index]
                                                                .profileImage
                                                                .toString(),
                                                            tripsList[index]
                                                                .hasExpense
                                                                .toString(),
                                                            tripsList[index]
                                                                .date
                                                                .toString()
                                                                .split(' ')
                                                                .first,
                                                            tripsList[index]
                                                                .time
                                                                .toString(),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 2.h,
                                                    )
                                                  ],
                                                )),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 3.w,
                                            )
                                          ],
                                        );
                                      }),
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
