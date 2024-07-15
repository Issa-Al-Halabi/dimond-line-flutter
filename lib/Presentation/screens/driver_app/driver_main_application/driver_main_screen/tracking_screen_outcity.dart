import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:connectivity/connectivity.dart';
import 'package:diamond_line/Data/network/network_client.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_main_screen/trip_wait_for_payment_driver.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import '../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_main_screen/trip_ended_outcity.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import '../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';

import '../../../../Functions/helper.dart';

class TrackingScreenOutside extends StatefulWidget {
  TrackingScreenOutside(
      {required this.tripId,
      required this.pickupLatitude,
      required this.pickupLongitude,
      required this.dropLatitude,
      required this.dropLongitude,
      Key? key})
      : super(key: key);
  String tripId;
  String pickupLatitude, pickupLongitude, dropLatitude, dropLongitude;

  @override
  State<TrackingScreenOutside> createState() => _TrackingScreenOutsideState();
}

class _TrackingScreenOutsideState extends State<TrackingScreenOutside> {
  CameraPosition? _kGooglePlex;
  GoogleMapController? gmc;
  late Position cl;
  double lat = 0.0;
  double lng = 0.0;
  double course = 0.0;
  bool _isNetworkAvail = true;
  late SharedPreferences prefs;
  String deviceNumber = '';
  int deviceNumb = 0;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> pathPolyline = <Polyline>{};
  var finalDistance;
  String totalPrice = '';
  String adminFare = '';
  List<double> latList = [];
  List<double> lngList = [];
  List<LatLng> points = [];
  List<GeoPoint> GeoPoints = [];
  Marker? marker;
  Marker? marker2;
  Marker? marker3;
  Circle? circle;
  Timer? timer;
  ValueNotifier<GeoPoint?> lastGeoPoint = ValueNotifier(null);

  IOWebSocketChannel? _channel;

  MapController? controller;
  bool isLoading = false;

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

  @override
  void initState() {
    // markerOfMainWay();
    getLatAndLong();
    initShared();
    getPer();

    ///رسم المسار الاساسي
    super.initState();
  }

  getpoly() async {
    // markerOfMainWay();
    getLatAndLong();
  }

  // void markerOfMainWay() {
  //   marker2 = Marker(
  //     markerId: MarkerId("from"),
  //     position: LatLng(double.parse(widget.pickupLatitude),
  //         double.parse(widget.pickupLongitude)),
  //     rotation: 2,
  //     draggable: false,
  //     zIndex: 2,
  //     flat: true,
  //     anchor: Offset(0.5, 0.5),
  //     infoWindow: InfoWindow(
  //       title: 'from'.tr(),
  //     ),
  //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  //   );

  //   marker3 = Marker(
  //     markerId: MarkerId("to"),
  //     position: LatLng(double.parse(widget.dropLatitude),
  //         double.parse(widget.dropLongitude)),
  //     rotation: 2,
  //     draggable: false,
  //     zIndex: 2,
  //     flat: true,
  //     anchor: Offset(0.5, 0.5),
  //     infoWindow: InfoWindow(
  //       title: 'to'.tr(),
  //     ),
  //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  //   );
  // }
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

  Future initShared() async {
    prefs = await SharedPreferences.getInstance();
    deviceNumber = prefs.getString('deviceNumber') ?? '';
    deviceNumb = int.parse(deviceNumber);

    // read
    List<String> savedStrList = prefs.getStringList('latList') ?? [];
    latList = savedStrList.map((i) => double.parse(i)).toList();

    List<String> savedStrList2 = prefs.getStringList('lngList') ?? [];
    lngList = savedStrList2.map((i) => double.parse(i)).toList();

    print('latList and lngList from sharedPreference');
    print("${latList.toString()}");
    print("${lngList.toString()}");
  }

  Future<void> getLatAndLong() async {
    cl = await Geolocator.getCurrentPosition().then((value) => value);
    lat = cl.latitude;
    lng = cl.longitude;
    controller = MapController(
      initPosition: GeoPoint(latitude: lat, longitude: lng),
    );
    latList.add(lat);
    lngList.add(lng);
    // write
    List<String> strList = latList.map((i) => i.toString()).toList();
    prefs.setStringList("latList", strList);

    List<String> strList2 = lngList.map((i) => i.toString()).toList();
    prefs.setStringList("lngList", strList2);
    print(latList);
    print(lngList);
    for (int i = 0; i < latList.length; i++) {
      points.add(LatLng(latList[i], lngList[i]));
      GeoPoints.add(GeoPoint(latitude: latList[i], longitude: lngList[i]));
    }
    ;
    print('points');
    print(points);
    print('============================================');
    print('GeoPoints');
    print(GeoPoints);
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

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load(carIcon);
    return byteData.buffer.asUint8List();
  }

