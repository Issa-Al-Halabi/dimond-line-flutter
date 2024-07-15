import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/inside_city_trips/in_trip_screen.dart';
import 'package:flutter/material.dart';
import '../../../../../widgets/loader_widget.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/get_type_option_provider.dart';
import 'package:diamond_line/Data/Models/User_Models/get_type_option_Model.dart';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import '../../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../Functions/helper.dart';
import '../user_dashboard.dart';

class SelectFeatures extends StatefulWidget {
  SelectFeatures(
      {required this.fromLat,
      required this.fromLon,
      required this.toLat,
      required this.toLon,
      required this.price,
      required this.id,
      required this.km,
      required this.minutes,
      required this.sourceAdd,
      required this.destAdd,
      required this.type,
      this.date = '',
      this.time = '',
      Key? key})
      : super(key: key);

  int price;
  String id;
  double fromLat;
  double fromLon;
  double toLat;
  double toLon;
  String km, minutes, sourceAdd, destAdd, type;
  String date, time;

  @override
  State<SelectFeatures> createState() => _SelectFeaturesState();
}

class _SelectFeaturesState extends State<SelectFeatures> {
  bool _isNetworkAvail = true;
  List<bool> carList = [];
  List<Data> modelList = [];
  final List<String> selectedIndexes = [];
  int priceoption = 0;
  String msg = '';
  bool loading = false;
  List<String> optionsId = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    var initPro =
        await Provider.of<GetTypeOptionProvider>(context, listen: false)
            .getTypeOption(widget.id);
    modelList = await Provider.of<GetTypeOptionProvider>(context, listen: false)
        .data
        .data!;
    loading = await Provider.of<GetTypeOptionProvider>(context, listen: false)
        .isLoading;

