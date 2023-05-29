import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/source_destination_delayed_provider.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/source_destination_provider.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:diamond_line/Presentation/widgets/container_widget2.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'map_screen_destination.dart';
import 'map_screen_polyline.dart';
import 'map_screen_source.dart';
import 'package:http/http.dart' as http;

class OrderNow extends StatefulWidget {
  OrderNow(
      {required this.fromLat,
      required this.fromLon,
      required this.sourceAddress,
      required this.toLat,
      required this.toLon,
      required this.destAddress,
      this.getDestAdd,
      this.laterOrder,
      Key? key})
      : super(key: key);

  double fromLat;
  double fromLon;
  double toLat;
  double toLon;
  String sourceAddress;
  String destAddress;
  bool? getDestAdd = false;
  bool? laterOrder = false;

  @override
  State<OrderNow> createState() => _OrderNowState();
}

class _OrderNowState extends State<OrderNow> {
  bool _isNetworkAvail = true;
  TextEditingController controllerFrom = TextEditingController();
  TextEditingController controllerTo = TextEditingController();
  var distance;
  String timeOfTrip = '';
  int length = 0;
  bool showTime = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  bool showDate = false;
  DateTime selectedDate = DateTime.now();
  List idList = [];
  List vehicletypeList = [];
  List baseKmList = [];
  List baseTimeList = [];
  List priceList = [];
  List vechileImage = [];

  @override
  void initState() {
    convertToAddress(widget.fromLat, widget.fromLon);
    if (widget.getDestAdd == true) {
      convertToAddressDest(widget.toLat, widget.toLon);
    }
    super.initState();
  }

  convertToAddress(double lat, double long) async {
    print(widget.sourceAddress.toString());
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
          widget.sourceAddress = data["results"][0]["address_components"][2]
                  ["long_name"] +
              "," +
              data["results"][0]["address_components"][1]
                  ["long_name"]; // f there is atleast one address
          print("address" + widget.sourceAddress);
          //you can use the JSON data to get address in your own format
          setState(() {
            //refresh UI
            controllerFrom = TextEditingController(text: widget.sourceAddress);
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

  convertToAddressDest(double lat, double long) async {
    print(widget.destAddress.toString());
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
          widget.destAddress = data["results"][0]["address_components"][2]
                  ["long_name"] +
              "," +
              data["results"][0]["address_components"][1]
                  ["long_name"]; // f there is atleast one address
          print("address" + widget.destAddress);
          //you can use the JSON data to get address in your own format
          setState(() {
            //refresh
            controllerTo = TextEditingController(text: widget.destAddress);
            print(widget.destAddress);
          });
        }
      } else {
        print(data["error_message"]);
      }
    } else {
      print("error while fetching geoconding data");
    }
  }

