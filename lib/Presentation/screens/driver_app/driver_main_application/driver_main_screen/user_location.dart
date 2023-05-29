import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserLocationScreen extends StatefulWidget {
  UserLocationScreen(
      {required this.pickupLatitude,
      required this.pickupLongitude,
      required this.dropLatitude,
      required this.dropLongitude,
      Key? key})
      : super(key: key);

  String pickupLatitude, pickupLongitude, dropLatitude, dropLongitude;

  @override
  State<UserLocationScreen> createState() => _UserLocationScreenState();
}

class _UserLocationScreenState extends State<UserLocationScreen> {
  CameraPosition? _kGooglePlex;
  GoogleMapController? gmc;
  Marker? markerFrom, markerTo, markerDriver;
  late Position cl;
  late double driverLat;
  late double driverLong;
  List<LatLng> polylineCoordinates = [];
  List<LatLng> polylineCoordinates2 = [];

  @override
  void initState() {
    getLatAndLong();
    getPolyPoints(
        double.parse(widget.pickupLatitude),
        double.parse(widget.pickupLongitude),
        double.parse(widget.dropLatitude),
        double.parse(widget.dropLongitude));
    getPer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getLatAndLong() async {
    cl = await Geolocator.getCurrentPosition().then((value) => value);
    driverLat = cl.latitude;
    driverLong = cl.longitude;
    print('*********driverLat && driverLong**********');
    print(driverLat);
    print(driverLong);
    _kGooglePlex = CameraPosition(
      target: LatLng(double.parse(widget.pickupLatitude),
          double.parse(widget.pickupLongitude)),
      zoom: 12,
    );
    if (mounted) {
      setState(() {});
    }
    getPolyPoints2(driverLat, driverLong, double.parse(widget.pickupLatitude),
        double.parse(widget.pickupLongitude));
    setMarker();
  }

  void getPolyPoints(fromLat, fromLon, toLat, toLon) async {
    print('getPolyPoints');
    polylineCoordinates.clear();
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      APIKEY,
      PointLatLng(fromLat, fromLon),
      PointLatLng(toLat, toLon),
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

  void getPolyPoints2(fromLat, fromLon, toLat, toLon) async {
    print('getPolyPoints2');
    polylineCoordinates2.clear();
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      APIKEY,
      PointLatLng(fromLat, fromLon),
      PointLatLng(toLat, toLon),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates2.add(LatLng(point.latitude, point.longitude));
      });
    }
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

  void setMarker() async {
    print('////// set marker///');
    print(widget.pickupLatitude);
    print(widget.pickupLongitude);
    print(widget.dropLatitude);
    print(widget.dropLongitude);
    print(driverLat);
    print(driverLong);
    markerFrom = Marker(
      markerId: MarkerId("from"),
      position: LatLng(double.parse(widget.pickupLatitude),
          double.parse(widget.pickupLongitude)),
      rotation: 2,
      draggable: false,
      zIndex: 2,
      flat: true,
      anchor: Offset(0.5, 0.5),
      infoWindow: InfoWindow(title: 'from'.tr()),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    markerTo = Marker(
      markerId: MarkerId("to"),
      position: LatLng(double.parse(widget.dropLatitude),
          double.parse(widget.dropLongitude)),
      rotation: 2,
      draggable: false,
      zIndex: 2,
      flat: true,
      anchor: Offset(0.5, 0.5),
      infoWindow: InfoWindow(title: 'to'.tr()),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    markerDriver = Marker(
      markerId: MarkerId("driver"),
      position: LatLng(driverLat, driverLong),
      rotation: 2,
      draggable: false,
      zIndex: 2,
      flat: true,
      anchor: Offset(0.5, 0.5),
      infoWindow: InfoWindow(title: 'you are here'.tr()),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        child: Padding(
                            padding: EdgeInsets.all(2.w),
                            child: Stack(children: [
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
                                  polylines: {
                                    Polyline(
                                      polylineId: PolylineId('route'),
                                      points: polylineCoordinates,
                                      color: primaryBlue,
                                      width: 5,
                                    ),
                                    Polyline(
                                      polylineId: PolylineId('driverRoute'),
                                      points: polylineCoordinates2,
                                      color: Colors.red,
                                      width: 5,
                                    ),
                                  },
                                  markers:
                                      Set.of((markerFrom != null)
                                          ? [
                                              markerFrom!,
                                              markerTo!,
                                              markerDriver!
                                            ]
                                          : []),
                                  initialCameraPosition: _kGooglePlex!,
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    gmc = controller;
                                  },
                                  onTap: (latlng) {},
                                ),
                              ),
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