    for (int i = 1; i <= modelList.length; i++) {
      carList.add(false);
    }
    print("carList");
    print(carList.length.toString());
    print(modelList.length);
    setState(() {});
  }

  @override
  void dispose() {
    Loader.hide();
    super.dispose();
  }

  ///////////////////////// get nearest car api //////////////////////////////////
  Future<void> getNearestCarApi(
      String latitude,
      String longitude,
      String tolat,
      String tolng,
      String km,
      String minutes,
      String pickup_addr,
      String dest_addr,
      String cost,
      String type_id,
      List optionsId,
      String order_time) async {
    _isNetworkAvail = await isNetworkAvailable();
    // Loader.show(context, progressIndicator: LoaderWidget());
    if (_isNetworkAvail) {
      print("There is internet");
      print("getNearestCarApi" + type_id);

      var data = await AppRequests.bookNowRequest(
          latitude,
          longitude,
          tolat,
          tolng,
          km,
          minutes,
          pickup_addr,
          dest_addr,
          cost,
          type_id,
          optionsId,
          order_time);
      data = json.decode(data);
      if (data["error"] == false) {
        // Loader.hide();
        if (mounted)
          setState(() {
            msg = data["message"];
            String tripId = data["data"]["id"].toString();
            print('tripId');
            print(tripId);
            // setSnackbar(msg, context);
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  // return UserDashboard(index: 1);
                  print("**********************************************");
                  print({
                    "tripId": tripId,
                    "pickupLatitude": latitude,
                    "pickupLongitude": longitude,
                    "dropLatitude": tolat,
                    "dropLongitude": tolng
                  });
                  return InTripScreen(
                      tripId: tripId,
                      pickupLatitude: latitude,
                      pickupLongitude: longitude,
                      dropLatitude: tolat,
                      dropLongitude: tolng);
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
        // Loader.hide();
        setSnackbar(data["message"].toString(), context);
      }
    } else {
      // Loader.hide();
      setSnackbar("nointernet".tr(), context);
    }
  }

  ///////////////////////// get nearest car delayed api //////////////////////////////////
  Future<void> getNearestCarDelayedApi(
      String latitude,
      String longitude,
      String tolat,
      String tolng,
      String km,
      String minutes,
      String pickup_addr,
      String dest_addr,
      String cost,
      String type_id,
      String date,
      String time,
      List optionsId) async {
    _isNetworkAvail = await isNetworkAvailable();
    Loader.show(context, progressIndicator: LoaderWidget());
    if (_isNetworkAvail) {
      print("There is internet");
      var data = await AppRequests.bookNowDelayedRequest(
        latitude,
        longitude,
        tolat,
        tolng,
        km,
        minutes,
        pickup_addr,
        dest_addr,
        cost,
        type_id,
        date,
        time,
        optionsId,
      );

      data = json.decode(data);
      if (data["error"] == false) {
        Loader.hide();
        setState(() {
          msg = data["message"];
          // TODO
          String tripId = data["data"]["id"].toString();
          print('tripId');
          print(tripId);
          setSnackbar(msg, context);
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return UserDashboard(index: 1);
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
      Loader.hide();
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
        body: modelList.length == 0
            ? Center(
                child: LoaderWidget(),
              )
            : Container(
                height: getScreenHeight(context),
                width: getScreenWidth(context),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(background),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 9.h,
                  ),
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
                              SizedBox(height: 8.h),
                              Container(
                                  width: 70.w,
                                  height: 8.h,
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
                                        BorderRadius.all(Radius.circular(20)),
                                    color: primaryBlue,
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        myText(
                                          text: widget.type,
                                          fontSize: 5.sp,
                                          color: white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        myText(
                                          text: formatter.format(widget.price) +
                                              'sp'.tr(),
                                          fontSize: 5.sp,
                                          color: white,
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(height: 3.h),
                              Expanded(
                                child: ListView.builder(
                                    itemCount: modelList.length,
                                    itemBuilder: (_, index) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.h),
                                            child: Container(
                                              height: 8.h,
                                              width: 80.w,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: primaryBlue
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
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 10),
                                                  Checkbox(
                                                    value: carList[index],
                                                    onChanged: (value) {
                                                      carList[index] = value!;
                                                      if (value == true) {
                                                        selectedIndexes.add(
                                                            modelList[index]
                                                                .name!);
                                                        print(index);
                                                        priceoption +=
                                                            int.parse(modelList[
                                                                    index]
                                                                .price!
                                                                .toString());
                                                        widget.price +=
                                                            int.parse(modelList[
                                                                    index]
                                                                .price!
                                                                .toString());
                                                        optionsId.add(
                                                            modelList[index]
                                                                .name
                                                                .toString());
                                                        setState(() {});
                                                      } else {
                                                        setState(() {});
                                                        selectedIndexes
                                                            .remove(index);
                                                        priceoption -=
                                                            int.parse(modelList[
                                                                    index]
                                                                .price!
                                                                .toString());
                                                        widget.price -=
                                                            int.parse(modelList[
                                                                    index]
                                                                .price!
                                                                .toString());
                                                        optionsId.remove(
                                                            modelList[index]
                                                                .name
                                                                .toString());
                                                      }
                                                      setState(() {});
                                                    },
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "${modelList[index].name}",
                                                    style: TextStyle(
                                                        fontSize: 17.0),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "${modelList[index].price}",
                                                    // formatter.format(double.parse(modelList[index].price)).toString(),
                                                    style: TextStyle(
                                                        fontSize: 17.0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              ContainerWidget(
                                  text: 'request'.tr(),
                                  h: 7.h,
                                  w: 60.w,
                                  onTap: () {
                                    Loader.show(context,
                                        progressIndicator: LoaderWidget());
                                    // if order now
                                    if (widget.date == '') {
                                      print('********************');
                                      print(widget.minutes);
                                      print(optionsId);
                                      DateTime t = DateTime.now();
                                      print(t);
                                      String order_time =
                                          '${t.hour}:${t.minute}:${t.second}';
                                      print(order_time);
                                      Loader.hide();
                                      // get nearest car
                                      print({
                                        widget.fromLat.toString(),
                                        widget.fromLon.toString(),
                                        widget.toLat.toString(),
                                        widget.toLon.toString(),
                                        widget.km,
                                        widget.minutes,
                                        widget.sourceAdd,
                                        widget.destAdd,
                                        widget.price.toString(),
                                        widget.id,
                                        optionsId,
                                        order_time
                                      });
                                      getNearestCarApi(
                                          widget.fromLat.toString(),
                                          widget.fromLon.toString(),
                                          widget.toLat.toString(),
                                          widget.toLon.toString(),
                                          widget.km,
                                          widget.minutes,
                                          widget.sourceAdd,
                                          widget.destAdd,
                                          widget.price.toString(),
                                          widget.id,
                                          optionsId,
                                          order_time);
                                    }
                                    // else if order later
                                    else {
                                      // get nearest delayed car
                                      print(optionsId);
                                      Loader.hide();
                                      getNearestCarDelayedApi(
                                          widget.fromLat.toString(),
                                          widget.fromLon.toString(),
                                          widget.toLat.toString(),
                                          widget.toLon.toString(),
                                          widget.km,
                                          widget.minutes,
                                          widget.sourceAdd,
                                          widget.destAdd,
                                          widget.price.toString(),
                                          widget.id,
                                          widget.date,
                                          widget.time,
                                          optionsId);
                                    }
                                  }),
                              SizedBox(
                                height: 5.h,
                              ),
                            ],
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
