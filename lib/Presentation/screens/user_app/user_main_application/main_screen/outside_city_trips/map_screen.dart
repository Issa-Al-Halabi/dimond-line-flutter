import 'dart:async';
import 'dart:convert';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import '../../../../../widgets/loader_widget.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../../../../../Functions/helper.dart';
import 'outside_city.dart';
import 'package:intl/intl.dart';

String addressFromMarker = '', addressToMarker = '';

class MapScreen extends StatefulWidget {
  MapScreen(
      {this.categoryId, this.subCategoryId, this.country, this.to, Key? key})
      : super(key: key);

  String? country;
  String? subCategoryId;
  String? categoryId;
  String? to;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late Position cl;
  var lat;
  var long;
  TextEditingController controllerFrom = TextEditingController();
  double fromLat = 0.0;
  double fromLon = 0.0;
  TextEditingController controllerTo = TextEditingController();
  double toLat = 0.0;
  double toLon = 0.0;
  String timeOfTrip = '';
  var distance;

  late MapController controller;
  bool isLoading = false;

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

  void roadActionBt(
      double fromLat, double fromLon, double toLat, double toLon) async {
    try {
      print(
          'Coordinates: From ($fromLat, $fromLon) To ($toLat, $toLon)'); // Debug print

      RoadInfo roadInfo = await controller.drawRoad(
        GeoPoint(
          latitude: fromLat,
          longitude: fromLon,
        ),
        GeoPoint(
          latitude: toLat,
          longitude: toLon,
        ),
        roadType: RoadType.car,
        roadOption: RoadOption(
          roadWidth: 15,
          roadColor: Colors.blue,
          zoomInto: true,
        ),
      );

      print('Road Info: ${roadInfo.toString()}');
      print('Route: ${roadInfo.route}');
      print('Distance: ${roadInfo.distance} km');
      print('Duration: ${roadInfo.duration} sec');
      print('Instructions: ${roadInfo.instructions}');
    } catch (e) {
      print('Error: $e');
    }
  }

  getDistance(double latcurrent, double lancurrent, double lat, double lng) {
    distance = Geolocator.distanceBetween(
      latcurrent,
      lancurrent,
      lat,
      lng,
    );
    distance = distance / 1000;
    print('distance' + distance.toString());
    return distance.toString();
  }

  getTimeOfTrip(
      double latcurrent, double lancurrent, double lat, double lng) async {
    timeOfTrip = await AppRequests.getTimeFromLatLng(
        fromLat: latcurrent.toString(),
        fromLong: lancurrent.toString(),
        toLat: lat.toString(),
        toLong: lng.toString());

    if (mounted) {
      setState(() {});
    }
    return timeOfTrip;
  }

  convertFromAddress(double lat, double long) async {
    print(addressFromMarker);

    addressFromMarker = await AppRequests.getLocationNameFromLatLng(
        lat: lat.toString(), long: long.toString());
    if (addressFromMarker != "") {
      setState(() {
        print(addressFromMarker);
      });
    } else {
      setSnackbar("Error While Connecting Please Check your Internet", context);
    }
  }

  convertToAddress(double lat, double long) async {
    print("addressToMarker addressToMarker addressToMarker");
    print(addressToMarker);
    addressToMarker = await AppRequests.getLocationNameFromLatLng(
        lat: lat.toString(), long: long.toString());
    if (addressToMarker != "") {
      setState(() {
        print(addressToMarker);
      });
    } else {
      setSnackbar("Error While Connecting Please Check your Internet", context);
    }
  }

  @override
  void initState() {
    getPer();
    getAddress();
    super.initState();
  }

  Future getAddress() async {
    await getAddTo();
    await getAddFrom();
    isLoading = true;
  }

  Future getAddTo() async {
    List<double> coordinates = await getCoordinates(widget.to.toString());
    print(coordinates);
    toLat = coordinates[0];
    toLon = coordinates[1];
    convertToAddress(toLat, toLon);
    if (mounted) {
      setState(() {});
    }
  }