  void updatePolyline() async {
    Uint8List imageData = await getMarker();
    marker = Marker(
        markerId: MarkerId("home"),
        position: points.last,
        // rotation: 2,
        //////  directional marker
        rotation: course,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData));

    circle = Circle(
        circleId: CircleId("car"),
        radius: 10,
        //newLocalData.accuracy!,
        zIndex: 1,
        strokeColor: Colors.grey,
        center: points.last,
        fillColor: Colors.grey.withAlpha(70));
    setState(() {});
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

  void UpdateRoadActionBt(double pickupLatitude, double pickupLongitude) async {
    await controller!.removeLastRoad();
    // controller.changeLocationMarker(
    //   oldLocation: GeoPoint(latitude: lat, longitude: lng),
    //   newLocation: GeoPoint(latitude: lat, longitude: lng),
    //   markerIcon: MarkerIcon(
    //     assetMarker: AssetMarker(
    //       image: AssetImage('assets/images/caricon.png'),
    //     ),
    //   ),
    // );
    await controller!.drawCircle(
      CircleOSM(
        key: "car",
        centerPoint: GeoPoint(latitude: lat, longitude: lng),
        radius: 10,
        color: Colors.red,
        strokeWidth: 0.3,
      ),
    );
    RoadInfo roadInfo = await controller!.drawRoad(
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

  getDistance(double latcurrent, double lancurrent, double lat, double lng) {
    finalDistance = Geolocator.distanceBetween(
      latcurrent,
      lancurrent,
      lat,
      lng,
    );
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
        setState(() {});
      } else {}
    } else {
      setSnackbar("nointernet".tr(), context);
    }
  }

