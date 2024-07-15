import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:connectivity/connectivity.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/in_trip_provider.dart';
import 'package:diamond_line/Data/network/network_client.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/inside_city_trips/trip_wait_for_payment.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lt;
import 'package:provider/provider.dart';
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

  IOWebSocketChannel? _channel;

  List<GeoPoint> latLngList = [];
  ValueNotifier<GeoPoint?> lastGeoPoint = ValueNotifier(null);
  MapController? controller;
  bool isLoading = false;

  Timer? timer;

  StreamController<Map<String, dynamic>> eventStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  @override
  void initState() {
    Provider.of<InTripProvider>(context, listen: false).tripStatus = "";
    getUserId();
    // getCookie();
    // connectSocket();
    // markerOfMainWay();
    getLatAndLong();
    // getPolyPoints();
    super.initState();
  }

  @override
  void dispose() {
    Loader.hide();
    if (timer != null) {
      print("timer != null");
      timer!.cancel();
      timer = null;
    }

    if (controller != null) {
      controller!.dispose();
      controller = null;
    }
    super.dispose();
  }

  Future<void> getLatAndLong() async {
    print("widget.pickupLatitude widget.pickupLatitude");
    print(widget.pickupLatitude);
    print(widget.pickupLongitude);
    print("widget.pickupLatitude widget.pickupLatitude");
    controller = await MapController(
      initPosition: GeoPoint(
        latitude: double.parse(widget.pickupLatitude),
        longitude: double.parse(widget.pickupLongitude),
      ),
    );
    print(controller!.initPosition);
    isLoading = true;
    if (controller != null) {
      // tripPolyline(double.parse(widget.pickupLatitude),
      //     double.parse(widget.pickupLongitude));
    }
    setState(() {});
  }

  Future<void> getCookie() async {
    try {
      Map<String, String> co = {};
      Response response =
          await get(Uri.parse(network_client.mycarSscSecurity_URL));
      co.addAll({"Cookie": response.headers['set-cookie'].toString()});
      print(co);
      _channel = IOWebSocketChannel.connect(
          Uri.parse(network_client.mycarSscSecurity_SOCKET),
          headers: co);
    } catch (e) {
      setSnackbar(e.toString(), context);
    }
  }

  void tripPolyline(
    double pickupLatitude,
    double pickupLongitude,
  ) async {
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    print({
      "latitude": pickupLatitude,
      "longitude": pickupLongitude,
    });
    if (controller == null || !mounted) {
      return;
    }
    // Create the new GeoPoint
    final newGeoPoint = GeoPoint(
      latitude: pickupLatitude,
      longitude: pickupLongitude,
    );

    // Check if lastGeoPoint is not null and is different from the newGeoPoint
    if (lastGeoPoint.value != null) {
      print("Removing existing marker at ${lastGeoPoint.value}");

      // Attempt to remove the existing marker
      await controller!.removeMarker(lastGeoPoint.value!);
      await controller!.removeMarkers([
        lastGeoPoint.value!,
        newGeoPoint,
      ]);

      print("Markers removed, adding new marker at $newGeoPoint");
    }
    // Add the new marker
    await controller!.addMarker(
      newGeoPoint,
      markerIcon: MarkerIcon(
        assetMarker: AssetMarker(
          scaleAssetImage: 2,
          image: AssetImage(
            "assets/images/caricon.png",
          ),
        ),
      ),
    );

    // Update lastGeoPoint with the new coordinates
    lastGeoPoint.value = newGeoPoint;

    print("Marker added and lastGeoPoint updated to $newGeoPoint");

    await controller!.drawCircle(
      CircleOSM(
        key: "car",
        centerPoint: newGeoPoint,
        radius: 50,
        color: Colors.blue,
        strokeWidth: 0.3,
      ),
    );
  }

  /// Draw main Road
  void roadActionBt() async {
    final pickupGeoPoint = GeoPoint(
        latitude: double.parse(widget.pickupLatitude),
        longitude: double.parse(widget.pickupLongitude));

    RoadInfo roadInfo = await controller!.drawRoad(
      pickupGeoPoint,
      GeoPoint(
        latitude: double.parse(widget.dropLatitude),
        longitude: double.parse(widget.dropLongitude),
      ),
      roadType: RoadType.car,
      roadOption: RoadOption(
        roadWidth: 10,
        roadColor: Colors.blue,
        zoomInto: true,
      ),
    );

    // init marker
    await controller!.addMarker(
      pickupGeoPoint,
      markerIcon: MarkerIcon(
        assetMarker: AssetMarker(
          scaleAssetImage: 2,
          image: AssetImage(
            "assets/images/caricon.png",
          ),
        ),
      ),
    );
    // Update lastGeoPoint with the new coordinates
    lastGeoPoint.value = pickupGeoPoint;

    print("${roadInfo.distance}km");
    print("${roadInfo.duration}sec");
    print("${roadInfo.instructions}");
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
        try {
          setSnackbar(data["message"].toString(), context);
        } catch (e) {
          print(e);
        }
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

  bool navigate() {
    eventStreamController.close();
    if (_channel != null) {
      _channel!.sink.close();
    }
    // pusher.disconnect();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TripWaitForPaymentUserScreen(
                  finalCost: finalCost,
                  tripId: widget.tripId,
                )),
      );
    });
    return true;
  }

  bool convertAccept() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isAcceptTrip) {
        setState(() {
          isAcceptTrip = true;
        });
      }
    });
    return true;
  }

  bool convertStart() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isStartTrip) {
        setState(() {
          isStartTrip = true;
        });
      }
    });
    return true;
  }

  bool convertSecondTrack() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isTrackDriverDelayTrip = true;
        isSecondTrip = true;
        ;
      });
    });
    return true;
  }

  bool convertSecondTrackFalse() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isTrackDriverDelayTrip = false;
        isSecondTrip = false;
        print(isTrackDriverDelayTrip);
        print(isSecondTrip);
      });
    });
    return true;
  }

  bool convertId(int newId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    if (_channel != null) {
      _channel!.sink.close();
    }
    // pusher.disconnect();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserDashboard()),
    );
  }

  bool navigateDash() {
    eventStreamController.close();
    if (_channel != null) {
      _channel!.sink.close();
    }
    // pusher.disconnect();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    if (_channel != null) {
      _channel!.sink.close();
    }
    // pusher.disconnect();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsideTripDelayedScreen(
          delayTripModel: delayTripModel,
          isAcceptTrip: isTrackDriverDelayTrip,
        ),
      ),
    );
  }

  ////////////////// to update the driver location //////////////////////////
  void startPeriodicRequest(driver_id) {
    timer = Timer.periodic(Duration(seconds: 10), (Timer tick) {
      if (timer != null) {
        updateDriverLocation(driver_id);
      }
    });
  }

  Future<void> updateDriverLocation(driver_id) async {
    try {
      final response = await AppRequests.updateDriverLocation(
          driver_id: driver_id.toString());

      if (response != null) {
        print('Response data: ${response}');
        tripPolyline(double.parse(response["latitude"].toString()),
            double.parse(response["longitude"].toString()));
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Request failed with catch: ${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('333333333333333333333');
    print(isLoading);
    print('333333333333333333333');
    print(controller);
    print(isLoading == false || controller == null);
    print('333333333333333333333');
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
        body: isLoading == false || controller == null
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
                          isAcceptTrip == true && _channel != null
                              ? StreamBuilder(
                                  stream: _channel!.stream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData == true) {
                                      var data =
                                          json.decode(snapshot.data.toString());
                                      // print('--------------------------------');
                                      // print(data);
                                      if (data['positions'] != null) {
                                        //TODO
                                        if (data['positions'][0]['deviceId'] ==
                                            deviceNumb) {
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
                                          // isStartTrip == true
                                          //     ? tripPolyline(
                                          //         latRoute,
                                          //         lngRoute,
                                          //       )
                                          //     : null;
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
                            child: OSMFlutter(
                              onMapIsReady: (p0) {
                                roadActionBt();
                                // tripPolyline(
                                //     double.parse(widget.pickupLatitude),
                                //     double.parse(widget.pickupLongitude));
                              },
                              controller: controller!,
                              osmOption: OSMOption(
                                zoomOption: ZoomOption(
                                  initZoom: 14,
                                ),
                                staticPoints: [
                                  StaticPositionGeoPoint(
                                    "from",
                                    MarkerIcon(
                                      icon: Icon(
                                        Icons.location_on_rounded,
                                        color: Colors.green,
                                        size: 32,
                                      ),
                                    ),
                                    [
                                      GeoPoint(
                                        latitude: double.parse(
                                          widget.pickupLatitude,
                                        ),
                                        longitude: double.parse(
                                          widget.pickupLongitude,
                                        ),
                                      ),
                                    ],
                                  ),
                                  StaticPositionGeoPoint(
                                    "to",
                                    MarkerIcon(
                                      icon: Icon(
                                        Icons.location_on_rounded,
                                        color: Colors.green,
                                        size: 32,
                                      ),
                                    ),
                                    [
                                      GeoPoint(
                                        latitude: double.parse(
                                          widget.dropLatitude,
                                        ),
                                        longitude: double.parse(
                                          widget.dropLongitude,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0.h,
                            child: Consumer<InTripProvider>(
                                builder: (context, provider, child) {
                              if (provider.tripStatus != "") {
                                Map<String, dynamic> data = provider.tripData;
                                int id = int.parse(data['id']);

                                print(
                                    "==========================================");
                                print(data);
                                print(data['status']);
                                print(widget.tripId);
                                print(id);
                                print(id.toString() == widget.tripId);
                                print(
                                    "==========================================");
                                if (id.toString() == widget.tripId) {
                                  status = data['status'];
                                  // print('ids equal');
                                  if (status == 'accepted') {
                                    convertAccept();
                                    // convertBoolean(isAcceptTrip);
                                    deviceNumb = int.parse(
                                        data['vehicel_device_number']);
                                    driverFname = data['driver_first_name'];
                                    driverLname = data['driver_last_name'];
                                    driverImage = data['driver_profile_image'];
                                    driverPhone = data['driver_phone'];
                                    carModel = data['vehicel_car_model'];
                                    carColor = data['vehicel_color'];
                                    vehicelImage = data['vehicel_image'];
                                  }
                                  if (status == 'started') {
                                    // to update the driver location
                                    if (data['driver_id'] != null &&
                                        timer == null) {
                                      startPeriodicRequest(
                                          int.parse(data['driver_id']));
                                    }

                                    convertStart();
                                    // convertBoolean(isStartTrip);
                                  }
                                  if (status == 'wait for payment') {
                                    finalCost = data['cost'];
                                    // print(finalCost);
                                    provider.reset();
                                    navigate();
                                  }
                                  if (status == 'ended') {
                                    finalCost = data['cost'];
                                    // print(finalCost);
                                    provider.reset();
                                    navigate();
                                  }
                                  if (status == 'canceld') {
                                    // print('your trip didnt accept');
                                    provider.reset();
                                    navigateDash();
                                  }
                                } else {
                                  print('ttttttttttttt');
                                  print(data);
                                  String statusDelayed = data['status'];
                                  print(statusDelayed);
                                  print(data['id']);
                                }
                                print("status:" + status);
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
                            }),
                          )
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
