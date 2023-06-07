import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import '../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Functions/helper.dart';

class ContactUsScreen extends StatefulWidget {
  ContactUsScreen({required this.isUser, Key? key}) : super(key: key);
  bool isUser;

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  bool _isNetworkAvail = true;
  List phone = [], email = [];

  @override
  void initState() {
    getContactUsApi();
    super.initState();
  }

  ///////////////////////// get nearest car api //////////////////////////////////
  Future<void> getContactUsApi() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      var data = await AppRequests.contactUsRequest();
      data = json.decode(data);
      if (data["error"] == false) {
        Loader.hide();
        for (int i = 0; i < data["data"].length; i++) {
          phone.add(data["data"][i]["phone"]);
          email.add(data["data"][i]["email"]);
        }
        setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPopLoader,
      child: Scaffold(
        body: phone.length == 0
            ? Center(
                child: LoaderWidget(),
              )
            : Container(
                height: getScreenHeight(context),
                width: getScreenWidth(context),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(background),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 9.h),
                  child: Column(
                    children: [
                      Container(
                        height: 82.h,
                        width: getScreenWidth(context),
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
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: backgroundColor,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 2.h,
                              ),
                              Center(
                                  child: myText(
                                text: 'contact'.tr(),
                                fontSize: 6.sp,
                                color: primaryBlue,
                              )),
                              SizedBox(
                                height: 2.h,
                              ),
                              Center(
                                child: Container(
                                  height: 1.h,
                                  width: 70.w,
                                  decoration: BoxDecoration(
                                    color: lightBlue2,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: ListView.builder(
                                    itemCount: phone.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 3.w,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.h),
                                            child: Column(
                                              children: [
                                                Container(
                                                    width: 80.w,
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
                                                          spreadRadius: 2,
                                                          blurRadius: 7,
                                                          offset:
                                                              const Offset(0, 0),
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                              Radius.circular(
                                                                  100)),
                                                      color: backgroundColor,
                                                    ),
                                                    child: ListTile(
                                                      trailing: Container(
                                                        decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(0.3),
                                                              spreadRadius: 2,
                                                              blurRadius: 7,
                                                              offset:
                                                              const Offset(0, 0),
                                                            ),
                                                          ],
                                                          borderRadius:
                                                          const BorderRadius.all(
                                                              Radius.circular(
                                                                  100)),
                                                          color: primaryBlue,
                                                        ),
                                                        child: IconButton(
                                                          icon: Icon(Icons.phone,
                                                              // color: primaryBlue2
                                                              color: white
                                                          ),
                                                          onPressed: () {
                                                            launchUrl(Uri.parse(
                                                                "tel:+963 ${phone[index]}"));
                                                          },
                                                        ),
                                                      ),
                                                      leading: myText(
                                                          text: phone[index]
                                                              .toString(),
                                                          fontSize: 6.sp,
                                                          color: primaryBlue2,
                                                        ),
                                                    )),
                                                SizedBox(
                                                  height: 2.h,
                                                ),
                                                Container(
                                                    width: 80.w,
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
                                                          spreadRadius: 2,
                                                          blurRadius: 7,
                                                          offset:
                                                              const Offset(0, 0),
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          const BorderRadius.all(
                                                              Radius.circular(
                                                                  100)),
                                                      color: backgroundColor,
                                                    ),
                                                    child: ListTile(
                                                      trailing: Container(
                                                        decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(0.3),
                                                              spreadRadius: 2,
                                                              blurRadius: 7,
                                                              offset:
                                                              const Offset(0, 0),
                                                            ),
                                                          ],
                                                          borderRadius:
                                                          const BorderRadius.all(
                                                              Radius.circular(
                                                                  100)),
                                                          color: primaryBlue,
                                                        ),
                                                        child: IconButton(
                                                          icon: Icon(Icons.email,
                                                              color: white),
                                                          onPressed: () {
                                                            launchUrl(Uri.parse(
                                                                "mailto:${email[index]}"));
                                                          },
                                                        ),
                                                      ),
                                                      leading: myText(
                                                            text: email[index],
                                                            fontSize: 6.sp,
                                                        color: primaryBlue2),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}