  Future getAddFrom() async {
    List<double> coordinates = await getCoordinates('Damascus');
    print(coordinates);
    fromLat = coordinates[0];
    fromLon = coordinates[1];
    // Do something with the latitude and longitude

    controller = await MapController.withPosition(
      initPosition: GeoPoint(latitude: fromLat, longitude: fromLon),
    );

    getDistance(fromLat, fromLon, toLat, toLon);
    getTimeOfTrip(fromLat, fromLon, toLat, toLon);
    convertFromAddress(fromLat, fromLon);
    if (mounted) {
      setState(() {});
    }
  }

  Future<List<double>> getCoordinates(String address) async {
    final apiKey = APIKEY; // Replace with your own Google Maps API key
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        final results = data['results'];
        if (results.isNotEmpty) {
          final location = results[0]['geometry']['location'];
          final latitude = location['lat'];
          final longitude = location['lng'];
          return [latitude, longitude];
        }
      }
    }
    return [];
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 91.h,
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
                              onMapIsReady: (p0) {
                                if (fromLat != toLat && fromLon != toLon) {
                                  roadActionBt(fromLat, fromLon, toLat, toLon);
                                }
                              },
                              controller: controller,
                              osmOption: OSMOption(
                                staticPoints: [
                                  StaticPositionGeoPoint(
                                    "from",
                                    MarkerIcon(
                                      icon: Icon(
                                        Icons.location_on_rounded,
                                        color: Colors.blue,
                                        size: 40,
                                      ),
                                    ),
                                    [
                                      GeoPoint(
                                          latitude: fromLat,
                                          longitude: fromLon),
                                    ],
                                  ),
                                  StaticPositionGeoPoint(
                                    "to",
                                    MarkerIcon(
                                      icon: Icon(
                                        Icons.location_on_rounded,
                                        color: Colors.blue,
                                        size: 40,
                                      ),
                                    ),
                                    [
                                      GeoPoint(
                                        latitude: toLat,
                                        longitude: toLon,
                                      ),
                                    ],
                                  ),
                                ],
                                zoomOption: ZoomOption(
                                  initZoom: 14,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 5.h,
                            left: 10.w,
                            right: 10.w,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 2.h,
                                ),
                                InkWell(
                                  child: Container(
                                    width: 60.w,
                                    height: 8.h,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                      gradient: RadialGradient(
                                        colors: [Colors.blueGrey, primaryBlue3],
                                        radius: 1.2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'confirm'.tr(),
                                        style: TextStyle(
                                            fontSize: 5.sp,
                                            color: backgroundColor),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Loader.show(context,
                                        progressIndicator: LoaderWidget());
                                    print(fromLat);
                                    print(fromLon);
                                    print(toLat);
                                    print(toLon);
                                    print(widget.categoryId);
                                    print(widget.subCategoryId);
                                    print(timeOfTrip);
                                    print(distance);
                                    print(widget.to);
                                    if (fromLat != 0.0 && toLat != 0.0) {
                                      Loader.hide();
                                      if (addressFromMarker == "" &&
                                          addressToMarker == "") {
                                        print("addressFromMarker " +
                                            addressFromMarker);
                                        print("addressToMarker " +
                                            addressToMarker);
                                        setSnackbar(
                                          'somethingMSg'.tr(),
                                          context,
                                        );
                                        convertToAddress(toLat, toLon);
                                      } else {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OutsideCityScreen(
                                              categoryId: widget.categoryId,
                                              subCategoryId:
                                                  widget.subCategoryId,
                                              timeOfTrip: timeOfTrip,
                                              distance: distance.toString(),
                                              fromLat: fromLat.toString(),
                                              fromLon: fromLon.toString(),
                                              toLat: toLat.toString(),
                                              toLon: toLon.toString(),
                                              to: widget.to,
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      Loader.hide();
                                      setSnackbar(
                                        'enter all fields'.tr(),
                                        context,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
