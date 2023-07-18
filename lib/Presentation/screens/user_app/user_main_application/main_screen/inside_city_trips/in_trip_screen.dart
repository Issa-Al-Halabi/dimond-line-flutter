import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:connectivity/connectivity.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/inside_city_trips/trip_ended.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lt;
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/io.dart';
import '../../../../../../Data/Models/User_Models/SocketResponse.dart';
import '../../../../../../Data/network/requests.dart';
import '../../../../../Functions/helper.dart';
import '../../../../../widgets/container_widget.dart';
import '../../../../../widgets/loader_widget.dart';
import '../../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import '../user_dashboard.dart';
import 'inside_trip_delayed.dart';

class InTripScreen extends StatefulWidget {
  InTripScreen(
      {required this.tripId,
      required this.pickupLatitude,
      required this.pickupLongitude,
      required this.dropLatitude,
      required this.dropLongitude,
      Key? key})
      : super(key: key);

  String tripId;
  String pickupLatitude, pickupLongitude, dropLatitude, dropLongitude;

  @override
  State<InTripScreen> createState() => _InTripScreenState();
}

class _InTripScreenState extends State<InTripScreen> {
  CameraPosition? _kGooglePlex;
  double latRoute = 0.0;
  double lngRoute = 0.0;
  double course = 0.0;
  GoogleMapController? gmc;
  bool _isNetworkAvail = true;
  String CUR_USERID = '';
  DateTime timeback = DateTime.now();
  String status = '';
  // String statusDelayed = '';
  // String id = '';
  int id = 0;
  List<LatLng> polylineCoordinates = [];
  List<LatLng> polylineCoordinates2 = [];
  List<LatLng> polylineCoordinates3 = [];
  Marker marker = Marker(markerId: MarkerId("home"));
  Marker marker2 = Marker(markerId: MarkerId("from"));
  Marker marker3 = Marker(markerId: MarkerId("to"));
  Circle circle = Circle(
    circleId: CircleId("car"),
  );
  int deviceNumb = 0;
  String driverFname = '',
      driverLname = '',
      driverImage = '',
      driverPhone = '',
      carModel = '',
      carColor = '',
      finalCost = '',
      vehicelImage = '';

  bool isAcceptTrip = false;
  bool isStartTrip = false;
  bool isSecondTrip = false;
  int counter = 180; // Initial counter value in seconds
  bool isTrackDriverDelayTrip = false;
  SocketResponse delayTripModel = SocketResponse();
  Map<String, dynamic> data = Map();

  var _channel = IOWebSocketChannel.connect(
    Uri.parse(
      'ws://mycar.ssc-security.net:8080/api/socket',
    ),
  );

  StreamController<Map<String, dynamic>> eventStreamController = StreamController<Map<String, dynamic>>.broadcast();

  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  @override
  void initState() {
    getUserId();
    getCookie();
    connectSocket();
    markerOfMainWay();
    getLatAndLong();
    getPolyPoints();
    super.initState();
  }

  @override
  void dispose() {
    Loader.hide();
    super.dispose();
  }

  Future<void> getLatAndLong() async {
    _kGooglePlex = CameraPosition(
      target: LatLng(double.parse(widget.pickupLatitude),
          double.parse(widget.pickupLongitude)),
      zoom: 10,
    );
    setState(() {});
  }

  Future<void> getCookie() async {
    Map<String, String> co = {};
    Response response = await get(Uri.parse(
      'http://mycar.ssc-security.net:8080/api/session?token=oqBN0XE1usgfA25X465NJs24XHtNs20S',
    ));
    co.addAll({"Cookie": response.headers['set-cookie'].toString()});
    _channel = IOWebSocketChannel.connect(
        Uri.parse(
          'ws://mycar.ssc-security.net:8080/api/socket',
        ),
        headers: co);
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load(carIcon);
    return byteData.buffer.asUint8List();
  }

