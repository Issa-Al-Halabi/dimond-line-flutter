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
import '../../../../../../Data/network/requests.dart';
import '../../../../../Functions/helper.dart';
import '../../../../../widgets/container_widget.dart';
import '../../../../../widgets/loader_widget.dart';
import '../../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';

import '../user_dashboard.dart';

class TripSocketFromMainScreen extends StatefulWidget {
  TripSocketFromMainScreen(
      {required this.tripId,
        required this.pickupLatitude,
        required this.pickupLongitude,
        required this.dropLatitude,
        required this.dropLongitude,

        required this.deviceNumb,
        required this.driverFname,
        required this.driverLname,
        required this.driverImage,
        required this.driverPhone,
        required this.carModel,
        required this.carColor,
        required this.finalCost,
        required this.vehicelImage,
        required this.status,

        Key? key})
      : super(key: key);

  String tripId;
  String pickupLatitude, pickupLongitude, dropLatitude, dropLongitude;

  int deviceNumb;
  String driverFname,
      driverLname,
      driverImage,
      driverPhone,
      carModel,
      carColor,
      finalCost,
      vehicelImage,
  status;

  @override
  State<TripSocketFromMainScreen> createState() => _TripSocketFromMainScreenState();
}

class _TripSocketFromMainScreenState extends State<TripSocketFromMainScreen> {
  CameraPosition? _kGooglePlex;
  double latRoute = 0.0;
  double lngRoute = 0.0;
  // double latToRoute = 0.0;
  // double lngToRoute = 0.0;
  double course = 0.0;
  GoogleMapController? gmc;

  // Set<Marker> myMarker = {};
  bool _isNetworkAvail = true;
  String CUR_USERID = '';
  DateTime timeback = DateTime.now();
  String id = '';
  List<LatLng> polylineCoordinates = [];
  Marker marker = Marker(markerId: MarkerId("home"));
  Marker marker2 = Marker(markerId: MarkerId("from"));
  Marker marker3 = Marker(markerId: MarkerId("to"));
  Circle circle = Circle(
    circleId: CircleId("car"),
  );

  bool isAcceptTrip = false;
  bool isStartTrip = false;

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
    print(widget.pickupLatitude);
    print(widget.pickupLongitude);
    print(widget.dropLatitude);
    print(widget.dropLongitude);
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
    eventStreamController.close();
    _channel.sink.close();
    pusher.disconnect();
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

