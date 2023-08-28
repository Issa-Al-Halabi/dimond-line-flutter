import 'package:connectivity/connectivity.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_main_screen/tracking_screen.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import '../../../../../Buisness_logic/provider/Driver_Provider/started_inside_trips_provider.dart';
import '../driver_profile_screen/driver_settings.dart';
import 'driver_efficient_trips.dart';
import 'external_driver_screen.dart';
import 'internal_driver_screen.dart';

class DriverDashboard extends StatefulWidget {
  int index = 2;

  DriverDashboard({required this.driverType,
    this.index = 2,
    Key? key}) : super(key: key);

  String driverType;

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  DateTime timeback = DateTime.now();
  var _bottomNavIndex = 2;
  final iconList=<String>[
    choices,
    trips,
  ];
  List<Widget> screens = <Widget>[];
  bool _isNetworkAvail = true;
  bool isTrip = false;
  String tripId = '';
  String status = '';
  String pickupLatitude = '', pickupLongitude= '', dropLatitude= '', dropLongitude= '';

  buildScreens() {
    screens.add(DriverSettings());
    screens.add(EfficientDriverTrips());
    widget.driverType == 'external_driver' ?
    screens.add(OutDriverMainScreen())
    :
    screens.add(InDriverMainScreen());
  }

  @override
  void initState() {
    buildScreens();
    getTrips();
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    super.initState();
  }


  ////////////////////////////////////////////////////////
  void getTrips() async {
    print('ssssssssssssssssssssssss');
    var getTrips = await Provider.of<StartedInsideTripsProvider>(context, listen: false);
    getTripsApi(getTrips);
  }

  /////////////////////////getTrips api //////////////////////////////////
  Future<void> getTripsApi(StartedInsideTripsProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var data = await creat.startedTrips();
      if (creat.data.error == false) {
        int length = creat.data.data!.length;
        print('data');
        print(creat.data.data);
        print('length');
        print(length);
        if(length != 0){
          isTrip = true;

          for(int i =0; i< creat.data.data!.length; i++){
            tripId = creat.data.data![i].id.toString();
            status = creat.data.data![i].status!;
            pickupLatitude = creat.data.data![i].pickupLatitude!;
            pickupLongitude = creat.data.data![i].pickupLongitude!;
            dropLatitude = creat.data.data![i].dropLatitude!;
            dropLongitude = creat.data.data![i].dropLongitude!;
          }
        }
      }
      startNavigate();
    } else {
      setSnackbar("nointernet".tr(), context);
    }
  }

  void startNavigate() async {
        if(isTrip == true){
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return TrackingScreen(
                    pickupLatitude: pickupLatitude,
                    pickupLongitude: pickupLongitude,
                    dropLongitude: dropLongitude,
                    dropLatitude: dropLatitude,
                    tripId: tripId,
                  );
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


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // if(widget.index == 2){
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
        // }
        // else{
        //   widget.index = 2;
        //   setState(() {});
        //   return false;
        // }
      },
      child: Scaffold(
        // body: screens[_bottomNavIndex],
        body: screens[widget.index],
        floatingActionButton: FloatingActionButton(
          elevation: 8,
          backgroundColor: primaryBlue,
          child: Icon(
            Icons.home,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            setState(() {
              widget.index = 2;
              _bottomNavIndex = 2;
            });
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          // borderColor: colors.White,
          itemCount: iconList.length,
          // itemCount: 3,
          tabBuilder: (int index, bool isActive) {
            final color = isActive ? lightBlue3 : grey;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset( iconList[index],
                  height: 6.h,
                  width: 7.w,
                  color: color,),
              ],
            );
          },
          backgroundColor: primaryBlue3,
          activeIndex: _bottomNavIndex,
          // splashColor: colors.newBlack,
          // notchAndCornersAnimation: borderRadiusAnimation,
          splashSpeedInMilliseconds: 300,
          notchSmoothness: NotchSmoothness.softEdge,
          notchMargin: 5.0,
          gapLocation: GapLocation.center,
          elevation: 0.0,
          // leftCornerRadius: 32,
          // rightCornerRadius: 32,
          onTap: (index) =>
          setState(() {
            widget.index = index;
            _bottomNavIndex = index;
          }),
        ),
      ),
    );
  }
}