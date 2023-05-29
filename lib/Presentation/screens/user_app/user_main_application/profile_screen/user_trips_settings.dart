import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/get_user_trips_provider.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/order_tour_provider.dart';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:diamond_line/Presentation/widgets/container_widget2.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserTripsSettings extends StatefulWidget {
  const UserTripsSettings({Key? key}) : super(key: key);

  @override
  State<UserTripsSettings> createState() => _UserTripsSettingsState();
}

class _UserTripsSettingsState extends State<UserTripsSettings> {
  bool _isNetworkAvail = true;
  late List tripsList;
  bool noTrips = false;
  String msg = '';
  String tourId = '';
  bool isAddTour = false;
  late final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  @override
  void initState() {
    init();
    _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
    super.initState();
  }

  Future<void> init() async {
    tripsList = [];
    var creat = await Provider.of<GetUserTripsProvider>(context, listen: false);
    getUserTripsApi(creat);
  }

  bool showTime = false;
  TimeOfDay selectedTimeFrom = TimeOfDay.now();
  TimeOfDay selectedTimeTo = TimeOfDay.now();

  String getTime(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return '${tod.hour}:${tod.minute}:00';
  }

  //  Select for Time
  Future<TimeOfDay> _selectTimeFrom(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTimeFrom,
    );
    if (selected != null && selected != selectedTimeFrom) {
      setState(() {
        selectedTimeFrom = selected;
      });
    }
    return selectedTimeFrom;
  }

  //  Select for Time
  Future<TimeOfDay> _selectTimeTo(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTimeTo,
    );
    if (selected != null && selected != selectedTimeTo) {
      setState(() {
        selectedTimeTo = selected;
      });
    }
    return selectedTimeTo;
  }

  ///////////////////////// GET USER TRIPS API //////////////////////////////////
  Future<void> getUserTripsApi(GetUserTripsProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: CircularProgressIndicator());
      await creat.getUserTrips();
      if (creat.data.error == false) {
        Loader.hide();
        for (int i = 0; i < creat.data.data!.length; i++) {
          setState(() {
            tripsList.add(creat.data.data![i]);
          });
        }
      } else {
        Loader.hide();
        setState(() {
          noTrips = true;
          msg = creat.data.message.toString();
        });
      }
    } else {
      setSnackbar("nointernet".tr(), context);
    }
  }

  ////////////////// cancel trip api //////////////////////////
  Future<void> cancelTrip(String trip_id) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      Loader.show(context, progressIndicator: CircularProgressIndicator());
      var data = await AppRequests.cancelTripRequest(trip_id);
      data = json.decode(data);
      if (data["error"] == false) {
        Loader.hide();
        setState(() {
          init();
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

  ////////////////// order tour api //////////////////////////
  Future<void> orderTourApi(String trip_id, String start_time, String end_time,
      OrderTourProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: CircularProgressIndicator());
      await creat.orderTour(trip_id, start_time, end_time);
      if (creat.data.error == false) {
        Loader.hide();
        setState(() {
          tourId = creat.data.data!.id.toString();
          Navigator.pop(context);
          setSnackbar(creat.data.message.toString(), context);
          init();
        });
      } else {
        Loader.hide();
        Navigator.pop(context);
        setSnackbar(creat.data.message.toString(), context);
        setState(() {
          isAddTour = false;
        });
      }
    } else {
      setSnackbar("nointernet".tr(), context);
      print("nointernet");
    }
  }

  ////////////////// cancel tour api //////////////////////////
  Future<void> cancelTour(String tour_id) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      Loader.show(context, progressIndicator: CircularProgressIndicator());
      var data = await AppRequests.cancelTourRequest(tour_id);
      data = json.decode(data);
      if (data["error"] == false) {
        Loader.hide();
        setState(() {
          Future.delayed(const Duration(seconds: 1)).then((_) async {
            setSnackbar(data["message"].toString(), context);
            isAddTour = false;
            init();
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

  getDialog(String tripId) async {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      // height: 50.h,
                      width: 90.w,
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
                          Radius.circular(20),
                        ),
                        color: backgroundColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.w, right: 5.w),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              myText(
                                text: 'select the time of tour'.tr(),
                                fontSize: 5.sp,
                                color: primaryBlue3,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              ContainerWidget2(
                                text: 'from hour :'.tr(),
                                h: 6.h,
                                w: 40.w,
                                onTap: () async {
                                  final selected = await showTimePicker(
                                    context: context,
                                    initialTime: selectedTimeFrom,
                                  );
                                  if (selected != null &&
                                      selected != selectedTimeFrom) {
                                    setState(() {
                                      selectedTimeFrom = selected;
                                      showTime = true;
                                    });
                                  }
                                },
                                color: backgroundColor,
                                textColor: lightBlue,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              showTime
                                  ? Center(
                                      child: Text(getTime(selectedTimeFrom)))
                                  : const SizedBox(),
                              SizedBox(
                                height: 5.h,
                              ),
                              ContainerWidget2(
                                text: 'to hour :'.tr(),
                                h: 6.h,
                                w: 40.w,
                                onTap: () async {
                                  // _selectTimeTo(context);
                                  final selected = await showTimePicker(
                                    context: context,
                                    initialTime: selectedTimeTo,
                                  );
                                  if (selected != null &&
                                      selected != selectedTimeTo) {
                                    setState(() {
                                      selectedTimeTo = selected;
                                      showTime = true;
                                    });
                                  }
                                },
                                color: backgroundColor,
                                textColor: lightBlue,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              showTime
                                  ? Center(child: Text(getTime(selectedTimeTo)))
                                  : const SizedBox(),
                              SizedBox(
                                height: 2.h,
                              ),
                              Center(
                                child: ContainerWidget(
                                    text: 'ok'.tr(),
                                    h: 5.h,
                                    w: 40.w,
                                    onTap: () async {
                                      print('call api to add a tour');
                                      print(getTime(selectedTimeFrom));
                                      print(getTime(selectedTimeTo));
                                      var creat =
                                          await Provider.of<OrderTourProvider>(
                                              context,
                                              listen: false);
                                      orderTourApi(
                                          tripId,
                                          getTime(selectedTimeFrom),
                                          getTime(selectedTimeTo),
                                          creat);
                                      setState(() {
                                        isAddTour = true;
                                      });
                                    }),
                              ),
                              SizedBox(
                                height: 4.h,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        }).then((val) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                                      tripsList[index]
                                                                  .requestType !=
                                                              'moment'
                                                          ? ListTile(
                                                              leading:
                                                                  const Icon(
                                                                Icons
                                                                    .date_range,
                                                                color:
                                                                    primaryBlue,
                                                              ),
                                                              title: Text(
                                                                tripsList[index]
                                                                    .date
                                                                    .toString()
                                                                    .split(' ')
                                                                    .first,
                                                                style:
                                                                    TextStyle(
                                                                  // color: grey,
                                                                  color:
                                                                      primaryBlue,
                                                                  fontSize:
                                                                      5.sp,
                                                                ),
                                                              ))
                                                          : Container(),
                                                      tripsList[index]
                                                                  .requestType !=
                                                              'moment'
                                                          ? ListTile(
                                                              leading:
                                                                  Image.asset(
                                                                clock,
                                                                color:
                                                                    primaryBlue,
                                                              ),
                                                              title: Text(
                                                                tripsList[index]
                                                                    .time
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      primaryBlue,
                                                                  fontSize:
                                                                      5.sp,
                                                                ),
                                                              ))
                                                          : Container(),
                                                      ListTile(
                                                          leading: const Icon(
                                                            Icons.location_on,
                                                            color: primaryBlue,
                                                          ),
                                                          title: tripsList[
                                                                          index]
                                                                      .categoryId
                                                                      .toString() ==
                                                                  '2'
                                                              ? Text(
                                                                  'from'.tr() +
                                                                      ' ${tripsList[index].from.toString()}' +
                                                                      '\n' +
                                                                      'to'.tr() +
                                                                      ' ${tripsList[index].to.toString()}',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        primaryBlue,
                                                                    fontSize:
                                                                        5.sp,
                                                                  ),
                                                                )
                                                              : Text(
                                                                  'from'.tr() +
                                                                      ' ${tripsList[index].pickupAddr.toString()}' +
                                                                      '\n' +
                                                                      'to'.tr() +
                                                                      ' ${tripsList[index].destAddr.toString()}',
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        primaryBlue,
                                                                    fontSize:
                                                                        5.sp,
                                                                  ),
                                                                )),
                                                      tripsList[index]
                                                                  .categoryId
                                                                  .toString() ==
                                                              '2'
                                                          ? ListTile(
                                                              leading:
                                                                  const Icon(
                                                                Icons
                                                                    .directions,
                                                                color:
                                                                    primaryBlue,
                                                              ),
                                                              title: Text(
                                                                ' ${tripsList[index].direction.toString()}',
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      primaryBlue,
                                                                  fontSize:
                                                                      5.sp,
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
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
                                                            color: primaryBlue,
                                                            fontSize: 5.sp,
                                                          ),
                                                        ),
                                                      ),
                                                      ListTile(
                                                        leading: Text(
                                                          '${tripsList[index].status.toString()}',
                                                          style: TextStyle(
                                                            // color: primaryBlue,
                                                            color: green,
                                                            fontSize: 5.sp,
                                                          ),
                                                        ),
                                                        trailing:
                                                            // tripsList[index]
                                                            // .status
                                                            // .toString() ==
                                                            // 'pending'
                                                            // &&
                                                            tripsList[index]
                                                                        .canCancle
                                                                        .toString() ==
                                                                    'yes'
                                                                ? Container(
                                                                    height: 6.h,
                                                                    width: 35.w,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors
                                                                              .grey
                                                                              .withOpacity(0.3),
                                                                          spreadRadius:
                                                                              2,
                                                                          blurRadius:
                                                                              7,
                                                                          offset: const Offset(
                                                                              0,
                                                                              0),
                                                                        ),
                                                                      ],
                                                                      borderRadius: const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              20)),
                                                                      color:
                                                                          lightBlue2,
                                                                    ),
                                                                    child:
                                                                        TextButton(
                                                                      child:
                                                                          Text(
                                                                        'cancel'
                                                                            .tr(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                5.sp,
                                                                            color: Colors.red),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        await cancelTrip(tripsList[index]
                                                                            .id
                                                                            .toString());
                                                                      },
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    height: 6.h,
                                                                    width: 35.w,
                                                                  ),
                                                      ),
                                                      SizedBox(
                                                        height: 1.h,
                                                      ),
                                                      tripsList[index]
                                                                      .status
                                                                      .toString() ==
                                                                  'pending' &&
                                                              tripsList[index]
                                                                      .isTour ==
                                                                  'Yes' &&
                                                              tripsList[index]
                                                                      .categoryId
                                                                      .toString() ==
                                                                  '2'
                                                          ? Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  height: 1.h,
                                                                ),
                                                                Divider(
                                                                  color:
                                                                      lightBlue,
                                                                  thickness:
                                                                      3.0,
                                                                  endIndent:
                                                                      20.w,
                                                                  indent: 20.w,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left: 2
                                                                              .w,
                                                                          right:
                                                                              2.w),
                                                                  child: Text(
                                                                    'the tour'
                                                                        .tr(),
                                                                    style: TextStyle(
                                                                        fontSize: 6
                                                                            .sp,
                                                                        color:
                                                                            primaryBlue,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
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
                                                                          tripsList[index]
                                                                              .tourDetail[0]
                                                                              .startTime
                                                                              .toString(),
                                                                      style:
                                                                          TextStyle(
                                                                        color:
                                                                            primaryBlue,
                                                                        fontSize:
                                                                            5.sp,
                                                                      ),
                                                                    )),
                                                                ListTile(
                                                                    leading: Image
                                                                        .asset(
                                                                      clock,
                                                                      color:
                                                                          primaryBlue,
                                                                    ),
                                                                    title: Text(
                                                                      'to'.tr() +
                                                                          ' ' +
                                                                          tripsList[index]
                                                                              .tourDetail[0]
                                                                              .endTime
                                                                              .toString(),
                                                                      style:
                                                                          TextStyle(
                                                                        color:
                                                                            primaryBlue,
                                                                        fontSize:
                                                                            5.sp,
                                                                      ),
                                                                    )),
                                                                ListTile(
                                                                    leading: Icon(
                                                                        Icons
                                                                            .money,
                                                                        size:
                                                                            iconSize,
                                                                        color:
                                                                            primaryBlue),
                                                                    title: Text(
                                                                      formatter.format(int.parse(tripsList[index]
                                                                              .tourDetail[0]
                                                                              .cost
                                                                              .toString())) +
                                                                          'sp'.tr(),
                                                                      style:
                                                                          TextStyle(
                                                                        color:
                                                                            primaryBlue,
                                                                        fontSize:
                                                                            5.sp,
                                                                      ),
                                                                    )),
                                                                ListTile(
                                                                  leading: Text(
                                                                    tripsList[
                                                                            index]
                                                                        .tourDetail[
                                                                            0]
                                                                        .status,
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          green,
                                                                      fontSize:
                                                                          5.sp,
                                                                    ),
                                                                  ),
                                                                  trailing:
                                                                  tripsList[index]
                                                                      .canCancle
                                                                      .toString() ==
                                                                      'yes'
                                                                  ?
                                                                      Container(
                                                                    height: 6.h,
                                                                    width: 35.w,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors
                                                                              .grey
                                                                              .withOpacity(0.3),
                                                                          spreadRadius:
                                                                              2,
                                                                          blurRadius:
                                                                              7,
                                                                          offset: const Offset(
                                                                              0,
                                                                              0),
                                                                        ),
                                                                      ],
                                                                      borderRadius: const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              20)),
                                                                      color:
                                                                          lightBlue2,
                                                                    ),
                                                                    child:
                                                                        TextButton(
                                                                      child:
                                                                          Text(
                                                                        'cancel'
                                                                            .tr(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                5.sp,
                                                                            color: Colors.red),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        print(
                                                                            'call api cancel');
                                                                        print(tripsList[index]
                                                                            .tourDetail[0]
                                                                            .id
                                                                            .toString());
                                                                        await cancelTour(tripsList[index]
                                                                            .tourDetail[0]
                                                                            .id
                                                                            .toString());
                                                                      },
                                                                    ),
                                                                  )
                                                                      : Container(
                                                                    height: 6.h,
                                                                    width: 35.w,)
                                                                ),
                                                              ],
                                                            )
                                                          : tripsList[index]
                                                                          .status
                                                                          .toString() ==
                                                                      'pending' &&
                                                                  tripsList[index]
                                                                          .categoryId
                                                                          .toString() ==
                                                                      '2' &&
                                                                  isAddTour ==
                                                                      false
                                                              ? Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: 2.w,
                                                                      right:
                                                                          2.w,
                                                                      bottom:
                                                                          1.h),
                                                                  child:
                                                                      Container(
                                                                    height: 6.h,
                                                                    // width: getScreenWidth(context),
                                                                    width: 50.w,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors
                                                                              .grey
                                                                              .withOpacity(0.3),
                                                                          spreadRadius:
                                                                              2,
                                                                          blurRadius:
                                                                              7,
                                                                          offset: const Offset(
                                                                              0,
                                                                              0),
                                                                        ),
                                                                      ],
                                                                      borderRadius: const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              20)),
                                                                      color:
                                                                          lightBlue2,
                                                                    ),
                                                                    child:
                                                                        InkWell(
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.add,
                                                                            size:
                                                                                iconSize,
                                                                            color:
                                                                                primaryBlue,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                2.w,
                                                                          ),
                                                                          myText(
                                                                            text:
                                                                                'add a tour'.tr(),
                                                                            fontSize:
                                                                                5.sp,
                                                                            color:
                                                                                primaryBlue,
                                                                          )
                                                                        ],
                                                                      ),
                                                                      onTap:
                                                                          () async {
                                                                        getDialog(tripsList[index]
                                                                            .id
                                                                            .toString());
                                                                      },
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container(),
                                                      SizedBox(
                                                        height: 2.h,
                                                      )
                                                      // ),
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
                                      }),
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
                            )))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
