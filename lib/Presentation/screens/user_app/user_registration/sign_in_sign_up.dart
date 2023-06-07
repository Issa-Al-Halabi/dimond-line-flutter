import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import '../../../widgets/loader_widget.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/email_login_provider.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/login_provider.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/send_otp_email_provider.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/send_otp_provider.dart';
import 'package:diamond_line/Presentation/Functions/Validators.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_registration/email_verification.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_registration/phone_verification.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Functions/helper.dart';
import '../../../widgets/phone_field.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import '../../../../constants.dart';
import '../user_main_application/main_screen/user_dashboard.dart';
import 'package:flutter_html/flutter_html.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

bool totalAgree = false;
bool isAgree = false;
bool newValue = false;

class _LoginScreenState extends State<LoginScreen> {
  bool newValue2 = false;
  String type = '';
  int signUpIndex = 0;
  int loginIndex = 0;
  bool _isNetworkAvail = true;
  String? token;
  bool showPassword = false;
  var formKey = GlobalKey<FormState>();
  var formKey2 = GlobalKey<FormState>();
  var formKey3 = GlobalKey<FormState>();
  var formKey4 = GlobalKey<FormState>();
  late SharedPreferences prefs;
  String? fcm;
  String? privacy;

  @override
  void initState() {
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    termsApi();
    initShared();
    super.initState();
  }


  Future initShared() async {
    prefs = await SharedPreferences.getInstance();
    print('fcm');
    fcm = prefs.getString('fcm_token') ?? '';
    print(fcm);
  }

