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

class InsideTripMomentScreen extends StatefulWidget {
  InsideTripMomentScreen(
      {required this.isSecondTrip,
      required this.isAcceptTrip,
      required this.momentTripModel,
      required this.delayTripModel,
      Key? key})
      : super(key: key);

  bool isSecondTrip;
  bool isAcceptTrip;
  SocketResponse momentTripModel = SocketResponse();
  SocketResponse delayTripModel = SocketResponse();

  @override
  State<InsideTripMomentScreen> createState() => _InsideTripMomentScreenState();
}

class _InsideTripMomentScreenState extends State<InsideTripMomentScreen> {
  CameraPosition? _kGooglePlex;
  double latRoute = 0.0;
  double lngRoute = 0.0;
  double course = 0.0;
  String statusDelayed = '';
  GoogleMapController? gmc;
  bool _isNetworkAvail = true;
  String CUR_USERID = '';
  DateTime timeback = DateTime.now();
  String id = '';
  List<LatLng> polylineCoordinates = [];
  List<LatLng> polylineCoordinates2 = [];
  List<LatLng> polylineCoordinates3 = [];
  Marker marker = Marker(markerId: MarkerId("home"));
  Marker marker2 = Marker(markerId: MarkerId("from"));
  Marker marker3 = Marker(markerId: MarkerId("to"));
  Circle circle = Circle(
    circleId: CircleId("car"),
  );

  bool isStartTrip = false;
  String finalCost = '';
  bool isTrackDriverDelayTrip = false;

  var _channel = IOWebSocketChannel.connect(
    Uri.parse(
      'ws://mycar.ssc-security.net:8080/api/socket',
    ),
  );
  StreamController<Map<String, dynamic>> eventStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
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

