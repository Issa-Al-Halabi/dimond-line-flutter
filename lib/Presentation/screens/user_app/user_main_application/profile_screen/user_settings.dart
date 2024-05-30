import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Presentation/Functions/Validators.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/profile_screen/user_trips_settings.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/profile_screen/web_view.dart';
import 'package:diamond_line/Presentation/widgets/container_with_icon.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../Data/network/requests.dart';
import '../../../../../constants.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../../../Functions/helper.dart';
import '../../user_registration/are_you.dart';
import '../../user_registration/sign_in_sign_up.dart';
import 'contact_us.dart';
import 'user_profile_settings.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

enum Languages { Arabic, English }

class _UserSettingsState extends State<UserSettings> {
  late Languages selectedLanguage;
  late SharedPreferences prefs;
  bool _isNetworkAvail = true;
  TextEditingController complaintController = TextEditingController();

  @override
  void initState() {
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
    // if (language == Languages.Arabic)
    // {
    //   selectedLanguage = Languages.Arabic;
    //   print(selectedLanguage);
    // }
    // else{
    //   selectedLanguage = Languages.English;
    //   print(selectedLanguage);
    // }
  }

  void checkLang(BuildContext context) {
    if (context.locale.toString() == 'ar_AR') {
      selectedLanguage = Languages.Arabic;
    } else {
      selectedLanguage = Languages.English;
    }
  }