  /////////////////// terms and conditions /////////////////////
  Future<void> termsApi() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      var data = await AppRequests.termsRequest();
      data = json.decode(data);
      print(data['reference']);
      setState(() {
        privacy = data['reference'].toString();
      });
    } else {
      setSnackbar("nointernet".tr(), context);
    }
  }

  ////////////////////////////login api with phone (syrian)/////////////////////////////////////
  Future<void> loginPhoneApi(
      String phone, String pass, LogInProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.getLogin(phone, pass, true);
      if (creat.data.error == false) {
        Loader.hide();
        token = creat.data.data!.apiToken;
        // setSnackbar("logsuccess".tr(), context);
        setState(() {
          Future.delayed(const Duration(seconds: 1)).then((_) async {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return UserDashboard();
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
      print("nointernet");
      Future.delayed(const Duration(seconds: 2)).then((_) async {
        if (mounted) {
          setState(() {
            _isNetworkAvail = false;
          });
        }
      });
    }
  }

  ///////////////////////////send otp code registration api ///////////////////////////////////////
  Future<void> sendOtpRegistrationApi(
      String phone, SendOtpProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.getSendOtp(phone, 'sign_up', true);
      if (creat.data.error == false) {
        Loader.hide();
        setSnackbar("sendotpsuccess".tr(), context);
        print(creat.data.data!.code);
        setState(() {
          Future.delayed(const Duration(seconds: 3)).then((_) async {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return PhoneVerification(
                    phone: phoneController.text,
                    code: creat.data.data!.code.toString(),
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
      print("nointernet");
      Future.delayed(const Duration(seconds: 2)).then((_) async {
        if (mounted) {
          setState(() {
            _isNetworkAvail = false;
          });
        }
      });
    }
  }

  ///////////////////////////send otp code email foreigner api ///////////////////////////////////////
  Future<void> sendOtpEmailForeignerApi(
      String email, SendOtpEmailProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.getSendOtpEmail(email);
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
                  return EmailVerification(
                    email: emailController.text,
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
      print("nointernet");
      Future.delayed(const Duration(seconds: 2)).then((_) async {
        if (mounted) {
          setState(() {
            // setSnackbar("enter all fields".tr(), context);
            _isNetworkAvail = false;
          });
        }
      });
    }
  }

/////////////////////////////////log in api with email(foreigner)/////////////////////////////////
  Future<void> loginEmailApi(
      String email, String pass, EmailLogInProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.getEmailLogin(email, pass);
      if (creat.data.error == false) {
        Loader.hide();
        token = creat.data.data!.apiToken;
        setState(() {
          Future.delayed(const Duration(seconds: 1)).then((_) async {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  // return SelectType();
                  return UserDashboard();
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
      print("nointernet");
      Future.delayed(const Duration(seconds: 2)).then((_) async {
        if (mounted) {
          setState(() {
            _isNetworkAvail = false;
          });
        }
      });
    }
  }

  Future<void> sendOtpForgetApi(String phone, SendOtpProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      print(phone);
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.getSendOtp(phone, 'forget_password', true);
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
                    isDriver: false,
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

  setSnackbar(
      String msg,
      BuildContext context,
      ) {
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

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert(
          privacy: privacy,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPopLoader,
      child: Scaffold(
        backgroundColor: primaryBlue,
        body: SingleChildScrollView(
            child: Container(
              height: getScreenHeight(context),
              width: getScreenWidth(context),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(background),
                  fit: BoxFit.fill,
                ),
              ),
              child: DefaultTabController(
                length: 2,
                child: Padding(
                  padding: EdgeInsets.only(top: 9.h, bottom: 7.h),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: backgroundColor,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10.h,
                          child: TabBar(
                            indicatorColor: primaryBlue2,
                            tabs: [
                              Tab(
                                child: myText(
                                  text: 'login'.tr(),
                                  fontSize: 6.sp,
                                  color: primaryBlue,
                                ),
                              ),
                              Tab(
                                child: myText(
                                    text: 'signup'.tr(),
                                    fontSize: 6.sp,
                                    color: primaryBlue),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(children: [
                            // first tab bar view widget for login
                            IndexedStack(
                              index: loginIndex,
                              children: [
                                // first index for indexed stack log in
                                Form(
                                  key: formKey,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(height: 15.h),
                                        Builder(builder: (context) {
                                          return PhoneField(
                                            txt: phoneController,
                                            onSaved: (value) {
                                              setState(() {
                                                phoneController.text = value!;
                                              });
                                            },
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
                                                color:
                                                    Colors.grey.withOpacity(0.3),
                                                spreadRadius: 2,
                                                blurRadius: 7,
                                                offset: Offset(0, 0),
                                              ),
                                            ],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 5.w, right: 5.w),
                                            child: TextFormField(
                                              controller: passwordController,
                                              obscureText: showPassword == true
                                                  ? false
                                                  : true,
                                              decoration: InputDecoration(
                                                errorStyle: TextStyle(
                                                    fontSize: 4.sp,
                                                    height: 0.01.h),
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
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (phoneController.text.length ==
                                                    9) {
                                                  print(phoneController.text);
                                                  var creat = Provider.of<
                                                          SendOtpProvider>(
                                                      context,
                                                      listen: false);
                                                  sendOtpForgetApi(
                                                      phoneController.text,
                                                      creat);
                                                } else {
                                                  setSnackbar(
                                                      'tapPhone'.tr(), context);
                                                }
                                              },
                                              child: Text(
                                                "forget?".tr(),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 4.sp,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor: grey,
                                                  decorationThickness: 1,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.h),
                                        ContainerWidget(
                                            text: 'login'.tr(),
                                            h: 7.h,
                                            w: 80.w,
                                            onTap: () async {
                                              if (formKey.currentState
                                                      ?.validate() ==
                                                  true) {
                                                FocusManager.instance.primaryFocus
                                                    ?.unfocus();
                                                print("save");
                                                print(phoneController.text);
                                                print(passwordController.text);
                                                var creat =
                                                    Provider.of<LogInProvider>(
                                                        context,
                                                        listen: false);
                                                loginPhoneApi(
                                                    phoneController.text,
                                                    passwordController.text,
                                                    creat);
                                              } else {
                                                print('not validate');
                                              }
                                            }),
                                        SizedBox(height: 10.h),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                child: Form(
                              key: formKey2,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    Center(
                                      child: myText(
                                        text: 'signup phone'.tr(),
                                        fontSize: 5.sp,
                                        color: grey,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    Builder(builder: (context) {
                                      return PhoneField(
                                        txt: phoneController,
                                        onSaved: (value) {
                                          setState(() {
                                            phoneController.text = value!;
                                          });
                                          validateFunction:
                                          (value) =>
                                              Validators.validatePhoneNumber(
                                                  value);
                                        },
                                        validateFunction: (value) =>
                                            Validators.validatePhoneNumber(value),
                                      );
                                    }),
                                    SizedBox(
                                      height: 2.h,
                                    ),
                                    InkWell(
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            // Builder(builder: (context) {
                                            //   return Checkbox(
                                            //     materialTapTargetSize:
                                            //         MaterialTapTargetSize
                                            //             .shrinkWrap,
                                            //     value: newValue,
                                            //     activeColor: primaryBlue,
                                            //     onChanged: (bool? value) {
                                            //       setState(() {
                                            //         newValue = value!;
                                            //         isAgree = value;
                                            //         print(isAgree);
                                            //         if (isAgree == true) {
                                            //           showAlertDialog(context);
                                            //         } else {
                                            //           totalAgree = false;
                                            //           isAgree = false;
                                            //         }
                                            //       });
                                            //     },
                                            //   );
                                            // }),
                                            getAgreeText(),
                                          ]),
                                      onTap: () {
                                        showAlertDialog(context);
                                      },
                                    ),
                                    SizedBox(
                                      height: 22.h,
                                    ),
                                    ContainerWidget(
                                        text: 'send code'.tr(),
                                        h: 8.h,
                                        w: 80.w,
                                        onTap: () async {
                                          if (formKey2.currentState?.validate() ==
                                              true) {
                                            if (totalAgree == true) {
                                              print(phoneController.text);
                                              print(type);
                                              var creat2 =
                                                  Provider.of<SendOtpProvider>(
                                                      context,
                                                      listen: false);
                                              sendOtpRegistrationApi(
                                                  phoneController.text, creat2);
                                            } else {
                                              // setSnackbar(
                                              //     "agreePolicy".tr(), context);
                                              showAlertDialog(context);

                                              // Future.delayed(
                                              //         const Duration(seconds: 2))
                                              //     .then((_) async {
                                              // showAlertDialog(context);
                                              // });
                                            }
                                          } else {
                                            print("not validate");
                                          }
                                        })
                                  ]),
                            )),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ),
    );
  }
}

class alert extends StatefulWidget {
  String? privacy;

  @override
  _MyDialogState createState() => new _MyDialogState();

  alert({Key? key, this.privacy}) : super(key: key);
}

class _MyDialogState extends State<alert> {
  bool agreeTerm = false;

  void notAgree(setState) {
    print(isAgree);
    print(newValue);
    setState(() {
      isAgree = false;
      newValue = false;
      print(isAgree);
      print(newValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return StatefulBuilder(builder: (context, StateSetter setState) {
        return AlertDialog(
          title: Center(
              child: myText(
            text: 'TERM'.tr() + '\n\n' + "agreePolicy".tr(),
                fontSize: 4.sp,
            color: primaryBlue,
          )),
          content: Scrollbar(
            isAlwaysShown: true,
            showTrackOnHover: true,
            interactive: true,
            child: Container(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  widget.privacy != null && widget.privacy != ""
                      ? Html(
                          data: widget.privacy.toString(),
                        )
                      : CircularProgressIndicator(color: primaryBlue),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        child: Checkbox(
                          value: agreeTerm,
                          onChanged: (value1) {
                            setState(() {
                              agreeTerm = value1 ?? false;
                              if (agreeTerm == true) {
                                totalAgree = true;
                              } else {
                                totalAgree = false;
                                notAgree(setState);
                                // isAgree = false;
                                // newValue = false;
                              }
                            });
                            // Navigator.of(context).pop();
                          },
                        ),
                      ),
                      // myText(text: 'CONTINUE'.tr(), fontSize: 4.sp, color: primaryBlue,),
                      myText(
                        text: 'AGREE'.tr(),
                        fontSize: 4.sp,
                        color: primaryBlue,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 3.0,
                  ),
                ],
              )),
            ),
          ),
        );
      });
    });
  }
}
