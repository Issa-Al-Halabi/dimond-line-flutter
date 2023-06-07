import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Presentation/widgets/bottom_icons_driver.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import '../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../Data/network/requests.dart';
import '../../../../Functions/helper.dart';
import '../../../../widgets/container_widget.dart';

class Expenses extends StatefulWidget {
  Expenses({required this.tripId, Key? key}) : super(key: key);
  String tripId;

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  List<String> types = [];
  List<String> prices = [];
  TextEditingController typeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  int count = 0;
  bool _isNetworkAvail = true;
  String msg = '';

  @override
  void initState() {
    super.initState();
  }

  /////////////////////////// add expenses api //////////////////////////////////
  Future<void> addExpensesApi(String trip_id, List type, List price) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      var data = await AppRequests.tripExpensesRequest(trip_id, type, price);
      data = json.decode(data);
      print(data["error"]);
      if (data["error"] == false) {
        Loader.hide();
        if (mounted) {
          setState(() {
            msg = data["message"];
            setSnackbar(msg, context);
            print(msg);
            Navigator.of(context).pop();
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
            padding: EdgeInsets.only(top: 9.h),
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
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8.h,
                        ),
                        myText(
                          text: 'expens'.tr(),
                          fontSize: 8.sp,
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Expanded(
                          // flex: 2,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                            ),
                            child: Container(
                                height: 5.h,
                                width: 45.w,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                  color: primaryBlue,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Center(
                                  child: InkWell(
                                    child: myText(
                                        text: 'add',
                                        fontSize: 6.sp,
                                        color: white),
                                    onTap: () {
                                      typeController = TextEditingController();
                                      priceController = TextEditingController();
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
                                                myText(
                                                  text: 'cost type'.tr(),
                                                  fontSize: 5.sp,
                                                  color: grey,
                                                ),
                                                SizedBox(
                                                  height: 1.h,
                                                ),
                                                TextField(
                                                  controller: typeController,
                                                ),
                                                SizedBox(
                                                  height: 2.h,
                                                ),
                                                myText(
                                                  text: 'price'.tr(),
                                                  fontSize: 5.sp,
                                                  color: grey,
                                                ),
                                                SizedBox(
                                                  height: 1.h,
                                                ),
                                                TextField(
                                                  controller: priceController,
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        btnOkOnPress: () {
                                          setState(() {
                                            count++;
                                            types.add(typeController.text);
                                            prices.add(priceController.text);
                                          });
                                        },
                                      ).show();
                                    },
                                  ),
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: ListView.builder(
                              // shrinkWrap: true,
                              itemCount: count,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1.h),
                                      child: Container(
                                        height: 25.h,
                                        width: 75.w,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.3),
                                              spreadRadius: 2,
                                              blurRadius: 7,
                                              offset: const Offset(0, 0),
                                            ),
                                          ],
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          color: backgroundColor,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.w, vertical: 2.h),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              myText(
                                                text: 'cost type'.tr(),
                                                fontSize: 5.sp,
                                                color: grey,
                                              ),
                                              SizedBox(
                                                height: 1.h,
                                              ),
                                              myText(
                                                text: types[index],
                                                fontSize: 5.sp,
                                                color: primaryBlue,
                                              ),
                                              SizedBox(
                                                height: 1.h,
                                              ),
                                              myText(
                                                text: 'price'.tr(),
                                                fontSize: 5.sp,
                                                color: grey,
                                              ),
                                              SizedBox(
                                                height: 1.h,
                                              ),
                                              myText(
                                                text: formatter.format(int.parse(prices[index])) +'sp'.tr(),
                                                fontSize: 5.sp,
                                                color: primaryBlue,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                        Visibility(
                            visible: count == 0 ? false : true,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ContainerWidget(
                                  text: 'confirm exp'.tr(),
                                  h: 7.h,
                                  w: 75.w,
                                  onTap: () {
                                    print(types);
                                    print(prices);
                                    print(types.length);
                                    print(prices.length);
                                    addExpensesApi(widget.tripId, types, prices);
                                  }),
                            )),
                        SizedBox(
                          height: 2.h,
                        )
                      ],
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