import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/get_profile_provider.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/update_profile_provider.dart';
import 'package:diamond_line/Presentation/Functions/Validators.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_registration/forget_password.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:diamond_line/Presentation/widgets/text_with_textfield.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../widgets/container_widget.dart';

class DriverProfileSettings extends StatefulWidget {
  const DriverProfileSettings({Key? key}) : super(key: key);

  @override
  State<DriverProfileSettings> createState() => _DriverProfileSettingsState();
}

class _DriverProfileSettingsState extends State<DriverProfileSettings> {
  final picker = ImagePicker();
  File? imageFile;
  bool _isNetworkAvail = true;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    var creat = await Provider.of<ProfilProvider>(context, listen: false);
    getDriverProfile(creat);
  }

///////////////////get profile api//////////////////////
  void getDriverProfile(ProfilProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: CircularProgressIndicator());
      await creat.getProfil();
      if (creat.data.error == false) {
        print(creat.data.data!.image);
        firstNameController.text = creat.data.data!.user!.firstName.toString();
        phoneController.text = creat.data.data!.user!.phone.toString();
        lastNameController.text = creat.data.data!.user!.lastName.toString();
        emailController.text = creat.data.data!.user!.email.toString();
        dateBirthController.text =
            creat.data.data!.user!.dateOfBirth.toString();
        imageFile = File(creat.data.data!.image.toString());
        print('imageFile is : ' + imageFile!.path);
        Loader.hide();
        setState(() {});
      } else {
        Loader.hide();
        setSnackbar(creat.data.message.toString(), context);
      }
    } else {
      setSnackbar("nointernet".tr(), context);
      print("nointernet");
    }
  }

