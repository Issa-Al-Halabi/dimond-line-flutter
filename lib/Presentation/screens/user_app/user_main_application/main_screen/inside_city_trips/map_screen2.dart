import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import '../../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../../Buisness_logic/provider/User_Provider/nearest_cars_map_provider.dart';
import '../../../../../Functions/helper.dart';
import '../../../../../widgets/loader_widget.dart';
import 'order_now.dart';
import 'package:http/http.dart';

class MapScreen2 extends StatefulWidget {
  MapScreen2({Key? key}) : super(key: key);

  @override
  State<MapScreen2> createState() => _MapScreen2State();
}

class _MapScreen2State extends State<MapScreen2> {
  CameraPosition? _kGooglePlex;
  GoogleMapController? gmc;
  late Position cl;
  late double lat;
  late double long;
  TextEditingController controllerFrom = TextEditingController();
  TextEditingController controllerTo = TextEditingController();
  List<LatLng> polylineCoordinates = [];
  String timeOfTrip = '';
  var distance;
  String address = '';
  Set<Marker> myMarker = {};
  bool _isNetworkAvail = true;
  int length = 0;
  List carsLatList = [];
  List carsLngList = [];


  @override
  void initState() {
    getPer();
    getLatAndLong();
    initMarker();
    super.initState();
  }

  @override
  void dispose() {
    controllerFrom.dispose();
    controllerTo.dispose();
    super.dispose();
  }

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
    print('*******************');
    print(lat);
    print(long);
    _kGooglePlex = CameraPosition(
      target: LatLng(lat, long),
      zoom: 10,
    );
    initMainMarker();
    var creat = await Provider.of<NearestCarsMapProvider>(context, listen: false);
    getNearestCarsApi(creat);
    if (mounted) {
      setState(() {});
    }
  }

  convertToAddress(double lat, double long) async {
    print(address);
    String apiurl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$APIKEY";
    Response response =
        await get(Uri.parse(apiurl)); //send get request to API URL
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["status"] == "OK") {
        if (data["results"].length > 0) {
          address = data["results"][0]["address_components"][2]["long_name"] +
              "," +
              data["results"][0]["address_components"][1]
                  ["long_name"]; // f there is atleast one address
          print("address" + address);
          if(mounted) setState(() {
            print(address);
          });
        }
      } else {
        print(data["error_message"]);
      }
    } else {
      print("error while fetching geoconding data");
    }
  }

  /////////////////////////// get nearest drivers cars (lats & lngs) api ///////////////////////////
  Future<void> getNearestCarsApi(NearestCarsMapProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.getNearestCarMap(lat.toString(), long.toString());
      if (creat.data.error == false) {
        length = creat.data.data!.length;
        print('------------------');
        print(length);
          for (int i = 0; i < creat.data.data!.length; i++) {
            setState(() {
              carsLatList.add(creat.data.data![i].latitude);
              carsLngList.add(creat.data.data![i].longitude);
            });
          }
        initMarker();
        Loader.hide();
        setState(() {});
      } else {
        Loader.hide();
        // setSnackbar(creat.data.message.toString(), context);
      }
    } else {
      setSnackbar("nointernet".tr(), context);
    }
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

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load(carIcon);
    return byteData.buffer.asUint8List();
  }

  void initMarker() async {
   for (int i = 0; i < length; i++) {
      Uint8List imageData = await getMarker();
      myMarker.add(Marker(
        markerId: MarkerId('$i'),
        position: LatLng(
          double.parse(carsLatList[i]),
          double.parse(carsLngList[i]),
        ),
    // rotation: double.parse(i),
    rotation: i.toDouble(),
        // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          icon: BitmapDescriptor.fromBytes(imageData)
      ));
      setState(() {
      });
    }
  }

  void initMainMarker(){
    myMarker.add(Marker(
      markerId: MarkerId('source'),
      infoWindow: InfoWindow(
          title: 'you are here'.tr(),
          onTap: () {
            print('marker info tab');
          }),
      position: LatLng(lat, long),
      onTap: () {
        print('marker tab');
      },
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue),
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
                              // markers: {
                              //   Marker(
                              //     markerId: MarkerId('1'),
                              //     infoWindow: InfoWindow(
                              //         title: 'you are here'.tr(),
                              //         onTap: () {
                              //           print('marker info tab');
                              //         }),
                              //     position: LatLng(lat, long),
                              //     onTap: () {
                              //       print('marker tab');
                              //     },
                              //     icon: BitmapDescriptor.defaultMarkerWithHue(
                              //         BitmapDescriptor.hueBlue),
                              //   )
                              // },
                              markers: myMarker,
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
                              left: 12.w,
                              right: 12.w,
                              child: Row(
                                children: [
                                  InkWell(
                                      child: Container(
                                          width: 35.w,
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
                                              child: myText(
                                            text: 'request now'.tr(),
                                            fontSize: 4.sp,
                                            color: white,
                                          ))),
                                      onTap: () async {
                                        Loader.show(context,
                                            progressIndicator:
                                                LoaderWidget());
                                        convertToAddress(lat, long);
                                        print('address is:');
                                        print(address);
                                        Loader.hide();
                                        Future.delayed(const Duration(seconds: 1))
                                            .then((_) async {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => OrderNow(
                                                  fromLat: lat,
                                                  fromLon: long,
                                                  sourceAddress: address,
                                                  toLat: 0.0,
                                                  toLon: 0.0,
                                                  destAddress: '',
                                                ),
                                              ));
                                        });
                                      }),
                                  SizedBox(
                                    width: 1.w,
                                  ),
                                  InkWell(
                                      child: Container(
                                          width: 35.w,
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
                                              child: myText(
                                            text: 'request later'.tr(),
                                            fontSize: 4.sp,
                                            color: white,
                                          ))),
                                      onTap: () async {
                                        Loader.show(context,
                                            progressIndicator:
                                                LoaderWidget());
                                        convertToAddress(lat, long);
                                        print('address is:');
                                        print(address);
                                        Loader.hide();
                                        Future.delayed(const Duration(seconds: 1))
                                            .then((_) async {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => OrderNow(
                                                    fromLat: lat,
                                                    fromLon: long,
                                                    sourceAddress: address,
                                                    toLat: 0.0,
                                                    toLon: 0.0,
                                                    destAddress: '',
                                                    laterOrder: true),
                                              ));
                                        });
                                      }),
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