import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../widgets/loader_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/email_register_provider.dart';
import 'package:diamond_line/Presentation/Functions/Validators.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Functions/helper.dart';
import '../../../widgets/container_with_textfield.dart';
import 'package:image_picker/image_picker.dart';
import '../user_main_application/main_screen/user_dashboard.dart';

class RegistrationForeigner extends StatefulWidget {
  const RegistrationForeigner({Key? key}) : super(key: key);

  @override
  State<RegistrationForeigner> createState() => _RegistrationForeignerState();
}

class _RegistrationForeignerState extends State<RegistrationForeigner> {
  String type = '';
  bool newValue = false;
  bool isAgree = false;
  final picker = ImagePicker();

  // XFile? image;
  var formKey = GlobalKey<FormState>();
  bool _isNetworkAvail = true;
  File? imageFile;

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
                        height: 3.h,
                      ),
                      Container(
                        height: 20.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: Offset(0, 0),
                            ),
                          ],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: lightBlue,
                        ),
                        child: imageFile == null
                            ? TextButton(
                                onPressed: () async {
                                  if (await Permission.storage.request().isGranted) {
                                    var im = await picker.pickImage(
                                        source: ImageSource.gallery);
                                    // setState(() {
                                    //   imageFile = File(im!.path);
                                    // });
                                    if (im != null) {
                                      setState(() {
                                        imageFile = File(im.path);
                                      });
                                    }   }
                                  else{
                                    showWarningGalleryDialog(context);
                                  }

                                },
                                child: Center(
                                    child: myText(
                                  text: 'image'.tr(),
                                  fontSize: 5.sp,
                                )),
                              )
                            : Image.file(
                                imageFile!,
                                // File(image!.path),
                                fit: BoxFit.cover,
                              ),
                      ),
                      SizedBox(
                        height: 3.h,
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
                        height: 2.h,
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
                        height: 2.h,
                      ),
                      ContainerWithTextField(
                        hintText: 'email'.tr(),
                        h: 6.h,
                        w: 90.w,
                        onTap: () {},
                        txtController: emailController,
                        validateFunction: (value) =>
                            Validators.validateEmail(value),
                      ),
                      SizedBox(
                        height: 2.h,
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
                      // SizedBox(
                      //   height: 1.h,
                      // ),
                      // ContainerWithTextField(
                      //   hintText: 'passport'.tr(),
                      //   h: 6.h,
                      //   w: 90.w,
                      //   onTap: () {},
                      //   txtController: passportController,
                      //   validateFunction: (value) =>
                      //       Validators.validateNumber(value),
                      // ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Builder(builder: (context) {
                              return Checkbox(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                value: newValue,
                                activeColor: primaryBlue,
                                onChanged: (bool? value) {
                                  setState(() {
                                    newValue = value!;
                                    isAgree = value;
                                  });
                                },
                              );
                            }),
                            getAgreeText(),
                          ]),
                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                        width: 80.w,
                        height: 6.h,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        child: MaterialButton(
                          disabledColor: grey,
                          color: primaryBlue,
                          child: Text(
                            "done".tr(),
                            style: TextStyle(fontSize: 8.sp, color: Colors.white),
                          ),
                          onPressed: isAgree
                              ? () async {
                                  if (formKey.currentState?.validate() == true) {
                                    _isNetworkAvail = await isNetworkAvailable();
                                    if (_isNetworkAvail) {
                                      print("There is internet");
                                      Loader.show(context,
                                          progressIndicator:
                                              LoaderWidget());
                                      var creat = await Provider.of<
                                              EmailRegisterProvider>(context,
                                          listen: false);
                                      print(creat);
                                      if (imageFile != null) {
                                        await creat.EmailCreatAcountwithphoto(
                                            firstNameController.text,
                                            lastNameController.text,
                                            emailController.text,
                                            passwordController.text,
                                            imageFile!);
                                      } else {
                                        await creat.EmailCreatAcountwithphoto(
                                          firstNameController.text,
                                          lastNameController.text,
                                          emailController.text,
                                          passwordController.text,
                                          // imageFile!
                                        );
                                      }
                                      print('creat.data.error');
                                      print(creat.data.error);
                                      print('creat.data.message');
                                      print(creat.data.message);
                                      if (creat.data.error == false) {
                                        Loader.hide();
                                        setSnackbar("success".tr(), context);
                                        setState(() {
                                          Future.delayed(
                                                  const Duration(seconds: 1))
                                              .then((_) async {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        // SelectType()));
                                                    UserDashboard()));
                                          });
                                        });
                                      } else {
                                        Loader.hide();
                                        print(creat.data.message);
                                        setSnackbar(creat.data.message.toString(),
                                            context);
                                      }
                                    } else {
                                      setSnackbar("nointernet".tr(), context);
                                      Future.delayed(const Duration(seconds: 2))
                                          .then((_) async {
                                        if (mounted) {
                                          setState(() {
                                            _isNetworkAvail = false;
                                          });
                                        }
                                      });
                                    }
                                  } else {
                                    print('not validate');
                                  }
                                }
                              : null,
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
