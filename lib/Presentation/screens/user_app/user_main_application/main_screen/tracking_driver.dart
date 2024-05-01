import 'dart:convert';
import 'dart:typed_data';
import 'package:connectivity/connectivity.dart';
import 'package:diamond_line/Data/network/network_client.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
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
      required this.pickupLatitude,
      required this.pickupLongitude,
      required this.dropLatitude,
      required this.dropLongitude,
      Key? key})
      : super(key: key);

  String tripId;
  String driverDeviceNumb;
  String pickupLatitude, pickupLongitude, dropLatitude, dropLongitude;

  @override
  State<TrackingDriverScreen> createState() => _TrackingDriverScreenState();
}

class _TrackingDriverScreenState extends State<TrackingDriverScreen> {
  CameraPosition? _kGooglePlex;
  GoogleMapController? gmc;
  late Position cl;
  double lat = 0.0;
  double lng = 0.0;
  double course = 0.0;
  bool _isNetworkAvail = true;
  late SharedPreferences prefs;
  List<LatLng> latLngList = [];
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> pathPolyline = <Polyline>{};
  var finalDistance;
  String totalPrice = '';
  int deviceNumb = 0;
  Marker marker = Marker(markerId: MarkerId("home"));
  Marker marker2 = Marker(markerId: MarkerId("from"));
  Marker marker3 = Marker(markerId: MarkerId("to"));
  Circle? circle;

  IOWebSocketChannel? _channel;

  @override
  void initState() {
    // getCookie();
    deviceNumb = int.parse(widget.driverDeviceNumb);
    print('deviceNumb');
    print(deviceNumb);
    markerOfMainWay();
    getLatAndLong();

    ///رسم المسار الاساسي
    getpoly();
    getPer();
    super.initState();
  }

  @override
  void dispose() {
    if (_channel != null) {
      _channel!.sink.close();
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

  getpoly() async {
    await getPolyPoints();
  }

  /// رسم المسار الاساسي
  Future getPolyPoints() async {
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

  Future<void> getLatAndLong() async {
    cl = await Geolocator.getCurrentPosition().then((value) => value);
    lat = cl.latitude;
    lng = cl.longitude;
    _kGooglePlex = CameraPosition(
      target: LatLng(double.parse(widget.pickupLatitude),
          double.parse(widget.pickupLongitude)),
      zoom: 12,
    );
    latLngList.add(LatLng(lat, lng));
    print(latLngList);
    // pathPolyline.add(
    //   Polyline(
    //       polylineId: PolylineId('track'),
    //       color: Colors.red,
    //       width: 5,
    //       points: latLngList,
    //       patterns: [
    //         PatternItem.dash(20),
    //         PatternItem.gap(10),
    //       ]),
    // );
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

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load(carIcon);
    return byteData.buffer.asUint8List();
  }

  void updatePolyline() async {
    Uint8List imageData = await getMarker();
    marker = Marker(
        markerId: MarkerId("home"),
        position: latLngList.last,
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
        zIndex: 1,
        strokeColor: Colors.grey,
        center: latLngList.last,
        fillColor: Colors.grey.withAlpha(70));
    setState(() {});
    // pathPolyline.add(
    //   Polyline(
    //       polylineId: PolylineId('track'),
    //       color: Colors.red,
    //       width: 4,
    //       points: latLngList,
    //       patterns: [
    //         PatternItem.dash(20),
    //         PatternItem.gap(10),
    //       ]),
    // );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                                latLngList
                                                    .add(LatLng(lat, lng));
                                                updatePolyline();
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
                                child: GoogleMap(
                                  mapType: MapType.normal,
                                  zoomControlsEnabled: true,
                                  zoomGesturesEnabled: true,
                                  scrollGesturesEnabled: true,
                                  markers:
                                      // Set.of((marker != null) ? [marker!,marker2!, marker3!] : []),
                                      Set.of((marker3 != null)
                                          ? [marker, marker2, marker3]
                                          : []),
                                  // Set.of([marker!,marker2!, marker3!]),
                                  circles:
                                      Set.of((circle != null) ? [circle!] : []),

                                  /// مع المسار الاساسي
                                  polylines: {
                                    Polyline(
                                      polylineId: PolylineId('route'),
                                      points: polylineCoordinates,
                                      color: primaryBlue,
                                      width: 5,
                                    ),
                                    // Polyline(
                                    //     points: latLngList,
                                    //     polylineId: PolylineId('track'),
                                    //     color: Colors.red,
                                    //     width: 4,
                                    //     // points: latLngList,
                                    //     patterns: [
                                    //       PatternItem.dash(20),
                                    //       PatternItem.gap(10),
                                    //     ]),
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
