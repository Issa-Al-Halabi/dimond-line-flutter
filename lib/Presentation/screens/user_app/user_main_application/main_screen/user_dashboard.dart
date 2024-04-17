import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../Buisness_logic/provider/User_Provider/init_user_trips_provider.dart';
import '../../../../../Data/Models/User_Models/InitUserTripsModel.dart';
import '../../../../../Data/Models/User_Models/SocketResponse.dart';
import '../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/user_orders.dart';
import '../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import '../profile_screen/user_settings.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'inside_city_trips/inside_trip_delayed.dart';
import 'inside_city_trips/inside_trip_moment.dart';
import 'select_type.dart';

class UserDashboard extends StatefulWidget {
  int index = 2;
  UserDashboard({this.index = 2, Key? key}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  DateTime timeback = DateTime.now();
  var _bottomNavIndex = 2;
  final iconList = <String>[
    choices,
    trips,
  ];

  bool _isNetworkAvail = true;
  // Data momentTripModel = Data();
  SocketResponse momentTripModel = SocketResponse();
  // Data delayTripModel = Data();
  SocketResponse delayTripModel = SocketResponse();
  bool isSecondTrip = false;
  bool goToMapDelay = true;
  bool isTrip = false;
  String typeOfTrip = '';
  bool isTrackDriverTrip = false;

  List<Widget> screens = <Widget>[];

  buildScreens() {
    screens.add(UserSettings());
    screens.add(UserOrders());
    screens.add(SelectType());
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

  void getTrips() async {
    print('ssssssssssssssssssssssss');
    var getTrips =
        await Provider.of<InitUserTripsProvider>(context, listen: false);
    getTripsApi(getTrips);
  }

  /////////////////////////getTrips api //////////////////////////////////
  Future<void> getTripsApi(InitUserTripsProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var data = await creat.getInitTrips();
      print('data');
      print(data);
      if (creat.data.success == true) {
        int length = creat.data.data!.length;
        print('length');
        print(length);
        if (length != 0) {
          isTrip = true;
          for (int i = 0; i < creat.data.data!.length; i++) {
            if (creat.data.data![i].requestType == 'moment') {
              typeOfTrip = 'moment';
              String? statusDelayed = creat.data.data![i].status;
              if (statusDelayed == 'pending') {
                momentTripModel.pickupLatitude =
                    creat.data.data![i].pickupLatitude;
                momentTripModel.pickupLongitude =
                    creat.data.data![i].pickupLongitude;
                momentTripModel.dropLatitude = creat.data.data![i].dropLatitude;
                momentTripModel.dropLongitude =
                    creat.data.data![i].dropLongitude;
                momentTripModel.id = creat.data.data![i].id;
                momentTripModel.status = creat.data.data![i].status;
              } else {
                isTrackDriverTrip = true;
                momentTripModel.driverFirstName =
                    creat.data.data![i].driver!.firstName;
                momentTripModel.driverLastName =
                    creat.data.data![i].driver!.lastName;
                momentTripModel.driverProfileImage =
                    creat.data.data![i].driver!.profileImage;
                momentTripModel.driverPhone = creat.data.data![i].driver!.phone;

                momentTripModel.vehicelDeviceNumber =
                    creat.data.data![i].vehicle!.deviceNumber;
                momentTripModel.vehicelCarModel =
                    creat.data.data![i].vehicle!.carModel;
                momentTripModel.vehicelColor =
                    creat.data.data![i].vehicle!.color;
                momentTripModel.vehicelImage =
                    creat.data.data![i].vehicle!.vehicleImage;

                momentTripModel.pickupLatitude =
                    creat.data.data![i].pickupLatitude;
                momentTripModel.pickupLongitude =
                    creat.data.data![i].pickupLongitude;
                momentTripModel.dropLatitude = creat.data.data![i].dropLatitude;
                momentTripModel.dropLongitude =
                    creat.data.data![i].dropLongitude;
                momentTripModel.id = creat.data.data![i].id;
                momentTripModel.status = creat.data.data![i].status;
              }
              print('dddddddddddddddddddd');
              print(momentTripModel.status.toString());
            } else {
              String? statusDelayed = creat.data.data![i].status;
              if (statusDelayed == 'pending' || statusDelayed == 'accepted') {
                goToMapDelay = false;
              } else {
                isTrackDriverTrip = true;
                isSecondTrip = true;
                delayTripModel.driverFirstName =
                    creat.data.data![i].driver!.firstName;
                delayTripModel.driverLastName =
                    creat.data.data![i].driver!.lastName;
                delayTripModel.driverProfileImage =
                    creat.data.data![i].driver!.profileImage;
                delayTripModel.driverPhone = creat.data.data![i].driver!.phone;

                delayTripModel.vehicelDeviceNumber =
                    creat.data.data![i].vehicle!.deviceNumber;
                delayTripModel.vehicelCarModel =
                    creat.data.data![i].vehicle!.carModel;
                delayTripModel.vehicelColor =
                    creat.data.data![i].vehicle!.color;
                delayTripModel.vehicelImage =
                    creat.data.data![i].vehicle!.vehicleImage;

                delayTripModel.pickupLatitude =
                    creat.data.data![i].pickupLatitude;
                delayTripModel.pickupLongitude =
                    creat.data.data![i].pickupLongitude;
                delayTripModel.dropLatitude = creat.data.data![i].dropLatitude;
                delayTripModel.dropLongitude =
                    creat.data.data![i].dropLongitude;
                delayTripModel.id = creat.data.data![i].id;
                delayTripModel.status = creat.data.data![i].status;
              }
              // typeOfTrip = 'delay';
              // isSecondTrip = true;
            }
          }

          print('isSecondTrip');
          print(isSecondTrip);
          print('goToMapDelay');
          print(goToMapDelay);
          print(isTrip);
          print(typeOfTrip);
          print(isTrackDriverTrip);

          // isTrip && typeOfTrip == '' && goToMapDelay == true
        }
      }
      startNavigate();
    } else {
      startNavigate();
      // setSnackbar("nointernet".tr(), context);
    }
  }

  void startNavigate() async {
    if (isTrip && typeOfTrip == 'moment') {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return InsideTripMomentScreen(
              isSecondTrip: isSecondTrip,
              momentTripModel: momentTripModel,
              delayTripModel: delayTripModel,
              isAcceptTrip: isTrackDriverTrip,
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
    } else if (isTrip && typeOfTrip == '' && goToMapDelay == true) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return InsideTripDelayedScreen(
              delayTripModel: delayTripModel,
              isAcceptTrip: isTrackDriverTrip,
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            final color = isActive ? lightBlue3 : grey;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  iconList[index],
                  // height: 7.h,
                  height: 6.h,
                  width: 7.w,
                  color: color,
                ),
              ],
            );
          },
          backgroundColor: primaryBlue3,
          activeIndex: _bottomNavIndex,
          splashSpeedInMilliseconds: 300,
          notchSmoothness: NotchSmoothness.softEdge,
          notchMargin: 5.0,
          gapLocation: GapLocation.center,
          elevation: 0.0,
          // leftCornerRadius: 32,
          // rightCornerRadius: 32,
          onTap: (index) => setState(() {
            widget.index = index;
            _bottomNavIndex = index;
          }),
        ),
      ),
    );
  }
}