  void updateMainPolyline(double pickupLatitude, double pickupLongitude,
      double dropLatitude, double dropLongitude) async {
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
    setState(() {});

    polylineCoordinates.clear();
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      APIKEY,
      PointLatLng(pickupLatitude, pickupLongitude),
      PointLatLng(dropLatitude, dropLongitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    if (mounted) {
      setState(() {});
    }

    // delete from marker
    marker2 = Marker(markerId: MarkerId("from"));
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
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      Loader.show(context, progressIndicator: LoaderWidget());
      var data = await AppRequests.cancelTripRequest(trip_id);
      data = json.decode(data);
      if (data["error"] == false) {
        Loader.hide();
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
  }

  // ******************************************* //
  void connectSocket() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString("apiKey", _apiKey.text);
    // prefs.setString("cluster", _cluster.text);
    // prefs.setString("channelName", _channelName.text);
    try {
      await pusher.init(
        apiKey: 'fa7ffa0cd3688f71ab11',
        cluster: 'mt1',
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        onSubscriptionCount: onSubscriptionCount,
        // authEndpoint: "<Your Authendpoint Url>",
        // onAuthorizer: onAuthorizer
      );
      // await pusher.subscribe(channelName: 'trip-status-$CUR_USERID');
      await pusher.subscribe(channelName: 'trip-status-246');
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
    print('on event');
    Map<String, dynamic> data = jsonDecode(event.data);
    eventStreamController.sink.add(data);
  }

  // void onEvent(PusherEvent event) {
  //   setState(() {
  //     print('on event');
  //     Map<String, dynamic> data = jsonDecode(event.data);
  //     status = data['data']['status'];
  //     print('------------------status');
  //     print(status);
  //
  //     id = data['data']['id'];
  //     print('------------------id');
  //     print(id);
  //
  //     // if(status == 'accepted'){
  //     //   promoSheet();
  //     // }
  //     // log("onEvent: $event");
  //   });
  //
  //   setState(() {
  //
  //   });
  // }

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
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => TripEndedUserScreen(
    //             finalCost: finalCost,
    //             tripId: widget.tripId,
    //           )),
    // );
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TripEndedUserScreen(
              finalCost: widget.finalCost,
              tripId: widget.tripId,
            )),
      );
    });
    return true;
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
                          print(snapshot.data);
                          print(snapshot.connectionState);
                          if (snapshot.hasData == true) {
                            var data =
                            json.decode(snapshot.data.toString());
                            print('--------------------------------');
                            if (data['positions'] != null) {
                              if (data['positions'][0]['deviceId'] ==
                                  widget.deviceNumb) {
                                print('course me');
                                print(data['positions'][0]['course']);
                                latRoute =
                                data['positions'][0]['latitude'];
                                lngRoute =
                                data['positions'][0]['longitude'];
                                course =
                                data['positions'][0]['course'];
                                isStartTrip == true
                                    ? updateMainPolyline(
                                    latRoute,
                                    lngRoute,
                                    // latToRoute,
                                    // lngToRoute
                                    double.parse(widget.dropLatitude),
                                    double.parse(widget.dropLongitude)
                                )
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
                          bottom: 0.h,
                          child: StreamBuilder<Map<String, dynamic>>(
                            stream: eventStreamController.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                Map<String, dynamic> data = snapshot.data!;
                                print(data);
                                widget.status = data['data']['status'];
                                print(widget.status);
                                int id = data['data']['id'];
                                print(id);
                                if(id.toString() == int.parse(widget.tripId)){
                                  //   setState(() {

                                  if (widget.status == 'accepted') {
                                    isAcceptTrip = true;
                                    // TODO
                                    widget.deviceNumb =
                                    data['data']['vehicel_device_number'];
                                    widget.driverFname =
                                    data['data']['driver_first_name'];
                                    widget.driverLname =
                                    data['data']['driver_last_name'];
                                    widget.driverImage =
                                    data['data']['driver_profile_image'];
                                    widget.driverPhone =
                                    data['data']['driver_phone'];
                                    widget.carModel =
                                    data['data']['vehicel_car_model'];
                                    widget.carColor = data['data']['vehicel_color'];
                                    widget.vehicelImage =
                                    data['data']['vehicel_image'];

                                    // pickup_latitude =
                                    // data['data']['pickup_latitude'];
                                    // pickup_longitude =
                                    // data['data']['pickup_longitude'];
                                    // drop_latitude =
                                    // data['data']['drop_latitude'];
                                    // drop_longitude =
                                    // data['data']['drop_longitude'];

                                    // latToRoute = double.parse(
                                    //     data['data']['drop_latitude']);
                                    // lngToRoute = double.parse(
                                    //     data['data']['drop_longitude']);
                                    print('[[[[[[[[[[[[[[[[[[[[[');
                                    print(widget.status);
                                    print(widget.deviceNumb);
                                    print(widget.driverFname);
                                    print(widget.driverLname);
                                    print(widget.driverPhone);
                                    print(widget.driverImage);
                                    print(widget.carModel);
                                    print(widget.carColor);
                                    print(widget.vehicelImage);
                                    // print(latToRoute);
                                    // print(lngToRoute);
                                  }
                                  if (widget.status == 'started') {
                                    isStartTrip = true;
                                  }
                                  if (widget.status == 'ended') {
                                    widget.finalCost = data['data']['cost'];
                                    print(widget.finalCost);
                                    navigate();
                                  }
                                  if(widget.status == 'canceld'){
                                    setSnackbar('the trip has cancel', context);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UserDashboard()),
                                    );

                                  }
                                  // });
                                  return Row(
                                    children: [
                                      widget.status == 'accepted'
                                          ? AcceptedWidget()
                                          : widget.status == 'arrived'
                                          ? ArrivedWidget()
                                          : widget.status == 'started'
                                          ? StartedWidget()
                                      // : status == 'ended'
                                      //     ? navigate()
                                      // : Text('the trip has cancel')
                                      // : TextButton(
                                      //     onPressed: () {
                                      //       print(status);
                                      //     },
                                      //     child: Text(
                                      //         'the trip has cancel'))

                                          : Text('')
                                    ],
                                  );
                                }
                                else{
                                  setSnackbar('this trip $id is ${widget.status}', context);
                                  return Text('');
                                  // return CircularProgressIndicator();
                                }
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
          // myText(
          //     text: 'looking car'.tr(),
          //     fontSize: 6.sp,
          //     color: primaryBlue,
          //     fontWeight: FontWeight.w600),
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
              // color: primaryBlue,
              // color: Colors.black
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
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     myText(
          //         text: 'looking car'.tr(),
          //         fontSize: 6.sp,
          //         color: primaryBlue,
          //         fontWeight: FontWeight.w600),
          //     Container(
          //       height: 6.h,
          //       width: 30.w,
          //       decoration: BoxDecoration(
          //         boxShadow: [
          //           BoxShadow(
          //             color: Colors.grey.withOpacity(0.3),
          //             spreadRadius: 2,
          //             blurRadius: 7,
          //             offset: const Offset(0, 0),
          //           ),
          //         ],
          //         borderRadius: const BorderRadius.all(Radius.circular(20)),
          //         // color: primaryBlue,
          //         // color: Colors.black
          //         color: Colors.red,
          //       ),
          //       child: TextButton(
          //         child: myText(
          //             text: 'cancel'.tr(),
          //             fontSize: 4.sp,
          //             color: Colors.black,
          //             fontWeight: FontWeight.w600),
          //         onPressed: () {
          //           cancelTrip(widget.tripId);
          //         },
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  AcceptedWidget() {
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
                  text: widget.driverFname + ' ' + widget.driverLname,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              InkWell(
                child: Text(
                  '${widget.driverPhone}',
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 5.sp,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  launchUrl(Uri.parse("tel://+963 ${widget.driverPhone}"));
                },
              ),
              InkWell(
                  child: FadeInImage(
                    image: NetworkImage(widget.driverImage.toString()),
                    height: 10.h,
                    width: 10.w,
                    fit: BoxFit.contain,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        erroWidget(100),
                    placeholder: placeHolder(100),
                  ),
                  onTap: () {
                    getDialog(widget.driverImage.toString());
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              myText(
                // text: 'car color'.tr(),
                  text: widget.carModel,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              myText(
                  text: widget.carColor,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              InkWell(
                child: FadeInImage(
                  image: NetworkImage(widget.vehicelImage.toString()),
                  height: 10.h,
                  width: 10.w,
                  fit: BoxFit.contain,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      erroWidget(20),
                  placeholder: placeHolder(20),
                ),
                onTap: () {
                  getDialog(widget.vehicelImage.toString());
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
                        "${widget.driverFname}"
                        "\t"
                        "${widget.driverLname}\n"
                        "${widget.driverPhone}\n"
                        "${widget.carModel}\n"
                        "${widget.carColor}";
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
          myText(
              text: 'driver arrive'.tr(),
              fontSize: 6.sp,
              color: primaryBlue,
              fontWeight: FontWeight.w600),
          myText(
              text: 'dont let him wait'.tr(),
              fontSize: 6.sp,
              color: primaryBlue,
              fontWeight: FontWeight.w600),
          Text('dont let him wait'),
          SizedBox(
            height: 2.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              lt.Lottie.asset(
                arrive,
                // height: 30.h,
                width: 30.w,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      myText(
                          text: widget.driverFname + ' ' + widget.driverLname,
                          fontSize: 5.sp,
                          color: primaryBlue,
                          fontWeight: FontWeight.w600),
                      InkWell(
                        child: Text(
                          '${widget.driverPhone}',
                          style: TextStyle(
                            color: primaryBlue,
                            fontSize: 5.sp,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onTap: () {
                          launchUrl(Uri.parse("tel://+963 ${widget.driverPhone}"));
                        },
                      ),
                      InkWell(
                          child: FadeInImage(
                            image: NetworkImage(widget.driverImage.toString()),
                            height: 10.h,
                            width: 10.w,
                            fit: BoxFit.contain,
                            imageErrorBuilder: (context, error, stackTrace) =>
                                erroWidget(100),
                            placeholder: placeHolder(100),
                          ),
                          onTap: () {
                            getDialog(widget.driverImage.toString());
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      myText(
                        // text: 'car color'.tr(),
                          text: widget.carModel,
                          fontSize: 5.sp,
                          color: primaryBlue,
                          fontWeight: FontWeight.w600),
                      myText(
                          text: widget.carColor,
                          fontSize: 5.sp,
                          color: primaryBlue,
                          fontWeight: FontWeight.w600),
                      InkWell(
                        child: FadeInImage(
                          image: NetworkImage(widget.vehicelImage.toString()),
                          height: 10.h,
                          width: 10.w,
                          fit: BoxFit.contain,
                          imageErrorBuilder: (context, error, stackTrace) =>
                              erroWidget(20),
                          placeholder: placeHolder(20),
                        ),
                        onTap: () {
                          getDialog(widget.vehicelImage.toString());
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
                                "${widget.driverFname}"
                                "\t"
                                "${widget.driverLname}\n"
                                "${widget.driverPhone}\n"
                                "${widget.carModel}\n"
                                "${widget.carColor}";
                        Share.share(str);
                        print(str);
                      }),
                  SizedBox(
                    height: 1.h,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  StartedWidget() {
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
                  text: widget.driverFname + ' ' + widget.driverLname,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              InkWell(
                child: Text(
                  '${widget.driverPhone}',
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 5.sp,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  launchUrl(Uri.parse("tel://+963 ${widget.driverPhone}"));
                },
              ),
              InkWell(
                  child: FadeInImage(
                    image: NetworkImage(widget.driverImage.toString()),
                    height: 10.h,
                    width: 10.w,
                    fit: BoxFit.contain,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        erroWidget(100),
                    placeholder: placeHolder(100),
                  ),
                  onTap: () {
                    getDialog(widget.driverImage.toString());
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              myText(
                // text: 'car color'.tr(),
                  text: widget.carModel,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              myText(
                  text: widget.carColor,
                  fontSize: 5.sp,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600),
              InkWell(
                child: FadeInImage(
                  image: NetworkImage(widget.vehicelImage.toString()),
                  height: 10.h,
                  width: 10.w,
                  fit: BoxFit.contain,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      erroWidget(20),
                  placeholder: placeHolder(20),
                ),
                onTap: () {
                  getDialog(widget.vehicelImage.toString());
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
                        "${widget.driverFname}"
                        "\t"
                        "${widget.driverLname}\n"
                        "${widget.driverPhone}\n"
                        "${widget.carModel}\n"
                        "${widget.carColor}";
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