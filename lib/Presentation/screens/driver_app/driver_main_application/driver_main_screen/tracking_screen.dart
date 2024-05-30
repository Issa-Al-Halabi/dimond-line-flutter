import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_main_screen/trip_wait_for_payment_driver.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import '../../../../widgets/loader_widget.dart';
import 'package:flutter/services.dart';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_main_screen/trip_ended.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import '../../../../../Data/network/network_client.dart';
import '../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'dart:async';

final network_client client = network_client(Client());

class TrackingScreen extends StatefulWidget {
  String tripId;
  String pickupLatitude, pickupLongitude, dropLatitude, dropLongitude;

  TrackingScreen({
    required this.tripId,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropLatitude,
    required this.dropLongitude,
    Key? key,
  }) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  late Position cl;
  double lat = 0.0;
  double lng = 0.0;
  bool _isNetworkAvail = true;
  late SharedPreferences prefs;
  String deviceNumber = '';
  int deviceNumb = 0;
  var finalDistance;
  String totalPrice = '';
  String adminFare = '';

  List<GeoPoint> latLngList = [];
  ValueNotifier<GeoPoint?> lastGeoPoint = ValueNotifier(null);

  IOWebSocketChannel? _channel;
  late MapController controller;
  bool isLoading = false;

  @override
  void initState() {
    initShared();
    getLatAndLong();
    getPer();
    super.initState();
  }

