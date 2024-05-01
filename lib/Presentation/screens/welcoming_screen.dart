import 'dart:async';
import 'package:diamond_line/Buisness_logic/provider/Driver_Provider/wait_for_payment_provider.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/in_trip_provider.dart';
import 'package:diamond_line/Presentation/Functions/firebase_notification.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/inside_city_trips/inside_trip_delayed.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/inside_city_trips/inside_trip_moment.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_registration/are_you.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:diamond_line/Presentation/Screens/landing_page.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Buisness_logic/provider/User_Provider/init_user_trips_provider.dart';

// import '../../Data/Models/User_Models/InitUserTripsModel.dart';
import '../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Functions/helper.dart';
import '../widgets/location_service_dialog.dart';
import 'driver_app/driver_main_application/driver_main_screen/driver_dashboard.dart';
import 'driver_app/driver_main_application/driver_main_screen/tracking_screen.dart';
import 'user_app/user_main_application/main_screen/user_dashboard.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';

class WelcomingScreen extends StatefulWidget {
  @override
  _WelcomingScreenState createState() => _WelcomingScreenState();
}

class _WelcomingScreenState extends State<WelcomingScreen> {
  String version = '';
  late SharedPreferences prefs;
  late String token;
  late String uid;
  late String type;
  late String device;
  // late String tripId;
  // late String pickupLatitude, pickupLongitude, dropLatitude, dropLongitude;

  // // late bool isTrip;
  // bool isTrip= false;
  // // late String typeOfTrip;
  // String typeOfTrip = '';
  // bool _isNetworkAvail = true;
  // Data momentTripModel = Data();
  // Data delayTripModel = Data();
  // bool isSecondTrip = false;
  // bool goToMapDelay = true;

  Future initShared() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    print('token in main');
    print(token);

    uid = prefs.getString('user_id') ?? '';
    print('uid in main');
    print(uid);

    type = prefs.getString('type_of_customer') ?? '';
    print('type_of_customer in main');
    print(type);

    device = prefs.getString('deviceNumber') ?? '';
    print('device in main');
    print(device);

