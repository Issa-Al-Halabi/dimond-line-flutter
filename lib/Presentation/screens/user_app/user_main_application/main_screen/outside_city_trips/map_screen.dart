import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import '../../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import '../../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../../../../../Functions/helper.dart';
import 'outside_city.dart';

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
  CameraPosition? _kGooglePlex;
  GoogleMapController? gmc;
  late Position cl;
  var lat;
  var long;
  TextEditingController controllerFrom = TextEditingController();
  double fromLat = 0.0;
  double fromLon = 0.0;
  TextEditingController controllerTo = TextEditingController();
  double toLat = 0.0;
  double toLon = 0.0;
  List<LatLng> polylineCoordinates = [];
  String timeOfTrip = '';
  var distance;
  Set<Marker> myMarker = {};

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
    cl = await Geolocator.getCurrentPosition().then((value) => value);
    lat = cl.latitude;
    long = cl.longitude;
    _kGooglePlex = CameraPosition(
      target: LatLng(lat, long),
      zoom: 14,
    );
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
    print('time is :');
    print(response.data);
    print(response);
    print(response.runtimeType);
    print(response.data["rows"].toString());
    print(
        response.data["rows"][0]["elements"][0]["duration"]["text"].toString());
    int t = response.data["rows"][0]["elements"][0]["duration"]["value"];
    double t2 = t / 60;
    timeOfTrip = t2.toString();
    if (mounted) {
      setState(() {});
    }
    return timeOfTrip;
  }

  void getPolyPoints(fromLat, fromLon, toLat, toLon) async {
    polylineCoordinates.clear();
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCPsxZeXKcSYK1XXw0O0RbrZiI_Ekou5DY',
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

  convertFromAddress(double lat, double long) async {
    print(addressFromMarker);
    String apiurl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$APIKEY";
    http.Response response =
        await http.get(Uri.parse(apiurl)); //send get request to API URL
    // Response response = await http.get(apiurl); //send get request to API URL
    if (response.statusCode == 200) {
      //if connection is successful
      var data = json.decode(response.body);
      // Map data = response.data; //get response data
      if (data["status"] == "OK") {
        //if status is "OK" returned from REST API
        if (data["results"].length > 0) {
          //if there is atleast one address
          addressFromMarker = data["results"][0]["address_components"][2]
                  ["long_name"] +
              "," +
              data["results"][0]["address_components"][1]
                  ["long_name"]; // f there is atleast one address
          print("address" + addressFromMarker);
          //you can use the JSON data to get address in your own format
          setState(() {
            //refresh UI
            print(addressFromMarker);
          });
        }
      } else {
        print(data["error_message"]);
      }
    } else {
      print("error while fetching geoconding data");
    }
  }

  convertToAddress(double lat, double long) async {
    print(addressToMarker);
    String apiurl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$APIKEY";
    http.Response response =
        await http.get(Uri.parse(apiurl)); //send get request to API URL
    // Response response = await http.get(apiurl); //send get request to API URL
    if (response.statusCode == 200) {
      //if connection is successful
      var data = json.decode(response.body);
      // Map data = response.data; //get response data
      if (data["status"] == "OK") {
        //if status is "OK" returned from REST API
        if (data["results"].length > 0) {
          //if there is atleast one address
          addressToMarker = data["results"][0]["address_components"][2]
                  ["long_name"] +
              "," +
              data["results"][0]["address_components"][1]
                  ["long_name"]; // f there is atleast one address
          print("address" + addressToMarker);
          //you can use the JSON data to get address in your own format
          setState(() {
            //refresh UI
            print(addressToMarker);
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
  void initState() {
    getPer();
    // getLatAndLong();
    getAddress();
    super.initState();
  }

  Future getAddress() async {
    await getAddTo();
    await getAddFrom();
  }

  Future getAddTo() async {
    print('FFFFFFFFFFFFFF');
    List<double> coordinates = await getCoordinates(widget.to.toString());
    print(coordinates);
    if (coordinates != null) {
      toLat = coordinates[0];
      toLon = coordinates[1];
      // Do something with the latitude and longitude

      LatLng toLatLng = LatLng(toLat, toLon);
      _kGooglePlex = CameraPosition(
        target: LatLng(toLat, toLon),
        zoom: 14,
      );
      myMarker.add(Marker(
        markerId: const MarkerId('to'),
        position: toLatLng,
        draggable: true,
        // onDragEnd: (LatLng latlng) {
        //   print(latlng);
        //   setState(() {
        //     toLat = latlng.latitude;
        //     toLon = latlng.longitude;
        //   });
        //   getPolyPoints(fromLat, fromLon, toLat, toLon);
        //   getDistance(fromLat, fromLon, toLat, toLon);
        //   getTimeOfTrip(fromLat, fromLon, toLat, toLon);
        //   convertToAddress(toLat, toLon);
        // },
        infoWindow: const InfoWindow(
          title: 'distenation',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));

      convertToAddress(toLat, toLon);

      if (mounted) {
        setState(() {});
      }
    } else {
      // Address not found or error occurred
    }
  }

  Future getAddFrom() async {
    print('FFFFFFFFFFFFFF');
    List<double> coordinates = await getCoordinates('Damascus');
    print(coordinates);
    if (coordinates != null) {
      fromLat = coordinates[0];
      fromLon = coordinates[1];
      // Do something with the latitude and longitude
      _kGooglePlex = CameraPosition(
        target: LatLng(fromLat, fromLon),
        zoom: 14,
      );

      LatLng fromLatLng = LatLng(fromLat, fromLon);
      myMarker.add(
        Marker(
          markerId: const MarkerId('from'),
          position: fromLatLng,
          draggable: true,
          // onDragEnd: (LatLng latlng) {
          //   print(latlng);
          //   setState(() {
          //     fromLat = latlng.latitude;
          //     fromLon = latlng.longitude;
          //   });
          //   getPolyPoints(fromLat, fromLon, toLat, toLon);
          //   getDistance(fromLat, fromLon, toLat, toLon);
          //   getTimeOfTrip(fromLat, fromLon, toLat, toLon);
          //   convertFromAddress(fromLat, fromLon);
          // },
          infoWindow: const InfoWindow(
            title: 'source',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
      print(fromLat);
      print(fromLon);
      print(toLat);
      print(toLon);
      getPolyPoints(fromLat, fromLon, toLat, toLon);
      getDistance(fromLat, fromLon, toLat, toLon);
      getTimeOfTrip(fromLat, fromLon, toLat, toLon);
      convertFromAddress(fromLat, fromLon);
      if (mounted) {
        setState(() {});
      }
    } else {
      // Address not found or error occurred
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
                              markers: myMarker,
                              polylines: {
                                Polyline(
                                  polylineId: PolylineId('route'),
                                  points: polylineCoordinates,
                                  color: primaryBlue,
                                  width: 5,
                                ),
                              },
                              mapType: MapType.normal,
                              initialCameraPosition: _kGooglePlex!,
                              onMapCreated: (GoogleMapController controller) {
                                gmc = controller;
                              },
                              onTap: (latlng) {},
                            ),
                          ),
                          Positioned(
                              bottom: 5.h,
                              left: 10.w,
                              right: 10.w,
                              child: Column(
                                children: [
                                  // InkWell(
                                  //     child: Container(
                                  //         width: 60.w,
                                  //         height: 8.h,
                                  //         decoration: const BoxDecoration(
                                  //           borderRadius: BorderRadius.all(
                                  //               Radius.circular(25)),
                                  //           gradient: RadialGradient(
                                  //             colors: [
                                  //               Colors.blueGrey,
                                  //               primaryBlue3
                                  //             ],
                                  //             radius: 1.2,
                                  //           ),
                                  //         ),
                                  //         child: Center(
                                  //             child: myText(
                                  //           text: 'tap to select'.tr(),
                                  //           fontSize: 5.sp,
                                  //           color: white,
                                  //         ))),
                                  //     onTap: () async {
                                  //       // AwesomeDialog(
                                  //       //   context: context,
                                  //       //   animType: AnimType.SCALE,
                                  //       //   btnOkColor: primaryBlue,
                                  //       //   dialogType: DialogType.NO_HEADER,
                                  //       //   padding: const EdgeInsets.all(10),
                                  //       //   body: StatefulBuilder(
                                  //       //     builder: (context, setState) {
                                  //       //       return Column(
                                  //       //         children: [
                                  //       //           myText(
                                  //       //             text: 'from'.tr(),
                                  //       //             fontSize: 4.sp,
                                  //       //             color: primaryBlue,
                                  //       //           ),
                                  //       //           GooglePlaceAutoCompleteTextField(
                                  //       //               textEditingController:
                                  //       //                   controllerFrom,
                                  //       //               googleAPIKey: APIKEY,
                                  //       //               inputDecoration:
                                  //       //                   const InputDecoration(),
                                  //       //               countries: const [
                                  //       //                 "sy",
                                  //       //                 "sy"
                                  //       //               ],
                                  //       //               // optional by default null is set
                                  //       //               isLatLngRequired: true,
                                  //       //               // if you required coordinates from place detail
                                  //       //               getPlaceDetailWithLatLng:
                                  //       //                   (prediction) {
                                  //       //                 setState(() {
                                  //       //                   controllerFrom.text =
                                  //       //                       prediction
                                  //       //                           .description!;
                                  //       //                   controllerFrom
                                  //       //                           .selection =
                                  //       //                       TextSelection.fromPosition(
                                  //       //                           TextPosition(
                                  //       //                               offset: prediction
                                  //       //                                   .description!
                                  //       //                                   .length));
                                  //       //                 });
                                  //       //                 fromLat = double.tryParse(
                                  //       //                     "${prediction.lat}")!;
                                  //       //                 fromLon = double.tryParse(
                                  //       //                     "${prediction.lng}")!;
                                  //       //                 setState(() {});
                                  //       //                 print("placeDetails 1 :" +
                                  //       //                     prediction.lng
                                  //       //                         .toString());
                                  //       //                 print("point lat 1 :" +
                                  //       //                     fromLat.toString());
                                  //       //                 print("point lan 1 :" +
                                  //       //                     fromLon.toString());
                                  //       //               },
                                  //       //               // this callback is called when isLatLngRequired is true
                                  //       //               itmClick: (prediction) {
                                  //       //                 setState(() {
                                  //       //                   controllerFrom.text =
                                  //       //                       prediction
                                  //       //                           .description!;
                                  //       //                   controllerFrom
                                  //       //                           .selection =
                                  //       //                       TextSelection.fromPosition(
                                  //       //                           TextPosition(
                                  //       //                               offset: prediction
                                  //       //                                   .description!
                                  //       //                                   .length));
                                  //       //                 });
                                  //       //               }),
                                  //       //           SizedBox(
                                  //       //             height: 2.h,
                                  //       //           ),
                                  //       //           myText(
                                  //       //             text: 'to'.tr(),
                                  //       //             fontSize: 4.sp,
                                  //       //             color: primaryBlue,
                                  //       //           ),
                                  //       //           GooglePlaceAutoCompleteTextField(
                                  //       //               textEditingController:
                                  //       //                   controllerTo,
                                  //       //               googleAPIKey: APIKEY,
                                  //       //               inputDecoration:
                                  //       //                   const InputDecoration(),
                                  //       //               countries: const [
                                  //       //                 "sy",
                                  //       //                 "sy"
                                  //       //               ],
                                  //       //               // optional by default null is set
                                  //       //               isLatLngRequired: true,
                                  //       //               // if you required coordinates from place detail
                                  //       //               getPlaceDetailWithLatLng:
                                  //       //                   (prediction) {
                                  //       //                 controllerTo.text =
                                  //       //                     prediction
                                  //       //                         .description!;
                                  //       //                 controllerTo.selection =
                                  //       //                     TextSelection.fromPosition(
                                  //       //                         TextPosition(
                                  //       //                             offset: prediction
                                  //       //                                 .description!
                                  //       //                                 .length));
                                  //       //                 toLat = double.tryParse(
                                  //       //                     "${prediction.lat}")!;
                                  //       //                 toLon = double.tryParse(
                                  //       //                     "${prediction.lng}")!;
                                  //       //                 print("placeDetails 2 :" +
                                  //       //                     prediction.lng
                                  //       //                         .toString());
                                  //       //                 print("point lat 2 :" +
                                  //       //                     toLat.toString());
                                  //       //                 print("point lan 2 :" +
                                  //       //                     toLon.toString());
                                  //       //               },
                                  //       //               // this callback is called when isLatLngRequired is true
                                  //       //               itmClick: (prediction) {
                                  //       //                 setState(() {
                                  //       //                   controllerTo.text =
                                  //       //                       prediction
                                  //       //                           .description!;
                                  //       //                   controllerTo.selection =
                                  //       //                       TextSelection.fromPosition(
                                  //       //                           TextPosition(
                                  //       //                               offset: prediction
                                  //       //                                   .description!
                                  //       //                                   .length));
                                  //       //                 });
                                  //       //               }),
                                  //       //         ],
                                  //       //       );
                                  //       //     },
                                  //       //   ),
                                  //       //   btnOkOnPress: () {
                                  //       //     LatLng fromLatLng =
                                  //       //         LatLng(fromLat, fromLon);
                                  //       //     LatLng toLatLng =
                                  //       //         LatLng(toLat, toLon);
                                  //       //     print(fromLatLng);
                                  //       //     print(toLatLng);
                                  //       //     Future.delayed(
                                  //       //             const Duration(seconds: 1))
                                  //       //         .then((_) async {
                                  //       //       gmc!.animateCamera(
                                  //       //           CameraUpdate.newCameraPosition(
                                  //       //               CameraPosition(
                                  //       //                   target: toLatLng,
                                  //       //                   zoom: 10)));
                                  //       //       myMarker.add(
                                  //       //         Marker(
                                  //       //           markerId:
                                  //       //               const MarkerId('from'),
                                  //       //           position: fromLatLng,
                                  //       //           draggable: true,
                                  //       //           onDragEnd: (LatLng latlng) {
                                  //       //             print(latlng);
                                  //       //             setState(() {
                                  //       //               fromLat = latlng.latitude;
                                  //       //               fromLon = latlng.longitude;
                                  //       //             });
                                  //       //             getPolyPoints(fromLat,
                                  //       //                 fromLon, toLat, toLon);
                                  //       //             getDistance(fromLat, fromLon,
                                  //       //                 toLat, toLon);
                                  //       //             getTimeOfTrip(fromLat,
                                  //       //                 fromLon, toLat, toLon);
                                  //       //             convertFromAddress(
                                  //       //                 fromLat, fromLon);
                                  //       //           },
                                  //       //           infoWindow: const InfoWindow(
                                  //       //             title: 'source',
                                  //       //           ),
                                  //       //           icon: BitmapDescriptor
                                  //       //               .defaultMarkerWithHue(
                                  //       //                   BitmapDescriptor
                                  //       //                       .hueBlue),
                                  //       //         ),
                                  //       //       );
                                  //       //       myMarker.add(Marker(
                                  //       //         markerId: const MarkerId('to'),
                                  //       //         position: toLatLng,
                                  //       //         draggable: true,
                                  //       //         onDragEnd: (LatLng latlng) {
                                  //       //           print(latlng);
                                  //       //           setState(() {
                                  //       //             toLat = latlng.latitude;
                                  //       //             toLon = latlng.longitude;
                                  //       //           });
                                  //       //           getPolyPoints(fromLat, fromLon,
                                  //       //               toLat, toLon);
                                  //       //           getDistance(fromLat, fromLon,
                                  //       //               toLat, toLon);
                                  //       //           getTimeOfTrip(fromLat, fromLon,
                                  //       //               toLat, toLon);
                                  //       //           convertToAddress(toLat, toLon);
                                  //       //         },
                                  //       //         infoWindow: const InfoWindow(
                                  //       //           title: 'distenation',
                                  //       //         ),
                                  //       //         icon: BitmapDescriptor
                                  //       //             .defaultMarkerWithHue(
                                  //       //                 BitmapDescriptor.hueBlue),
                                  //       //       ));
                                  //       //       getPolyPoints(
                                  //       //           fromLat, fromLon, toLat, toLon);
                                  //       //       getDistance(
                                  //       //           fromLat, fromLon, toLat, toLon);
                                  //       //       getTimeOfTrip(
                                  //       //           fromLat, fromLon, toLat, toLon);
                                  //       //       convertFromAddress(
                                  //       //           fromLat, fromLon);
                                  //       //       convertToAddress(toLat, toLon);
                                  //       //     });
                                  //       //     setState(() {});
                                  //       //   },
                                  //       // ).show();
                                  //     }),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  InkWell(
                                    child: Container(
                                      width: 60.w,
                                      height: 8.h,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        gradient: RadialGradient(
                                          colors: [
                                            Colors.blueGrey,
                                            primaryBlue3
                                          ],
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
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OutsideCityScreen(
                                                      categoryId:
                                                          widget.categoryId,
                                                      subCategoryId:
                                                          widget.subCategoryId,
                                                      timeOfTrip: timeOfTrip,
                                                      distance:
                                                          distance.toString(),
                                                      fromLat:
                                                          fromLat.toString(),
                                                      fromLon:
                                                          fromLon.toString(),
                                                      toLat: toLat.toString(),
                                                      toLon: toLon.toString(),
                                                      to: widget.to,
                                                    )));
                                      } else {
                                        Loader.hide();
                                        setSnackbar(
                                            'enter all fields'.tr(), context);
                                      }
                                    },
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ],
                  ),
                )),
      ),
    );
  }
}
