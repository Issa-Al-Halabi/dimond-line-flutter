import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/user_orders.dart';
import '../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import '../profile_screen/user_settings.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
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
  final iconList=<String>[
    choices,
    trips,
  ];

  List<Widget> screens = <Widget>[];

  buildScreens() {
    screens.add(UserSettings());
    screens.add(UserOrders());
    screens.add(SelectType());
  }

  @override
  void initState() {
    buildScreens();
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    super.initState();
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
                Image.asset( iconList[index],
                  // height: 7.h,
                  height: 6.h,
                  width: 7.w,
                  color: color,),
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