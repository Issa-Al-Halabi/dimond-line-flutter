import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import '../../../../Buisness_logic/provider/User_Provider/send_otp_provider.dart';
import '../../../widgets/loader_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:diamond_line/Presentation/Functions/Validators.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:diamond_line/Presentation/widgets/container_widget3.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import '../../../../Buisness_logic/provider/Driver_Provider/driver_complete_register_provider.dart';
import '../../../../Buisness_logic/provider/Driver_Provider/driver_register_provider.dart';
import '../../../../Data/network/requests.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Functions/helper.dart';
import '../../../Widgets/text.dart';
import '../../../widgets/container_with_textfield.dart';
import 'package:image_picker/image_picker.dart';
import '../../user_app/user_registration/phone_verification.dart';
import '../driver_main_application/driver_main_screen/driver_dashboard.dart';

class RegistrationDriver extends StatefulWidget {
  const RegistrationDriver({Key? key}) : super(key: key);

  @override
  State<RegistrationDriver> createState() => _RegistrationDriverState();
}

bool totalAgree = false;
bool isAgree = false;

class _RegistrationDriverState extends State<RegistrationDriver> {
  final picker = ImagePicker();
  XFile? image;
  File? idCardImage;
  File? CarImage;
  File? drivingCertiImage;
  File? carMechaImage;
  File? carInsuImage;
  String idCardStr = 'id card image'.tr();
  String carImgStr = 'car image'.tr();
  String driCertiStr = 'driving certi image'.tr();
  String carMechaStr = 'car mecha image'.tr();
  String carInsuStr = 'car insu image'.tr();
  bool _isNetworkAvail = true;
  String typeDriver = '';
  var formKey = GlobalKey<FormState>();
  bool newValue = false;

  String? privacy;

  @override
  void initState() {
    initBoolean();
    termsApi();
    super.initState();
  }

  initBoolean(){
     totalAgree = false;
     isAgree = false;
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

  void init() async {
    if (CarImage != null && idCardImage != null) {
      driverCompleteRegisterApi(
        CarImage!,
        idCardImage!,
        drivingCertiImage!,
      );
    } else if (CarImage != null) {
      driverCompleteRegisterApi(
        CarImage!,
        drivingCertiImage!,
      );
    } else if (idCardImage != null) {
      driverCompleteRegisterApi(
        idCardImage!,
        drivingCertiImage!,
      );
    } else {
      driverCompleteRegisterApi(
        drivingCertiImage!,
      );
    }
  }

  ////////////////////driver register api///////////////////////////
  Future<void> driverRegisterApi(
    String first_name,
    String last_name,
    String email,
    String password,
    String phone, [
    File? car_mechanic,
    File? car_insurance,
  ]) async {
    _isNetworkAvail = await isNetworkAvailable();
    var creat =
        await Provider.of<DriverRegisterProvider>(context, listen: false);
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      if (car_mechanic != null && car_insurance != null) {
        await creat.DriverCreatAcountwithphoto(
          first_name,
          last_name,
          email,
          password,
          phone,
          car_mechanic,
          car_insurance,
        );
      } else if (car_mechanic != null) {
        await creat.DriverCreatAcountwithphoto(
          first_name,
          last_name,
          email,
          password,
          phone,
          car_mechanic,
        );
      } else if (car_insurance != null) {
        await creat.DriverCreatAcountwithphoto(
          first_name,
          last_name,
          email,
          password,
          phone,
          car_insurance,
        );
      } else {
        await creat.DriverCreatAcountwithphoto(
            first_name, last_name, email, password, phone);
      }
      print(creat.data.error);
      print(creat.data.message);
      if (creat.data.error == false) {
        Loader.hide();
        setState(() {
          if (creat.data.data!.user!.userType == 'external_driver') {
            typeDriver = 'external_driver';
          } else {
            typeDriver = 'driver';
          }
          init();
        });
      } else {
        Loader.hide();
        print(creat.data.message);
        setSnackbar(creat.data.message.toString(), context);
      }
    } else {
      setSnackbar("nointernet".tr(), context);
      Future.delayed(const Duration(seconds: 2)).then((_) async {
        if (mounted) {
          setState(() {
            _isNetworkAvail = false;
          });
        }
      });
    }
  }

