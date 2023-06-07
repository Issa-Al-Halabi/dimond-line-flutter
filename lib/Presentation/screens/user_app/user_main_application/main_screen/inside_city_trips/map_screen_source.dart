import 'dart:convert';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import '../../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'order_now.dart';
import 'package:http/http.dart';

class MapScreenSource extends StatefulWidget {
  MapScreenSource(
      {required this.fromLat,
      required this.fromLon,
      required this.sourceAddress,
      this.laterOrder,
      Key? key})
      : super(key: key);

  double fromLat;
  double fromLon;
  String sourceAddress;
  bool? laterOrder = false;

  @override
  State<MapScreenSource> createState() => _MapScreenSourceState();
}

class _MapScreenSourceState extends State<MapScreenSource> {
  CameraPosition? _kGooglePlex;
  GoogleMapController? gmc;
  late Position cl;

  @override
  void initState() {
    getLatAndLong();
    super.initState();
  }

  Future<void> getLatAndLong() async {
    cl = await Geolocator.getCurrentPosition().then((value) => value);
    widget.fromLat = cl.latitude;
    widget.fromLon = cl.longitude;
    print('*******************');
    print(widget.fromLat);
    print(widget.fromLon);
    _kGooglePlex = CameraPosition(
      target: LatLng(widget.fromLat, widget.fromLon),
      zoom: 10,
    );
    if (mounted) {
      setState(() {});
    }
  }

  convertToAddress(double lat, double long) async {
    print(widget.sourceAddress.toString());
    String apiurl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$APIKEY";
    Response response =
        await get(Uri.parse(apiurl)); //send get request to API URL
    // Response response = await http.get(apiurl); //send get request to API URL
    if (response.statusCode == 200) {
      //if connection is successful
      var data = json.decode(response.body);
      // Map data = response.data; //get response data
      if (data["status"] == "OK") {
        //if status is "OK" returned from REST API
        if (data["results"].length > 0) {
          //if there is atleast one address
          widget.sourceAddress = data["results"][0]["address_components"][2]
                  ["long_name"] +
              "," +
              data["results"][0]["address_components"][1]
                  ["long_name"]; // f there is atleast one address
          print("address" + widget.sourceAddress);
          //you can use the JSON data to get address in your own format
          setState(() {
            //refresh
            print(widget.sourceAddress);
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
                                markerId: MarkerId('1'),
                                draggable: true,
                                infoWindow: InfoWindow(
                                    title: 'source'.tr(),
                                    onTap: () {
                                      print('marker info tab');
                                    }),
                                position:
                                    LatLng(widget.fromLat, widget.fromLon),
                                onTap: () {
                                  print('marker tab');
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
                                widget.fromLat = latlng.latitude;
                                widget.fromLon = latlng.longitude;
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
                                            child: isRTL ? Icon(
                                          Icons.arrow_back_ios_new,
                                          size: 40,
                                          color: primaryBlue,
                                        )
                                                : Icon(
                                              Icons.arrow_forward_ios,
                                              size: 40,
                                              color: primaryBlue,
                                            )
                                        )),
                                    onTap: () async {
                                      print('map screen source done');
                                      print(widget.fromLat);
                                      print(widget.fromLon);
                                      convertToAddress(
                                          widget.fromLat, widget.fromLon);
                                      print(widget.sourceAddress);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OrderNow(
                                              fromLat: widget.fromLat,
                                              fromLon: widget.fromLon,
                                              sourceAddress:
                                                  widget.sourceAddress,
                                              toLat: 0.0,
                                              toLon: 0.0,
                                              destAddress: '',
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