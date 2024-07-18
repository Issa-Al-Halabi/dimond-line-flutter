import 'dart:async';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import '../../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Presentation/Functions/helper.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/inside_city_trips/select_features.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';

class MapScreenPolyline extends StatefulWidget {
  final double? fromLat;
  final double? fromLng;
  final double? toLat;
  final double? toLng;
  final String? sourceAdd;
  final String? destAdd;
  var comfort;
  var classic;
  List idList;
  List vehicletypeList;
  List vechileImageList;
  List baseKmList = [];
  List baseTimeList = [];
  List priceList = [];
  int length;
  String date, time;
  String km, minutes;

  MapScreenPolyline({
    required this.fromLat,
    required this.fromLng,
    required this.toLat,
    required this.toLng,
    required this.sourceAdd,
    required this.destAdd,
    required this.idList,
    required this.vehicletypeList,
    required this.vechileImageList,
    required this.baseKmList,
    required this.baseTimeList,
    required this.priceList,
    required this.length,
    this.date = '',
    this.time = '',
    this.km = '',
    this.minutes = '',
  });

  @override
  State<MapScreenPolyline> createState() => _MapScreenPolylineState();
}

class _MapScreenPolylineState extends State<MapScreenPolyline> {
  late Position cl;
  var lat;
  var long;
  String timeOfTrip = '';
  double distance = 0.0;

  late MapController controller;
  bool isLoading = false;

  Future<void> getLatAndLong() async {
    cl = await Geolocator.getCurrentPosition();
    lat = cl.latitude;
    long = cl.longitude;
    controller = MapController(
      initPosition: GeoPoint(
        latitude: lat,
        longitude: long,
      ),
    );
    isLoading = true;

    if (mounted) {
      setState(() {});
    }
  }

  void roadActionBt(fromLat, fromLon, toLat, toLon) async {
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
    print("${roadInfo.distance}km");
    print("${roadInfo.duration}sec");
    print("${roadInfo.instructions}");
  }

  getDistance(double latcurrent, double lancurrent, double lat, double lng) {
    distance = Geolocator.distanceBetween(
      latcurrent,
      lancurrent,
      lat,
      lng,
    );
    distance = distance / 1000;
    print('distance  --- Ahmad --- : ' + distance.toString());
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

  @override
  void initState() {
    getLatAndLong();
    super.initState();
  }

  @override
  void dispose() {
    Loader.hide();
    super.dispose();
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
                        child: Stack(
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
                                color: backgroundColor,
                              ),
                              child: OSMFlutter(
                                onMapIsReady: (p0) => roadActionBt(
                                  widget.fromLat,
                                  widget.fromLng,
                                  widget.toLat,
                                  widget.toLng,
                                ),
                                controller: controller,
                                osmOption: OSMOption(
                                  staticPoints: [
                                    StaticPositionGeoPoint(
                                      "1",
                                      MarkerIcon(
                                        icon: Icon(
                                          Icons.location_on_rounded,
                                          color: Colors.blue,
                                          size: 40,
                                        ),
                                      ),
                                      [
                                        GeoPoint(
                                          latitude: widget.fromLat!,
                                          longitude: widget.fromLng!,
                                        )
                                      ],
                                    ),
                                    StaticPositionGeoPoint(
                                      "2",
                                      MarkerIcon(
                                        icon: Icon(
                                          Icons.location_on_rounded,
                                          color: Colors.blue,
                                          size: 40,
                                        ),
                                      ),
                                      [
                                        GeoPoint(
                                          latitude: widget.toLat!,
                                          longitude: widget.toLng!,
                                        )
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
                              bottom: 1.h,
                              child: Container(
                                height: 20.h,
                                width: getScreenWidth(context),
                                child: ListView.builder(
                                  itemCount: widget.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1.h),
                                          child: InkWell(
                                            onTap: () async {
                                              Loader.show(context,
                                                  progressIndicator:
                                                      LoaderWidget());
                                              getDistance(
                                                  widget.fromLat!,
                                                  widget.fromLng!,
                                                  widget.toLat!,
                                                  widget.toLng!);
                                              // getTimeOfTrip(widget.fromLat!, widget.fromLng!, widget.toLat!, widget.toLng!);
                                              if (widget.fromLat != 0.0 &&
                                                  widget.fromLng != 0.0 &&
                                                  widget.toLat != 0.0 &&
                                                  widget.toLng != 0.0) {
                                                await getTimeOfTrip(
                                                    widget.fromLat!,
                                                    widget.fromLng!,
                                                    widget.toLat!,
                                                    widget.toLng!);
                                              }
                                              print(timeOfTrip);
                                              Loader.hide();
                                              Future.delayed(const Duration(
                                                      seconds: 0))
                                                  .then((_) async {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SelectFeatures(
                                                        fromLat:
                                                            widget.fromLat!,
                                                        fromLon:
                                                            widget.fromLng!,
                                                        toLat: widget.toLat!,
                                                        toLon: widget.toLng!,
                                                        id: widget.idList[index]
                                                            .toString(),
                                                        price: widget
                                                            .priceList[index],
                                                        km: distance.toString(),
                                                        minutes: timeOfTrip,
                                                        sourceAdd: widget
                                                            .sourceAdd
                                                            .toString(),
                                                        destAdd: widget.destAdd
                                                            .toString(),
                                                        date: widget.date,
                                                        time: widget.time,
                                                        type: widget
                                                                .vehicletypeList[
                                                            index],
                                                      ),
                                                    ));
                                                setState(() {});
                                              });
                                            },
                                            child: Container(
                                              height: 30.h,
                                              width: 80.w,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    spreadRadius: 2,
                                                    blurRadius: 7,
                                                    offset: const Offset(0, 0),
                                                  ),
                                                ],
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(20),
                                                ),
                                                color: backgroundColor,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  FadeInImage(
                                                    image: NetworkImage(
                                                      widget.vechileImageList[
                                                              index]
                                                          .toString(),
                                                    ),
                                                    // height: 100.0,
                                                    width: 40.w,
                                                    fit: BoxFit.contain,
                                                    imageErrorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        erroWidget(20.h),
                                                    placeholder:
                                                        placeHolder(100),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 2.w,
                                                      right: 2.w,
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Text(
                                                          '${widget.vehicletypeList[index]}',
                                                          style: TextStyle(
                                                              color:
                                                                  primaryBlue,
                                                              fontSize: 5.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          formatter.format(widget
                                                                      .priceList[
                                                                  index]) +
                                                              'sp'.tr(),
                                                          style: TextStyle(
                                                            color: grey,
                                                            fontSize: 5.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                      ],
                                    );
                                  },
                                ),
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
    );
  }
}
