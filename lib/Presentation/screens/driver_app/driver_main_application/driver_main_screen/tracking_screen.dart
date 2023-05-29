import 'dart:convert';
import 'dart:typed_data';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_main_screen/trip_ended.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import '../../../../../Data/network/network_client.dart';
import '../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'dart:async';

final network_client client = network_client(Client());

class TrackingScreen extends StatefulWidget {
  TrackingScreen(
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
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
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
  List<LatLng> latLngList = [];
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> pathPolyline = <Polyline>{};
  var finalDistance;
  String totalPrice = '';
  String adminFare = '';
  Marker marker = Marker(markerId: MarkerId("home"));
  Marker marker2 = Marker(markerId: MarkerId("from"));
  Marker marker3 = Marker(markerId: MarkerId("to"));
  Circle? circle;
  List<double> latListIn = [];
  List<double> lngListIn = [];

  var _channel = IOWebSocketChannel.connect(
    Uri.parse(
      'ws://mycar.ssc-security.net:8080/api/socket',
    ),
  );

  @override
  void initState() {
    getCookie();
    markerOfMainWay();
    initShared();
    getLatAndLong();
    getPer();
    saveShared();
    getPolyPoints();
    super.initState();
  }

  saveShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('tripId', widget.tripId);
    prefs.setString('pickupLatitude', widget.pickupLatitude);
    prefs.setString('pickupLongitude', widget.pickupLongitude);
    prefs.setString('dropLatitude', widget.dropLatitude);
    prefs.setString('dropLongitude', widget.dropLongitude);
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  Future<void> getCookie() async {
    Map<String, String> co = {};
    Response response = await get(Uri.parse(
      'http://mycar.ssc-security.net:8080/api/session?token=oqBN0XE1usgfA25X465NJs24XHtNs20S',
    ));
    co.addAll({"Cookie": response.headers['set-cookie'].toString()});
    _channel = IOWebSocketChannel.connect(
        Uri.parse(
          'ws://mycar.ssc-security.net:8080/api/socket',
        ),
        headers: co);
  }

  Future initShared() async {
    prefs = await SharedPreferences.getInstance();
    deviceNumber = prefs.getString('deviceNumber') ?? '';
    deviceNumb = int.parse(deviceNumber);
    // read
    List<String> savedStrList = prefs.getStringList('latListIn') ?? [];
    latListIn = savedStrList.map((i) => double.parse(i)).toList();
    List<String> savedStrList2 = prefs.getStringList('lngListIn') ?? [];
    lngListIn = savedStrList2.map((i) => double.parse(i)).toList();
    print('latListIn and lngListIn from sharedPreference');
    print("${latListIn.toString()}");
    print("${lngListIn.toString()}");
  }

  Future<void> getLatAndLong() async {
    cl = await Geolocator.getCurrentPosition().then((value) => value);
    lat = cl.latitude;
    lng = cl.longitude;
    _kGooglePlex = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 14,
    );
    latLngList.add(LatLng(lat, lng));

    latListIn.add(lat);
    lngListIn.add(lng);
    // write
    List<String> strList = latListIn.map((i) => i.toString()).toList();
    prefs.setStringList("latListIn", strList);
    List<String> strList2 = lngListIn.map((i) => i.toString()).toList();
    prefs.setStringList("lngListIn", strList2);
    print('/////////////////');
    print(latListIn);
    print(lngListIn);
    for (int i = 0; i < latListIn.length; i++) {
      latLngList.add(LatLng(latListIn[i], lngListIn[i]));
    };
    pathPolyline.add(
      Polyline(
          polylineId: PolylineId('track'),
          color: Colors.red,
          width: 5,
          points: latLngList,
          patterns: [
            PatternItem.dash(20),
            PatternItem.gap(10),
          ]),
    );
    if (mounted) {
      setState(() {});
    }
    updatePolyline();
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

  void markerOfMainWay() {
    marker2 = Marker(
      markerId: MarkerId("from"),
      position: LatLng(double.parse(widget.pickupLatitude),
          double.parse(widget.pickupLongitude)),
      rotation: 2,
      draggable: false,
      zIndex: 2,
      flat: true,
      anchor: Offset(0.5, 0.5),
      infoWindow: InfoWindow(
        title: 'from'.tr(),
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    marker3 = Marker(
      markerId: MarkerId("to"),
      position: LatLng(double.parse(widget.dropLatitude),
          double.parse(widget.dropLongitude)),
      rotation: 2,
      draggable: false,
      zIndex: 2,
      flat: true,
      anchor: Offset(0.5, 0.5),
      infoWindow: InfoWindow(
        title: 'to'.tr(),
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load(carIcon);
    return byteData.buffer.asUint8List();
  }

  void updatePolyline() async {
    Uint8List imageData = await getMarker();
    marker = Marker(
        markerId: MarkerId("home"),
        position: latLngList.last,
        rotation: course,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData));
    circle = Circle(
        circleId: CircleId("car"),
        radius: 10,
        zIndex: 1,
        strokeColor: Colors.grey,
        center: latLngList.last,
        fillColor: Colors.grey.withAlpha(70));
    setState(() {});
    pathPolyline.add(
      Polyline(
          polylineId: PolylineId('track'),
          color: Colors.red,
          width: 5,
          points: latLngList,
          patterns: [
            PatternItem.dash(20),
            PatternItem.gap(10),
          ]),
    );
  }

  /// رسم المسار الاساسي
  void getPolyPoints() async {
    polylineCoordinates.clear();
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      APIKEY,
      PointLatLng(double.parse(widget.pickupLatitude),
          double.parse(widget.pickupLongitude)),
      PointLatLng(double.parse(widget.dropLatitude),
          double.parse(widget.dropLongitude)),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    if (mounted) {
      setState(() {});
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

  /////////////////////////get location api //////////////////////////////////
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

  /////////////////////////trip end api //////////////////////////////////
  Future<void> endTripApi(
      String trip_id, String end_time, String finalDistance) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      Loader.show(context, progressIndicator: CircularProgressIndicator());
      var data =
          await AppRequests.endTripRequest(trip_id, end_time, finalDistance);
      print(data);
      data = json.decode(data);
      if (data["error"] == false) {
        _channel.sink.close();
        Loader.hide();
        prefs.remove('tripId');
        prefs.remove('pickupLatitude');
        prefs.remove('pickupLongitude');
        prefs.remove('dropLatitude');
        prefs.remove('dropLongitude');
        setSnackbar(data["message"].toString(), context);
        setState(() {
          totalPrice = data["data"]["new_cost"].toString();
          adminFare = data["data"]["admin_fare"].toString();
          Future.delayed(const Duration(seconds: 3)).then((_) async {
            Navigator.of(context).push(
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
    return WillPopScope(
      onWillPop: () async {
        final differance = DateTime.now().difference(timeback);
        final isExitWarning = differance >= Duration(seconds: 2);
        timeback = DateTime.now();
        if (isExitWarning) {
          final Message = "Press back agin to Exit".tr();
          Fluttertoast.showToast(
              msg: Message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: white,
              textColor: primaryBlue,
              fontSize: 5.sp);
          return false;
        } else {
          Fluttertoast.cancel();
          SystemNavigator.pop();
          return true;
        }
      },
      child: Scaffold(
        body: _kGooglePlex == null
            ? Center(child: CircularProgressIndicator())
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
                            StreamBuilder(
                              stream: _channel.stream,
                              builder: (context, snapshot) {
                                print(snapshot.connectionState);
                                if (snapshot.hasData == true) {
                                  var data =
                                      json.decode(snapshot.data.toString());
                                  if (data['positions'] != null) {
                                    // if (data['positions'][0]['deviceId'] == 204) {
                                      if (data['positions'][0]['deviceId'] ==
                                          deviceNumb) {
                                      print('--------------------------------');
                                      lat = data['positions'][0]['latitude'];
                                      lng = data['positions'][0]['longitude'];
                                      course = data['positions'][0]['course'];
                                      if(latListIn.last != lat && lngListIn.last != lng){
                                        print('lats and longs isnt equal');
                                        latListIn.add(lat);
                                        lngListIn.add(lng);
                                        List<String> strList = latListIn
                                            .map((i) => i.toString())
                                            .toList();
                                        prefs.setStringList(
                                            "latListIn", strList);
                                        List<String> strList2 = lngListIn
                                            .map((i) => i.toString())
                                            .toList();
                                        prefs.setStringList(
                                            "lngListIn", strList2);
                                        latLngList.add(LatLng(lat, lng));
                                        updatePolyline();
                                        getLocationApi(
                                            lat.toString(),
                                            lng.toString(),
                                            deviceNumb.toString());
                                      }
                                    }
                                  }
                                } else {
                                  print('no data');
                                }
                                return Text('');
                              },
                            ),
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
                              child: GoogleMap(
                                mapType: MapType.normal,
                                zoomControlsEnabled: true,
                                zoomGesturesEnabled: true,
                                scrollGesturesEnabled: true,
                                // padding: EdgeInsets.all(2.w),
                                markers:
                                    Set.of((marker3 != null)
                                        ? [marker, marker2, marker3]
                                        : []),
                                circles:
                                    Set.of((circle != null) ? [circle!] : []),
                                // polylines: {
                                //   Polyline(
                                //     polylineId: PolylineId('route'),
                                //     points: polylineCoordinates,
                                //     color: primaryBlue,
                                //     width: 5,
                                //   ),
                                // },

                                /// مع المسار الاساسي
                                polylines: {
                                  Polyline(
                                    polylineId: PolylineId('route'),
                                    points: polylineCoordinates,
                                    color: primaryBlue,
                                    width: 4,
                                  ),

                                  //TODO
                                  Polyline(
                                      points: latLngList,
                                      polylineId: PolylineId('track'),
                                      color: Colors.red,
                                      width: 4,
                                      patterns: [
                                        PatternItem.dash(20),
                                        PatternItem.gap(10),
                                      ]),
                                },

                                /// بدون المسار الاساسي
                                // polylines: pathPolyline,
                                initialCameraPosition: _kGooglePlex!,
                                onMapCreated:
                                    (GoogleMapController controller) {
                                  gmc = controller;
                                },
                                onTap: (latlng) {},
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
                                      print(t);
                                      String end_time =
                                          '${t.hour}:${t.minute}:${t.second}';
                                      print(end_time);
                                      print(latLngList.first.latitude);
                                      print(latLngList.first.longitude);
                                      print(latLngList.last.latitude);
                                      print(latLngList.last.longitude);
                                      print(latListIn);
                                      print(lngListIn);
                                      print(latListIn.first);
                                      print(latListIn.last);
                                      print(lngListIn.first);
                                      print(lngListIn.last);
                                      print(widget.tripId);
                                      getDistance(
                                          latListIn.first,
                                          lngListIn.first,
                                          latListIn.last,
                                          lngListIn.last);
                                      print(finalDistance.toString());
                                      latListIn = [];
                                      lngListIn = [];
                                      prefs.remove('latListIn');
                                      prefs.remove('lngListIn');
                                      for (int i = 0;
                                          i < latListIn.length;
                                          i++) {
                                        latLngList.add(LatLng(
                                            latListIn[i], lngListIn[i]));
                                      }
                                      ;
                                      endTripApi(widget.tripId, end_time,
                                          finalDistance.toString());
                                    }))
                          ]),
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