  ////////////////////driver complete register api///////////////////////////
  Future<void> driverCompleteRegisterApi(
      [File? car_image,
      File? personal_identity,
      File? driving_certificate]) async {
    _isNetworkAvail = await isNetworkAvailable();
    var creat = await Provider.of<DriverCompleteRegisterProvider>(context,
        listen: false);
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      if (car_image != null && personal_identity != null) {
        await creat.driverCompleteRegister(
          car_image,
          personal_identity,
          driving_certificate,
        );
      } else if (car_image != null) {
        await creat.driverCompleteRegister(
          car_image,
          driving_certificate,
        );
      } else if (personal_identity != null) {
        await creat.driverCompleteRegister(
          personal_identity,
          driving_certificate,
        );
      } else {
        await creat.driverCompleteRegister(
          driving_certificate,
        );
      }
      print(creat.data.error);
      print(creat.data.message);
      if (creat.data.error == false) {
        Loader.hide();
        setSnackbar("success".tr(), context);
        setState(() {
          Future.delayed(const Duration(seconds: 1)).then((_) async {
            // if (typeDriver == 'external_driver') {
            //   // Navigator.pushNamed(context, 'out_driver_main_screen');
            //   Navigator.of(context).push(
            //     PageRouteBuilder(
            //       pageBuilder: (BuildContext context,
            //           Animation<double> animation,
            //           Animation<double> secondaryAnimation) {
            //         // return OutDriverMainScreen();
            //         return DriverDashboard(
            //           driverType: 'external_driver',
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
            // } else {
            //   Navigator.of(context).push(
            //     PageRouteBuilder(
            //       pageBuilder: (BuildContext context,
            //           Animation<double> animation,
            //           Animation<double> secondaryAnimation) {
            //         return DriverDashboard(
            //           driverType: 'driver',
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
            var creat = Provider.of<SendOtpProvider>(context, listen: false);
            sendOtpApi( phoneController.text, creat);
          });
        });
      } else {
        Loader.hide();
        print(creat.data.message);
        setSnackbar(creat.data.message.toString(), context);
      }
    } else {
      setSnackbar("nointernet".tr(), context);
      Future.delayed(const Duration(seconds: 1)).then((_) async {
        if (mounted) {
          setState(() {
            _isNetworkAvail = false;
          });
        }
      });
    }
  }

  Future<void> sendOtpApi(String phone, SendOtpProvider creat) async {
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
                    isFromForgetPass: false,
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
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      ContainerWithTextField(
                        hintText: 'first name'.tr(),
                        h: 6.h,
                        w: 90.w,
                        onTap: () {},
                        txtController: firstNameController,
                        validateFunction: (value) =>
                            Validators.validateName(value),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      ContainerWithTextField(
                        hintText: 'last name'.tr(),
                        h: 6.h,
                        w: 90.w,
                        onTap: () {},
                        txtController: lastNameController,
                        validateFunction: (value) =>
                            Validators.validateName(value),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      ContainerWithTextField(
                        hintText: 'email'.tr(),
                        h: 6.h,
                        w: 90.w,
                        onTap: () {},
                        txtController: emailController,
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      ContainerWithTextField(
                        hintText: 'password'.tr(),
                        h: 6.h,
                        w: 90.w,
                        onTap: () {},
                        txtController: passwordController,
                        validateFunction: (value) =>
                            Validators.validatePassword(value),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Container(
                        height: 6.h,
                        width: 90.w,
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
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 3.w, right: 3.w),
                          child: TextFormField(
                            controller: phoneController,
                            maxLength: 9,
                            // obscureText: true,
                            decoration: InputDecoration(
                              errorStyle:
                                  TextStyle(fontSize: 4.sp, height: 0.01.h),
                              fillColor: Colors.white,
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 5.sp,
                              ),
                              hintText: '+963'+' '+'mobile'.tr(),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 10)
                            ),
                            // maxLength: 9,
                            onChanged: (value) {},
                            validator: (value) =>
                                Validators.validatePhoneNumber(value),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      ContainerWidget3(
                        text: idCardStr,
                        borderRadius: 15,
                        icon: Icons.add,
                        onIconPressed: () async {
                          final imageFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (imageFile == null) return;
                          final imageTemp = File(imageFile.path);
                          setState(() {
                            this.idCardImage = imageTemp;
                            idCardStr = idCardImage!.path
                                .split('/')
                                .last
                                .substring(0, 15);
                          });
                        },
                        textColor: grey,
                        color: white,
                        w: 90.w,
                        h: 6.h,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      ContainerWidget3(
                        text: carImgStr,
                        borderRadius: 15,
                        icon: Icons.add,
                        onIconPressed: () async {
                          final imageFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (imageFile == null) return;
                          final imageTemp = File(imageFile.path);
                          setState(() {
                            this.CarImage = imageTemp;
                            carImgStr =
                                CarImage!.path.split('/').last.substring(0, 15);
                          });
                        },
                        textColor: grey,
                        color: white,
                        w: 90.w,
                        h: 6.h,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      ContainerWidget3(
                        text: driCertiStr,
                        borderRadius: 15,
                        icon: Icons.add,
                        onIconPressed: () async {
                          final imageFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (imageFile == null) return;
                          final imageTemp = File(imageFile.path);
                          setState(() {
                            this.drivingCertiImage = imageTemp;
                            driCertiStr = drivingCertiImage!.path
                                .split('/')
                                .last
                                .substring(0, 15);
                          });
                        },
                        textColor: grey,
                        color: white,
                        w: 90.w,
                        h: 6.h,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      ContainerWidget3(
                        text: carMechaStr,
                        borderRadius: 15,
                        icon: Icons.add,
                        onIconPressed: () async {
                          final imageFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (imageFile == null) return;
                          final imageTemp = File(imageFile.path);
                          setState(() {
                            this.carMechaImage = imageTemp;
                            carMechaStr = carMechaImage!.path
                                .split('/')
                                .last
                                .substring(0, 15);
                          });
                        },
                        textColor: grey,
                        color: white,
                        w: 90.w,
                        h: 6.h,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      ContainerWidget3(
                        text: carInsuStr,
                        borderRadius: 15,
                        icon: Icons.add,
                        onIconPressed: () async {
                          final imageFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (imageFile == null) return;
                          final imageTemp = File(imageFile.path);
                          setState(() {
                            this.carInsuImage = imageTemp;
                            carInsuStr = carInsuImage!.path
                                .split('/')
                                .last
                                .substring(0, 15);
                          });
                        },
                        textColor: grey,
                        color: white,
                        w: 90.w,
                        h: 6.h,
                      ),

                      SizedBox(height: 1.h,),
                      InkWell(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // Builder(builder: (context) {
                              //   return Checkbox(
                              //     materialTapTargetSize:
                              //         MaterialTapTargetSize.shrinkWrap,
                              //     value: newValue,
                              //     activeColor: primaryBlue,
                              //     onChanged: (bool? value) {
                              //       setState(() {
                              //         newValue = value!;
                              //         isAgree = value;
                              //         print(isAgree);
                              //         if (isAgree == true) {
                              //           totalAgree = true;
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
                        onTap: (){
                          showAlertDialog(context);
                        },
                      ),
                      SizedBox(height: 1.h,),
                      // SizedBox(
                      //   height: 3.h,
                      // ),
                      Center(
                        child: ContainerWidget(
                          text: 'send'.tr(),
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            print(totalAgree);
                            if (formKey.currentState?.validate() == true) {
                              if (totalAgree == true) {
                                if (drivingCertiImage == null) {
                                  setSnackbar(
                                      'please the driving certificate is required'
                                          .tr(),
                                      context);
                                } else {
                                  print('send tap');
                                  print(firstNameController.text);
                                  print(lastNameController.text);
                                  print(emailController.text);
                                  print(passwordController.text);
                                  print(phoneController.text);
                                  print(carMechaImage);
                                  print(carInsuImage);
                                  print(CarImage);
                                  print(idCardImage);
                                  print(drivingCertiImage);
                                  if (carMechaImage != null &&
                                      carInsuImage != null) {
                                    await driverRegisterApi(
                                      firstNameController.text,
                                      lastNameController.text,
                                      emailController.text,
                                      passwordController.text,
                                      phoneController.text,
                                      carMechaImage!,
                                      carInsuImage!,
                                      // creat
                                    );
                                  } else if (carMechaImage != null) {
                                    await driverRegisterApi(
                                      firstNameController.text,
                                      lastNameController.text,
                                      emailController.text,
                                      passwordController.text,
                                      phoneController.text,
                                      carMechaImage!,
                                    );
                                  } else if (carInsuImage != null) {
                                    await driverRegisterApi(
                                      firstNameController.text,
                                      lastNameController.text,
                                      emailController.text,
                                      passwordController.text,
                                      phoneController.text,
                                      carInsuImage!,
                                    );
                                  } else {
                                    await driverRegisterApi(
                                      firstNameController.text,
                                      lastNameController.text,
                                      emailController.text,
                                      passwordController.text,
                                      phoneController.text,
                                    );
                                  }
                                }
                              } else {
                                // setSnackbar("agreePolicy".tr(), context);
                                showAlertDialog(context);

                                // Future.delayed(
                                //     const Duration(seconds: 2))
                                //     .then((_) async {
                                //   showAlertDialog(context);
                                // });
                              }
                            } else {
                              print('not validate');
                            }
                          },
                          h: 7.h,
                          w: 80.w,
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
          child: myText(
        // text: 'TERM'.tr(),
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
                            isAgree = false;
                          }
                        });
                        // Navigator.of(context).pop();
                      },
                    ),
                  ),
                  myText(
                    // text: 'CONTINUE'.tr(),
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
  }
}