  String getTime(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  //  Select for Time
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
      });
    }
    return selectedTime;
  }

  String getDate() {
    if (selectedDate == null) {
      return 'select date'.tr();
    } else {
      return DateFormat('yyyy-MM-dd').format(selectedDate);
    }
  }

  // Select for Date
  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      // firstDate: DateTime(2000),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
    return selectedDate;
  }

  /////////////////////////sourceDistApi api //////////////////////////////////
  Future<void> sourceDistApi(
      String pickup_latitude,
      String pickup_longitude,
      String drop_latitude,
      String drop_longitude,
      String km,
      String minutes,
      SourceDestinationProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      print(pickup_latitude);
      print(pickup_longitude);
      print(drop_latitude);
      print(drop_longitude);
      print(km);
      print(minutes);
      idList = [];
      vehicletypeList = [];
      baseKmList = [];
      baseTimeList = [];
      priceList = [];
      vechileImage = [];
      Loader.show(context, progressIndicator: CircularProgressIndicator());
      await creat.getSourceDistenation(pickup_latitude, pickup_longitude,
          drop_latitude, drop_longitude, km, minutes);
      if (creat.data.error == false) {
        length = creat.data.data!.length;
        for (int i = 0; i < creat.data.data!.length; i++) {
          setState(() {
            idList.add(creat.data.data![i].id);
            vehicletypeList.add(creat.data.data![i].vehicletype);
            baseKmList.add(creat.data.data![i].baseKm);
            baseTimeList.add(creat.data.data![i].baseTime);
            priceList.add(creat.data.data![i].price);
            vechileImage.add(creat.data.data![i].icon);
          });
        }
        Loader.hide();
        setState(() {
          Future.delayed(const Duration(seconds: 0)).then((_) async {
            if (widget.toLat == 0.0 || widget.fromLat == 0.0) {
              setSnackbar("select fields".tr(), context);
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreenPolyline(
                        fromLat: widget.fromLat,
                        toLat: widget.toLat,
                        fromLng: widget.fromLon,
                        toLng: widget.toLon,
                        sourceAdd: controllerFrom.text,
                        destAdd: controllerTo.text,
                        idList: idList,
                        vehicletypeList: vehicletypeList,
                        baseKmList: baseKmList,
                        baseTimeList: baseTimeList,
                        priceList: priceList,
                        length: length,
                        km: distance.toString(),
                        minutes: timeOfTrip,
                        vechileImageList: vechileImage),
                  ));
            }
          });
        });
      } else {
        Loader.hide();
        setSnackbar(creat.data.message.toString(), context);
      }
    } else {
      setSnackbar("nointernet".tr(), context);
    }
  }

  /////////////////////////sourceDistApi api //////////////////////////////////
  Future<void> sourceDistDelayApi(
      String pickup_latitude,
      String pickup_longitude,
      String drop_latitude,
      String drop_longitude,
      String km,
      String minutes,
      String date,
      String time,
      SourceDestinationDelayedProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      idList = [];
      vehicletypeList = [];
      baseKmList = [];
      baseTimeList = [];
      priceList = [];
      vechileImage = [];
      Loader.show(context, progressIndicator: CircularProgressIndicator());
      await creat.getSourceDistenationDelayed(pickup_latitude, pickup_longitude,
          drop_latitude, drop_longitude, km, minutes, date, time);
      if (creat.data.error == false) {
        length = creat.data.data!.length;
        for (int i = 0; i < creat.data.data!.length; i++) {
          setState(() {
            idList.add(creat.data.data![i].id);
            vehicletypeList.add(creat.data.data![i].vehicletype);
            baseKmList.add(creat.data.data![i].baseKm);
            baseTimeList.add(creat.data.data![i].baseTime);
            priceList.add(creat.data.data![i].price);
            vechileImage.add(creat.data.data![i].icon);
          });
        }
        Loader.hide();
        setState(() {
          Future.delayed(const Duration(seconds: 0)).then((_) async {
            if (widget.toLat == 0.0 || widget.fromLat == 0.0) {
              setSnackbar("select fields".tr(), context);
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreenPolyline(
                        fromLat: widget.fromLat,
                        toLat: widget.toLat,
                        fromLng: widget.fromLon,
                        toLng: widget.toLon,
                        sourceAdd: controllerFrom.text,
                        destAdd: controllerTo.text,
                        idList: idList,
                        vehicletypeList: vehicletypeList,
                        baseKmList: baseKmList,
                        baseTimeList: baseTimeList,
                        priceList: priceList,
                        length: length,
                        date: date,
                        time: time,
                        vechileImageList: vechileImage),
                  ));
            }
          });
        });
      } else {
        Loader.hide();
        setSnackbar(creat.data.message.toString(), context);
      }
    } else {
      setSnackbar("nointernet".tr(), context);
    }
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
    int t = response.data["rows"][0]["elements"][0]["duration"]["value"];
    double t2 = t / 60;
    timeOfTrip = t2.toString();
    print(timeOfTrip);
    if (mounted) {
      setState(() {});
    }
    return timeOfTrip;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.sourceAddress == ''
          ? Center(child: CircularProgressIndicator())
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
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 2.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50,
                              ),
                              myText(
                                text: 'from address'.tr(),
                                fontSize: 7.sp,
                                fontWeight: FontWeight.bold,
                                color: lightBlue4,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryBlue.withOpacity(0.3),
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
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.w),
                                  child: GooglePlaceAutoCompleteTextField(
                                      textEditingController: controllerFrom,
                                      // textStyle: TextStyle(),
                                      googleAPIKey: APIKEY,
                                      inputDecoration: const InputDecoration(
                                          border: InputBorder.none),
                                      countries: const ["sy", "sy"],
                                      isLatLngRequired: true,
                                      getPlaceDetailWithLatLng: (prediction) {
                                        setState(() {
                                          controllerFrom.text =
                                              prediction.description!;
                                          controllerFrom.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: prediction
                                                          .description!
                                                          .length));
                                        });
                                        widget.fromLat = double.tryParse(
                                            "${prediction.lat}")!;
                                        widget.fromLon = double.tryParse(
                                            "${prediction.lng}")!;
                                        setState(() {});
                                        print("placeDetails 1 :" +
                                            prediction.lng.toString());
                                        print("point lat 1 :" +
                                            widget.fromLat.toString());
                                        print("point lan 1 :" +
                                            widget.fromLon.toString());
                                      },
                                      // this callback is called when isLatLngRequired is true
                                      itmClick: (prediction) {
                                        setState(() {
                                          controllerFrom.text =
                                              prediction.description!;
                                          controllerFrom.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: prediction
                                                          .description!
                                                          .length));
                                        });
                                      }),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              InkWell(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: primaryBlue2,
                                    ),
                                    Text('select address on map'.tr(),
                                        style: TextStyle(color: primaryBlue)),
                                  ],
                                ),
                                onTap: () {
                                  print('order now select from on map icon ');
                                  print(widget.fromLat);
                                  print(widget.fromLon);
                                  print(widget.sourceAddress);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MapScreenSource(
                                          fromLat: widget.fromLat,
                                          fromLon: widget.fromLon,
                                          sourceAddress: widget.sourceAddress,
                                          laterOrder: widget.laterOrder,
                                        ),
                                      ));
                                },
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              myText(
                                text: 'to address'.tr(),
                                fontSize: 7.sp,
                                fontWeight: FontWeight.bold,
                                color: lightBlue4,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryBlue.withOpacity(0.3),
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
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.w),
                                  child: GooglePlaceAutoCompleteTextField(
                                      textEditingController: controllerTo,
                                      googleAPIKey: APIKEY,
                                      inputDecoration: const InputDecoration(
                                          border: InputBorder.none),
                                      countries: const ["sy", "sy"],
                                      // optional by default null is set
                                      isLatLngRequired: true,
                                      // if you required coordinates from place detail
                                      getPlaceDetailWithLatLng: (prediction) {
                                        setState(() {
                                          controllerTo.text =
                                              prediction.description!;
                                          controllerTo.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: prediction
                                                          .description!
                                                          .length));
                                        });
                                        widget.toLat = double.tryParse(
                                            "${prediction.lat}")!;
                                        widget.toLon = double.tryParse(
                                            "${prediction.lng}")!;
                                        setState(() {});
                                        print("placeDetails 2 :" +
                                            prediction.lng.toString());
                                        print("point lat 2 :" +
                                            widget.toLat.toString());
                                        print("point lan 2 :" +
                                            widget.toLon.toString());
                                      },
                                      // this callback is called when isLatLngRequired is true
                                      itmClick: (prediction) {
                                        setState(() {
                                          controllerTo.text =
                                              prediction.description!;
                                          controllerTo.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: prediction
                                                          .description!
                                                          .length));
                                        });
                                      }),
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              InkWell(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: primaryBlue2,
                                    ),
                                    Text('select address on map'.tr(),
                                        style: TextStyle(color: primaryBlue)),
                                  ],
                                ),
                                onTap: () {
                                  if (widget.fromLat == 0.0) {
                                    setSnackbar("select from".tr(), context);
                                  } else {
                                    print('order now select to on map icon');
                                    print(widget.fromLat);
                                    print(widget.fromLon);
                                    print(widget.toLat);
                                    print(widget.toLon);
                                    print(widget.sourceAddress);
                                    print(widget.destAddress);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MapScreenDestination(
                                            fromLat: widget.fromLat,
                                            toLat: widget.toLat,
                                            fromLon: widget.fromLon,
                                            toLon: widget.toLon,
                                            sourceAddress: widget.sourceAddress,
                                            destinationAddress:
                                                widget.destAddress,
                                            laterOrder: widget.laterOrder,
                                          ),
                                        ));
                                  }
                                },
                              ),
                              widget.laterOrder == true
                                  ? SizedBox(
                                      height: 4.h,
                                    )
                                  : SizedBox(
                                      height: 5.h,
                                    ),
                              widget.laterOrder == true
                                  ? Column(
                                      children: [
                                        ContainerWidget2(
                                          text: 'select date'.tr(),
                                          // text: getDate(),
                                          h: 6.h,
                                          w: 80.w,
                                          onTap: () {
                                            _selectDate(context);
                                            showDate = true;
                                          },
                                          color: backgroundColor,
                                          textColor: lightBlue,
                                        ),
                                        Container(
                                          height: 1,
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        showDate
                                            ? Center(
                                                child: myText(
                                                text: getDate(),
                                                fontSize: 4.sp,
                                                color: primaryBlue,
                                              ))
                                            : const SizedBox(),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        ContainerWidget2(
                                          text: 'select time'.tr(),
                                          h: 6.h,
                                          w: 80.w,
                                          onTap: () {
                                            _selectTime(context);
                                            showTime = true;
                                          },
                                          color: backgroundColor,
                                          textColor: lightBlue,
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        showTime
                                            ? Center(
                                                child: myText(
                                                text: getTime(selectedTime),
                                                fontSize: 4.sp,
                                                color: primaryBlue,
                                              ))
                                            : const SizedBox(),
                                        SizedBox(
                                          height: 50,
                                        ),
                                      ],
                                    )
                                  : Container(),
                              widget.laterOrder == true
                                  ? SizedBox(
                                      height: 0.h,
                                    )
                                  : SizedBox(
                                      height: 20.h,
                                    ),
                              widget.laterOrder == true
                                  ? Center(
                                      child: ContainerWidget(
                                        text: 'request'.tr(),
                                        h: 7.h,
                                        w: 60.w,
                                        onTap: () async {
                                          Loader.show(context,
                                              progressIndicator:
                                                  CircularProgressIndicator());
                                          print('later');
                                          print(widget.fromLat);
                                          print(widget.fromLon);
                                          print(widget.toLat);
                                          print(widget.toLon);
                                          print(widget.sourceAddress);
                                          print(getDate());
                                          print(getTime(selectedTime));
                                          getDistance(
                                              widget.fromLat,
                                              widget.fromLon,
                                              widget.toLat,
                                              widget.toLon);
                                          if (widget.fromLat != 0.0 &&
                                              widget.fromLon != 0.0 &&
                                              widget.toLat != 0.0 &&
                                              widget.toLon != 0.0) {
                                            await getTimeOfTrip(
                                                widget.fromLat,
                                                widget.fromLon,
                                                widget.toLat,
                                                widget.toLon);
                                          }
                                          print(timeOfTrip);
                                          Loader.hide();
                                          // api source and distenation delayed
                                          var getSourceDistDelay = await Provider
                                              .of<SourceDestinationDelayedProvider>(
                                                  context,
                                                  listen: false);
                                          sourceDistDelayApi(
                                              widget.fromLat.toString(),
                                              widget.fromLon.toString(),
                                              widget.toLat.toString(),
                                              widget.toLon.toString(),
                                              distance.toString(),
                                              timeOfTrip,
                                              getDate(),
                                              getTime(selectedTime),
                                              getSourceDistDelay);
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: ContainerWidget(
                                        text: 'request'.tr(),
                                        h: 7.h,
                                        w: 60.w,
                                        onTap: () async {
                                          Loader.show(context,
                                              progressIndicator:
                                                  CircularProgressIndicator());
                                          print(widget.fromLat);
                                          print(widget.fromLon);
                                          print(widget.toLat);
                                          print(widget.toLon);
                                          print(widget.sourceAddress);
                                          getDistance(
                                              widget.fromLat,
                                              widget.fromLon,
                                              widget.toLat,
                                              widget.toLon);
                                          if (widget.fromLat != 0.0 &&
                                              widget.fromLon != 0.0 &&
                                              widget.toLat != 0.0 &&
                                              widget.toLon != 0.0) {
                                            await getTimeOfTrip(
                                                widget.fromLat,
                                                widget.fromLon,
                                                widget.toLat,
                                                widget.toLon);
                                          }
                                          print(timeOfTrip);
                                          Loader.hide();
                                          var getSourceDist = await Provider.of<
                                                  SourceDestinationProvider>(
                                              context,
                                              listen: false);
                                          sourceDistApi(
                                              widget.fromLat.toString(),
                                              widget.fromLon.toString(),
                                              widget.toLat.toString(),
                                              widget.toLon.toString(),
                                              distance.toString(),
                                              timeOfTrip,
                                              getSourceDist);
                                        },
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
    );
  }
}