  @override
  void dispose() {
    if (_channel != null) {
      _channel!.sink.close();
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> getCookie() async {
    try {
      Map<String, String> co = {};
      Response response = await get(Uri.parse(network_client.mycarSscSecurity_URL));
      co.addAll({"Cookie": response.headers['set-cookie'].toString()});
      print(co);
      _channel = IOWebSocketChannel.connect(
        Uri.parse(network_client.mycarSscSecurity_SOCKET),
        headers: co,
      );
    } catch (e) {
      setSnackbar(e.toString(), context);
    }
  }

  Future initShared() async {
    prefs = await SharedPreferences.getInstance();
    deviceNumber = prefs.getString('deviceNumber') ?? '';
    deviceNumb = int.parse(deviceNumber);
  }

  Future<void> getLatAndLong() async {
    cl = await Geolocator.getCurrentPosition().then((value) => value);
    lat = cl.latitude;
    lng = cl.longitude;
    controller = MapController(
      initPosition: GeoPoint(
        latitude: lat,
        longitude: lng,
      ),
    );

    latLngList.add(GeoPoint(latitude: lat, longitude: lng));

    isLoading = true;
    if (mounted) {
      setState(() {});
    }
    updateMarker();
  }

  Future getPer() async {
    LocationPermission permission;
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

  getDistance(double latcurrent, double lancurrent, double lat, double lng) {
    finalDistance = Geolocator.distanceBetween(
      latcurrent,
      lancurrent,
      lat,
      lng,
    );
    finalDistance = finalDistance / 1000;
    print('distance' + finalDistance.toString());
    return finalDistance.toString();
  }

  ///////////////////////// get location api //////////////////////////////////
  Future<void> getLocationApi(String lat, String lng, String device_id) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var data = await AppRequests.getLocationRequest(lat, lng, device_id);
      print(data);
      data = json.decode(data);
      if (data["error"] == false) {
      } else {}
    } else {
      setSnackbar("nointernet".tr(), context);
    }
  }

  ///////////////////////// OSM FLUTTER //////////////////////////////////
  void roadActionBt() async {
    controller.addMarker(
      GeoPoint(
        latitude: lat,
        longitude: lng,
      ),
      markerIcon: MarkerIcon(
        assetMarker: AssetMarker(
          scaleAssetImage: 2,
          image: AssetImage("assets/images/caricon.png"),
        ),
      ),
    );
    RoadInfo roadInfo = await controller.drawRoad(
      GeoPoint(
          latitude: double.parse(widget.pickupLatitude),
          longitude: double.parse(widget.pickupLongitude)),
      GeoPoint(
        latitude: double.parse(widget.dropLatitude),
        longitude: double.parse(widget.dropLongitude),
      ),
      roadType: RoadType.car,
      roadOption: RoadOption(
        roadWidth: 10,
        roadColor: Colors.blue,
        zoomInto: true,
      ),
    );

    // controller.changeLocationMarker(oldLocation: oldLocation, newLocation: newLocation)

    print("${roadInfo.distance}km");
    print("${roadInfo.duration}sec");
    print("${roadInfo.instructions}");
  }

  void UpdateRoadActionBt(double pickupLatitude, double pickupLongitude) async {
    await controller.removeLastRoad();
    RoadInfo roadInfo = await controller.drawRoad(
      GeoPoint(
        latitude: pickupLatitude,
        longitude: pickupLongitude,
      ),
      GeoPoint(
        latitude: double.parse(widget.dropLatitude),
        longitude: double.parse(widget.dropLongitude),
      ),
      roadType: RoadType.car,
      roadOption: RoadOption(
        roadWidth: 10,
        roadColor: Colors.blue,
        zoomInto: true,
      ),
    );
    print("${roadInfo.distance}km_2");
    print("${roadInfo.duration}sec_2");
    print("${roadInfo.instructions}");
  }

  void updateMarker() async {
    if (lastGeoPoint.value != null) {
      controller.changeLocationMarker(
        oldLocation: lastGeoPoint.value!,
        newLocation: latLngList.last,
      );
    } else {
      controller.addMarker(
        latLngList.last,
        markerIcon: MarkerIcon(
          assetMarker: AssetMarker(
            scaleAssetImage: 2,
            image: AssetImage(
              "assets/images/caricon.png",
            ),
          ),
        ),
      );
    }
    lastGeoPoint.value = latLngList.last;

    await controller.drawCircle(
      CircleOSM(
        key: "car",
        centerPoint: latLngList.last,
        radius: 10,
        color: Colors.blue,
        strokeWidth: 0.3,
      ),
    );
  }

  /////////////////////////trip end api //////////////////////////////////
  Future<void> endTripApi(
      String trip_id, String end_time, String finalDistance) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      Loader.show(context, progressIndicator: LoaderWidget());
      var data =
          await AppRequests.endTripRequest(trip_id, end_time, finalDistance);
      print(data);
      data = json.decode(data);
      if (data["error"] == false) {
        if (_channel != null) {
          _channel!.sink.close();
        }
        Loader.hide();
        setSnackbar(data["message"].toString(), context);
        setState(() {
          totalPrice = data["data"]["new_cost"].toString();
          adminFare = data["data"]["admin_fare"].toString();
          Future.delayed(const Duration(seconds: 3)).then((_) async {
            // Navigator.of(context).push(
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return TripEndedScreen(
                    tripId: widget.tripId,
                    finalCost: totalPrice.toString(),
                    adminFare: adminFare.toString(),
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

  /////////////////////////wait For Payment api //////////////////////////////////
  Future<void> waitForPaymentApi(
      String trip_id, String end_time, String finalDistance) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      Loader.show(context, progressIndicator: LoaderWidget());
      var data = await AppRequests.tripWaitForPaymentRequest(
        trip_id: trip_id,
        end_time: end_time,
        km: finalDistance,
      );
      print(data);

      if (data != null) {
        if (_channel != null) {
          _channel!.sink.close();
        }
        Loader.hide();
        setSnackbar(data["message"].toString(), context);
        setState(() {
          Future.delayed(const Duration(seconds: 3)).then((_) async {
            totalPrice = data["data"]["new_cost"].toString();
            adminFare = data["data"]["admin_fare"].toString();
            // Navigator.of(context).push(
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return TripWaitForPaymentDriverScreen(
                    tripId: widget.tripId,
                    finalCost: totalPrice.toString(),
                    adminFare: adminFare.toString(),
                    endTime: end_time.toString(),
                    finalDistance: finalDistance.toString(),
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
        setSnackbar("حدث خطأ ما", context);
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

  DateTime timeback = DateTime.now();

  @override
  Widget build(BuildContext context) {
    print("tracking dsfe================================================");
    return WillPopScope(
      onWillPop: () async {
        if (Loader.isShown == true) {
          Loader.hide();
        }
        final differance = DateTime.now().difference(timeback);
        final isExitWarning = differance >= Duration(seconds: 2);
        timeback = DateTime.now();
        if (isExitWarning) {
          final Message = "Press back again to Exit".tr();
          Fluttertoast.showToast(
            msg: Message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: white,
            textColor: primaryBlue,
            fontSize: 5.sp,
          );
          return false;
        } else {
          Fluttertoast.cancel();
          SystemNavigator.pop();
          return true;
        }
      },
      child: Scaffold(
        body: isLoading == false
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
                              topRight: Radius.circular(20),
                            ),
                            color: backgroundColor,
                          ),
                          child: Stack(
                            children: [
                              _channel != null
                                  ? StreamBuilder(
                                      stream: _channel!.stream,
                                      builder: (context, snapshot) {
                                        print(snapshot.connectionState);
                                        if (snapshot.hasData == true) {
                                          var data = json.decode(
                                            snapshot.data.toString(),
                                          );
                                          print('=========================');
                                          print(data);
                                          print('=========================');
                                          if (data['positions'] != null) {
                                            // todo
                                            if (data['positions'][0]
                                                    ['deviceId'] ==
                                                deviceNumb) {
                                              print(
                                                  '--------------------------------');
                                              lat = data['positions'][0]
                                                  ['latitude'];
                                              lng = data['positions'][0]
                                                  ['longitude'];

                                              latLngList.add(
                                                GeoPoint(
                                                  latitude: lat,
                                                  longitude: lng,
                                                ),
                                              );
                                              updateMarker();
                                              UpdateRoadActionBt(
                                                lat,
                                                lng,
                                              );
                                              //todo
                                              getLocationApi(
                                                lat.toString(),
                                                lng.toString(),
                                                deviceNumb.toString(),
                                              );
                                            }
                                          }
                                        } else {
                                          print('no data');
                                        }
                                        return Text('');
                                      },
                                    )
                                  : Container(),
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
                                    topRight: Radius.circular(20),
                                  ),
                                  color: backgroundColor,
                                ),
                                child: OSMFlutter(
                                  onMapIsReady: (p0) => roadActionBt(),
                                  controller: controller,
                                  osmOption: OSMOption(
                                    roadConfiguration: RoadOption(
                                      roadColor: Colors.blueAccent,
                                    ),
                                    showContributorBadgeForOSM: true,
                                    showDefaultInfoWindow: false,
                                    zoomOption: ZoomOption(initZoom: 14),
                                    enableRotationByGesture: true,
                                    staticPoints: [
                                      StaticPositionGeoPoint(
                                        "from",
                                        MarkerIcon(
                                          icon: Icon(
                                            Icons.location_on_rounded,
                                            color: Colors.green,
                                            size: 32,
                                          ),
                                        ),
                                        [
                                          GeoPoint(
                                            latitude: double.parse(
                                              widget.pickupLatitude,
                                            ),
                                            longitude: double.parse(
                                              widget.pickupLongitude,
                                            ),
                                          ),
                                        ],
                                      ),
                                      StaticPositionGeoPoint(
                                        "to",
                                        MarkerIcon(
                                          icon: Icon(
                                            Icons.location_on_rounded,
                                            color: Colors.green,
                                            size: 32,
                                          ),
                                        ),
                                        [
                                          GeoPoint(
                                            latitude: double.parse(
                                              widget.dropLatitude,
                                            ),
                                            longitude: double.parse(
                                              widget.dropLongitude,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 2.h,
                                left: 30.w,
                                right: 30.w,
                                child: ContainerWidget(
                                  text: 'end'.tr(),
                                  h: 7.h,
                                  w: 50.w,
                                  onTap: () {
                                    DateTime t = DateTime.now();
                                    String end_time =
                                        '${t.hour}:${t.minute}:${t.second}';
                                    getDistance(
                                      double.parse(widget.pickupLatitude),
                                      double.parse(widget.pickupLongitude),
                                      double.parse(widget.dropLatitude),
                                      double.parse(widget.dropLongitude),
                                    );
                                    waitForPaymentApi(
                                      widget.tripId,
                                      end_time,
                                      finalDistance.toString(),
                                    );
                                  },
                                ),
                              )
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
