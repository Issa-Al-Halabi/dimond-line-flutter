import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/login_provider.dart';
import 'package:diamond_line/Presentation/Functions/Validators.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:diamond_line/Presentation/widgets/phone_field.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../Buisness_logic/provider/User_Provider/send_otp_provider.dart';
import '../../../../constants.dart';
import '../../../Functions/helper.dart';
import '../../../widgets/loader_widget.dart';
import '../../user_app/user_registration/phone_verification.dart';
import '../driver_main_application/driver_main_screen/driver_dashboard.dart';

class DriverLogin extends StatefulWidget {
  const DriverLogin({Key? key}) : super(key: key);

  @override
  _DriverLoginState createState() => _DriverLoginState();
}

class _DriverLoginState extends State<DriverLogin> {
  String? countryCode = 'SY';
  String completePhone = "";
  bool showPassword = false;
  bool _isNetworkAvail = true;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  ////////////////////////////login api with phone/////////////////////////////////////
  Future<void> logInDriverApi(
      String phone, String pass, LogInProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.getLogin(phone, pass, false);
      if (creat.data.error == false) {
        Loader.hide();
        // setSnackbar("logsuccess".tr(), context);
        setState(() {
          Future.delayed(const Duration(seconds: 1)).then((_) async {
            if (creat.data.data!.type == 'external_driver') {
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
                    return DriverDashboard(driverType: 'driver');
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

  Future<void> sendOtpForgetApi(String phone, SendOtpProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      print(phone);
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.getSendOtp(phone, 'forget_password', false);
      if (creat.data.error == false) {
        Loader.hide();
        setSnackbar("sendotpsuccess".tr(), context);
        print(creat.data.data!.code);
        setState(() {
          Future.delayed(const Duration(seconds: 1)).then((_) async {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return PhoneVerification(
                    phone: phone,
                    code: creat.data.data!.code.toString(),
                    isDriver: true,
                    isFromForgetPass: true,
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
      content: Text(
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
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Container(
                      height: getScreenHeight(context) - 20.h,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25)),
                        color: backgroundColor,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 3.h),
                            Center(
                              child: Text(
                                'login'.tr(),
                                style: TextStyle(
                                    color: primaryBlue2,
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Stack(
                              children: [
                                const Divider(
                                  color: lightBlue2,
                                  thickness: 6,
                                ),
                                Divider(
                                  color: primaryBlue,
                                  indent: 30.w,
                                  endIndent: 35.w,
                                  thickness: 5,
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Builder(builder: (context) {
                              return PhoneField(
                                onSaved: (value) {
                                  setState(() {
                                    phoneController.text = value!;
                                  });
                                },
                                txt: phoneController,
                                validateFunction: (value) =>
                                    Validators.validatePhoneNumber(value),
                              );
                            }),
                            SizedBox(height: 5.h),
                            Container(
                              height: 6.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                                child: TextFormField(
                                  controller: passwordController,
                                  obscureText:
                                      showPassword == true ? false : true,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 5.sp,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: showPassword == true
                                          ? Icon(
                                              Icons.visibility_off,
                                              color: Colors.grey,
                                            )
                                          : Icon(
                                              Icons.visibility,
                                              color: Colors.grey,
                                            ),
                                      onPressed: () {
                                        setState(() {
                                          if (showPassword == false) {
                                            showPassword = true;
                                            print(showPassword);
                                          } else {
                                            showPassword = false;
                                            print(showPassword);
                                          }
                                        });
                                      },
                                    ),
                                    hintText: 'pass hint'.tr(),
                                    border: InputBorder.none,
                                    // contentPadding: EdgeInsets.all(1.h),
                                    // errorStyle: TextStyle(
                                    //     // height: 0.6.h,
                                    //     fontSize: 1.sp)
                                  ),
                                  onChanged: (value) {},
                                  validator: (value) =>
                                      Validators.validatePassword(value),
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (phoneController.text.length == 9) {
                                      print(phoneController.text);
                                      var creat = Provider.of<SendOtpProvider>(
                                          context,
                                          listen: false);
                                      sendOtpForgetApi(
                                          phoneController.text, creat);
                                    } else {
                                      setSnackbar('tapPhone'.tr(), context);
                                    }
                                  },
                                  child: Text(
                                    "forget?".tr(),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 4.sp,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.grey,
                                      decorationThickness: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            ContainerWidget(
                                text: 'login'.tr(),
                                h: 7.h,
                                w: 80.w,
                                onTap: () {
                                  if (formKey.currentState?.validate() ==
                                      true) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    var creat = Provider.of<LogInProvider>(
                                        context,
                                        listen: false);
                                    logInDriverApi(phoneController.text,
                                        passwordController.text, creat);
                                  } else {
                                    print('not validate');
                                  }
                                }),
                            SizedBox(height: 2.h),
                            ContainerWidget(
                                text: 'join us'.tr(),
                                h: 7.h,
                                w: 80.w,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, 'registration driver');
                                }),
                            SizedBox(height: 2.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