  void tripPolyline(double pickupLatitude, double pickupLongitude,
      double dropLatitude, double dropLongitude) async {
    /// clear main route
    polylineCoordinates.clear();

    // /// clear car route
    // polylineCoordinates3.clear();

    Uint8List imageData = await getMarker();
    marker = Marker(
        markerId: MarkerId("home"),
        // position: latLngList.last,
        position: LatLng(pickupLatitude, pickupLongitude),
        rotation: course,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData));
    circle = Circle(
        circleId: CircleId("car"),
        radius: 10,
        zIndex: 1,
        strokeColor: Colors.grey,
        // center: latLngList.last,
        center: LatLng(pickupLatitude, pickupLongitude),
        fillColor: Colors.grey.withAlpha(70));
    polylineCoordinates2.clear();
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      APIKEY,
      PointLatLng(pickupLatitude, pickupLongitude),
      PointLatLng(dropLatitude, dropLongitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates2.add(LatLng(point.latitude, point.longitude));
      });
    }
    if (mounted) {
      setState(() {});
    }

    // delete from marker
    marker2 = Marker(markerId: MarkerId("from"));
  }

  void carPolyline(double pickupLatitude, double pickupLongitude,
      double dropLatitude, double dropLongitude) async {
    /// clear main route
    // polylineCoordinates.clear();

    Uint8List imageData = await getMarker();
    marker = Marker(
        markerId: MarkerId("home"),
        // position: latLngList.last,
        position: LatLng(pickupLatitude, pickupLongitude),
        rotation: course,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData));
    circle = Circle(
        circleId: CircleId("car"),
        radius: 10,
        zIndex: 1,
        strokeColor: Colors.grey,
        // center: latLngList.last,
        center: LatLng(pickupLatitude, pickupLongitude),
        fillColor: Colors.grey.withAlpha(70));
    polylineCoordinates3.clear();
    // setState(() {});
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      APIKEY,
      PointLatLng(pickupLatitude, pickupLongitude),
      PointLatLng(dropLatitude, dropLongitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates3.add(LatLng(point.latitude, point.longitude));
      });
    }
    if (mounted) {
      setState(() {});
    }
  }

  /// رسم المسار الاساسي
  void getPolyPoints() async {
    polylineCoordinates.clear();
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      APIKEY,
      PointLatLng(double.parse(widget.pickupLatitude),
          double.parse(widget.pickupLongitude)),
      PointLatLng(double.parse(widget.dropLatitude),
          double.parse(widget.dropLongitude)),
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

  void markerOfMainWay() {
    marker2 = Marker(
      markerId: MarkerId("from"),
      position: LatLng(double.parse(widget.pickupLatitude),
          double.parse(widget.pickupLongitude)),
      rotation: 2,
      draggable: false,
      zIndex: 2,
      flat: true,
      anchor: Offset(0.5, 0.5),
      infoWindow: InfoWindow(
        title: 'from'.tr(),
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    marker3 = Marker(
      markerId: MarkerId("to"),
      position: LatLng(double.parse(widget.dropLatitude),
          double.parse(widget.dropLongitude)),
      rotation: 2,
      draggable: false,
      zIndex: 2,
      flat: true,
      anchor: Offset(0.5, 0.5),
      infoWindow: InfoWindow(
        title: 'to'.tr(),
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
  }

  ////////////////// cancel trip api //////////////////////////
  Future<void> cancelTrip(String trip_id) async {
    print(trip_id);
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      Loader.show(context, progressIndicator: LoaderWidget());
      var data = await AppRequests.cancelTripRequest(trip_id);
      data = json.decode(data);
      if (data["error"] == false) {
        Loader.hide();
        if (isSecondTrip == true) {
          navigateToSecondTrip();
        } else {
          navigateToDashboard();
        }
      } else {
        Loader.hide();
        setSnackbar(data["message"].toString(), context);
      }
    } else {
      setSnackbar("nointernet".tr(), context);
      print("nointernet");
    }
  }

  void getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CUR_USERID = prefs.getString('user_id') ?? '';
    print('CUR_USERID');
    print(CUR_USERID);
  }

  void connectSocket() async {
    try {
      await pusher.init(
        apiKey: APIKEY_PUSHER,
        cluster: CLUSTER_PUSHER,
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        onSubscriptionCount: onSubscriptionCount,
      );
      await pusher.subscribe(channelName: 'trip-status-$CUR_USERID');
      await pusher.connect();
    } catch (e) {
      log("ERROR: $e");
    }
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    log("Connection: $currentState");
  }

  void onError(String message, int? code, dynamic e) {
    log("onError: $message code: $code exception: $e");
  }

  void onEvent(PusherEvent event) {
    log("onEvent: $event");
    Map<String, dynamic> data = jsonDecode(event.data);
    eventStreamController.sink.add(data);
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    log("onSubscriptionSucceeded: $channelName data: $data");
    final me = pusher.getChannel(channelName)?.me;
    log("Me: $me");
  }

  void onSubscriptionError(String message, dynamic e) {
    log("onSubscriptionError: $message Exception: $e");
  }

  void onDecryptionFailure(String event, String reason) {
    log("onDecryptionFailure: $event reason: $reason");
  }

  void onMemberAdded(String channelName, PusherMember member) {
    log("onMemberAdded: $channelName user: $member");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    log("onMemberRemoved: $channelName user: $member");
  }

  void onSubscriptionCount(String channelName, int subscriptionCount) {
    log("onSubscriptionCount: $channelName subscriptionCount: $subscriptionCount");
  }

  bool navigate() {
    eventStreamController.close();
    _channel.sink.close();
    pusher.disconnect();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TripEndedUserScreen(
                  finalCost: finalCost,
                  tripId: widget.tripId,
                )),
      );
    });
    return true;
  }

  bool convertAccept() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        isAcceptTrip = true;
        // print('teeeeeeeeeeeeeeeeeeeeeeeest accept');
        // print(isAcceptTrip);
      });
    });
    return true;
  }

  bool convertStart() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        isStartTrip = true;
        // print('teeeeeeeeeeeeeeeeeeeeeeeest start');
        // print(isStartTrip);
      });
    });
    return true;
  }

  // bool convertSecondTrack() {
  //   WidgetsBinding.instance?.addPostFrameCallback((_) {
  //     setState(() {
  //       isTrackDriverDelayTrip = !isTrackDriverDelayTrip;
  //       isSecondTrip = !isSecondTrip;
  //       print(isTrackDriverDelayTrip);
  //       print(isSecondTrip);
  //     });
  //   });
  //   return true;
  // }

  bool convertSecondTrack() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        isTrackDriverDelayTrip = true;
        isSecondTrip = true;
        // print(isTrackDriverDelayTrip);
        // print(isSecondTrip);
      });
    });
    return true;
  }


  bool convertSecondTrackFalse() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        isTrackDriverDelayTrip = false;
        isSecondTrip = false;
        print(isTrackDriverDelayTrip);
        print(isSecondTrip);
      });
    });
    return true;
  }

  // bool convertBoolean(bool myBoolean) {
  //   WidgetsBinding.instance?.addPostFrameCallback((_) {
  //     setState(() {
  //       myBoolean = !myBoolean;
  //       // print('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhh $myBoolean');
  //     });
  //   });
  //   return true;
  // }

  bool convertId(int newId) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        id = newId;
          print('id is: $id');
          print(newId);
      });
    });
    return true;
  }

  void navigateToDashboard() {
    eventStreamController.close();
    _channel.sink.close();
    pusher.disconnect();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserDashboard()),
    );
  }

  bool navigateDash() {
    eventStreamController.close();
    _channel.sink.close();
    pusher.disconnect();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setSnackbar('your trip didnt accept'.tr(), context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserDashboard()),
      );
    });
    return true;
  }

  void navigateToSecondTrip() {
    eventStreamController.close();
    _channel.sink.close();
    pusher.disconnect();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InsideTripDelayedScreen(
                delayTripModel: delayTripModel,
                isAcceptTrip: isTrackDriverDelayTrip,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Loader.isShown == true) {
          Loader.hide();
        }
        final differance = DateTime.now().difference(timeback);
        final isExitWarning = differance >= Duration(seconds: 2);
        timeback = DateTime.now();
        if (isExitWarning) {
          final Message = "Press back agin to Exit".tr();
          Fluttertoast.showToast(
              msg: Message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: white,
              textColor: primaryBlue,
              fontSize: 5.sp);
          return false;
        } else {
          Fluttertoast.cancel();
          SystemNavigator.pop();
          return true;
        }
      },
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
                          isAcceptTrip == true
                              ? StreamBuilder(
                                  stream: _channel.stream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData == true) {
                                      var data =
                                          json.decode(snapshot.data.toString());
                                      // print('--------------------------------');
                                      // print(data);
                                      if (data['positions'] != null) {
                                        //TODO
                                        if (data['positions'][0]['deviceId'] == deviceNumb) {
                                        // if (data['positions'][0]['deviceId'] ==
                                        //     204) {
                                          // print(
                                          //     'course me ${data['positions'][0]['course']}');
                                          latRoute =
                                              data['positions'][0]['latitude'];
                                          lngRoute =
                                              data['positions'][0]['longitude'];
                                          course =
                                              data['positions'][0]['course'];
                                          isStartTrip == true
                                              ? tripPolyline(
                                                  latRoute,
                                                  lngRoute,
                                                  double.parse(
                                                      widget.dropLatitude),
                                                  double.parse(
                                                      widget.dropLongitude))
                                              // : isAcceptTrip == true ?
                                              // carPolyline(
                                              //     latRoute,
                                              //     lngRoute,
                                              //     double.parse(widget.pickupLatitude),
                                              //     double.parse(widget.pickupLongitude)
                                              // )
                                              : null;
                                        }
                                      }
                                    } else {}
                                    return Text('');
                                  },
                                )
                              : Container(),
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
                              // markers: myMarker,
                              markers: Set.of((marker3 != null)
                                  ? [marker, marker2, marker3]
                                  : []),
                              polylines: {
                                Polyline(
                                  polylineId: PolylineId('route'),
                                  points: polylineCoordinates,
                                  color: primaryBlue,
                                  width: 5,
                                ),
                                Polyline(
                                  polylineId: PolylineId('track'),
                                  points: polylineCoordinates2,
                                  color: primaryBlue,
                                  // color: Colors.red,
                                  width: 5,
                                ),
                                Polyline(
                                  polylineId: PolylineId('car'),
                                  points: polylineCoordinates3,
                                  color: Colors.orange,
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
                          // Positioned(
                          //   top: 4.h,
                          //   right: 1.w,
                          //   child: isSecondTrip
                          //       ? InkWell(
                          //           child: Container(
                          //               width: 50,
                          //               height: 50,
                          //               decoration: BoxDecoration(
                          //                   boxShadow: [
                          //                     BoxShadow(
                          //                       color: primaryBlue
                          //                           .withOpacity(0.3),
                          //                       spreadRadius: 2,
                          //                       blurRadius: 7,
                          //                       offset: const Offset(0, 0),
                          //                     ),
                          //                   ],
                          //                   borderRadius: BorderRadius.all(
                          //                       Radius.circular(100)),
                          //                   color: primaryBlue),
                          //               child: Center(
                          //                   child: Icon(
                          //                 Icons.compare_arrows_outlined,
                          //                 size: 35,
                          //                 color: backgroundColor,
                          //               ))),
                          //           onTap: () async {
                          //             navigateToSecondTrip();
                          //           })
                          //       : Text(''),
                          // ),
                          Positioned(
                              bottom: 0.h,
                              child: StreamBuilder<Map<String, dynamic>>(
                                stream: eventStreamController.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    // Map<String, dynamic> data = snapshot.data!;
                                    data = snapshot.data!;
                                    int id = data['data']['id'];
                                    // setState(() {
                                    //   id = data['data']['id'];
                                    //   print('id is: $id');
                                    //   print(data['data']['id']);
                                    // });
                                    // convertId(data['data']['id']);

                                    if (id.toString() == widget.tripId) {
                                      status = data['data']['status'];
                                      // print('ids equal');
                                      if (status == 'accepted') {
                                        convertAccept();
                                        // convertBoolean(isAcceptTrip);
                                        deviceNumb = data['data']
                                            ['vehicel_device_number'];
                                        driverFname =
                                            data['data']['driver_first_name'];
                                        driverLname =
                                            data['data']['driver_last_name'];
                                        driverImage = data['data']
                                            ['driver_profile_image'];
                                        driverPhone =
                                            data['data']['driver_phone'];
                                        carModel =
                                            data['data']['vehicel_car_model'];
                                        carColor =
                                            data['data']['vehicel_color'];
                                        vehicelImage =
                                            data['data']['vehicel_image'];
                                      }
                                      if (status == 'started') {
                                        convertStart();
                                        // convertBoolean(isStartTrip);
                                      }
                                      if (status == 'ended') {
                                        finalCost = data['data']['cost'];
                                        // print(finalCost);
                                        navigate();
                                      }
                                      if (status == 'canceld') {
                                        // print('your trip didnt accept');
                                        navigateDash();
                                      }
                                    }

                                    else{
                                      print('ttttttttttttt');
                                      print(data);
                                      String statusDelayed = data['data']['status'];
                                      print(statusDelayed);
                                      print(data['data']['id']);
                                    }

                                    // TODO
                                    // else {
                                    //   // print(data);
                                    //   // print('actual second status ${data['data']['status']}');
                                    //   String statusDelayed = data['data']['status'];
                                    //   print('this trip $id is $statusDelayed');
                                    //   print(widget.tripId);
                                    //   if (statusDelayed != 'pending' && statusDelayed != 'accepted') {
                                    //     // print('not pending or accepted');
                                    //     convertSecondTrack();
                                    //     // print('second status $statusDelayed');
                                    //     // convertBoolean(isTrackDriverDelayTrip);
                                    //     // convertBoolean(isSecondTrip);
                                    //
                                    //     // delayTripModel = SocketResponse();
                                    //
                                    //
                                    //     delayTripModel.driverFirstName =
                                    //         data['data']['driver_first_name'];
                                    //     delayTripModel.driverLastName =
                                    //         data['data']['driver_last_name'];
                                    //     delayTripModel.driverProfileImage =
                                    //         data['data']
                                    //             ['driver_profile_image'];
                                    //     delayTripModel.driverPhone =
                                    //         data['data']['driver_phone'];
                                    //     delayTripModel.vehicelDeviceNumber =
                                    //         data['data']
                                    //             ['vehicel_device_number'];
                                    //     delayTripModel.vehicelCarModel =
                                    //         data['data']['vehicel_car_model'];
                                    //     delayTripModel.vehicelColor =
                                    //         data['data']['vehicel_color'];
                                    //     delayTripModel.vehicelImage =
                                    //         data['data']['vehicel_image'];
                                    //     delayTripModel.pickupLatitude =
                                    //         data['data']['pickup_latitude'];
                                    //     delayTripModel.pickupLongitude =
                                    //         data['data']['pickup_longitude'];
                                    //     delayTripModel.dropLatitude =
                                    //         data['data']['drop_latitude'];
                                    //     delayTripModel.dropLongitude =
                                    //         data['data']['drop_longitude'];
                                    //     delayTripModel.id = data['data']['id'];
                                    //     delayTripModel.status =
                                    //         data['data']['status'];
                                    //   } else if (statusDelayed == 'ended') {
                                    //     print('endeeeeeeeeeeeeeeeeeeeeeeeeed');
                                    //     convertSecondTrackFalse();
                                    //     // convertBoolean(isTrackDriverDelayTrip);
                                    //     // convertBoolean(isSecondTrip);
                                    //   }
                                    // }

                                    return Row(
                                      children: [
                                        status == 'accepted'
                                            ? AcceptedWidget()
                                            : status == 'arrived'
                                                ? ArrivedWidget()
                                                : status == 'started'
                                                    ? StartedWidget()
                                                    : Text('')
                                      ],
                                    );
                                  } else {
                                    return PendingWidget();
                                  }
                                },
                              ))
                        ],
                      ),
                    ],
                  ),
                )),
      ),
    );
  }

  getDialog(String image) async {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return FadeInImage(
                image: NetworkImage(image),
                height: 30.h,
                width: 90.w,
                imageErrorBuilder: (context, error, stackTrace) =>
                    erroWidget(100),
                placeholder: placeHolder(100),
              );
            }),
          );
        }).then((val) {});
  }

  PendingWidget() {
    return Container(
      // height: 30.h,
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
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: backgroundColor,
      ),
      child: PendingContent(),
    );
  }

  PendingContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              lt.Lottie.asset(
                lookingDriver,
                height: 20.h,
                width: 50.w,
              ),
              Expanded(
                child: myText(
                    text: 'looking car'.tr(),
                    fontSize: 5.sp,
                    color: primaryBlue,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Container(
            height: 6.h,
            width: 30.w,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 0),
                ),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.red,
            ),
            child: TextButton(
              child: myText(
                  text: 'cancel'.tr(),
                  fontSize: 4.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
              onPressed: () {
                cancelTrip(widget.tripId);
              },
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
        ],
      ),
    );
  }

  AcceptedWidget() {
    return Container(
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
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: backgroundColor,
      ),
      child: AcceptedContent(),
    );
  }

  AcceptedContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 1.h,
          ),
          myText(
              text: 'your trip accepted'.tr(),
              fontSize: 6.sp,
              color: primaryBlue,
              fontWeight: FontWeight.w600),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              myText(
                  text: driverFname + ' ' + driverLname,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              InkWell(
                child: Text(
                  '${driverPhone}',
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 5.sp,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  launchUrl(Uri.parse("tel://+963 ${driverPhone}"));
                },
              ),
              InkWell(
                  child: FadeInImage(
                    image: NetworkImage(driverImage.toString()),
                    height: 10.h,
                    width: 10.w,
                    fit: BoxFit.contain,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        erroWidget(100),
                    placeholder: placeHolder(100),
                  ),
                  onTap: () {
                    getDialog(driverImage.toString());
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              myText(
                  // text: 'car color'.tr(),
                  text: carModel,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              myText(
                  text: carColor,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              InkWell(
                child: FadeInImage(
                  image: NetworkImage(vehicelImage.toString()),
                  height: 10.h,
                  width: 10.w,
                  fit: BoxFit.contain,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      erroWidget(20),
                  placeholder: placeHolder(20),
                ),
                onTap: () {
                  getDialog(vehicelImage.toString());
                },
              ),
            ],
          ),
          ContainerWidget(
              text: 'share'.tr(),
              h: 6.h,
              w: 30.w,
              onTap: () {
                var str = "AppName".tr() +
                    "\n\n" +
                    "I with".tr() +
                    "\n"
                        "${driverFname}"
                        "\t"
                        "${driverLname}\n"
                        "${driverPhone}\n"
                        "${carModel}\n"
                        "${carColor}";
                Share.share(str);
                print(str);
              }),
          SizedBox(
            height: 1.h,
          ),
        ],
      ),
    );
  }

  ArrivedWidget() {
    return Container(
      // height: 30.h,
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
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: backgroundColor,
      ),
      child: ArrivedContent(),
    );
  }

  ArrivedContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 3.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              myText(
                text: 'driver arrive'.tr() + '\n' + 'dont let him wait'.tr(),
                fontSize: 6.sp,
                color: primaryBlue,
                fontWeight: FontWeight.w600,
              ),
              lt.Lottie.asset(
                arrive,
                // height: 30.h,
                width: 30.w,
              ),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              myText(
                  text: driverFname + ' ' + driverLname,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              SizedBox(
                width: 1.w,
              ),
              InkWell(
                child: Text(
                  '${driverPhone}',
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 5.sp,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  launchUrl(Uri.parse("tel://+963 ${driverPhone}"));
                },
              ),
              InkWell(
                  child: FadeInImage(
                    image: NetworkImage(driverImage.toString()),
                    height: 10.h,
                    width: 10.w,
                    fit: BoxFit.contain,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        erroWidget(100),
                    placeholder: placeHolder(100),
                  ),
                  onTap: () {
                    getDialog(driverImage.toString());
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              myText(
                  text: carModel,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              myText(
                  text: carColor,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              InkWell(
                child: FadeInImage(
                  image: NetworkImage(vehicelImage.toString()),
                  height: 10.h,
                  width: 10.w,
                  fit: BoxFit.contain,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      erroWidget(20),
                  placeholder: placeHolder(20),
                ),
                onTap: () {
                  getDialog(vehicelImage.toString());
                },
              ),
            ],
          ),
          ContainerWidget(
              text: 'share'.tr(),
              h: 6.h,
              w: 30.w,
              onTap: () {
                var str = "AppName".tr() +
                    "\n\n" +
                    "I with".tr() +
                    "\n"
                        "${driverFname}"
                        "\t"
                        "${driverLname}\n"
                        "${driverPhone}\n"
                        "${carModel}\n"
                        "${carColor}";
                Share.share(str);
                print(str);
              }),
          SizedBox(
            height: 1.h,
          ),
        ],
      ),
    );
  }

  StartedWidget() {
    return Container(
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
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: backgroundColor,
      ),
      child: StartedContent(),
    );
  }

  StartedContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 1.h,
          ),
          myText(
              text: 'your trip started'.tr(),
              fontSize: 6.sp,
              color: primaryBlue,
              fontWeight: FontWeight.w600),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              myText(
                  text: driverFname + ' ' + driverLname,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              InkWell(
                child: Text(
                  '${driverPhone}',
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 5.sp,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  launchUrl(Uri.parse("tel://+963 ${driverPhone}"));
                },
              ),
              InkWell(
                  child: FadeInImage(
                    image: NetworkImage(driverImage.toString()),
                    height: 10.h,
                    width: 10.w,
                    fit: BoxFit.contain,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        erroWidget(100),
                    placeholder: placeHolder(100),
                  ),
                  onTap: () {
                    getDialog(driverImage.toString());
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              myText(
                  // text: 'car color'.tr(),
                  text: carModel,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              myText(
                  text: carColor,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              InkWell(
                child: FadeInImage(
                  image: NetworkImage(vehicelImage.toString()),
                  height: 10.h,
                  width: 10.w,
                  fit: BoxFit.contain,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      erroWidget(20),
                  placeholder: placeHolder(20),
                ),
                onTap: () {
                  getDialog(vehicelImage.toString());
                },
              ),
            ],
          ),
          ContainerWidget(
              text: 'share'.tr(),
              h: 6.h,
              w: 30.w,
              onTap: () {
                var str = "AppName".tr() +
                    "\n\n" +
                    "I with".tr() +
                    "\n"
                        "${driverFname}"
                        "\t"
                        "${driverLname}\n"
                        "${driverPhone}\n"
                        "${carModel}\n"
                        "${carColor}";
                Share.share(str);
                print(str);
              }),
          SizedBox(
            height: 1.h,
          ),
        ],
      ),
    );
  }

  Future<bool> isNetworkAvailable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
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
}
