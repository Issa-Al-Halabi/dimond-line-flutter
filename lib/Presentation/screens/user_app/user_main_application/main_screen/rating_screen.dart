import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:diamond_line/Data/network/requests.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/user_dashboard.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import '../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../Widgets/text.dart';

class RatingScreen extends StatefulWidget {
  RatingScreen({required this.tripId, Key? key}) : super(key: key);
  String tripId;

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  bool _isNetworkAvail = true;
  String msg = '';
  String rate = '';
  TextEditingController commmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /////////////////////////// get rating api //////////////////////////////////
  Future<void> getRatingApi(
      String trip_id, String review_text, String ratings) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: CircularProgressIndicator());
      var data = await AppRequests.reviewRequest(trip_id, review_text, ratings);
      data = json.decode(data);
      print(data["error"]);
      // print(data["message"]);
      if (data["error"] == false) {
        Loader.hide();
        if (mounted) {
          setState(() {
            msg = data["message"];
            setSnackbar(msg, context);
            print(msg);
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
        }
      } else {
        Loader.hide();
        if (mounted) {
          setState(() {
            msg = data["message"];
            setSnackbar(msg, context);
            print(msg);
          });
        }
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
            ),
            child: SingleChildScrollView(
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15.h,
                          ),
                          Image.asset(
                            'assets/images/logo.png',
                            color: primaryBlue,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          myText(
                              text: 'rate the driver please'.tr(),
                              fontSize: 6.sp,
                              color: primaryBlue),
                          SizedBox(
                            height: 5.h,
                          ),
                          RatingBar.builder(
                            initialRating: 1,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 35,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                              setState(() {
                                rate = rating.toString();
                              });
                            },
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.w, right: 10.w),
                              child: TextFormField(
                                controller: commmentController,
                                // obscureText: true,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.0, color: lightBlue),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.0, color: lightBlue),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  errorStyle: TextStyle(fontSize: 4.sp, height: 0.01.h),
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 5.sp,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.comment_outlined,
                                    color: primaryBlue,
                                    size: 25,
                                  ),
                                  hintText: 'tap your comment please',
                                ),
                                onChanged: (value) {},
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          Container(
                            width: 40.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: primaryBlue.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              color: primaryBlue,
                            ),
                            child: TextButton(
                              child: Text(
                                'submit',
                                style: TextStyle(
                                    color: backgroundColor, fontSize: 7.sp),
                              ),
                              onPressed: () {
                                print(commmentController.text);
                                print(rate);
                                getRatingApi(widget.tripId,
                                    commmentController.text, rate);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}