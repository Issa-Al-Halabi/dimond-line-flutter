import 'dart:convert';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import '../../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'order_now.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class MapScreenSource extends StatefulWidget {
  MapScreenSource(
      {required this.fromLat,
      required this.fromLon,
      required this.sourceAddress,
      required this.destinationAddress,
      required this.toLat,
      required this.toLon,
      this.laterOrder,
      Key? key})
      : super(key: key);

  double fromLat;
  double fromLon;
  String sourceAddress;
  String destinationAddress;
  double toLat;
  double toLon;
  bool? laterOrder = false;

  @override
  State<MapScreenSource> createState() => _MapScreenSourceState();
}

class _MapScreenSourceState extends State<MapScreenSource> {
  late Position cl;
  late MapController controller;
  bool isLoading = false;
  ValueNotifier<GeoPoint?> lastGeoPoint = ValueNotifier(null);

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

  Future<void> getLatAndLong() async {
    cl = await Geolocator.getCurrentPosition().then((value) => value);
    widget.fromLat = cl.latitude;
    widget.fromLon = cl.longitude;
    print(widget.fromLat);
    print(widget.fromLon);
    controller = await MapController.withPosition(
      initPosition: GeoPoint(
        latitude: widget.fromLat,
        longitude: widget.fromLon,
      ),
    );
    convertToAddress(
      GeoPoint(
        latitude: widget.fromLat,
        longitude: widget.fromLon,
      ),
    );
    controller.listenerMapSingleTapping.addListener(() async {
      controller.removeMarker(
          GeoPoint(latitude: widget.fromLat, longitude: widget.fromLon));
      if (controller.listenerMapSingleTapping.value != null) {
        print(controller.listenerMapSingleTapping.value);
        if (lastGeoPoint.value != null) {
          await controller.changeLocationMarker(
            oldLocation: lastGeoPoint.value!,
            newLocation: controller.listenerMapSingleTapping.value!,
          );
          lastGeoPoint.value = controller.listenerMapSingleTapping.value;
          convertToAddress(lastGeoPoint.value!);
        } else {
          await controller.addMarker(
            controller.listenerMapSingleTapping.value!,
            markerIcon: MarkerIcon(
              icon: Icon(
                Icons.person_pin,
                color: Colors.red,
                size: 48,
              ),
            ),
            iconAnchor: IconAnchor(
              anchor: Anchor.top,
            ),
          );
          lastGeoPoint.value = controller.listenerMapSingleTapping.value;
          convertToAddress(lastGeoPoint.value!);
        }
      }
    });
    isLoading = true;
    if (mounted) {
      setState(() {});
    }
  }

  convertToAddress(GeoPoint geoPoint) async {
    widget.sourceAddress = await AppRequests.getLocationNameFromLatLng(
        lat: geoPoint.latitude.toString(), long: geoPoint.longitude.toString());

    if (mounted)
      setState(() {
        print(widget.sourceAddress.toString());
      });
  }

  void initMarker() {
    controller.addMarker(
      GeoPoint(latitude: widget.fromLat, longitude: widget.fromLon),
      markerIcon: MarkerIcon(
        icon: Icon(
          Icons.person_pin,
          color: Colors.red,
          size: 48,
        ),
      ),
      iconAnchor: IconAnchor(
        anchor: Anchor.top,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = Localizations.localeOf(context);
    String currentLanguage = currentLocale.languageCode;
    bool isRTL = currentLanguage == 'en' ? false : true;
    return Scaffold(
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
                                topRight: Radius.circular(20)),
                            color: backgroundColor,
                          ),
                          child: OSMFlutter(
                            onMapIsReady: (p0) => initMarker(),
                            controller: controller,
                            osmOption: OSMOption(
                              zoomOption: ZoomOption(
                                initZoom: 14,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 5.h,
                            left: 10.w,
                            right: 10.w,
                            child: Container(
                                width: 70.w,
                                height: 8.h,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryBlue.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  color: backgroundColor,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: myText(
                                      text: widget.sourceAddress,
                                      fontSize: 5.sp,
                                      color: primaryBlue,
                                    ),
                                  ),
                                ))),
                        Positioned(
                            bottom: 5.h,
                            left: 10.w,
                            right: 10.w,
                            child: Column(
                              children: [
                                InkWell(
                                    child: Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  primaryBlue.withOpacity(0.3),
                                              spreadRadius: 2,
                                              blurRadius: 7,
                                              offset: const Offset(0, 0),
                                            ),
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100)),
                                          color: backgroundColor,
                                        ),
                                        child: Center(
                                            child: isRTL
                                                ? Icon(
                                                    Icons.arrow_back_ios_new,
                                                    size: 40,
                                                    color: primaryBlue,
                                                  )
                                                : Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 40,
                                                    color: primaryBlue,
                                                  ))),
                                    onTap: () async {
                                      print('map screen source done');
                                      print(widget.fromLat);
                                      print(widget.fromLon);
                                      // if (lastGeoPoint.value != null) {
                                      convertToAddress(lastGeoPoint.value!);
                                      // }
                                      print(widget.sourceAddress);

                                      print({
                                        "fromLat": lastGeoPoint.value!.latitude,
                                        "fromLon":
                                            lastGeoPoint.value!.longitude,
                                        "sourceAddress": widget.sourceAddress,
                                        "toLat": widget.toLat,
                                        "toLon": widget.toLon,
                                        "destAddress":
                                            widget.destinationAddress,
                                        "laterOrder": widget.laterOrder,
                                      });
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OrderNow(
                                              // fromLat: widget.fromLat,
                                              // fromLon: widget.fromLon,
                                              fromLat:
                                                  lastGeoPoint.value!.latitude,
                                              fromLon:
                                                  lastGeoPoint.value!.longitude,
                                              sourceAddress:
                                                  widget.sourceAddress,
                                              toLat: widget.toLat,
                                              toLon: widget.toLon,
                                              destAddress:
                                                  widget.destinationAddress,
                                              laterOrder: widget.laterOrder,
                                              getDestAdd: true,
                                            ),
                                          ));
                                    }),
                              ],
                            ))
                      ],
                    ),
                  ],
                ),
              )),
    );
  }
}
