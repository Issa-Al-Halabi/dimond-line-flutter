import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import '../../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/order_tour_provider.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/trip_outcity_provider.dart';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:diamond_line/Presentation/Functions/helper.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:diamond_line/Presentation/widgets/container_widget2.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../user_dashboard.dart';
import 'map_screen.dart';

class SelectCarOutCity extends StatefulWidget {
  SelectCarOutCity(
      {required this.vechileImage,
      required this.vechileType,
      required this.carModel,
      required this.seats,
      required this.bags,
      required this.filteredLength,
      required this.date,
      required this.time,
      required this.to,
      required this.categoryId,
      required this.subCategoryId,
      required this.vechileId,
      required this.priceList,
      this.distance,
      this.timeOfTrip,
      this.fromLat,
      this.fromLon,
      this.toLat,
      this.toLon,
      Key? key})
      : super(key: key);

  List vechileImage, vechileType, vechileId, carModel, priceList;

  String seats, bags, date, time, to;
  int filteredLength;
  String categoryId, subCategoryId;
  String? timeOfTrip;
  String? distance;
  String? fromLat;
  String? fromLon;
  String? toLat;
  String? toLon;

  @override
  State<SelectCarOutCity> createState() => _SelectCarOutCityState();
}

class _SelectCarOutCityState extends State<SelectCarOutCity> {
  bool isAccept = false;
  bool isOrdered = false;
  String oneVechileId = '';
  bool _isNetworkAvail = true;
  String orderType = '';
  String orderTypeId = '';
  String tripId = '';
  String tourId = '';
  String price = '';
  String msg = '';

  bool showTime = false;
  TimeOfDay selectedTimeFrom = TimeOfDay.now();
  TimeOfDay selectedTimeTo = TimeOfDay.now();

