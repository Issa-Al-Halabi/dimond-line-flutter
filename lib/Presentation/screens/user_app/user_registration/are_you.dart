import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_registration/driver_login.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'sign_in_sign_up.dart';

class AreYou extends StatefulWidget {
  const AreYou({Key? key}) : super(key: key);

  @override
  _AreYouState createState() => _AreYouState();
}


class _AreYouState extends State<AreYou> {

  DateTime timeback = DateTime.now();
  Future<bool> willPop() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
        body: Container(
          height: getScreenHeight(context),
          width: getScreenWidth(context),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(background),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 9.h, bottom: 7.h),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                color: backgroundColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 5.h),
                  Center(
                    child: Text(
                      "are you".tr(),
                      style: TextStyle(
                          color: primaryBlue2,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  const Divider(
                    color: lightBlue2,
                    thickness: 6,
                  ),
                  SizedBox(height: 15.h),
                  Stack(
                    children: [
                      Container(
                        height: 6.h,
                        width: 85.w,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(0, 0),
                            ),
                          ],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        right: 20.w,
                        left: 20.w,
                        child: ContainerWidget(
                          h: 6.h,
                          w: 40.w,
                          text: "user".tr(),
                          onTap: () {
                            Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (BuildContext context, Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return LoginScreen();
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
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Stack(
                    children: [
                      Container(
                        height: 6.h,
                        width: 85.w,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(0, 0),
                            ),
                          ],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        right: 20.w,
                        left: 20.w,
                        child: ContainerWidget(
                          h: 6.h,
                          w: 40.w,
                          text: "driver".tr(),
                          onTap: () {
                                  Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (BuildContext context, Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return DriverLogin();
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
                                  },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}