  Future<void> getLatAndLong() async {
    _kGooglePlex = CameraPosition(
      target: LatLng(double.parse(widget.momentTripModel.pickupLatitude!),
          double.parse(widget.momentTripModel.pickupLongitude!)),
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

    /// clear car route
    // polylineCoordinates3.clear();

    Uint8List imageData = await getMarker();
    marker = Marker(
        markerId: MarkerId("home"),
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
      PointLatLng(double.parse(widget.momentTripModel.pickupLatitude!),
          double.parse(widget.momentTripModel.pickupLongitude!)),
      PointLatLng(double.parse(widget.momentTripModel.dropLatitude!),
          double.parse(widget.momentTripModel.dropLongitude!)),
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
      position: LatLng(double.parse(widget.momentTripModel.pickupLatitude!),
          double.parse(widget.momentTripModel.pickupLongitude!)),
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
      position: LatLng(double.parse(widget.momentTripModel.dropLatitude!),
          double.parse(widget.momentTripModel.dropLongitude!)),
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
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      Loader.show(context, progressIndicator: LoaderWidget());
      var data = await AppRequests.cancelTripRequest(trip_id);
      data = json.decode(data);
      if (data["error"] == false) {
        Loader.hide();
        if (widget.isSecondTrip == true) {
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

  void navigateToDashboard() {
    eventStreamController.close();
    _channel.sink.close();
    pusher.disconnect();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserDashboard()),
    );
  }

  void getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CUR_USERID = prefs.getString('user_id') ?? '';
  }

  // ******************************************* //
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

  dynamic onAuthorizer(String channelName, String socketId, dynamic options) {
    return {
      "auth": "foo:bar",
      "channel_data": '{"user_id": 1}',
      "shared_secret": "foobar"
    };
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
                  tripId: widget.momentTripModel.id.toString(),
                )),
      );
    });
    return true;
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

  bool convertAccept() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        widget.isAcceptTrip = true;
      });
    });
    return true;
  }

  bool convertStart() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        isStartTrip = true;
      });
    });
    return true;
  }

  // bool convertSecondTrack() {
  //   WidgetsBinding.instance?.addPostFrameCallback((_) {
  //     setState(() {
  //       !isTrackDriverDelayTrip;
  //       !widget.isSecondTrip;
  //     });
  //   });
  //   return true;
  // }

  bool convertSecondTrack() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        isTrackDriverDelayTrip = true;
        widget.isSecondTrip = true;
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
        widget.isSecondTrip = false;
        // print(isTrackDriverDelayTrip);
        // print(widget.isSecondTrip);
      });
    });
    return true;
  }

  // bool convertBoolean(bool myBoolean) {
  //   WidgetsBinding.instance?.addPostFrameCallback((_) {
  //     setState(() {
  //       myBoolean = !myBoolean;
  //     });
  //   });
  //   return true;
  // }

  void navigateToSecondTrip() {
    eventStreamController.close();
    _channel.sink.close();
    pusher.disconnect();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InsideTripDelayedScreen(
                delayTripModel: widget.delayTripModel,
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
                          widget.isAcceptTrip == true
                              ? StreamBuilder(
                                  stream: _channel.stream,
                                  builder: (context, snapshot) {
                                    print(snapshot.data);
                                    print(snapshot.connectionState);
                                    if (snapshot.hasData == true) {
                                      var data =
                                          json.decode(snapshot.data.toString());
                                      print('--------------------------------');
                                      print(data);
                                      if (data['positions'] != null) {
                                        if (data['positions'][0]['deviceId'] ==
                                            widget.momentTripModel
                                                .vehicelDeviceNumber) {
                                          print(
                                              'course me ${data['positions'][0]['course']}');
                                          latRoute =
                                              data['positions'][0]['latitude'];
                                          lngRoute =
                                              data['positions'][0]['longitude'];
                                          course =
                                              data['positions'][0]['course'];
                                          isStartTrip == true
                                              // ? updateMainPolyline(
                                              ? tripPolyline(
                                                  latRoute,
                                                  lngRoute,
                                                  // latToRoute,
                                                  // lngToRoute
                                                  double.parse(widget
                                                      .momentTripModel
                                                      .dropLatitude!),
                                                  double.parse(widget
                                                      .momentTripModel
                                                      .dropLongitude!))
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
                          Positioned(
                            top: 4.h,
                            right: 1.w,
                            child: widget.isSecondTrip == true
                                ? InkWell(
                                    child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: primaryBlue
                                                    .withOpacity(0.3),
                                                spreadRadius: 2,
                                                blurRadius: 7,
                                                offset: const Offset(0, 0),
                                              ),
                                            ],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100)),
                                            color: primaryBlue),
                                        child: Center(
                                            child: Icon(
                                          Icons.compare_arrows_outlined,
                                          size: 35,
                                          color: backgroundColor,
                                        ))),
                                    onTap: () async {
                                      navigateToSecondTrip();
                                    })
                                : Text(''),
                          ),
                          Positioned(
                              bottom: 0.h,
                              child: StreamBuilder<Map<String, dynamic>>(
                                stream: eventStreamController.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    Map<String, dynamic> data = snapshot.data!;
                                    print('**************************');
                                    print(data);
                                    // print(data);
                                    int id = data['data']['id'];
                                    // if(id.toString() == int.parse(widget.momentTripModel.id)){
                                    if (id.toString() ==
                                        widget.momentTripModel.id.toString()) {
                                      print('xxxxxxxxxxxxxxxxxxxxxx');
                                      //   setState(() {
                                      widget.momentTripModel.status =
                                          data['data']['status'];
                                      // print(widget.momentTripModel.status);
                                      if (widget.momentTripModel.status ==
                                          'accepted') {
                                        convertAccept();
                                        // convertBoolean(widget.isAcceptTrip);
                                        widget.momentTripModel
                                                .vehicelDeviceNumber =
                                            data['data']
                                                ['vehicel_device_number'];
                                        widget.momentTripModel.driverFirstName =
                                            data['data']['driver_first_name'];
                                        widget.momentTripModel.driverLastName =
                                            data['data']['driver_last_name'];
                                        widget.momentTripModel
                                                .driverProfileImage =
                                            data['data']
                                                ['driver_profile_image'];
                                        widget.momentTripModel.driverPhone =
                                            data['data']['driver_phone'];
                                        widget.momentTripModel.vehicelCarModel =
                                            data['data']['vehicel_car_model'];
                                        widget.momentTripModel.vehicelColor =
                                            data['data']['vehicel_color'];
                                        widget.momentTripModel.vehicelImage =
                                            data['data']['vehicel_image'];
                                      }
                                      if (widget.momentTripModel.status ==
                                          'started') {
                                        // isStartTrip = true;
                                        convertStart();
                                        // convertBoolean(isStartTrip);
                                      }
                                      if (widget.momentTripModel.status ==
                                          'ended') {
                                        finalCost = data['data']['cost'];
                                        print(finalCost);
                                        navigate();
                                      }
                                      if (widget.momentTripModel.status ==
                                          'canceld') {
                                        print('your trip didnt accept');
                                        navigateDash();
                                      }
                                    }

                                    // else {
                                    //   print('vvvvvvvvvvvvvvvvvvvvvvvv');
                                    //
                                    //   statusDelayed =  data['data']['status'];
                                    //   print('this trip $id is ${statusDelayed}');
                                    //   if (statusDelayed != 'pending' && statusDelayed != 'accepted') {
                                    //     widget.delayTripModel = SocketResponse();
                                    //     convertSecondTrack();
                                    //     // convertBoolean(isTrackDriverDelayTrip);
                                    //     // convertBoolean(widget.isSecondTrip);
                                    //     widget.delayTripModel.driverFirstName =
                                    //         data['data']['driver_first_name'];
                                    //     widget.delayTripModel.driverLastName =
                                    //         data['data']['driver_last_name'];
                                    //     widget.delayTripModel
                                    //             .driverProfileImage =
                                    //         data['data']
                                    //             ['driver_profile_image'];
                                    //     widget.delayTripModel.driverPhone =
                                    //         data['data']['driver_phone'];
                                    //
                                    //     widget.delayTripModel
                                    //             .vehicelDeviceNumber =
                                    //         data['data']
                                    //             ['vehicel_device_number'];
                                    //     widget.delayTripModel.vehicelCarModel =
                                    //         data['data']['vehicel_car_model'];
                                    //     widget.delayTripModel.vehicelColor =
                                    //         data['data']['vehicel_color'];
                                    //     widget.delayTripModel.vehicelImage =
                                    //         data['data']['vehicel_image'];
                                    //
                                    //     widget.delayTripModel.pickupLatitude =
                                    //         data['data']['pickup_latitude'];
                                    //     widget.delayTripModel.pickupLongitude =
                                    //         data['data']['pickup_longitude'];
                                    //     widget.delayTripModel.dropLatitude =
                                    //         data['data']['drop_latitude'];
                                    //     widget.delayTripModel.dropLongitude =
                                    //         data['data']['drop_longitude'];
                                    //     widget.delayTripModel.id =
                                    //         data['data']['id'];
                                    //     widget.delayTripModel.status =
                                    //         data['data']['status'];
                                    //   } else if (statusDelayed == 'ended') {
                                    //     print(
                                    //         'endeeeeeeeeeeeeeeeeeeeeeeeeed');
                                    //     convertSecondTrackFalse();
                                    //     // convertBoolean(isTrackDriverDelayTrip);
                                    //     // convertBoolean(widget.isSecondTrip);
                                    //   }
                                    // }


                                    return Row(
                                      children: [
                                        widget.momentTripModel.status ==
                                                'accepted'
                                            ? AcceptedWidget()
                                            : widget.momentTripModel.status ==
                                                    'arrived'
                                                ? ArrivedWidget()
                                                : widget.momentTripModel
                                                            .status ==
                                                        'started'
                                                    ? StartedWidget()
                                                    : Text('')
                                      ],
                                    );
                                  } else {
                                    return Row(
                                      children: [
                                        widget.momentTripModel.status ==
                                                'accepted'
                                            ? AcceptedWidget()
                                            : widget.momentTripModel.status ==
                                                    'arrived'
                                                ? ArrivedWidget()
                                                : widget.momentTripModel
                                                            .status ==
                                                        'started'
                                                    ? StartedWidget()
                                                    : PendingWidget()
                                      ],
                                    );
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
                cancelTrip(widget.momentTripModel.id.toString());
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
                  text: widget.momentTripModel.driverFirstName! +
                      ' ' +
                      widget.momentTripModel.driverLastName!,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              InkWell(
                child: Text(
                  '${widget.momentTripModel.driverPhone}',
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 5.sp,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  launchUrl(Uri.parse(
                      "tel://+963 ${widget.momentTripModel.driverPhone}"));
                },
              ),
              InkWell(
                  child: FadeInImage(
                    image: NetworkImage(
                        widget.momentTripModel.driverProfileImage.toString()),
                    height: 10.h,
                    width: 10.w,
                    fit: BoxFit.contain,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        erroWidget(100),
                    placeholder: placeHolder(100),
                  ),
                  onTap: () {
                    getDialog(
                        widget.momentTripModel.driverProfileImage.toString());
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              myText(
                  text: widget.momentTripModel.vehicelCarModel,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              myText(
                  text: widget.momentTripModel.vehicelColor,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              InkWell(
                child: FadeInImage(
                  image: NetworkImage(
                      widget.momentTripModel.vehicelImage.toString()),
                  height: 10.h,
                  width: 10.w,
                  fit: BoxFit.contain,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      erroWidget(20),
                  placeholder: placeHolder(20),
                ),
                onTap: () {
                  getDialog(widget.momentTripModel.vehicelImage.toString());
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
                        "${widget.momentTripModel.driverFirstName}"
                        "\t"
                        "${widget.momentTripModel.driverLastName}\n"
                        "${widget.momentTripModel.driverPhone}\n"
                        "${widget.momentTripModel.vehicelCarModel}\n"
                        "${widget.momentTripModel.vehicelColor}";
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
                  text: widget.momentTripModel.driverFirstName! +
                      ' ' +
                      widget.momentTripModel.driverLastName!,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              SizedBox(
                width: 1.w,
              ),
              InkWell(
                child: Text(
                  '${widget.momentTripModel.driverPhone}',
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 5.sp,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  launchUrl(Uri.parse(
                      "tel://+963 ${widget.momentTripModel.driverPhone}"));
                },
              ),
              InkWell(
                  child: FadeInImage(
                    image: NetworkImage(
                        widget.momentTripModel.driverProfileImage.toString()),
                    height: 10.h,
                    width: 10.w,
                    fit: BoxFit.contain,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        erroWidget(100),
                    placeholder: placeHolder(100),
                  ),
                  onTap: () {
                    getDialog(
                        widget.momentTripModel.driverProfileImage.toString());
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              myText(
                  text: widget.momentTripModel.vehicelCarModel,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              myText(
                  text: widget.momentTripModel.vehicelColor,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              InkWell(
                child: FadeInImage(
                  image: NetworkImage(
                      widget.momentTripModel.vehicelImage.toString()),
                  height: 10.h,
                  width: 10.w,
                  fit: BoxFit.contain,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      erroWidget(20),
                  placeholder: placeHolder(20),
                ),
                onTap: () {
                  getDialog(widget.momentTripModel.vehicelImage.toString());
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
                        "${widget.momentTripModel.driverFirstName}"
                        "\t"
                        "${widget.momentTripModel.driverLastName}\n"
                        "${widget.momentTripModel.driverPhone}\n"
                        "${widget.momentTripModel.vehicelCarModel}\n"
                        "${widget.momentTripModel.vehicelColor}";
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
                  text: widget.momentTripModel.driverFirstName! +
                      ' ' +
                      widget.momentTripModel.driverLastName!,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              InkWell(
                child: Text(
                  '${widget.momentTripModel.driverPhone}',
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 5.sp,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  launchUrl(Uri.parse(
                      "tel://+963 ${widget.momentTripModel.driverPhone}"));
                },
              ),
              InkWell(
                  child: FadeInImage(
                    image: NetworkImage(
                        widget.momentTripModel.driverProfileImage.toString()),
                    height: 10.h,
                    width: 10.w,
                    fit: BoxFit.contain,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        erroWidget(100),
                    placeholder: placeHolder(100),
                  ),
                  onTap: () {
                    getDialog(
                        widget.momentTripModel.driverProfileImage.toString());
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              myText(
                  // text: 'car color'.tr(),
                  text: widget.momentTripModel.vehicelCarModel,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              myText(
                  text: widget.momentTripModel.vehicelColor,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              InkWell(
                child: FadeInImage(
                  image: NetworkImage(
                      widget.momentTripModel.vehicelImage.toString()),
                  height: 10.h,
                  width: 10.w,
                  fit: BoxFit.contain,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      erroWidget(20),
                  placeholder: placeHolder(20),
                ),
                onTap: () {
                  getDialog(widget.momentTripModel.vehicelImage.toString());
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
                        "${widget.momentTripModel.driverFirstName}"
                        "\t"
                        "${widget.momentTripModel.driverLastName}\n"
                        "${widget.momentTripModel.driverPhone}\n"
                        "${widget.momentTripModel.vehicelCarModel}\n"
                        "${widget.momentTripModel.vehicelColor}";
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