  String getTime(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
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

  ///////////////////////// trip out city  api //////////////////////////////////
  Future<void> tripOutcityApi(
      String pickup_latitude,
      String pickup_longitude,
      String drop_latitude,
      String drop_longitude,
      String category_id,
      String subcategory_id,
      String km,
      String minutes,
      String vehicle_id,
      String time,
      String date,
      String bags,
      String seats,
      String direction,
      String from,
      String to,
      TripOutCityProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.getTripOutcity(
          pickup_latitude,
          pickup_longitude,
          drop_latitude,
          drop_longitude,
          category_id,
          subcategory_id,
          km,
          minutes,
          vehicle_id,
          time,
          date,
          bags,
          seats,
          direction,
          from,
          to);
      if (creat.data.error == false) {
        Loader.hide();
        setState(() {
          tripId = creat.data.data![0].id.toString();
          price = creat.data.data![0].cost.toString();
          msg = creat.data.message.toString();
          Navigator.of(context).pop();
          getDialog3();
          Future.delayed(const Duration(seconds: 1)).then((_) async {});
        });
      } else {
        Loader.hide();
        setSnackbar(creat.data.message.toString(), context);
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
      setSnackbar('There is internet', context);
      var data = await AppRequests.cancelTripRequest(trip_id);
      data = json.decode(data);
      if (data["error"] == false) {
        Loader.hide();
        setState(() {
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

  ////////////////// order tour api //////////////////////////
  Future<void> orderTourApi(String trip_id, String start_time, String end_time,
      OrderTourProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.orderTour(trip_id, start_time, end_time);
      if (creat.data.error == false) {
        Loader.hide();
        setState(() {
          tourId = creat.data.data!.id.toString();
          Navigator.pop(context);
          setSnackbar(creat.data.message.toString(), context);
        });
      } else {
        Loader.hide();
        setSnackbar(creat.data.message.toString(), context);
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
      Loader.show(context, progressIndicator: LoaderWidget());
      setSnackbar('There is internet', context);
      var data = await AppRequests.cancelTourRequest(tour_id);
      data = json.decode(data);
      if (data["error"] == false) {
        Loader.hide();
        setState(() {
          Future.delayed(const Duration(seconds: 1)).then((_) async {
            Navigator.pop(context);
            setSnackbar(data["message"].toString(), context);
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

  decriseTime(var fiftyDaysFromNow) {
    setState(() {
      fiftyDaysFromNow--;
    });
  }

  String getText() {
    if (isAccept == true && isOrdered == false) {
      return 'cancel'.tr();
    } else if (isAccept == true && isOrdered == true) {
      return 'ordered successfully'.tr();
    } else {
      return 'ok'.tr();
    }
  }

  getDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      // height: 65.h,
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
                        padding: EdgeInsets.only(left: 5.w, right: 2.w),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 1.h,
                              ),
                              Center(
                                child: myText(
                                  text: '${widget.date}\n ${widget.time}',
                                  fontSize: 5.sp,
                                  color: lightBlue,
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              RadioListTile(
                                contentPadding: EdgeInsets.only(right: 10.w),
                                title: myText(
                                  text: "going".tr(),
                                  fontSize: 5.sp,
                                  color: primaryBlue,
                                ),
                                value: "going".tr(),
                                groupValue: orderType,
                                activeColor: primaryBlue,
                                onChanged: (value) {
                                  setState(() {
                                    orderType = "going".tr();
                                    print(orderType);
                                    orderTypeId = '1';
                                    print(orderTypeId);
                                  });
                                },
                              ),
                              RadioListTile(
                                contentPadding: EdgeInsets.only(right: 10.w),
                                title: myText(
                                  text: "goingandback".tr(),
                                  fontSize: 5.sp,
                                  color: primaryBlue,
                                ),
                                value: "goingandback".tr(),
                                groupValue: orderType,
                                activeColor: primaryBlue,
                                onChanged: (value) {
                                  setState(() {
                                    orderType = "goingandback".tr();
                                    print(orderType);
                                    orderTypeId = '2';
                                    print(orderTypeId);
                                  });
                                },
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 5.w,
                                  right: 5.w,
                                ),
                                child: ContainerWidget(
                                    text: getText(),
                                    h: 6.h,
                                    w: 50.w,
                                    onTap: () async {
                                      if (orderTypeId == '') {
                                        setSnackbar(
                                            'please select type'.tr(), context);
                                      } else {
                                        if (isAccept == true &&
                                            isOrdered == false) {
                                          print('call api cancel');
                                          print(tripId);
                                          await cancelTrip(tripId);
                                        } else {
                                          print(widget.fromLat!);
                                          print(widget.fromLon!);
                                          print(widget.toLat!);
                                          print(widget.toLon!);
                                          print(widget.categoryId);
                                          print(widget.subCategoryId);
                                          print(widget.distance!);
                                          print(widget.timeOfTrip!);
                                          print(oneVechileId);
                                          print(widget.time);
                                          print(widget.date);
                                          print(widget.bags);
                                          print(widget.seats);
                                          print('********');
                                          print(orderTypeId);
                                          var creat = await Provider.of<
                                                  TripOutCityProvider>(context,
                                              listen: false);
                                          tripOutcityApi(
                                              widget.fromLat!,
                                              widget.fromLon!,
                                              widget.toLat!,
                                              widget.toLon!,
                                              widget.categoryId,
                                              widget.subCategoryId,
                                              widget.distance!,
                                              widget.timeOfTrip!,
                                              oneVechileId,
                                              widget.time,
                                              widget.date,
                                              widget.bags,
                                              widget.seats,
                                              orderTypeId,
                                              addressFromMarker,
                                              addressToMarker,
                                              creat);
                                          print(isAccept);
                                          setState(() {
                                            isAccept = true;
                                            print(isAccept);
                                          });
                                          Timer timer = Timer.periodic(
                                              // Duration(seconds: 20), (timer) {
                                              Duration(hours: 24), (timer) {
                                            setState(() {
                                              isOrdered = true;
                                              print(isAccept);
                                              print(isOrdered);
                                              timer.cancel();
                                            });
                                          });
                                        }
                                      }
                                    }),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Visibility(
                                visible: isOrdered == true ? true : false,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 12.w, right: 8.w),
                                  child: InkWell(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: iconSize,
                                          color: lightBlue,
                                        ),
                                        myText(
                                          text: 'add a tour'.tr(),
                                          fontSize: 5.sp,
                                          color: lightBlue,
                                        )
                                      ],
                                    ),
                                    onTap: () async {
                                      Navigator.pop(context);
                                      getDialog2();
                                    },
                                  ),
                                ),
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

  getDialog2() async {
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
                      height: 65.h,
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
                                w: 50.w,
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
                                w: 50.w,
                                onTap: () async {
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
                                child: InkWell(
                                  child: myText(
                                    text: 'ok'.tr(),
                                    fontSize: 8.sp,
                                    color: primaryBlue,
                                  ),
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
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Center(
                                child: ContainerWidget(
                                    text: 'cancel'.tr(),
                                    h: 5.h,
                                    w: 40.w,
                                    onTap: () async {
                                      print('call api cancel');
                                      print(tourId);
                                      await cancelTour(tourId);
                                    }),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Center(
                                child: ContainerWidget(
                                    text: 'edit tour'.tr(),
                                    h: 5.h,
                                    w: 40.w,
                                    onTap: () async {
                                      Navigator.pop(context);
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

  getDialog3() async {
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
                      height: 18.h,
                      width: 80.w,
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
                            children: [
                              SizedBox(
                                height: 2.h,
                              ),
                              myText(
                                text: 'cost of trip'.tr(),
                                fontSize: 5.sp,
                                color: primaryBlue3,
                              ),
                              myText(
                                text: formatter.format(int.parse(price)),
                                fontSize: 5.sp,
                                color: primaryBlue3,
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              ContainerWidget(
                                  text: 'ok'.tr(),
                                  h: 5.h,
                                  w: 30.w,
                                  onTap: () {
                                    setSnackbar(msg, context);
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation) {
                                          return UserDashboard();
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
                                  }),
                              SizedBox(
                                height: 1.h,
                              ),
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
                    child: Column(
                      children: [
                        Expanded(
                          flex: 8,
                          child: ListView.builder(
                              itemCount: widget.filteredLength,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1.h),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            print('***********');
                                            print(widget.vechileId[index]
                                                .toString());
                                            oneVechileId = widget
                                                .vechileId[index]
                                                .toString();
                                            getDialog();
                                          });
                                        },
                                        child: Container(
                                          width: 95.w,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                spreadRadius: 2,
                                                blurRadius: 7,
                                                offset: const Offset(0, 0),
                                              ),
                                            ],
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            color: backgroundColor,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 2.h,
                                                        ),
                                                        Text(
                                                          widget.vechileType[
                                                              index],
                                                          style: TextStyle(
                                                              color:
                                                                  primaryBlue,
                                                              fontSize: 6.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          height: 2.h,
                                                        ),
                                                        Text(
                                                          widget
                                                              .carModel[index],
                                                          style: TextStyle(
                                                            color: primaryBlue,
                                                            fontSize: 5.sp,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 2.h,
                                                        ),
                                                        Text(
                                                          '${widget.seats}' +
                                                              ' ' +
                                                              'person'.tr(),
                                                          style: TextStyle(
                                                            color: grey,
                                                            fontSize: 5.sp,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 2.h,
                                                        ),
                                                        Text(
                                                          '${widget.bags}' +
                                                              ' ' +
                                                              'bags'.tr(),
                                                          style: TextStyle(
                                                            color: grey,
                                                            fontSize: 5.sp,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 2.h,
                                                        ),
                                                        Text(
                                                          formatter
                                                                  .format(double
                                                                      .parse(widget
                                                                              .priceList[
                                                                          index]))
                                                                  .toString() +
                                                              'sp'.tr(),
                                                          style: TextStyle(
                                                            color: grey,
                                                            fontSize: 5.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    widget.vechileImage[index]
                                                                .endsWith(
                                                                    ".jpg") ||
                                                            widget.vechileImage[
                                                                    index]
                                                                .endsWith(
                                                                    ".png")
                                                        ? FadeInImage(
                                                            image: NetworkImage(
                                                                widget.vechileImage[
                                                                    index]),
                                                            height: 12.h,
                                                            width: 25.w,
                                                            fit: BoxFit.contain,
                                                            imageErrorBuilder:
                                                                (context, error,
                                                                        stackTrace) =>
                                                                    erroWidget(
                                                                        100),
                                                            placeholder:
                                                                placeHolder(
                                                                    100),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ],
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