/////////////////////update profile api////////////////////////
  void updateDriverProfile(
      String fname,
      String lname,
      String phone,
      String email,
      String date_of_birth,
      [File? imageFile]
      ) async {
    _isNetworkAvail = await isNetworkAvailable();
    var creat = Provider.of<UpdateProfileProvider>(context, listen: false);
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: CircularProgressIndicator());
      await creat.getUpdateDriverProfile(fname, lname,
          phone, email, date_of_birth, imageFile);
      if (creat.data.error == false) {
        Loader.hide();
        setSnackbar("updsuccess".tr(), context);
        phoneController.text = creat.data.data!.phone.toString();
        firstNameController.text = creat.data.data!.firstName.toString();
        lastNameController.text = creat.data.data!.lastName.toString();
        emailController.text = creat.data.data!.email.toString();
        dateBirthController.text = creat.data.data!.dateOfBirth.toString();
        imageFile = File(creat.data.data!.profileImage.toString());
        print('successsssss update');
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
    return Scaffold(
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
            bottom: 7.h,
          ),
          child: Container(
            height: 25.h,
            width: 80.w,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 0),
                ),
              ],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: backgroundColor,
            ),
            child: SingleChildScrollView(
                child: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 3.h,
                    ),
                    Center(
                      child: Stack(children: [
                        Container(
                          height: 18.h,
                          width: 45.w,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            color: lightBlue,
                          ),
                          child:
                              imageFile == null
                                  ? TextButton(
                                      onPressed: () async {
                                        var im = await picker.pickImage(
                                            source: ImageSource.gallery);
                                        setState(() {
                                          imageFile = File(im!.path);
                                        });
                                      },
                                      child: Center(
                                          child: myText(
                                        text: 'image'.tr(),
                                        fontSize: 5.sp,
                                      )),
                                    )
                                  : imageFile!.path
                                          .toString()
                                          .startsWith('http')
                                      ? FadeInImage(
                                          image: NetworkImage(
                                            imageFile!.path,
                                          ),
                                          fit: BoxFit.fill,
                                height: 18.h,
                                width: 45.w,
                                          imageErrorBuilder: (context, error,
                                                  stackTrace) =>
                                              Image.asset(logo),
                                          placeholder: AssetImage(logo),
                                        )
                                      : FadeInImage(
                                          image: FileImage(imageFile!),
                                          fit: BoxFit.fill,
                                height: 18.h,
                                width: 45.w,
                                          imageErrorBuilder: (context, error,
                                                  stackTrace) =>
                                              Image.asset(logo),
                                          placeholder: AssetImage(logo),
                                        ),
                        ),
                        Positioned(
                            bottom: 13.h,
                            left: 32.w,
                            child: IconButton(
                              icon: const Icon(
                                Icons.add,
                                size: 45,
                                color: white,
                              ),
                              onPressed: () async {
                                // await pickImage();
                                var im = await picker.pickImage(
                                    source: ImageSource.gallery);
                                setState(() {
                                  print('im!.path');
                                  print(im!.path);
                                  imageFile = File(im.path);
                                  print('imageFile');
                                  print(imageFile);
                                });
                              },
                            ))
                      ]),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: myText(
                        text: 'mobile'.tr(),
                        fontSize: 5.sp,
                        color: primaryBlue2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: myText(text: '+963', fontSize: 5.sp),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: TextFormField(
                              controller: phoneController,
                              maxLength: 9,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsetsDirectional.only(
                                    top: 4.h, start: 2.w),
                                fillColor: Colors.white,
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 5.sp,
                                ),
                                suffixIcon: Icon(Icons.edit_outlined),
                              ),
                              onSaved: (value) {
                                setState(() {
                                  phoneController.text = value!;
                                });
                                print(phoneController.text);
                              },
                              validator: (value) =>
                                  Validators.validatePhoneNumber(value),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    TextWithTextField(
                      text: "first".tr(),
                      controller: firstNameController,
                      onTap: () {},
                      icon: const Icon(Icons.edit_outlined),
                      validateFunction: (value) =>
                          Validators.validateName(value),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    TextWithTextField(
                      text: "last".tr(),
                      controller: lastNameController,
                      onTap: () {},
                      icon: const Icon(Icons.edit_outlined),
                      validateFunction: (value) =>
                          Validators.validateName(value),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    TextWithTextField(
                      text: "email".tr(),
                      controller: emailController,
                      onTap: () {},
                      icon: const Icon(Icons.edit_outlined),
                      validateFunction: (value) =>
                          Validators.validateEmail(value),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    TextWithTextField(
                      text: "date".tr(),
                      controller: dateBirthController,
                      onTap: () {},
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Center(
                      child: Container(
                        height: 6.h,
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
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Colors.white,
                        ),
                        child: TextButton(
                          child: Text(
                            'change pass'.tr(),
                            style:
                                TextStyle(color: primaryBlue, fontSize: 5.sp),
                          ),
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ForgetPassword(
                                          emailOrPhone: phoneController.text,
                                          title: 'change pass',
                                          isDriver: true,
                                        )));
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Center(
                      child: ContainerWidget(
                        text: 'edit'.tr(),
                        onTap: () async {
                          print('**********************************');
                          print(imageFile);
                          if (formKey.currentState?.validate() == true) {
                            // //     var updat = Provider.of<UpdateProfileProvider>(
                            // // context,
                            // // listen: false);
                            if(imageFile!.path.toString().startsWith('http')){
                              print('ifffffffffffff');
                              updateDriverProfile(
                                firstNameController.text,
                                lastNameController.text,
                                phoneController.text,
                                emailController.text,
                                dateBirthController.text,
                              );
                            }
                            else{
                              print('elseeeeeeeeeeeeeeee');
                              updateDriverProfile(
                                firstNameController.text,
                                lastNameController.text,
                                phoneController.text,
                                emailController.text,
                                dateBirthController.text,
                                imageFile!,
                              );
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
                      height: 2.h,
                    ),
                  ],
                ),
              ),
            )),
          ),
        ),
      ),
    );
  }
}