import 'package:connectivity/connectivity.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_registration/sign_in_sign_up.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import '../../../widgets/loader_widget.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/forget_password_provider.dart';
import 'package:diamond_line/Presentation/Functions/Validators.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constants.dart';
import '../../../Functions/helper.dart';
import '../../driver_app/driver_registration/driver_login.dart';

class ForgetPassword extends StatefulWidget {
  ForgetPassword(
      {required this.emailOrPhone,
      required this.title,
      this.isEmail = false,
      this.isDriver = false,
      Key? key})
      : super(key: key);
  String emailOrPhone;
  String title;
  bool isEmail;
  bool isDriver;

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool showPassword = false;
  bool showPassword2 = false;
  bool _isNetworkAvail = true;
  String? token;
  var formKey = GlobalKey<FormState>();

  late SharedPreferences prefs;
  late String typeOfDriver;

  Future initShared() async {
    prefs = await SharedPreferences.getInstance();
    typeOfDriver = prefs.getString('type_of_customer') ?? '';
    print(typeOfDriver);
  }

  @override
  void initState() {
    passwordController.text = '';
    confirmPasswordController.text = '';
    initShared();
    super.initState();
  }

  void validateAndSubmitPhone(String phone, String pass, String pass2,
      ForgetPasswordProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.getForgetPassword(phone, pass, pass2, !widget.isDriver);
      if (creat.data.error == false) {
        Loader.hide();
        setSnackbar("updatePass".tr(), context);
        setState(() {
          Future.delayed(const Duration(seconds: 1)).then((_) async {
            if (widget.title == 'change pass') {
              Navigator.of(context).pop();
            } else {
              // var creat = Provider.of<SendOtpProvider>(context, listen: false);
              // print('widget.emailOrPhone');
              // print(widget.emailOrPhone);
              // sendOtp(widget.emailOrPhone, creat);

              if (widget.isDriver == true) {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
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
              } else {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
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

  // void validateAndSubmitEmail(String phone, String pass, String pass2,
  //     ForgetPasswordEmailProvider creat) async {
  //   _isNetworkAvail = await isNetworkAvailable();
  //   if (_isNetworkAvail) {
  //     print("There is internet");
  //     Loader.show(context, progressIndicator: LoaderWidget());
  //     // var data = await AppRequests.ForgetPasswordEmailRequest(phone, pass, pass2);
  //     // data = json.decode(data);
  //     await creat.getForgetPassword(phone, pass, pass2);
  //     if (creat.data.error == false) {
  //       Loader.hide();
  //       setSnackbar("updatePass".tr(), context);
  //       if (widget.isDriver == true && typeOfDriver == 'external_driver') {
  //         Navigator.pushNamed(context, 'out_driver_main_screen');
  //       } else if (widget.isDriver == true &&
  //           typeOfDriver == 'external_driver') {
  //         Navigator.pushNamed(context, 'in_driver_main_screen');
  //       } else {
  //         Navigator.pushNamed(context, 'select');
  //       }
  //     } else {
  //       Loader.hide();
  //       setSnackbar(creat.data.message.toString(), context);
  //     }
  //   } else {
  //     setSnackbar("nointernet".tr(), context);
  //   }
  // }

  // Future<void> sendOtp(String phone, SendOtpProvider creat) async {
  //   _isNetworkAvail = await isNetworkAvailable();
  //   if (_isNetworkAvail) {
  //     print("There is internet");
  //     print(phone);
  //     Loader.show(context, progressIndicator: LoaderWidget());
  //     await creat.getSendOtp(phone, 'forget_password');
  //     if (creat.data.error == false) {
  //       Loader.hide();
  //       setSnackbar("sendotpsuccess".tr(), context);
  //       print(creat.data.data!.code);
  //       setState(() {
  //         Future.delayed(const Duration(seconds: 3)).then((_) async {
  //           Navigator.of(context).push(
  //             PageRouteBuilder(
  //               pageBuilder: (BuildContext context, Animation<double> animation,
  //                   Animation<double> secondaryAnimation) {
  //                 return PhoneVerification(
  //                   phone: widget.emailOrPhone,
  //                   code: creat.data.data!.code.toString(),
  //                   isDriver: widget.isDriver == true ? true : false,
  //                   isFromForgetPass: true,
  //                 );
  //               },
  //               transitionsBuilder: (BuildContext context,
  //                   Animation<double> animation,
  //                   Animation<double> secondaryAnimation,
  //                   Widget child) {
  //                 return Align(
  //                   child: SizeTransition(
  //                     sizeFactor: animation,
  //                     child: child,
  //                   ),
  //                 );
  //               },
  //               transitionDuration: Duration(milliseconds: 500),
  //             ),
  //           );
  //         });
  //       });
  //     } else {
  //       Loader.hide();
  //       setSnackbar(creat.data.message.toString(), context);
  //     }
  //   } else {
  //     setSnackbar("nointernet".tr(), context);
  //   }
  // }

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
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 5.h),
                          Center(
                            child: Text(
                              widget.title.tr(),
                              // 'forget'.tr(),
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
                                indent: 20.w,
                                endIndent: 25.w,
                                thickness: 5,
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Container(
                            height: 6.h,
                            width: 80.w,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: TextFormField(
                                // keyboardType: TextInputType.number,
                                controller: passwordController,
                                obscureText: showPassword == true ? false : true,
                                decoration: InputDecoration(
                                  errorStyle:
                                      TextStyle(fontSize: 4.sp, height: 0.01.h),
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
                                ),
                                onChanged: (value) {},
                                validator: (value) =>
                                    Validators.validatePassword(value),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            height: 6.h,
                            width: 80.w,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: TextFormField(
                                controller: confirmPasswordController,
                                obscureText: showPassword2 == true ? false : true,
                                decoration: InputDecoration(
                                  errorStyle:
                                      TextStyle(fontSize: 4.sp, height: 0.01.h),
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 5.sp,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: showPassword2 == true
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
                                        if (showPassword2 == false) {
                                          showPassword2 = true;
                                          print(showPassword2);
                                        } else {
                                          showPassword2 = false;
                                          print(showPassword2);
                                        }
                                      });
                                    },
                                  ),
                                  hintText: 'confirm hint'.tr(),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {},
                                validator: (value) =>
                                    Validators.validatePassword(value),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          ContainerWidget(
                              text: 'save'.tr(),
                              h: 7.h,
                              w: 80.w,
                              onTap: () async {
                                if (formKey.currentState?.validate() == true) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  print("save");
                                  print(passwordController.text ==
                                      confirmPasswordController.text);
                                  print(widget.emailOrPhone);
                                  print(widget.isEmail);
                                  if (passwordController.text ==
                                      confirmPasswordController.text) {
                                    // if (widget.isEmail == true) {
                                    //   print(widget.emailOrPhone);
                                    //   var creat = Provider.of<
                                    //           ForgetPasswordEmailProvider>(
                                    //       context,
                                    //       listen: false);
                                    //   validateAndSubmitEmail(
                                    //       widget.emailOrPhone,
                                    //       passwordController.text,
                                    //       confirmPasswordController.text,
                                    //       creat);
                                    // } else {
                                      print(widget.emailOrPhone);
                                      var creat =
                                          Provider.of<ForgetPasswordProvider>(
                                              context,
                                              listen: false);
                                      validateAndSubmitPhone(
                                          widget.emailOrPhone,
                                          passwordController.text,
                                          confirmPasswordController.text,
                                          creat);
                                    // }
                                  } else {
                                    setSnackbar(
                                        'password not matching'.tr(), context);
                                  }
                                } else {
                                  print("not validate");
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                // Row(
                //   children: [
                //     SizedBox(width: 8.w),
                //     IconButton(
                //       icon: ImageIcon(
                //         const AssetImage(back),
                //         color: backgroundColor,
                //         size: iconSize,
                //       ),
                //       onPressed: () {
                //         Navigator.of(context).pop();
                //       },
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
