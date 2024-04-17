import 'dart:typed_data';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/loader_widget.dart';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:diamond_line/Buisness_logic/provider/Driver_Provider/driver_trips_provider.dart';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_main_screen/trip_information.dart';
import 'package:diamond_line/Presentation/widgets/shimmer_widget.dart';
import 'package:diamond_line/constants.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Functions/helper.dart';

String? userIdForTrip = '';

class InsideCityDriverTrips extends StatefulWidget {
  const InsideCityDriverTrips();

  @override
  State<InsideCityDriverTrips> createState() => _InsideCityDriverTripsState();
}

class _InsideCityDriverTripsState extends State<InsideCityDriverTrips> {
  double lat = 0.0;
  double lng = 0.0;
  bool _isNetworkAvail = true;
  late SharedPreferences prefs;
  String deviceNumber = '';
  int deviceNumb = 0;
  CameraPosition? _kGooglePlex;
  GoogleMapController? gmc;
  late Position cl;
  bool isUpdate = false;
  int length = 0;
  bool isGetTrips = false;
  List idList = [];
  List pickupAddr = [];
  List destAddr = [];
  List fNameList = [];
  List lNameList = [];
  List phoneList = [];
  List priceList = [];
  List minutesList = [];
  List kmList = [];
  List userIdList = [];
  List requestTypeList = [];
  List timeList = [];
  List dateList = [];
  late List tripsList;
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
  late final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  Set<Marker> myMarker = {};

