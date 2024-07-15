import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:connectivity/connectivity.dart';
import 'package:diamond_line/Data/network/network_client.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import '../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/rating_screen.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import '../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';

class TrackingDriverScreen extends StatefulWidget {
  TrackingDriverScreen(
      {required this.tripId,
      required this.driverDeviceNumb,
      required this.driverId,
      required this.pickupLatitude,
      required this.pickupLongitude,
      required this.dropLatitude,
      required this.dropLongitude,
      Key? key})
      : super(key: key);

  String tripId;
  String driverId;
  String driverDeviceNumb;
  String pickupLatitude, pickupLongitude, dropLatitude, dropLongitude;

  @override
  State<TrackingDriverScreen> createState() => _TrackingDriverScreenState();
}

class _TrackingDriverScreenState extends State<TrackingDriverScreen> {
  GoogleMapController? gmc;
  late Position cl;
  double lat = 0.0;
  double lng = 0.0;
  double course = 0.0;
  bool _isNetworkAvail = true;
  late SharedPreferences prefs;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> pathPolyline = <Polyline>{};
  var finalDistance;
  String totalPrice = '';
  int deviceNumb = 0;

  List<GeoPoint> latLngList = [];
  ValueNotifier<GeoPoint?> lastGeoPoint = ValueNotifier(null);
  MapController? controller;
  bool isLoading = false;
  Timer? timer;

  IOWebSocketChannel? _channel;

  @override
  void initState() {
    // getCookie();
    deviceNumb = int.parse(widget.driverDeviceNumb);
    print('deviceNumb');
    print(deviceNumb);
    getLatAndLong();

    ///رسم المسار الاساسي
    getPer();

    super.initState();
  }

  @override
  void dispose() {
    print("dispose()");
    if (_channel != null) {
      _channel!.sink.close();
    }
    if (timer != null) {
      print("timer != null");
      timer!.cancel();
      timer = null;
    }

    if (controller != null) {
      controller!.dispose();
      controller = null;
    }
    super.dispose();
  }

  Future<void> getCookie() async {
    try {
      Map<String, String> co = {};
      Response response =
          await get(Uri.parse(network_client.mycarSscSecurity_URL));
      co.addAll({"Cookie": response.headers['set-cookie'].toString()});
      print(co);
      _channel = IOWebSocketChannel.connect(
          Uri.parse(network_client.mycarSscSecurity_SOCKET),
          headers: co);
    } catch (e) {
      setSnackbar(e.toString(), context);
    }
  }

