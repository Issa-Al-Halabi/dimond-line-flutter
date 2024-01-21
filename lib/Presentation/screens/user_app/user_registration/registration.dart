import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../widgets/loader_widget.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/user_register_provider.dart';
import 'package:diamond_line/Presentation/Functions/Validators.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Functions/helper.dart';
import '../../../widgets/container_widget.dart';
import '../../../widgets/container_with_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import '../user_main_application/main_screen/user_dashboard.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  int _index = 0;
  String type = '';
  bool newValue = false;
  bool isAgree = false;
  final picker = ImagePicker();

  // XFile? image;

  bool _isNetworkAvail = true;
  String? token;
  bool load = false;

  File? imageFile;
  late SharedPreferences prefs;
  var formKey = GlobalKey<FormState>();
  var formKey2 = GlobalKey<FormState>();

  @override
  void initState() {
    // init();
    initShared();
    super.initState();
  }

  Future initShared() async {
    prefs = await SharedPreferences.getInstance();
  }

  save() async {
    prefs.setString('string', type);
  }

  fetch() async {
    String Stringval = prefs.getString('string') ?? '';
    print(Stringval);
  }

  remove() async {
    prefs.remove('string');
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

  //////to store if the user signed in id card or passport
  void sharedPrefInit() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  }

  Widget getSecondIndex() {
    return Form(
      key: formKey2,
      child: Column(
        children: [
          SizedBox(
            height: 1.h,
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
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: lightBlue,
            ),
            child: imageFile == null
                ? TextButton(
                    onPressed: () async {

                      bool isAndroid13 = false;
                      final androidInfo = await DeviceInfoPlugin().androidInfo;
                      if (androidInfo.version.sdkInt! <= 32) {
                        isAndroid13 = false;
                      }  else {
                        isAndroid13 = true;
                      }
                      var res = isAndroid13 == true ? await Permission.photos.request().isGranted : await Permission.storage.request().isGranted;
                      if (res) {     // pickImage();
                        var im =
                        await picker.pickImage(source: ImageSource.gallery);
                        if (im != null) {
                          setState(() {
                            imageFile = File(im.path);
                          });
                        }
                      }
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
                    fit: BoxFit.cover,
                  ),
          ),
          SizedBox(
            height: 2.h,
          ),
          ContainerWithTextField(
            hintText: 'first name'.tr(),
            w: 90.w,
            onTap: () {},
            txtController: firstNameController,
            validateFunction: (value) => Validators.validateName(value),
          ),
          SizedBox(
            height: 1.h,
          ),
          ContainerWithTextField(
            hintText: 'last name'.tr(),
            w: 90.w,
            onTap: () {},
            txtController: lastNameController,
            validateFunction: (value) => Validators.validateName(value),
          ),
          SizedBox(
            height: 1.h,
          ),
          ContainerWithTextField(
            hintText: 'mother'.tr(),
            w: 90.w,
            onTap: () {},
            txtController: motherNameController,
            // validateFunction: (value) => Validators.validateName(value),
          ),
          SizedBox(
            height: 1.h,
          ),
          ContainerWithTextField(
            hintText: 'father'.tr(),
            w: 90.w,
            onTap: () {},
            txtController: fatherNameController,
            // validateFunction: (value) => Validators.validateName(value),
          ),
          SizedBox(
            height: 1.h,
          ),
          ContainerWithTextField(
            hintText: 'mobile'.tr(),
            w: 90.w,
            onTap: () {},
            txtController: phoneController,
            validateFunction: (value) => Validators.validatePhoneNumber(value),
          ),
          SizedBox(
            height: 1.h,
          ),
          ContainerWithTextField(
            hintText: 'password'.tr(),
            w: 90.w,
            onTap: () {},
            txtController: passwordController,
            validateFunction: (value) => Validators.validatePassword(value),
          ),
          SizedBox(
            height: 1.h,
          ),
          ContainerWithTextField(
            hintText: 'email'.tr(),
            w: 90.w,
            onTap: () {},
            txtController: emailController,
            // validateFunction: (value) => Validators.validateEmail(value),
          ),
          SizedBox(
            height: 1.h,
          ),
          ContainerWithTextField(
            hintText: 'place'.tr(),
            w: 90.w,
            onTap: () {},
            txtController: placeBirthController,
            // validateFunction: (value) => Validators.validateName(value),
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
                controller: dateBirthController,
                decoration: InputDecoration(
                  errorStyle: TextStyle(fontSize: 4.sp, height: 0.01.h),
                  fillColor: Colors.white,
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 5.sp,
                  ),
                  hintText: 'date'.tr() + ' 0000-00-00',
                  border: InputBorder.none,
                ),
                onChanged: (value) {},
              ),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          ContainerWidget(
            text: 'done'.tr(),
            h: 6.h,
            w: 80.w,
            onTap: () async {
              print(isAgree);
              print('done tap');
              if (formKey2.currentState?.validate() == true) {
                _isNetworkAvail = await isNetworkAvailable();
                if (_isNetworkAvail) {
                  print("There is internet");
                  Loader.show(context,
                      progressIndicator: LoaderWidget());
                  var creat = await Provider.of<UserRegisterProvider>(context,
                      listen: false);
                  print(creat);

                  if (imageFile != null) {
                    await creat.getCreatAcount(
                        firstNameController.text,
                        lastNameController.text,
                        motherNameController.text,
                        fatherNameController.text,
                        phoneController.text,
                        passwordController.text,
                        emailController.text,
                        // passportController.text,
                        placeBirthController.text,
                        dateBirthController.text,
                        imageFile!);
                  } else {
                    await creat.getCreatAcount(
                      firstNameController.text,
                      lastNameController.text,
                      motherNameController.text,
                      fatherNameController.text,
                      phoneController.text,
                      passwordController.text,
                      emailController.text,
                      // passportController.text,
                      placeBirthController.text,
                      dateBirthController.text,
                    );
                  }
                  print(creat.data.error);
                  print(creat.data.message);
                  if (creat.data.error == false) {
                    Loader.hide();
                    setSnackbar("success".tr(), context);
                    setState(() {
                      Future.delayed(const Duration(seconds: 1))
                          .then((_) async {
                        Navigator.of(context).push(MaterialPageRoute(
                            // builder: (context) => SelectType()));
                            builder: (context) => UserDashboard()));
                      });
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
              } else {
                print('not valid');
              }
            },
          ),
          SizedBox(
            height: 1.h,
          ),
        ],
      ),
    );
    // }
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IndexedStack(
                      index: _index,
                      children: [
                        // //first index
                        // Padding(
                        //   padding:
                        //       EdgeInsets.only(top: 25.h, left: 10.w, right: 10.w),
                        //   child: Container(
                        //     height: 25.h,
                        //     width: 80.w,
                        //     decoration: BoxDecoration(
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.grey.withOpacity(0.3),
                        //           spreadRadius: 2,
                        //           blurRadius: 7,
                        //           offset: Offset(0, 0),
                        //         ),
                        //       ],
                        //       borderRadius:
                        //           const BorderRadius.all(Radius.circular(20)),
                        //       color: backgroundColor,
                        //     ),
                        //     child: Column(
                        //       children: [
                        //         SizedBox(
                        //           height: 2.h,
                        //         ),
                        //         Text(
                        //           'register'.tr(),
                        //           style:
                        //               TextStyle(color: lightBlue, fontSize: 5.sp),
                        //         ),
                        //         SizedBox(
                        //           height: 2.h,
                        //         ),
                        //         ContainerWidget(
                        //           text: 'id card'.tr(),
                        //           h: 7.h,
                        //           w: 50.w,
                        //           onTap: () {
                        //             setState(() {
                        //               type = 'id card'.tr();
                        //               print('save type');
                        //               save();
                        //               _index++;
                        //             });
                        //           },
                        //           color: primaryBlue,
                        //         ),
                        //         SizedBox(
                        //           height: 2.h,
                        //         ),
                        //         ContainerWidget(
                        //           text: 'passport'.tr(),
                        //           h: 7.h,
                        //           w: 50.w,
                        //           onTap: () {
                        //             setState(() {
                        //               type = 'passport'.tr();
                        //               save();
                        //               _index++;
                        //             });
                        //           },
                        //           color: primaryBlue,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        getSecondIndex(),
                      ],
                    ),
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