  /////////////////////////trip end api //////////////////////////////////
  Future<void> endTripApi(
      String trip_id, String end_time, String finalDistance) async {
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
        if (_channel != null) {
          _channel!.sink.close();
        }
        Loader.hide();
        setSnackbar(data["message"].toString(), context);
        setState(() {
          totalPrice = data["data"]["new_cost"].toString();
          print('new cost');
          print(totalPrice);
          adminFare = data["data"]["admin_fare"].toString();
          print('adminFare');
          print(adminFare);
          Future.delayed(const Duration(seconds: 3)).then((_) async {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return TripOutCityEndedScreen(
                      tripId: widget.tripId,
                      finalCost: totalPrice,
                      adminFare: adminFare);
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

  void updateMarker(
    double pickupLatitude,
    double pickupLongitude,
  ) async {
    print('2222222222222222222222222222');
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

  ////////////////// to update the driver location //////////////////////////
  void startPeriodicRequest() {
    timer = Timer.periodic(Duration(seconds: 10), (Timer tick) {
      if (timer != null) {
        updateDriverLocation();
      }

      print("timer :" + tick.tick.toString());
    });
  }

  Future<void> updateDriverLocation() async {
    try {
      Position currentLocation =
          await Geolocator.getCurrentPosition().then((value) => value);
      updateMarker(currentLocation.latitude, currentLocation.longitude);
    } catch (e) {
      print('updateDriverLocation failed with catch: ${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    print("tracking outcity");
    return WillPopScope(
      onWillPop: willPopLoader,
      child: Scaffold(
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
                                          // if (data['positions'][0]['deviceId'] == 252) {
                                          //TODO
                                          // if (data['positions'][0]['deviceId'] ==
                                          //     274) {
                                          if (data['positions'][0]
                                                  ['deviceId'] ==
                                              deviceNumb) {
                                            print(
                                                '////////////////////////////');
                                            // print(data['positions'][0]['deviceId']);
                                            // print(data['positions'][0]['latitude']);
                                            // print(data['positions'][0]['longitude']);
                                            print('course me');
                                            print(
                                                data['positions'][0]['course']);
                                            lat = data['positions'][0]
                                                ['latitude'];
                                            lng = data['positions'][0]
                                                ['longitude'];
                                            course =
                                                data['positions'][0]['course'];
                                            if (latList.last != lat &&
                                                lngList.last != lng) {
                                              print(
                                                  'lats and longs isnt equal');
                                              latList.add(lat);
                                              lngList.add(lng);
                                              List<String> strList = latList
                                                  .map((i) => i.toString())
                                                  .toList();
                                              prefs.setStringList(
                                                  "latList", strList);
                                              List<String> strList2 = lngList
                                                  .map((i) => i.toString())
                                                  .toList();
                                              prefs.setStringList(
                                                  "lngList", strList2);
                                              points.add(LatLng(lat, lng));
                                              GeoPoints.add(GeoPoint(
                                                  latitude: lat,
                                                  longitude: lng));
                                              // updatePolyline();
                                              // UpdateRoadActionBt(lat, lng);
                                              // getLocationApi(
                                              //     lat.toString(),
                                              //     lng.toString(),
                                              //     deviceNumb.toString());
                                            }
                                          }
                                        }
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
                                    topRight: Radius.circular(20)),
                                color: backgroundColor,
                              ),
                              child: OSMFlutter(
                                onMapIsReady: (p0) {
                                  roadActionBt();
                                  if (timer == null) {
                                    startPeriodicRequest();
                                  }
                                },
                                controller: controller!,
                                osmOption: OSMOption(
                                  zoomOption: ZoomOption(initZoom: 14),
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
                              // child: GoogleMap(
                              //   mapType: MapType.normal,
                              //   zoomControlsEnabled: true,
                              //   zoomGesturesEnabled: true,
                              //   scrollGesturesEnabled: true,
                              //   // padding: EdgeInsets.all(2.w),
                              //
                              //   markers: Set.of((marker != null)
                              //       ? [marker!, marker2!, marker3!]
                              //       : []),
                              //   circles:
                              //       Set.of((circle != null) ? [circle!] : []),
                              //
                              //   polylines: {
                              //     Polyline(
                              //       polylineId: PolylineId('route'),
                              //       points: polylineCoordinates,
                              //       color: primaryBlue,
                              //       width: 5,
                              //     ),
                              //   },
                              //
                              //   // /// مع المسار الاساسي
                              //   // polylines: {
                              //   //   Polyline(
                              //   //     polylineId: PolylineId('route'),
                              //   //     points: polylineCoordinates,
                              //   //     color: primaryBlue,
                              //   //     width: 5,
                              //   //   ),
                              //   //   Polyline(
                              //   //       points: points,
                              //   //       polylineId: PolylineId('track'),
                              //   //       color: Colors.red,
                              //   //       width: 4,
                              //   //       // points: latLngList,
                              //   //       patterns: [
                              //   //         PatternItem.dash(20),
                              //   //         PatternItem.gap(10),
                              //   //       ]),
                              //   // },
                              //
                              //   /// بدون المسار الاساسي
                              //   // polylines: pathPolyline,
                              //
                              //   initialCameraPosition: _kGooglePlex!,
                              //   onMapCreated: (GoogleMapController controller) {
                              //     gmc = controller;
                              //   },
                              //   onTap: (latlng) {},
                              // ),
                            ),
                            Positioned(
                                bottom: 2.h,
                                left: 30.w,
                                right: 30.w,
                                child: ContainerWidget(
                                    text: 'end'.tr(),
                                    h: 7.h,
                                    w: 50.w,
                                    onTap: () async {
                                      DateTime t = DateTime.now();
                                      print(t);
                                      String end_time =
                                          '${t.hour}:${t.minute}:${t.second}';
                                      print(end_time);
                                      print(latList);
                                      print(lngList);
                                      print(latList.first);
                                      print(latList.last);
                                      print(lngList.first);
                                      print(lngList.last);
                                      getDistance(latList.first, lngList.first,
                                          latList.last, lngList.last);
                                      print(widget.tripId);
                                      print(end_time);
                                      print(finalDistance.toString());
                                      latList = [];
                                      lngList = [];
                                      prefs.remove('latList');
                                      prefs.remove('lngList');
                                      for (int i = 0; i < latList.length; i++) {
                                        points.add(
                                            LatLng(latList[i], lngList[i]));
                                        GeoPoints.add(GeoPoint(
                                            latitude: latList[i],
                                            longitude: lngList[i]));
                                      }
                                      ;
                                      getDistance(
                                        double.parse(widget.pickupLatitude),
                                        double.parse(widget.pickupLongitude),
                                        double.parse(widget.dropLatitude),
                                        double.parse(widget.dropLongitude),
                                      );
                                      await waitForPaymentApi(widget.tripId,
                                          end_time, finalDistance.toString());
                                    }))
                          ]),
                        ),
                        // SizedBox(
                        //   height: 3.h,
                        // ),
                        // BottomIconsDriver(),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
