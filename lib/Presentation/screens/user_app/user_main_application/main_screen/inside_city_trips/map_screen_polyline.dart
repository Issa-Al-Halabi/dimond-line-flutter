import 'dart:async';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
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

  MapScreenPolyline(
      {required this.fromLat,
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
      this.minutes = ''});

  @override
  State<MapScreenPolyline> createState() => _MapScreenPolylineState();
}

class _MapScreenPolylineState extends State<MapScreenPolyline> {
  CameraPosition? _kGooglePlex;
  GoogleMapController? gmc;
  late Position cl;
  var lat;
  var long;
  List<LatLng> polylineCoordinates = [];
  String timeOfTrip = '';
  var distance;

  Set<Marker> myMarker = {};

  Future<void> getLatAndLong() async {
    cl = await Geolocator.getCurrentPosition().then((value) => value);
    lat = cl.latitude;
    long = cl.longitude;
    _kGooglePlex = CameraPosition(
      target: LatLng(lat, long),
      zoom: 12,
    );
    if (mounted) {
      setState(() {});
    }
  }

  void getPolyPoints(fromLat, fromLon, toLat, toLon) async {
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
    Dio dio = new Dio();
    String url =
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$latcurrent,$lancurrent&destinations=$lat,$lng&key=AIzaSyCPsxZeXKcSYK1XXw0O0RbrZiI_Ekou5DY";
    print(url);
    Response response = await dio.get(url);
    // print('time is :');
    // print(response.data);
    // print(response);
    // print(response.runtimeType);
    // print(response.data["rows"].toString());
    // print(
    //     response.data["rows"][0]["elements"][0]["duration"]["text"].toString());
    int t = response.data["rows"][0]["elements"][0]["duration"]["value"];
    double t2 = t / 60;
    timeOfTrip = t2.toString();
    if (mounted) {
      setState(() {});
    }
    return timeOfTrip;
  }

  @override
  void initState() {
    getLatAndLong();
    getPolyPoints(widget.fromLat, widget.fromLng, widget.toLat, widget.toLng);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: getScreenHeight(context),
            width: getScreenWidth(context),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(background),
                fit: BoxFit.fill,
              ),
            ),
            child: SingleChildScrollView(
                child: Column(children: [
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
                      topRight: Radius.circular(20)),
                  color: backgroundColor,
                ),
                child: Stack(children: [
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
                    child: widget.fromLat == null
                        ? CircularProgressIndicator()
                        : GoogleMap(
                            markers: {
                              Marker(
                                markerId: MarkerId('1'),
                                // draggable: true,
                                infoWindow: InfoWindow(
                                    title: 'source'.tr(),
                                    onTap: () {
                                      print('marker info tab');
                                    }),
                                position:
                                    LatLng(widget.fromLat!, widget.fromLng!),
                                onTap: () {
                                  print('marker tab');
                                },
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueBlue),
                              ),
                              Marker(
                                markerId: MarkerId('2'),
                                infoWindow: InfoWindow(
                                    title: 'destination'.tr(),
                                    onTap: () {
                                      print('marker2 info tab');
                                    }),
                                position: LatLng(widget.toLat!, widget.toLng!),
                                onTap: () {
                                  print('marker2 tab');
                                },
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueBlue),
                              )
                            },
                            polylines: {
                              Polyline(
                                polylineId: PolylineId('route'),
                                points: polylineCoordinates,
                                color: primaryBlue,
                                width: 5,
                              ),
                            },
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(widget.fromLat!, widget.fromLng!),
                              zoom: 12,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              gmc = controller;
                            },
                            onTap: (latlng) {},
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
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 2.w,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 1.h),
                                  child: InkWell(
                                    onTap: () async {
                                      Loader.show(context,
                                          progressIndicator:
                                              CircularProgressIndicator());
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
                                      Future.delayed(const Duration(seconds: 0))
                                          .then((_) async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SelectFeatures(
                                                fromLat: widget.fromLat!,
                                                fromLon: widget.fromLng!,
                                                toLat: widget.toLat!,
                                                toLon: widget.toLng!,
                                                id: widget.idList[index]
                                                    .toString(),
                                                price: widget.priceList[index],
                                                km: distance
                                                    .toString()
                                                    .toString(),
                                                minutes: timeOfTrip,
                                                sourceAdd:
                                                    widget.sourceAdd.toString(),
                                                destAdd:
                                                    widget.destAdd.toString(),
                                                date: widget.date,
                                                time: widget.time,
                                                type: widget
                                                    .vehicletypeList[index],
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
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 7,
                                            offset: const Offset(0, 0),
                                          ),
                                        ],
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        color: backgroundColor,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          FadeInImage(
                                            image: NetworkImage(
                                              widget.vechileImageList[index]
                                                  .toString(),
                                            ),
                                            // height: 100.0,
                                            width: 40.w,
                                            fit: BoxFit.contain,
                                            imageErrorBuilder:
                                                (context, error, stackTrace) =>
                                                    erroWidget(20.h),
                                            placeholder: placeHolder(100),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 2.w, right: 2.w),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Text(
                                                  '${widget.vehicletypeList[index]}',
                                                  style: TextStyle(
                                                      color: primaryBlue,
                                                      fontSize: 5.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  formatter.format(widget
                                                          .priceList[index]) +
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
                                SizedBox(
                                  width: 5.w,
                                ),
                              ],
                            );
                          }),
                    ),
                  )
                ]),
              ),
            ]))));
  }
}