  /// رسم المسار الاساس
  void roadActionBt() async {
    // controller.addMarker(
    //   GeoPoint(
    //     latitude: lat,
    //     longitude: lng,
    //   ),
    //   markerIcon: MarkerIcon(
    //     assetMarker: AssetMarker(
    //       scaleAssetImage: 2,
    //       image: AssetImage("assets/images/caricon.png"),
    //     ),
    //   ),
    // );
    final pickupGeoPoint = GeoPoint(
        latitude: double.parse(widget.pickupLatitude),
        longitude: double.parse(widget.pickupLongitude));

    RoadInfo roadInfo = await controller!.drawRoad(
      pickupGeoPoint,
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

    // init marker
    await controller!.addMarker(
      pickupGeoPoint,
      markerIcon: MarkerIcon(
        assetMarker: AssetMarker(
          scaleAssetImage: 2,
          image: AssetImage(
            "assets/images/caricon.png",
          ),
        ),
      ),
    );
    // Update lastGeoPoint with the new coordinates
    lastGeoPoint.value = pickupGeoPoint;
    // controller.changeLocationMarker(oldLocation: oldLocation, newLocation: newLocation)

    print("${roadInfo.distance}km");
    print("${roadInfo.duration}sec");
    print("${roadInfo.instructions}");
  }

  Future<void> getLatAndLong() async {
    cl = await Geolocator.getCurrentPosition().then((value) => value);
    lat = cl.latitude;
    lng = cl.longitude;
    controller = MapController(
      initPosition: GeoPoint(
        latitude: double.parse(widget.pickupLatitude),
        longitude: double.parse(widget.pickupLongitude),
      ),
    );
    latLngList.add(GeoPoint(latitude: lat, longitude: lng));

    print(latLngList);
    // updateMarker();

    isLoading = true;

    if (mounted) {
      setState(() {});
    }
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

  // void updateMarker() async {
  //   if (lastGeoPoint.value != null) {
  //     controller!.changeLocationMarker(
  //       oldLocation: lastGeoPoint.value!,
  //       newLocation: latLngList.last,
  //     );
  //   } else {
  //     controller!.addMarker(
  //       latLngList.last,
  //       markerIcon: MarkerIcon(
  //         assetMarker: AssetMarker(
  //           scaleAssetImage: 2,
  //           image: AssetImage(
  //             "assets/images/caricon.png",
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  //   lastGeoPoint.value = latLngList.last;
  //   controller!.drawCircle(
  //     CircleOSM(
  //       key: "car",
  //       centerPoint: latLngList.last,
  //       radius: 50,
  //       color: Colors.blue,
  //       strokeWidth: 0.3,
  //     ),
  //   );
  // }

  void updateMarker(
    double pickupLatitude,
    double pickupLongitude,
  ) async {
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    print({
      "latitude": pickupLatitude,
      "longitude": pickupLongitude,
    });
    if (controller == null || !mounted) {
      return;
    }
    // Create the new GeoPoint
    final newGeoPoint = GeoPoint(
      latitude: pickupLatitude,
      longitude: pickupLongitude,
    );

    // Check if lastGeoPoint is not null and is different from the newGeoPoint
    if (lastGeoPoint.value != null) {
      print("Removing existing marker at ${lastGeoPoint.value}");

      // Attempt to remove the existing marker
      await controller!.removeMarker(lastGeoPoint.value!);
      await controller!.removeMarkers([
        lastGeoPoint.value!,
        newGeoPoint,
      ]);

      print("Markers removed, adding new marker at $newGeoPoint");
    }
    // Add the new marker
    await controller!.addMarker(
      newGeoPoint,
      markerIcon: MarkerIcon(
        assetMarker: AssetMarker(
          scaleAssetImage: 2,
          image: AssetImage(
            "assets/images/caricon.png",
          ),
        ),
      ),
    );

    // Update lastGeoPoint with the new coordinates
    lastGeoPoint.value = newGeoPoint;

    print("Marker added and lastGeoPoint updated to $newGeoPoint");

    await controller!.drawCircle(
      CircleOSM(
        key: "car",
        centerPoint: newGeoPoint,
        radius: 50,
        color: Colors.blue,
        strokeWidth: 0.3,
      ),
    );
  }

  getDistance(double latcurrent, double lancurrent, double lat, double lng) {
    finalDistance = Geolocator.distanceBetween(
      latcurrent,
      lancurrent,
      lat,
      lng,
    );
    print('distance');
    print(finalDistance);
    print(finalDistance / 1000);
    finalDistance = finalDistance / 1000;
    return finalDistance.toString();
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
        // setState(() {});
      } else {}
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

  ////////////////// to update the driver location //////////////////////////
  void startPeriodicRequest(driver_id) {
    timer = Timer.periodic(Duration(seconds: 10), (Timer tick) {
      if (timer != null) {
        updateDriverLocation(driver_id);
      }

      print("timer :" + tick.tick.toString());
    });
  }

  Future<void> updateDriverLocation(driver_id) async {
    try {
      final response = await AppRequests.updateDriverLocation(
          driver_id: driver_id.toString());

      if (response != null) {
        print('Response data: ${response}');
        updateMarker(double.parse(response["latitude"].toString()),
            double.parse(response["longitude"].toString()));
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Request failed with catch: ${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == false || controller == null
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
                              topRight: Radius.circular(20)),
                          color: backgroundColor,
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(2.w),
                            child: Stack(children: [
                              _channel != null
                                  ? StreamBuilder(
                                      stream: _channel!.stream,
                                      builder: (context, snapshot) {
                                        print(snapshot.data);
                                        print(snapshot.connectionState);
                                        if (snapshot.hasData == true) {
                                          var data = json
                                              .decode(snapshot.data.toString());
                                          print(
                                              '--------------------------------');
                                          if (data['positions'] != null) {
                                            if (data['positions'][0]
                                                    ['deviceId'] ==
                                                // TODO
                                                deviceNumb) {
                                              // 204) {
                                              print('course me');
                                              print(data['positions'][0]
                                                  ['course']);
                                              lat = data['positions'][0]
                                                  ['latitude'];
                                              lng = data['positions'][0]
                                                  ['longitude'];
                                              course = data['positions'][0]
                                                  ['course'];
                                              if (latLngList.last.latitude !=
                                                      lat &&
                                                  latLngList.last.longitude !=
                                                      lng) {
                                                print(
                                                    'lats and longs isnt equal');
                                                latLngList.add(GeoPoint(
                                                    latitude: lat,
                                                    longitude: lng));
                                                // updateMarker();
                                                getLocationApi(
                                                    lat.toString(),
                                                    lng.toString(),
                                                    deviceNumb.toString());
                                              }
                                            }
                                          }
                                        } else {}
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
                                      topRight: Radius.circular(20)),
                                  color: backgroundColor,
                                ),
                                child: OSMFlutter(
                                  onMapIsReady: (p0) {
                                    roadActionBt();
                                    if (timer == null) {
                                      startPeriodicRequest(widget.driverId);
                                    }
                                  },
                                  controller: controller!,
                                  osmOption: OSMOption(
                                    zoomOption: ZoomOption(
                                      initZoom: 14,
                                    ),
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
                                      text: 'rate'.tr(),
                                      h: 7.h,
                                      w: 50.w,
                                      onTap: () {
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            pageBuilder: (BuildContext context,
                                                Animation<double> animation,
                                                Animation<double>
                                                    secondaryAnimation) {
                                              return RatingScreen(
                                                tripId: widget.tripId,
                                              );
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
                                      }))
                            ])),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
