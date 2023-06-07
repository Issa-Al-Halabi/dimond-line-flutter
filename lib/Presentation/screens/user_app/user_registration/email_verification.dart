import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/send_otp_email_provider.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/verify_otp_email_provider.dart';
import 'package:diamond_line/Presentation/widgets/code_verification.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../constants.dart';
import '../../../Functions/helper.dart';
import '../../../widgets/loader_widget.dart';

class EmailVerification extends StatefulWidget {
  EmailVerification({required this.email, Key? key}) : super(key: key);
  String email;

  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  TextEditingController verification = TextEditingController();
  String _code = "";
  bool _isNetworkAvail = true;
  bool isClickable = false;

  @override
  void initState() {
    setState(() {
      isClickable = true;
      Future.delayed(const Duration(seconds: 60)).then((_) async {
        isClickable = false;
      });
    });
    super.initState();
  }

  // verify email otp
  void validateAndSubmit(
      String phone, String code, VerifyOtpEmailProvider R) async {
    checkNetwork(phone, code, R);
  }

  Future<void> checkNetwork(
      String email, String code, VerifyOtpEmailProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      print(email);
      print(code);
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.getVerifyOtpEmailCode(email, code);
      // if (creat.data.error == "false")
      if (creat.data.erorr == false) {
        Loader.hide();
        setSnackbar("success".tr(), context);
        setState(() {
          Future.delayed(const Duration(seconds: 1)).then((_) async {
            Navigator.pushNamed(context, 'registration2');
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
            setSnackbar("enter all fields".tr(), context);
            _isNetworkAvail = false;
          });
        }
      });
    }
  }

  // resend email otp
  Future<void> resendOtp(String email, SendOtpEmailProvider creat) async {
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
          isClickable = false;
          Future.delayed(const Duration(seconds: 60)).then((_) async {
            isClickable = true;
          });
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
      print("nointernet");
      Future.delayed(const Duration(seconds: 2)).then((_) async {
        if (mounted) {
          setState(() {
            setSnackbar("enter all fields".tr(), context);
            _isNetworkAvail = false;
          });
        }
      });
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
                    topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                color: backgroundColor,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 5.h),
                    Center(
                      child: Text(
                        'email verification'.tr(),
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
                            var creat3 = Provider.of<SendOtpEmailProvider>(
                                context,
                                listen: false);
                            resendOtp(widget.email, creat3);
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
                          print('widget.email' + widget.email);
                          var creat = Provider.of<VerifyOtpEmailProvider>(context,
                              listen: false);
                          validateAndSubmit(widget.email, _code, creat);
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