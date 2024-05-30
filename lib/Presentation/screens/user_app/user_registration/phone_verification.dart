import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import '../../../widgets/loader_widget.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/send_otp_provider.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/verify_otp_provider.dart';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_registration/registration.dart';
import 'package:diamond_line/Presentation/widgets/code_verification.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constants.dart';
import '../../../Functions/helper.dart';
import '../../driver_app/driver_main_application/driver_main_screen/driver_dashboard.dart';
import 'forget_password.dart';

class PhoneVerification extends StatefulWidget {
  PhoneVerification(
      {required this.phone,
      required this.code,
      this.isDriver = false,
      this.isFromForgetPass = false,
      Key? key})
      : super(key: key);
  String phone, code;
  bool isDriver;
  bool isFromForgetPass;

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  TextEditingController verification = TextEditingController();
  String _code = "";
  bool _isNetworkAvail = true;
  bool isClickable = false;
  late SharedPreferences prefs;
  late String typeOfDriver;

  Future initShared() async {
    prefs = await SharedPreferences.getInstance();
    typeOfDriver = prefs.getString('type_of_customer') ?? '';
    print(typeOfDriver);
  }

  @override
  void initState() {
    initShared();
    verifyUser();
    setState(() {
      // isClickable = true;
      Future.delayed(const Duration(seconds: 60)).then((_) async {
        // isClickable= false;
        isClickable = true;
      });
    });
    super.initState();
  }

  ////////////////////////////verify otp api/////////////////////////////////////
  void validateAndSubmit(String phone, String code, VerifyOtpProvider R) async {
    checkNetwork(phone, code, R);
  }

