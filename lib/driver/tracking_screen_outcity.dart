// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:connectivity/connectivity.dart';
// import 'package:diamond_line/Data/network/network_client.dart';
// import 'package:diamond_line/Presentation/Functions/helper.dart';
// import 'package:diamond_line/Presentation/widgets/loader_widget.dart';
// import 'package:easy_localization/src/public_ext.dart';
// import 'package:flutter/material.dart';
// import 'package:diamond_line/Data/network/requests.dart';
// import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_main_screen/trip_ended_outcity.dart';
// import 'package:diamond_line/Presentation/widgets/container_widget.dart';
// import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:web_socket_channel/io.dart';
// import '../../../../../constants.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart';
//
//
// class TrackingScreenOutside extends StatefulWidget {
//   TrackingScreenOutside(
//       {required this.tripId,
//       required this.pickupLatitude,
//       required this.pickupLongitude,
//       required this.dropLatitude,
//       required this.dropLongitude,
//       Key? key})
//       : super(key: key);
//   String tripId;
//   String pickupLatitude, pickupLongitude, dropLatitude, dropLongitude;
//
//   @override
//   State<TrackingScreenOutside> createState() => _TrackingScreenOutsideState();
// }
//
// class _TrackingScreenOutsideState extends State<TrackingScreenOutside> {
//   CameraPosition? _kGooglePlex;
//   GoogleMapController? gmc;
//   late Position cl;
//   double lat = 0.0;
//   double lng = 0.0;
//   double course = 0.0;
//   bool _isNetworkAvail = true;
//   late SharedPreferences prefs;
//   String deviceNumber = '';
//   int deviceNumb = 0;
//   List<LatLng> polylineCoordinates = [];
//   Set<Polyline> pathPolyline = <Polyline>{};
//   var finalDistance;
//   String totalPrice = '';
//   String adminFare = '';
//   List<double> latList = [];
//   List<double> lngList = [];
//   List<LatLng> points = [];
//   Marker? marker;
//   Marker? marker2;
//   Marker? marker3;
//   Circle? circle;
//
//   IOWebSocketChannel? _channel;
//
//   Future<void> getCookie() async {
//     try {
//       Map<String, String> co = {};
//       Response response =
//           await get(Uri.parse(network_client.mycarSscSecurity_URL));
//       co.addAll({"Cookie": response.headers['set-cookie'].toString()});
//       print(co);
//       _channel = IOWebSocketChannel.connect(
//           Uri.parse(network_client.mycarSscSecurity_SOCKET),
//           headers: co);
//     } catch (e) {
//       setSnackbar(e.toString(), context);
//     }
//   }
//
//   @override
//   void initState() {
//     // getCookie();
//     markerOfMainWay();
//     getLatAndLong();
//     initShared();
//     getPer();
//
//     ///رسم المسار الاساسي
//     getPolyPoints();
//     super.initState();
//   }
//
//   getpoly() async {
//     await getPolyPoints();
//     markerOfMainWay();
//     getLatAndLong();
//   }
//
//   void markerOfMainWay() {
//     marker2 = Marker(
//       markerId: MarkerId("from"),
//       position: LatLng(double.parse(widget.pickupLatitude),
//           double.parse(widget.pickupLongitude)),
//       rotation: 2,
//       draggable: false,
//       zIndex: 2,
//       flat: true,
//       anchor: Offset(0.5, 0.5),
//       infoWindow: InfoWindow(
//         title: 'from'.tr(),
//       ),
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//     );
//
//     marker3 = Marker(
//       markerId: MarkerId("to"),
//       position: LatLng(double.parse(widget.dropLatitude),
//           double.parse(widget.dropLongitude)),
//       rotation: 2,
//       draggable: false,
//       zIndex: 2,
//       flat: true,
//       anchor: Offset(0.5, 0.5),
//       infoWindow: InfoWindow(
//         title: 'to'.tr(),
//       ),
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//     );
//   }
//
//   @override
//   void dispose() {
//     if (_channel != null) {
//       _channel!.sink.close();
//     }
//     super.dispose();
//   }
//
//   Future initShared() async {
//     prefs = await SharedPreferences.getInstance();
//     deviceNumber = prefs.getString('deviceNumber') ?? '';
//     deviceNumb = int.parse(deviceNumber);
//
//     // read
//     List<String> savedStrList = prefs.getStringList('latList') ?? [];
//     latList = savedStrList.map((i) => double.parse(i)).toList();
//
//     List<String> savedStrList2 = prefs.getStringList('lngList') ?? [];
//     lngList = savedStrList2.map((i) => double.parse(i)).toList();
//
//     print('latList and lngList from sharedPreference');
//     print("${latList.toString()}");
//     print("${lngList.toString()}");
//   }
//
//   Future<void> getLatAndLong() async {
//     cl = await Geolocator.getCurrentPosition().then((value) => value);
//     lat = cl.latitude;
//     lng = cl.longitude;
//     _kGooglePlex = CameraPosition(
//       target: LatLng(lat, lng),
//       zoom: 14,
//     );
//     latList.add(lat);
//     lngList.add(lng);
//     // write
//     List<String> strList = latList.map((i) => i.toString()).toList();
//     prefs.setStringList("latList", strList);
//
//     List<String> strList2 = lngList.map((i) => i.toString()).toList();
//     prefs.setStringList("lngList", strList2);
//     print(latList);
//     print(lngList);
//     for (int i = 0; i < latList.length; i++) {
//       points.add(LatLng(latList[i], lngList[i]));
//     }
//     ;
//     print('points');
//     print(points);
//     // pathPolyline.add(
//     //   Polyline(
//     //       polylineId: PolylineId('track'),
//     //       color: Colors.red,
//     //       width: 4,
//     //       points: points,
//     //       patterns: [
//     //         PatternItem.dash(20),
//     //         PatternItem.gap(10),
//     //       ]),
//     // );
//     if (mounted) {
//       setState(() {});
//     }
//
//     updatePolyline();
//   }
//
//   Future getPer() async {
//     LocationPermission permission;
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//   }
//
//   Future<Uint8List> getMarker() async {
//     ByteData byteData = await DefaultAssetBundle.of(context).load(carIcon);
//     return byteData.buffer.asUint8List();
//   }
//
//   void updatePolyline() async {
//     Uint8List imageData = await getMarker();
//     marker = Marker(
//         markerId: MarkerId("home"),
//         position: points.last,
//         // rotation: 2,
//         //////  directional marker
//         rotation: course,
//         draggable: false,
//         zIndex: 2,
//         flat: true,
//         anchor: Offset(0.5, 0.5),
//         icon: BitmapDescriptor.fromBytes(imageData));
//
//     circle = Circle(
//         circleId: CircleId("car"),
//         radius: 10,
//         //newLocalData.accuracy!,
//         zIndex: 1,
//         strokeColor: Colors.grey,
//         center: points.last,
//         fillColor: Colors.grey.withAlpha(70));
//     setState(() {});
//     // pathPolyline.add(
//     //   Polyline(
//     //       polylineId: PolylineId('track'),
//     //       color: Colors.red,
//     //       width: 5,
//     //       points: points,
//     //       patterns: [
//     //         PatternItem.dash(20),
//     //         PatternItem.gap(10),
//     //       ]),
//     // );
//   }
//
//   void updateMainPolyline(double pickupLatitude, double pickupLongitude) async {
//     polylineCoordinates.clear();
//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       APIKEY,
//       PointLatLng(pickupLatitude, pickupLongitude),
//       PointLatLng(double.parse(widget.dropLatitude),
//           double.parse(widget.dropLongitude)),
//     );
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     }
//     if (mounted) {
//       setState(() {});
//     }
//
//     // delete from marker
//     marker2 = Marker(markerId: MarkerId("from"));
//   }
//
//   /// رسم المسار الاساسي
//   Future getPolyPoints() async {
//     polylineCoordinates.clear();
//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       'AIzaSyCPsxZeXKcSYK1XXw0O0RbrZiI_Ekou5DY',
//       PointLatLng(double.parse(widget.pickupLatitude),
//           double.parse(widget.pickupLongitude)),
//       PointLatLng(double.parse(widget.dropLatitude),
//           double.parse(widget.dropLongitude)),
//     );
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     }
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   getDistance(double latcurrent, double lancurrent, double lat, double lng) {
//     finalDistance = Geolocator.distanceBetween(
//       latcurrent,
//       lancurrent,
//       lat,
//       lng,
//     );
//     print('distaaaaaaaaaaaaaaance');
//     print(finalDistance);
//     print(finalDistance / 1000);
//     finalDistance = finalDistance / 1000;
//     return finalDistance.toString();
//   }
//
//   /////////////////////////get location api //////////////////////////////////
//   Future<void> getLocationApi(String lat, String lng, String device_id) async {
//     _isNetworkAvail = await isNetworkAvailable();
//     if (_isNetworkAvail) {
//       print("There is internet");
//       var data = await AppRequests.getLocationRequest(lat, lng, device_id);
//       print(data);
//       data = json.decode(data);
//       if (data["error"] == false) {
//         setState(() {});
//       } else {}
//     } else {
//       setSnackbar("nointernet".tr(), context);
//     }
//   }
//
//   /////////////////////////trip end api //////////////////////////////////
//   Future<void> endTripApi(
//       String trip_id, String end_time, String finalDistance) async {
//     _isNetworkAvail = await isNetworkAvailable();
//     print(trip_id);
//     print(end_time);
//     print(finalDistance);
//     if (_isNetworkAvail) {
//       print("There is internet");
//       Loader.show(context, progressIndicator: LoaderWidget());
//       var data =
//           await AppRequests.endTripRequest(trip_id, end_time, finalDistance);
//       print(data);
//       data = json.decode(data);
//       if (data["error"] == false) {
//         if (_channel != null) {
//           _channel!.sink.close();
//         }
//         Loader.hide();
//         setSnackbar(data["message"].toString(), context);
//         setState(() {
//           totalPrice = data["data"]["new_cost"].toString();
//           print('new cost');
//           print(totalPrice);
//           adminFare = data["data"]["admin_fare"].toString();
//           print('adminFare');
//           print(adminFare);
//           Future.delayed(const Duration(seconds: 3)).then((_) async {
//             Navigator.of(context).push(
//               PageRouteBuilder(
//                 pageBuilder: (BuildContext context, Animation<double> animation,
//                     Animation<double> secondaryAnimation) {
//                   return TripOutCityEndedScreen(
//                       tripId: widget.tripId,
//                       finalCost: totalPrice,
//                       adminFare: adminFare);
//                 },
//                 transitionsBuilder: (BuildContext context,
//                     Animation<double> animation,
//                     Animation<double> secondaryAnimation,
//                     Widget child) {
//                   return Align(
//                     child: SizeTransition(
//                       sizeFactor: animation,
//                       child: child,
//                     ),
//                   );
//                 },
//                 transitionDuration: Duration(milliseconds: 500),
//               ),
//             );
//           });
//         });
//       } else {
//         Loader.hide();
//         setSnackbar(data["message"].toString(), context);
//       }
//     } else {
//       setSnackbar("nointernet".tr(), context);
//     }
//   }
//
//   Future<bool> isNetworkAvailable() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.mobile) {
//       return true;
//     } else if (connectivityResult == ConnectivityResult.wifi) {
//       return true;
//     }
//     return false;
//   }
//
//   setSnackbar(String msg, BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       duration: Duration(seconds: 3),
//       content: new Text(
//         msg,
//         textAlign: TextAlign.center,
//         style: TextStyle(color: primaryBlue),
//       ),
//       backgroundColor: white,
//       elevation: 1.0,
//     ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: willPopLoader,
//       child: Scaffold(
//         body: _kGooglePlex == null || _channel == null
//             ? Center(child: LoaderWidget())
//             : Container(
//                 height: getScreenHeight(context),
//                 width: getScreenWidth(context),
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage(background),
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.only(top: 9.h),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         Container(
//                           height: 82.h,
//                           width: getScreenWidth(context),
//                           decoration: BoxDecoration(
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.3),
//                                 spreadRadius: 2,
//                                 blurRadius: 7,
//                                 offset: const Offset(0, 0),
//                               ),
//                             ],
//                             borderRadius: const BorderRadius.only(
//                                 topLeft: Radius.circular(20),
//                                 topRight: Radius.circular(20)),
//                             color: backgroundColor,
//                           ),
//                           child: Stack(children: [
//                             _channel != null
//                                 ? StreamBuilder(
//                                     stream: _channel!.stream,
//                                     builder: (context, snapshot) {
//                                       print(snapshot.data);
//                                       print(snapshot.connectionState);
//                                       if (snapshot.hasData == true) {
//                                         var data = json
//                                             .decode(snapshot.data.toString());
//                                         print(
//                                             '--------------------------------');
//                                         if (data['positions'] != null) {
//                                           // if (data['positions'][0]['deviceId'] == 252) {
//                                           //TODO
//                                           // if (data['positions'][0]['deviceId'] ==
//                                           //     274) {
//                                           if (data['positions'][0]
//                                                   ['deviceId'] ==
//                                               deviceNumb) {
//                                             print(
//                                                 '////////////////////////////');
//                                             // print(data['positions'][0]['deviceId']);
//                                             // print(data['positions'][0]['latitude']);
//                                             // print(data['positions'][0]['longitude']);
//                                             print('course me');
//                                             print(
//                                                 data['positions'][0]['course']);
//                                             lat = data['positions'][0]
//                                                 ['latitude'];
//                                             lng = data['positions'][0]
//                                                 ['longitude'];
//                                             course =
//                                                 data['positions'][0]['course'];
//                                             if (latList.last != lat &&
//                                                 lngList.last != lng) {
//                                               print(
//                                                   'lats and longs isnt equal');
//                                               latList.add(lat);
//                                               lngList.add(lng);
//                                               List<String> strList = latList
//                                                   .map((i) => i.toString())
//                                                   .toList();
//                                               prefs.setStringList(
//                                                   "latList", strList);
//                                               List<String> strList2 = lngList
//                                                   .map((i) => i.toString())
//                                                   .toList();
//                                               prefs.setStringList(
//                                                   "lngList", strList2);
//                                               // for (int i = 0;
//                                               //     i < latList.length;
//                                               //     i++) {
//                                               //   points.add(
//                                               //       LatLng(latList[i], lngList[i]));
//                                               // }
//                                               points.add(LatLng(lat, lng));
//                                               // print(points);
//                                               updatePolyline();
//                                               updateMainPolyline(lat, lng);
//                                               getLocationApi(
//                                                   lat.toString(),
//                                                   lng.toString(),
//                                                   deviceNumb.toString());
//                                             }
//                                             //   latList.add(lat);
//                                             //   lngList.add(lng);
//                                             //   List<String> strList = latList.map((i) => i.toString()).toList();
//                                             //   prefs.setStringList("latList", strList);
//                                             //   List<String> strList2 = lngList.map((i) => i.toString()).toList();
//                                             //   prefs.setStringList("lngList", strList2);
//                                             //  //   for (int i = 0 ; i < latList.length; i++){
//                                             //   //     points.add(LatLng(latList[i],lngList[i]));
//                                             //   //   };
//                                             // points.add(LatLng(lat, lng));
//                                             //   // print(points);
//                                             //   updatePolyline();
//                                             //   getLocationApi(lat.toString(), lng.toString(), deviceNumb.toString());
//                                           }
//                                         }
//                                       } else {}
//                                       return Text('');
//                                     },
//                                   )
//                                 : Container(),
//                             Container(
//                               height: 82.h,
//                               width: getScreenWidth(context),
//                               decoration: BoxDecoration(
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.3),
//                                     spreadRadius: 2,
//                                     blurRadius: 7,
//                                     offset: const Offset(0, 0),
//                                   ),
//                                 ],
//                                 borderRadius: const BorderRadius.only(
//                                     topLeft: Radius.circular(20),
//                                     topRight: Radius.circular(20)),
//                                 color: backgroundColor,
//                               ),
//                               child: GoogleMap(
//                                 mapType: MapType.normal,
//                                 zoomControlsEnabled: true,
//                                 zoomGesturesEnabled: true,
//                                 scrollGesturesEnabled: true,
//                                 // padding: EdgeInsets.all(2.w),
//
//                                 markers: Set.of((marker != null)
//                                     ? [marker!, marker2!, marker3!]
//                                     : []),
//                                 circles:
//                                     Set.of((circle != null) ? [circle!] : []),
//
//                                 polylines: {
//                                   Polyline(
//                                     polylineId: PolylineId('route'),
//                                     points: polylineCoordinates,
//                                     color: primaryBlue,
//                                     width: 5,
//                                   ),
//                                 },
//
//                                 // /// مع المسار الاساسي
//                                 // polylines: {
//                                 //   Polyline(
//                                 //     polylineId: PolylineId('route'),
//                                 //     points: polylineCoordinates,
//                                 //     color: primaryBlue,
//                                 //     width: 5,
//                                 //   ),
//                                 //   Polyline(
//                                 //       points: points,
//                                 //       polylineId: PolylineId('track'),
//                                 //       color: Colors.red,
//                                 //       width: 4,
//                                 //       // points: latLngList,
//                                 //       patterns: [
//                                 //         PatternItem.dash(20),
//                                 //         PatternItem.gap(10),
//                                 //       ]),
//                                 // },
//
//                                 /// بدون المسار الاساسي
//                                 // polylines: pathPolyline,
//
//                                 initialCameraPosition: _kGooglePlex!,
//                                 onMapCreated: (GoogleMapController controller) {
//                                   gmc = controller;
//                                 },
//                                 onTap: (latlng) {},
//                               ),
//                             ),
//                             Positioned(
//                                 bottom: 2.h,
//                                 left: 30.w,
//                                 right: 30.w,
//                                 child: ContainerWidget(
//                                     text: 'end'.tr(),
//                                     h: 7.h,
//                                     w: 50.w,
//                                     onTap: () {
//                                       DateTime t = DateTime.now();
//                                       print(t);
//                                       String end_time =
//                                           '${t.hour}:${t.minute}:${t.second}';
//                                       print(end_time);
//                                       print(latList);
//                                       print(lngList);
//                                       print(latList.first);
//                                       print(latList.last);
//                                       print(lngList.first);
//                                       print(lngList.last);
//                                       getDistance(latList.first, lngList.first,
//                                           latList.last, lngList.last);
//                                       print(widget.tripId);
//                                       print(end_time);
//                                       print(finalDistance.toString());
//                                       latList = [];
//                                       lngList = [];
//                                       prefs.remove('latList');
//                                       prefs.remove('lngList');
//                                       for (int i = 0; i < latList.length; i++) {
//                                         points.add(
//                                             LatLng(latList[i], lngList[i]));
//                                       }
//                                       ;
//                                       endTripApi(widget.tripId, end_time,
//                                           finalDistance.toString());
//                                     }))
//                           ]),
//                         ),
//                         // SizedBox(
//                         //   height: 3.h,
//                         // ),
//                         // BottomIconsDriver(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
// }
