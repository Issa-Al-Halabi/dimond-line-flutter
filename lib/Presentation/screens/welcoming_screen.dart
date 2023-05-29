import 'dart:async';
import 'package:flutter/material.dart';
import 'package:diamond_line/Presentation/Screens/landing_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'driver_app/driver_main_application/driver_main_screen/driver_dashboard.dart';
import 'driver_app/driver_main_application/driver_main_screen/tracking_screen.dart';
import 'user_app/user_main_application/main_screen/user_dashboard.dart';
import 'package:package_info/package_info.dart';

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
  late String tripId;
  late String pickupLatitude, pickupLongitude, dropLatitude, dropLongitude;

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

    tripId = prefs.getString('tripId') ?? '';
    print('tripId in main');
    print(tripId);

    pickupLatitude = prefs.getString('pickupLatitude') ?? '';
    print('pickupLatitude in main');
    print(pickupLatitude);

    pickupLongitude = prefs.getString('pickupLongitude') ?? '';
    print('pickupLongitude in main');
    print(pickupLongitude);

    dropLatitude = prefs.getString('dropLatitude') ?? '';
    print('dropLatitude in main');
    print(dropLatitude);

    dropLongitude = prefs.getString('dropLongitude') ?? '';
    print('dropLongitude in main');
    print(dropLongitude);

      }

  @override
  void initState() {
    initShared();
    getVersion();
    getPer();
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => 
        Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (BuildContext context, Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return  //  MapScreen()
            token != '' && type == 'user' ? UserDashboard()
            : token != '' && type == 'foreign user' ? UserDashboard()
            : token != '' && type == 'organisations' ? UserDashboard()
             : token != '' && type == 'external_driver' ?
            tripId !='' ?
            TrackingScreen(
              pickupLatitude: pickupLatitude,
              pickupLongitude: pickupLongitude,
              dropLongitude: dropLongitude,
              dropLatitude: dropLatitude,
              tripId: tripId,
            )
            :
            DriverDashboard(driverType: 'external_driver',)
             : token != '' && type == 'driver' ?
            tripId !='' ?
            TrackingScreen(
              pickupLatitude: pickupLatitude,
              pickupLongitude: pickupLongitude,
              dropLongitude: dropLongitude,
              dropLatitude: dropLatitude,
              tripId: tripId,
            )
                :
            DriverDashboard(driverType: 'driver')
              :
            LandingPage();
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
              )
            );
  }

  void getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
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

  @override
  Widget build(BuildContext context) {
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