  ////////////////// sign out api //////////////////////////
  Future<void> SignOutApi() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      Loader.show(context, progressIndicator: LoaderWidget());
      var data = await AppRequests.signOutRequest();
      data = json.decode(data);
      if (data["error"] == false) {
        Loader.hide();
        // setState(() {
        setSnackbar(data["message"].toString(), context);
        prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        // SystemNavigator.pop();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => AreYou()));
      } else {
        Loader.hide();
        setSnackbar(data["message"].toString(), context);
      }
    } else {
      setSnackbar("nointernet".tr(), context);
      print("nointernet");
    }
  }

  ///////////////////////// complaint api //////////////////////////////////
  Future<void> complaintApi(String description) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      var data = await AppRequests.complaintRequest(description);
      print(data);
      data = json.decode(data);
      if (data["error"] == false) {
        Loader.hide();
        setSnackbar(data["message"].toString(), context);
      } else {
        Loader.hide();
        setSnackbar(data["message"].toString(), context);
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
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: primaryBlue),
      ),
      backgroundColor: white,
      elevation: 1.0,
    ));
  }

  LogoutDialog(String Text, BuildContext context) {
    AwesomeDialog(
      context: context,
      width: MediaQuery.of(context).size.width > 1201
          ? 500.0
          : MediaQuery.of(context).size.width > 1025
              ? 400.0
              : MediaQuery.of(context).size.width,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      btnOkColor: primaryBlue,
      padding: EdgeInsets.only(left: 10, right: 10),
      animType: AnimType.topSlide,
      title: Text + 'logout'.tr() + '?'.tr(),
      desc: "",
      showCloseIcon: true,
      btnCancelText: 'no'.tr(),
      btnOkText: 'yes'.tr(),
      btnOkOnPress: () async {
        SignOutApi();
      },
      btnCancelOnPress: () {
        // Navigator.of(context).pop(false);
      },
    )..show();
  }

  deleteAccountDialog(String text, BuildContext context) {
    return AwesomeDialog(
      context: context,
      width: MediaQuery.of(context).size.width > 1201
          ? 500.0
          : MediaQuery.of(context).size.width > 1025
              ? 400.0
              : MediaQuery.of(context).size.width,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      btnOkColor: primaryBlue,
      padding: EdgeInsets.only(left: 10, right: 10),
      animType: AnimType.topSlide,
      title: text + 'delete'.tr() + '?'.tr(),
      desc: "",
      showCloseIcon: true,
      btnCancelText: 'cancel'.tr(),
      btnOkText: 'ok'.tr(),
      btnOkOnPress: () async {
        print(phoneController.text);
        print(passwordController.text);
        deleteAccount(phoneController.text, passwordController.text);
      },
      btnCancelOnPress: () {
        // Navigator.of(context).pop();
      },
      body: Column(
        children: [
          TextFormField(
            controller: phoneController,
            maxLength: 9,
            style: TextStyle(
              color: primaryBlue,
            ),
            decoration: InputDecoration(
              label: Text('enter phone'.tr()),
              fillColor: Colors.white,
            ),
            onSaved: (String? value) {},
          ),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            obscuringCharacter: "*",
            style: TextStyle(
              color: primaryBlue,
            ),
            decoration: InputDecoration(
              label: Text('ENTER_PASSWORD'.tr()),
              fillColor: Colors.white,
            ),
            onSaved: (String? value) {},
            validator: (val) => Validators.validatePassword(val),
          ),
        ],
      ),
    )..show();
  }

  Future<void> deleteAccount(String phone, String password) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      Loader.show(context, progressIndicator: LoaderWidget());
      var data = await AppRequests.userDeleteAccountRequest(phone, password);
      data = json.decode(data);
      if (data["error"] == false) {
        Loader.hide();
        prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        setState(() {
          Future.delayed(const Duration(seconds: 1)).then((_) async {
            // Navigator.pop(context);
            setSnackbar(data["message"].toString(), context);
            Navigator.of(context).pushReplacement(
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
          });
        });
      } else {
        Loader.hide();
        setSnackbar(data["message"].toString(), context);
      }
    } else {
      setSnackbar("nointernet".tr(), context);
    }
  }

  sendComplaintDialog(BuildContext context) {
    return AwesomeDialog(
      context: context,
      width: MediaQuery.of(context).size.width > 1201
          ? 500.0
          : MediaQuery.of(context).size.width > 1025
              ? 400.0
              : MediaQuery.of(context).size.width,
      dialogType: DialogType.info,
      headerAnimationLoop: false,
      btnOkColor: primaryBlue,
      padding: EdgeInsets.only(left: 10, right: 10),
      animType: AnimType.topSlide,
      title: 'complaint'.tr(),
      desc: 'enter your complaint please'.tr(),
      showCloseIcon: true,
      btnCancelText: 'cancel'.tr(),
      btnOkText: 'send comp'.tr(),
      btnOkOnPress: () async {
        print(complaintController.text);
        complaintApi(complaintController.text);
      },
      btnCancelOnPress: () {
        // Navigator.of(context).pop();
      },
      body: Column(
        children: [
          TextFormField(
            controller: complaintController,
            style: TextStyle(
              color: primaryBlue,
            ),
            decoration: InputDecoration(
              label: Text('enter your complaint please'.tr()),
              fillColor: Colors.white,
            ),
            onSaved: (String? value) {},
          ),
        ],
      ),
    )..show();
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
            padding: EdgeInsets.only(
              top: 9.h,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: getScreenWidth(context),
                    // height: 82.h,
                    height: 90.h,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: backgroundColor,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 5.h),
                          ContainerWithIcon(
                            text: 'profile'.tr(),
                            h: 6.h,
                            w: 80.w,
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    return UserProfileSettings();
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
                                  transitionDuration:
                                      Duration(milliseconds: 500),
                                ),
                              );
                            },
                            color: backgroundColor,
                            textColor: lightBlue4,
                            iconImage: profile,
                            iconColor: lightBlue4,
                          ),
                          SizedBox(height: 2.h),
                          ContainerWithIcon(
                            text: 'trips'.tr(),
                            h: 6.h,
                            w: 80.w,
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    return UserTripsSettings();
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
                                  transitionDuration:
                                      Duration(milliseconds: 500),
                                ),
                              );
                            },
                            color: backgroundColor,
                            textColor: lightBlue4,
                            iconImage: trips,
                            iconColor: lightBlue4,
                          ),
                          SizedBox(height: 2.h),
                          ContainerWithIcon(
                            text: 'lang'.tr(),
                            h: 6.h,
                            w: 80.w,
                            onTap: () {
                              checkLang(context);
                              AwesomeDialog(
                                      context: context,
                                      animType: AnimType.scale,
                                      btnOkColor: primaryBlue,
                                      dialogType: DialogType.noHeader,
                                      padding: const EdgeInsets.all(10),
                                      body: StatefulBuilder(
                                        builder: (context, setState) {
                                          return Column(
                                            children: [
                                              ListTile(
                                                title: InkWell(
                                                  child: myText(
                                                    text: 'عربي',
                                                    fontSize: 5.sp,
                                                    color: selectedLanguage ==
                                                            Languages.Arabic
                                                        ? primaryBlue
                                                        : grey,
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      selectedLanguage =
                                                          Languages.Arabic;
                                                      print(selectedLanguage);
                                                    });
                                                  },
                                                ),
                                              ),
                                              ListTile(
                                                title: InkWell(
                                                  child: myText(
                                                    text: 'English',
                                                    fontSize: 5.sp,
                                                    color: selectedLanguage ==
                                                            Languages.English
                                                        ? primaryBlue
                                                        : grey,
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      selectedLanguage =
                                                          Languages.English;
                                                      print(selectedLanguage);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      title: 'This is Ignored',
                                      desc: 'This is also Ignored',
                                      btnOkOnPress: () {
                                        if (selectedLanguage ==
                                            Languages.Arabic) {
                                          if (context.locale !=
                                              const Locale('ar'))
                                            // setState(() {
                                            context
                                                .setLocale(Locale('ar', 'AR'));
                                          // });
                                        } else {
                                          if (context.locale !=
                                              const Locale('en'))
                                            // setState(() {
                                            context
                                                .setLocale(Locale('en', 'US'));
                                          // });
                                        }
                                      },
                                      btnOkText: 'ok'.tr())
                                  .show();
                            },
                            color: backgroundColor,
                            textColor: lightBlue4,
                            iconImage: lang,
                            iconColor: lightBlue4,
                          ),
                          SizedBox(height: 2.h),
                          ContainerWithIcon(
                            text: 'priv poli'.tr(),
                            h: 6.h,
                            w: 80.w,
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    //TODO
                                    return WebViewScreen(
                                      url:
                                          'https://diamond-line.com.sy/admin/policy',
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
                                  transitionDuration:
                                      Duration(milliseconds: 500),
                                ),
                              );
                            },
                            color: backgroundColor,
                            textColor: lightBlue4,
                            iconImage: privacy,
                            iconColor: lightBlue4,
                          ),
                          // SizedBox(height: 2.h),
                          // ContainerWithIcon(
                          //   text: 'term cond'.tr(),
                          //   h: 6.h,
                          //   w: 80.w,
                          //   onTap: () {
                          //     Navigator.of(context).push(
                          //       PageRouteBuilder(
                          //         pageBuilder: (BuildContext context,
                          //             Animation<double> animation,
                          //             Animation<double> secondaryAnimation) {
                          //           //TODO
                          //           return WebViewScreen(url: '',);
                          //         },
                          //         transitionsBuilder: (BuildContext context,
                          //             Animation<double> animation,
                          //             Animation<double> secondaryAnimation,
                          //             Widget child) {
                          //           return Align(
                          //             child: SizeTransition(
                          //               sizeFactor: animation,
                          //               child: child,
                          //             ),
                          //           );
                          //         },
                          //         transitionDuration: Duration(milliseconds: 500),
                          //       ),
                          //     );
                          //   },
                          //   color: backgroundColor,
                          //   textColor: lightBlue4,
                          //   iconImage: terms,
                          //   iconColor: lightBlue4,
                          // ),
                          SizedBox(height: 2.h),
                          ContainerWithIcon(
                            text: 'emergency'.tr(),
                            h: 6.h,
                            w: 80.w,
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    //TODO
                                    return WebViewScreen(
                                      url:
                                          'https://diamond-line.com.sy/admin/emergency',
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
                                  transitionDuration:
                                      Duration(milliseconds: 500),
                                ),
                              );
                            },
                            color: backgroundColor,
                            textColor: lightBlue4,
                            iconImage: emergency,
                            iconColor: lightBlue4,
                          ),
                          SizedBox(height: 2.h),
                          ContainerWithIcon(
                            text: 'contact'.tr(),
                            h: 6.h,
                            w: 80.w,
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    return ContactUsScreen(
                                      isUser: true,
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
                                  transitionDuration:
                                      Duration(milliseconds: 500),
                                ),
                              );
                            },
                            color: backgroundColor,
                            textColor: lightBlue4,
                            iconImage: call,
                            iconColor: lightBlue4,
                          ),
                          SizedBox(height: 2.h),
                          ContainerWithIcon(
                            text: 'about'.tr(),
                            h: 6.h,
                            w: 80.w,
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    // return AboutUsScreen();
                                    return WebViewScreen(
                                      url: 'https://sub.diamond-line.com.sy',
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
                                  transitionDuration:
                                      Duration(milliseconds: 500),
                                ),
                              );
                            },
                            color: backgroundColor,
                            textColor: lightBlue4,
                            iconImage: about,
                            iconColor: lightBlue4,
                          ),
                          SizedBox(height: 2.h),
                          ContainerWithIcon(
                            text: 'complaint'.tr(),
                            h: 6.h,
                            w: 80.w,
                            onTap: () async {
                              print('tap');
                              sendComplaintDialog(context);
                            },
                            color: backgroundColor,
                            textColor: lightBlue4,
                            iconImage: complaint,
                            iconColor: lightBlue4,
                          ),
                          SizedBox(height: 2.h),
                          ContainerWithIcon(
                            text: 'delete'.tr(),
                            h: 6.h,
                            w: 80.w,
                            onTap: () async {
                              print('tap');
                              deleteAccountDialog('are you sure'.tr(), context);
                            },
                            color: backgroundColor,
                            textColor: lightBlue4,
                            iconImage: delete,
                            iconColor: lightBlue4,
                          ),
                          SizedBox(height: 2.h),
                          ContainerWithIcon(
                            text: 'sign out'.tr(),
                            h: 6.h,
                            w: 80.w,
                            onTap: () async {
                              print('tap');
                              LogoutDialog('are you sure'.tr(), context);
                            },
                            color: backgroundColor,
                            textColor: lightBlue4,
                            // iconImage: exit,
                            iconImage: logout,
                            iconColor: lightBlue4,
                          ),
                          // SizedBox(height: 2.h),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
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