    // tripId = prefs.getString('tripId') ?? '';
    // print('tripId in main');
    // print(tripId);
    //
    // pickupLatitude = prefs.getString('pickupLatitude') ?? '';
    // print('pickupLatitude in main');
    // print(pickupLatitude);
    //
    // pickupLongitude = prefs.getString('pickupLongitude') ?? '';
    // print('pickupLongitude in main');
    // print(pickupLongitude);
    //
    // dropLatitude = prefs.getString('dropLatitude') ?? '';
    // print('dropLatitude in main');
    // print(dropLatitude);
    //
    // dropLongitude = prefs.getString('dropLongitude') ?? '';
    // print('dropLongitude in main');
    // print(dropLongitude);
  }

  @override
  void initState() {
    initShared();
    getVersion();
    // getPer();
    CheckLocationServicesInDevice();
    // requestLocationPermission(context);
    // getTrips();
    super.initState();
    // startTimer();
  }

  late PermissionStatus status;

  Future<void> requestLocationPermission(BuildContext context) async {
    print('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh');
    // final PermissionStatus status = await Permission.location.request();
    status = await Permission.location.request();

    if (status.isGranted) {
      print('isGranted');
      startTimer();
      // Permission granted, continue with app functionality
    } else if (status.isDenied || status.isPermanentlyDenied) {
      print('isDenied');
      // Permission denied, show a message and close the app
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Permission'),
            content: Text(
                'The app requires location permission to function properly.'),
            actions: [
              MaterialButton(
                child: Text('Yes'),
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              ),
              MaterialButton(
                child: Text('No'),
                // onPressed: () => requestLocationPermission(context),
                onPressed: () {
                  // Set the permission status to granted
                  // Permission.location.request().then((newStatus) {
                  //   if (newStatus.isGranted) {
                  //     print('newStatus.isGranted');
                  //     startTimer();
                  //     // Permission granted, continue with app functionality
                  //   }
                  // });
                  // Navigator.of(context).pop();
                  // print('kkkkkkkkkkkkk');
                  // print(status);
                  // setState(() {
                  //   status = PermissionStatus.granted;
                  // });
                  // print('kkkkkkkkkkkkk2222');
                  // print(status);
                  // requestLocationPermission(context);
                  Permission.location.request().then((newStatus) {
                    if (newStatus.isGranted) {
                      print('newStatus.isGranted');
                      startTimer();
                      // Permission granted, continue with app functionality
                    }
                  });
                  // Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      // // Close the app
      // await Future.delayed(Duration(seconds: 2));
      // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  // Future getPer() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // return Future.error('Location services are disabled');
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('turn on location'),
  //           content: Text('turn on location please'),
  //           actions: [
  //             FlatButton(
  //               child: Text('retry'),
  //               onPressed: () => getPer,
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  //       // return Future.error('Location permissions are denied');
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     // return Future.error(
  //     //     'Location permissions are permanently denied, we cannot request permissions.');
  //     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  //   }
  //
  //   if (permission == LocationPermission.whileInUse) {
  //     startTimer();
  //   }
  //
  //   if (permission == LocationPermission.always) {
  //     startTimer();
  //   }
  // }

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
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        // return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  bool _serviceEnabled = false;
  Future<void> CheckLocationServicesInDevice() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (_serviceEnabled) {
      LocationPermission permissionStatus =
          await Geolocator.requestPermission();
      if (permissionStatus == LocationPermission.always ||
          permissionStatus == LocationPermission.whileInUse) {
        // Position _locationData = await Geolocator.getCurrentPosition();
        startTimer();
      } else if (permissionStatus == LocationPermission.denied ||
          permissionStatus == LocationPermission.deniedForever) {
        LocationServiceDialog(
          context,
          onRetry: () {
            CheckLocationServicesInDevice();
          },
          onClose: () {},
          title: "please_enable_your_location_permission_and_try_again".tr(),
        );
      }
    } else {
      print('elseeee');
      LocationServiceDialog(
        context,
        onRetry: () {
          CheckLocationServicesInDevice();
        },
        onClose: () {},
        title: "please_enable_your_location_service_and_try_again".tr(),
      );
    }
  }

  void startTimer() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Timer(Duration(seconds: 2), () {
      // InTripProvider inTripProvider =
      //     Provider.of<InTripProvider>(context, listen: false);
      // inTripProvider.firebaseInit();
      // print(inTripProvider.test);

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return token != '' && type == 'user'
                ? UserDashboard()
                // : token != '' && type == 'foreign user' ? UserDashboard()
                : token != '' && type == 'organisations'
                    ? UserDashboard()
                    ////////////////////////////////////////////////////////
                    : token != '' && type == 'external_driver'
                        ? DriverDashboard(
                            driverType: 'external_driver',
                          )
                        : token != '' && type == 'driver'
                            ? DriverDashboard(driverType: 'driver')
                            // : token != '' && type == 'external_driver' ?
                            //              tripId !='' ?
                            //              TrackingScreen(
                            //                pickupLatitude: pickupLatitude,
                            //                pickupLongitude: pickupLongitude,
                            //                dropLongitude: dropLongitude,
                            //                dropLatitude: dropLatitude,
                            //                tripId: tripId,
                            //              )
                            //                  :
                            //              DriverDashboard(driverType: 'external_driver',)
                            //                  : token != '' && type == 'driver' ?
                            //              tripId !='' ?
                            //              TrackingScreen(
                            //                pickupLatitude: pickupLatitude,
                            //                pickupLongitude: pickupLongitude,
                            //                dropLongitude: dropLongitude,
                            //                dropLatitude: dropLatitude,
                            //                tripId: tripId,
                            //              )
                            //                  :
                            //              DriverDashboard(driverType: 'driver')

                            //////////////////////////////////////////////////////////////////////////////////////////////
                            : pref.getBool('isFirstTimeUser') ?? true
                                ? LandingPage()
                                : AreYou();
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return Align(
              child: SizeTransition(
                sizeFactor: animation,
                child: child,
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 500),
        ),
      );
    });
  }

  // void getTrips() async {
  //   print('ssssssssssssssssssssssss');
  //   var getTrips = await Provider.of<InitUserTripsProvider>(context, listen: false);
  //   getTripsApi(getTrips);
  // }

  // /////////////////////////getTrips api //////////////////////////////////
  // Future<void> getTripsApi(
  //     InitUserTripsProvider creat) async {
  //   _isNetworkAvail = await isNetworkAvailable();
  //   if (_isNetworkAvail) {
  //     var data = await creat.getInitTrips();
  //     print('data');
  //     print(data);
  //     if (creat.data.success == true) {
  //       int length = creat.data.data!.length;
  //       print('length');
  //       print(length);
  //       if(length != 0){
  //         // print(creat.data.data![0].driver!.phone.toString());
  //         // print(creat.data.data![0].vehicle!.carModel.toString());
  //         isTrip = true;
  //       for(int i =0; i< creat.data.data!.length; i++){
  //         if(creat.data.data![i].requestType == 'moment'){
  //           momentTripModel = creat.data.data![i];
  //           typeOfTrip = 'moment';
  //         }
  //         else{
  //           delayTripModel = creat.data.data![i];
  //           String? statusDelayed = creat.data.data![i].status;
  //           if (statusDelayed == 'pending' || statusDelayed == 'accepted'){
  //             goToMapDelay = false;
  //           }
  //           // typeOfTrip = 'delay';
  //           isSecondTrip = true;
  //         }
  //       }
  //
  //       print('isSecondTrip');
  //       print(isSecondTrip);
  //     }
  //     }
  //     startTimer();
  //
  //   } else {
  //     startTimer();
  //     // setSnackbar("nointernet".tr(), context);
  //   }
  // }

  void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseNotificationsHandler().context = context;
    FirebaseNotificationsHandler().inTripProvider =
        Provider.of<InTripProvider>(context);
    FirebaseNotificationsHandler().waitForPaymentProvider =
        Provider.of<WaitForPaymentProvider>(context);
    return Scaffold(
      backgroundColor: primaryBlue,
      body: Container(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Container(
                  height: 20.h,
                  child: Image.asset(
                    logo,
                    height: 70.h,
                    width: 80.w,
                    // fit: BoxFit.cover,
                  )),
              getLogoText(fontSize: 8.sp),
              SizedBox(
                height: 40.h,
              ),
              Center(
                  child: Text(
                'POWERED BY PEAK LINK\nVERSION $version',
                style: TextStyle(
                  color: backgroundColor,
                ),
                textAlign: TextAlign.center,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