  Future<void> checkNetwork(
      String phone, String code, VerifyOtpProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      print(phone);
      print(code);
      print(widget.isFromForgetPass);
      print(widget.isDriver);
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.getVerifyOtpCode(phone, code);
      if (creat.data.erorr == false) {
        Loader.hide();
        setState(() {
          Future.delayed(const Duration(seconds: 1)).then((_) async {
            // if(widget.isFromForgetPass == false){
            //   Navigator.of(context).push(
            //     PageRouteBuilder(
            //       pageBuilder: (BuildContext context, Animation<double> animation,
            //           Animation<double> secondaryAnimation) {
            //         return Registration();
            //       },
            //       transitionsBuilder: (BuildContext context,
            //           Animation<double> animation,
            //           Animation<double> secondaryAnimation,
            //           Widget child) {
            //         return Align(
            //           child: SizeTransition(
            //             sizeFactor: animation,
            //             child: child,
            //           ),
            //         );
            //       },
            //       transitionDuration: Duration(milliseconds: 500),
            //     ),
            //   );
            // }
            // else {
            //   Navigator.of(context).push(
            //     PageRouteBuilder(
            //       pageBuilder: (BuildContext context,
            //           Animation<double> animation,
            //           Animation<double> secondaryAnimation) {
            //         // return DriverLogin();
            //         return ForgetPassword(
            //           emailOrPhone: widget.phone,
            //           title: 'forget',
            //           isDriver: widget.isDriver == true ? true : false,
            //         );
            //       },
            //       transitionsBuilder: (BuildContext context,
            //           Animation<double> animation,
            //           Animation<double> secondaryAnimation,
            //           Widget child) {
            //         return Align(
            //           child: SizeTransition(
            //             sizeFactor: animation,
            //             child: child,
            //           ),
            //         );
            //       },
            //       transitionDuration: Duration(milliseconds: 500),
            //     ),
            //   );
            // }

            if (widget.isDriver == true) {
              if (widget.isFromForgetPass == false) {
                if (typeOfDriver == 'external_driver') {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return DriverDashboard(
                          driverType: 'external_driver',
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
                } else {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return DriverDashboard(
                          driverType: 'driver',
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
              } else {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      // return DriverLogin();
                      return ForgetPassword(
                        emailOrPhone: widget.phone,
                        title: 'forget',
                        isDriver: widget.isDriver == true ? true : false,
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
            } else {
              if (widget.isFromForgetPass == false) {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return Registration();
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
              } else {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      // return DriverLogin();
                      return ForgetPassword(
                        emailOrPhone: widget.phone,
                        title: 'forget',
                        isDriver: widget.isDriver == true ? true : false,
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

  // resend otp api
  Future<void> resendOtp(String phone, SendOtpProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.getSendOtp(
          phone,
          widget.isFromForgetPass == true ? 'forget_password' : 'sign_up',
          widget.isDriver == true ? false : true);
      if (creat.data.error == false) {
        Loader.hide();
        setSnackbar("sendotpsuccess".tr(), context);
        // setSnackbar(creat.data.data!.code.toString(), context);
        print(creat.data.data!.code);
        setState(() {
          isClickable = false;
          Future.delayed(const Duration(seconds: 60)).then((_) async {
            isClickable = true;
          });
          verifyUserResend(creat.data.data!.code.toString());
        });
      } else {
        Loader.hide();
        setSnackbar(creat.data.message.toString(), context);
        setState(() {
          isClickable = false;
          Future.delayed(const Duration(seconds: 60)).then((_) async {
            isClickable = true;
          });
        });
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
      duration: const Duration(seconds: 3),
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(color: primaryBlue),
      ),
      backgroundColor: white,
      elevation: 1.0,
    ));
  }

  void verifyUser() async {
    ////////////////mtn
    String msg = " The code for the Diamond line app is";
    try {
      String phone = '963' + widget.phone.toString();
      print(phone);
      print(widget.code);
      print(msg);
      AppRequests.mtnRequest(phone, widget.code);
    } on TimeoutException catch (_) {
      setSnackbar('somethingMSg'.tr(), context);
    }
  }

  void verifyUserResend(String code) async {
    ////////////////mtn
    String msg = " The code for the Diamond line app is";
    try {
      String phone = '963' + widget.phone.toString();
      print('resend');
      print(phone);
      print(code);
      print(msg);
      AppRequests.mtnRequest(phone, code);
    } on TimeoutException catch (_) {
      setSnackbar('somethingMSg'.tr(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPopLoader,
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
            padding: EdgeInsets.only(top: 10.h, bottom: 7.h),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
                color: backgroundColor,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 5.h),
                    Center(
                      child: Text(
                        'phone verification'.tr(),
                        style: TextStyle(
                            color: primaryBlue2,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Image.asset(
                      verificationImage,
                      height: 40.h,
                      width: 70.w,
                    ),
                    SizedBox(height: 1.h),
                    myText(
                      text: 'enter code'.tr(),
                      fontSize: 5.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 1.h),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                      child: Builder(builder: (context) {
                        return VerificationCodeField(
                          length: 6,
                          textEditingController: verification,
                          onChange: (value) {
                            _code = value;
                            verification.text = value;
                          },
                        );
                      }),
                    ),
                    SizedBox(height: 2.h),
                    TextButton(
                        onPressed: () {
                          if (isClickable == true) {
                            var creat2 = Provider.of<SendOtpProvider>(context,
                                listen: false);
                            resendOtp(widget.phone, creat2);
                          } else {
                            setSnackbar('please wait 60 s'.tr(), context);
                          }
                        },
                        child: myText(
                          text: 'resend code'.tr(),
                          fontSize: 5.sp,
                          color: primaryBlue2,
                        )),
                    SizedBox(height: 2.h),
                    ContainerWidget(
                        text: 'done'.tr(),
                        h: 6.h,
                        w: 80.w,
                        onTap: () async {
                          print('verification.text' + verification.text);
                          print('_code' + _code);
                          print('widget.phone' + widget.phone);
                          // Navigator.pushNamed(context, 'registration');
                          var creat = Provider.of<VerifyOtpProvider>(context,
                              listen: false);
                          validateAndSubmit(widget.phone, _code, creat);
                        }),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
