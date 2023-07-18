import 'dart:convert';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import '../../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'order_now.dart';
import 'package:http/http.dart';

class MapScreenDestination extends StatefulWidget {
  MapScreenDestination(
      {required this.fromLat,
      required this.fromLon,
      required this.sourceAddress,
      required this.toLat,
      required this.toLon,
      required this.destinationAddress,
      this.laterOrder,
      Key? key})
      : super(key: key);
  double toLat;
  double toLon;
  String destinationAddress;
  double fromLat;
  double fromLon;
  String sourceAddress;
  bool? laterOrder = false;

  @override
  State<MapScreenDestination> createState() => _MapScreenDestinationState();
}

class _MapScreenDestinationState extends State<MapScreenDestination> {
  CameraPosition? _kGooglePlex;
  GoogleMapController? gmc;
  late Position cl;

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
    widget.toLat = cl.latitude;
    widget.toLon = cl.longitude;
    print('*******************');
    print(widget.toLat);
    print(widget.toLon);
    _kGooglePlex = CameraPosition(
      target: LatLng(widget.toLat, widget.toLon),
      zoom: 10,
    );
    if (mounted) {
      setState(() {});
    }
  }

  convertToAddress(double lat, double long) async {
    print(widget.destinationAddress.toString());
    String apiurl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$APIKEY";
    Response response =
        await get(Uri.parse(apiurl)); //send get request to API URL
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["status"] == "OK") {
        if (data["results"].length > 0) {
          widget.destinationAddress = data["results"][0]["address_components"]
                  [2]["long_name"] +
              "," +
              data["results"][0]["address_components"][1]
                  ["long_name"]; // f there is atleast one address
          print("address" + widget.destinationAddress);
          if(mounted)
          setState(() {
            print(widget.destinationAddress);
          });
        }
      } else {
        print(data["error_message"]);
      }
    } else {
      print("error while fetching geoconding data");
    }
  }

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = Localizations.localeOf(context);
    String currentLanguage = currentLocale.languageCode;
    bool isRTL = currentLanguage == 'en' ? false : true;
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
                          child: GoogleMap(
                            markers: {
                              Marker(
                                markerId: MarkerId('2'),
                                draggable: true,
                                infoWindow: InfoWindow(
                                    title: 'destination'.tr(),
                                    onTap: () {
                                      print('marker2 info tab');
                                    }),
                                position: LatLng(widget.toLat, widget.toLon),
                                onTap: () {
                                  print('marker2 tab');
                                },
                                onDragEnd: (LatLng latlng) {
                                  print(latlng);
                                },
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueBlue),
                              )
                            },
                            mapType: MapType.normal,
                            initialCameraPosition: _kGooglePlex!,
                            onMapCreated: (GoogleMapController controller) {
                              gmc = controller;
                            },
                            onTap: (latlng) {
                              print(latlng.latitude);
                              print(latlng.longitude);
                              convertToAddress(
                                  latlng.latitude, latlng.longitude);
                              setState(() {
                                widget.toLat = latlng.latitude;
                                widget.toLon = latlng.longitude;
                              });
                            },
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    child: myText(
                                      text: widget.destinationAddress,
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
                                      print('map screen destination done');
                                      print(widget.fromLat);
                                      print(widget.fromLon);
                                      print(widget.toLat);
                                      print(widget.toLon);
                                      convertToAddress(
                                          widget.toLat, widget.toLon);
                                      print(widget.destinationAddress);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OrderNow(
                                              toLat: widget.toLat,
                                              toLon: widget.toLon,
                                              destAddress:
                                                  widget.destinationAddress,
                                              fromLat: widget.fromLat,
                                              fromLon: widget.fromLon,
                                              sourceAddress:
                                                  widget.sourceAddress,
                                              getDestAdd: true,
                                              laterOrder: widget.laterOrder,
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
