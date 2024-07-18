import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import '../../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../../Buisness_logic/provider/User_Provider/nearest_cars_map_provider.dart';
import '../../../../../Functions/helper.dart';
import '../../../../../widgets/loader_widget.dart';
import 'order_now.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class MapScreen2 extends StatefulWidget {
  MapScreen2({Key? key}) : super(key: key);

  @override
  State<MapScreen2> createState() => _MapScreen2State();
}

class _MapScreen2State extends State<MapScreen2> {
  late Position cl;
  double lat = 0.0;
  double long = 0.0;
  TextEditingController controllerFrom = TextEditingController();
  TextEditingController controllerTo = TextEditingController();
  List<LatLng> polylineCoordinates = [];
  String timeOfTrip = '';
  var distance;
  String address = '';
  bool _isNetworkAvail = true;
  int length = 0;
  List carsLatList = [];
  List carsLngList = [];
  late MapController controller;
  bool isLoading = false;

  @override
  void initState() {
    getPer();
    getLatAndLong();
    initMarker();
    super.initState();
  }

  @override
  void dispose() {
    controllerFrom.dispose();
    controllerTo.dispose();
    Loader.hide();
    super.dispose();
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

  Future<void> getLatAndLong() async {
    cl = await Geolocator.getCurrentPosition();
    lat = cl.latitude;
    long = cl.longitude;
    print('*******************');
    print(lat);
    print(long);
    controller = MapController(
      initPosition: GeoPoint(
        latitude: lat,
        longitude: long,
      ),
    );

    var creat =
        await Provider.of<NearestCarsMapProvider>(context, listen: false);
    getNearestCarsApi(creat);
    isLoading = true;
    if (mounted) {
      setState(() {});
    }
  }

  convertToAddress(double lat, double long) async {
    address = await AppRequests.getLocationNameFromLatLng(
        lat: lat.toString(), long: long.toString());

    if (mounted)
      setState(() {
        print(address);
      });
  }

  /////////////////////////// get nearest drivers cars (lats & lngs) api ///////////////////////////
  Future<void> getNearestCarsApi(NearestCarsMapProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.getNearestCarMap(lat.toString(), long.toString());
      if (creat.data.error == false) {
        length = creat.data.data!.length;
        print('------------------');
        print(length);
        for (int i = 0; i < creat.data.data!.length; i++) {
          setState(() {
            carsLatList.add(creat.data.data![i].latitude);
            carsLngList.add(creat.data.data![i].longitude);
          });
        }
        initMarker();
        Loader.hide();
        setState(() {});
      } else {
        Loader.hide();
      }
    } else {
      setSnackbar("nointernet".tr(), context);
    }
  }

  setSnackbar(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: new Text(
          msg,
          textAlign: TextAlign.center,
          style: TextStyle(color: primaryBlue),
        ),
        backgroundColor: white,
        elevation: 1.0,
      ),
    );
  }

  void initMarker() async {
    for (int i = 0; i < length; i++) {
      controller.setStaticPosition(
        [
          GeoPoint(
            latitude: double.parse(carsLatList[i]),
            longitude: double.parse(carsLngList[i]),
          )
        ],
        "$i",
      );
      controller.setMarkerOfStaticPoint(
        id: "$i",
        markerIcon: MarkerIcon(
          assetMarker: AssetMarker(
            scaleAssetImage: 2,
            image: AssetImage('assets/images/caricon.png'),
          ),
        ),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    print("####################################");
    print(address);
    print("lat" + lat.toString());
    print("long" + long.toString());
    print("####################################");
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
                              controller: controller,
                              osmOption: OSMOption(
                                enableRotationByGesture: true,
                                staticPoints: [
                                  StaticPositionGeoPoint(
                                    "home",
                                    MarkerIcon(
                                      icon: Icon(
                                        Icons.location_on_rounded,
                                        size: 40,
                                        color: Colors.green,
                                      ),
                                    ),
                                    [
                                      GeoPoint(
                                        latitude: lat,
                                        longitude: long,
                                      ),
                                    ],
                                  ),
                                ],
                                zoomOption: ZoomOption(
                                  initZoom: 17,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 5.h,
                            left: 12.w,
                            right: 12.w,
                            child: Row(
                              children: [
                                InkWell(
                                  child: Container(
                                    width: 35.w,
                                    height: 8.h,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(25),
                                      ),
                                      gradient: RadialGradient(
                                        colors: [Colors.blueGrey, primaryBlue3],
                                        radius: 1.2,
                                      ),
                                    ),
                                    child: Center(
                                      child: myText(
                                        text: 'request now'.tr(),
                                        fontSize: 4.sp,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    if (lat != 0.0 && long != 0.0) {
                                      Loader.show(
                                        context,
                                        progressIndicator: LoaderWidget(),
                                      );

                                      print(lat.toString());
                                      print(long.toString());
                                      convertToAddress(lat, long);
                                      print(
                                          '2222222222222222222222222222222222222222 is:');
                                      print('address is:');
                                      print(address);
                                      Loader.hide();
                                      Future.delayed(
                                        const Duration(seconds: 1),
                                      ).then(
                                        (_) async {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => OrderNow(
                                                fromLat: lat,
                                                fromLon: long,
                                                sourceAddress: address,
                                                toLat: 0.0,
                                                toLon: 0.0,
                                                destAddress: '',
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                                SizedBox(width: 1.w),
                                InkWell(
                                  child: Container(
                                      width: 35.w,
                                      height: 8.h,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                        gradient: RadialGradient(
                                          colors: [
                                            Colors.blueGrey,
                                            primaryBlue3
                                          ],
                                          radius: 1.2,
                                        ),
                                      ),
                                      child: Center(
                                          child: myText(
                                        text: 'request later'.tr(),
                                        fontSize: 4.sp,
                                        color: white,
                                      ))),
                                  onTap: () async {
                                    if (lat != 0.0 && long != 0.0) {
                                      Loader.show(context,
                                          progressIndicator: LoaderWidget());
                                      convertToAddress(lat, long);
                                      print('address is:');
                                      print(address);
                                      Loader.hide();
                                      Future.delayed(const Duration(seconds: 1))
                                          .then(
                                        (_) async {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => OrderNow(
                                                fromLat: lat,
                                                fromLon: long,
                                                sourceAddress: address,
                                                toLat: 0.0,
                                                toLon: 0.0,
                                                destAddress: '',
                                                laterOrder: true,
                                              ),
                                            ),
                                          );
                                        },
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
                )),
      ),
    );
  }
}