  @override
  void initState() {
    _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
    getPer();
    initShared();
    getLatAndLong();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future initShared() async {
    prefs = await SharedPreferences.getInstance();
    deviceNumber = prefs.getString('deviceNumber') ?? '';
    print(deviceNumber);
    deviceNumb = int.parse(deviceNumber);
    print(deviceNumb);
  }

  Future<void> init2() async {
    tripsList = [];
    var creat =
        await Provider.of<GetDriverTripsProvider>(context, listen: false);
    getDriverTripsApi(creat);
  }

  Future getPer() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  /////////////////////////get lat long api //////////////////////////////////
  Future<void> getLatAndLong() async {
    cl = await Geolocator.getCurrentPosition().then((value) => value);
    lat = cl.latitude;
    lng = cl.longitude;
    _kGooglePlex = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 14,
    );
    if (lat != 0.0 || lng != 0.0) {
      getLocationApi(lat.toString(), lng.toString(), deviceNumb.toString());
    } else {
      print('no lat or lng');
      getLatAndLong();
    }
    initMainMarker();
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
      if (data["error"] == false) {
        setState(() {
          isUpdate = true;
          Future.delayed(const Duration(seconds: 2)).then((_) async {
            init2();
          });
        });
      } else {}
    } else {
      setSnackbar("nointernet".tr(), context);
    }
  }

  /////////////////////////// get driver trips inside city api ///////////////////////////
  Future<void> getDriverTripsApi(GetDriverTripsProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.getDriverTrips();
      if (creat.data.error == false) {
        length = creat.data.data!.nearestTrips!.length;
        print('------------------');
        print(length);
        if (length != 0) {
          for (int i = 0; i < creat.data.data!.nearestTrips!.length; i++) {
            setState(() {
              tripsList.add(creat.data.data!.nearestTrips![i]);
              idList.add(creat.data.data!.nearestTrips![i].id);
              pickupAddr.add(creat.data.data!.nearestTrips![i].pickupAddr);
              destAddr.add(creat.data.data!.nearestTrips![i].destAddr);
              fNameList.add(creat.data.data!.nearestTrips![i].firstName);
              lNameList.add(creat.data.data!.nearestTrips![i].lastName);
              phoneList.add(creat.data.data!.nearestTrips![i].phone);
              priceList.add(creat.data.data!.nearestTrips![i].cost);
              kmList.add(creat.data.data!.nearestTrips![i].km);
              minutesList.add(creat.data.data!.nearestTrips![i].minutes);
              userIdList.add(creat.data.data!.nearestTrips![i].userId);
              requestTypeList
                  .add(creat.data.data!.nearestTrips![i].requestType);
              timeList.add(creat.data.data!.nearestTrips![i].time);
              dateList.add(creat.data.data!.nearestTrips![i].date);
              isGetTrips = true;
            });
            initMarker();
          }
        } else {
          setSnackbar('there are no trips'.tr(), context);
        }
        Loader.hide();
        setState(() {});
      } else {
        Loader.hide();
        setSnackbar(creat.data.message.toString(), context);
      }
    } else {
      setSnackbar("nointernet".tr(), context);
    }
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load(carIcon);
    return byteData.buffer.asUint8List();
  }

  void initMainMarker() async {
    Uint8List imageData = await getMarker();
    myMarker.add(Marker(
        markerId: MarkerId('source'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
            title: 'you are here'.tr(),
            onTap: () {
              print('marker info tab');
            }),
        icon: BitmapDescriptor.fromBytes(imageData)));
  }

  void initMarker() async {
    print('ggggggggggmmmmmmmmmmmllllllllll');
    for (int i = 0; i < tripsList.length; i++) {
      myMarker.add(Marker(
        markerId: MarkerId('$i'),
        position: LatLng(
          double.parse(tripsList[i].pickupLatitude),
          double.parse(tripsList[i].pickupLongitude),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
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

  void navigate(
    String trip_id,
    String pickupLatitude,
    String pickupLongitude,
    String dropLatitude,
    String dropLongitude,
    List options,
    String profileImage,
    String isOption,
  ) {
    if (requestType == 'moment') {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return TripInfoScreen(
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
              options: options,
              profileImage: profileImage,
              isOption: isOption,
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
            return TripInfoScreen(
              idTrip: idTrip,
              pickupAddTrip: pickupAddTrip,
              destAddrTrip: destAddrTrip,
              fNameTrip: fNameTrip,
              lNameTrip: lNameTrip,
              phoneTrip: phoneTrip,
              priceTrip: priceTrip,
              minTrip: minTrip,
              kmTrip: kmTrip,
              time: time,
              date: date,
              pickupLatitude: pickupLatitude,
              pickupLongitude: pickupLongitude,
              dropLatitude: dropLatitude,
              dropLongitude: dropLongitude,
              options: options,
              profileImage: profileImage,
              isOption: isOption,
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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPopLoader,
      child: Scaffold(
        body: _kGooglePlex == null
            ? Center(child: LoaderWidget())
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
                  padding: EdgeInsets.only(top: 9.h),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        RefreshIndicator(
                          color: primaryBlue,
                          key: _refreshIndicatorKey,
                          onRefresh: init2,
                          child: Container(
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
                              physics: NeverScrollableScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        isUpdate
                                            ? Container(
                                                height: 82.h,
                                                width: getScreenWidth(context),
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
                                                  color: backgroundColor,
                                                ),
                                                child: GoogleMap(
                                                  mapType: MapType.normal,
                                                  markers: myMarker,
                                                  initialCameraPosition:
                                                      _kGooglePlex!,
                                                  onMapCreated:
                                                      (GoogleMapController
                                                          controller) {
                                                    gmc = controller;
                                                  },
                                                  onTap: (latlng) {},
                                                ),
                                              )
                                            : shimmer(context),
                                        Positioned(
                                            top: 1.h,
                                            left: 3.w,
                                            child: InkWell(
                                              onTap: () {
                                                init2();
                                              },
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: primaryBlue
                                                          .withOpacity(0.3),
                                                      spreadRadius: 2,
                                                      blurRadius: 7,
                                                      offset:
                                                          const Offset(0, 0),
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(100)),
                                                  color: backgroundColor,
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                      Icons.refresh_outlined,
                                                      color: primaryBlue,
                                                      size: 30),
                                                ),
                                              ),
                                            )),
                                        Positioned(
                                            bottom: 1.h,
                                            child: Visibility(
                                              visible: isGetTrips,
                                              child: Container(
                                                height: 25.h,
                                                width: getScreenWidth(context),
                                                child: ListView.builder(
                                                    itemCount: length,
                                                    // itemCount: 3,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        1.h),
                                                            child: length == 0
                                                                ? Center(
                                                                    child:
                                                                        Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            20.h,
                                                                      ),
                                                                      Image
                                                                          .asset(
                                                                        noData,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        height:
                                                                            30.h,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            2.h,
                                                                      ),
                                                                      Text(
                                                                        'there are no trips'
                                                                            .tr(),
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'cairo',
                                                                            color:
                                                                                primaryBlue,
                                                                            fontSize:
                                                                                6.sp),
                                                                      )
                                                                    ],
                                                                  ))
                                                                : Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            2.w),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        print('id of trip' +
                                                                            idList[index].toString());
                                                                        setState(
                                                                            () {
                                                                          idTrip =
                                                                              idList[index].toString();
                                                                          pickupAddTrip =
                                                                              pickupAddr[index];
                                                                          destAddrTrip =
                                                                              destAddr[index];
                                                                          fNameTrip =
                                                                              fNameList[index];
                                                                          lNameTrip =
                                                                              lNameList[index];
                                                                          phoneTrip =
                                                                              phoneList[index];
                                                                          priceTrip =
                                                                              priceList[index].toString();
                                                                          minTrip =
                                                                              minutesList[index].toString();
                                                                          kmTrip =
                                                                              kmList[index].toString();
                                                                          requestType =
                                                                              requestTypeList[index].toString();
                                                                          time =
                                                                              timeList[index].toString();
                                                                          date =
                                                                              dateList[index].toString();
                                                                          userIdForTrip =
                                                                              userIdList[index].toString();
                                                                        });
                                                                        navigate(
                                                                            idList[index].toString(),
                                                                            tripsList[index].pickupLatitude,
                                                                            tripsList[index].pickupLongitude,
                                                                            tripsList[index].dropLatitude,
                                                                            tripsList[index].dropLongitude,
                                                                            tripsList[index].optionId,
                                                                            tripsList[index].profileImage.toString(),
                                                                            tripsList[index].options.toString());
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            25.h,
                                                                        width:
                                                                            67.w,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: primaryBlue.withOpacity(0.3),
                                                                              spreadRadius: 2,
                                                                              blurRadius: 7,
                                                                              offset: Offset(0, 0),
                                                                            ),
                                                                          ],
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(20)),
                                                                          color:
                                                                              white,
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsets.only(
                                                                              left: 2.w,
                                                                              right: 2.w),
                                                                          child:
                                                                              SingleChildScrollView(
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 1.h,
                                                                                ),
                                                                                Center(
                                                                                  child: Text(
                                                                                    requestTypeList[index],
                                                                                    style: TextStyle(color: primaryBlue, fontSize: 5.sp, fontWeight: FontWeight.w700),
                                                                                  ),
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      'from'.tr(),
                                                                                      style: TextStyle(
                                                                                        color: primaryBlue,
                                                                                        fontSize: 5.sp,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 5.w,
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Text(
                                                                                        '${pickupAddr[index]}',
                                                                                        style: TextStyle(
                                                                                          color: grey,
                                                                                          fontSize: 5.sp,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      'to'.tr(),
                                                                                      style: TextStyle(
                                                                                        color: primaryBlue,
                                                                                        fontSize: 5.sp,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 12.w,
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Text(
                                                                                        '${destAddr[index]}',
                                                                                        style: TextStyle(
                                                                                          color: grey,
                                                                                          fontSize: 5.sp,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 2.5.h,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                          ),
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
