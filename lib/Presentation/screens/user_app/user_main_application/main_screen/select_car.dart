import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/order_trip_outside_provider.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import '../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Functions/helper.dart';

class SelectCar extends StatefulWidget {
  SelectCar(
      {required this.vechileImage,
      required this.vechileType,
      required this.seats,
      required this.bags,
      required this.filteredLength,
      required this.date,
      required this.time,
      required this.to,
      required this.categoryId,
      required this.subCategoryId,
      required this.vechileId,
      Key? key})
      : super(key: key);

  List vechileImage, vechileType, vechileId;
  String seats, bags, date, time, to;
  int filteredLength;
  String categoryId, subCategoryId;

  @override
  State<SelectCar> createState() => _SelectCarState();
}

class _SelectCarState extends State<SelectCar> {
  bool isSelect = false;
  bool isAccept = false;
  bool isOrdered = false;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  String oneVechileId = '';
  bool _isNetworkAvail = true;
  String orderType = '';
  String orderTypeId = '';

  ///////////////////////// order trip api //////////////////////////////////
  Future<void> checkNetwork(
      String vehicle_id,
      String category_id,
      String subcategory_id,
      String person,
      String bags,
      String time,
      String date,
      String direction,
      OrderTripOutsideProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.getOrderTrip(
          vehicle_id, category_id, subcategory_id, person, bags, time, date, direction);
      if (creat.data.error == false) {
        Loader.hide();
        setSnackbar(creat.data.message.toString(), context);
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

  decriseTime(var fiftyDaysFromNow) {
    setState(() {
      fiftyDaysFromNow--;
    });
  }

  String getText() {
    if (isAccept == true && isOrdered == false) {
      return 'cancel'.tr();
    } else if (isAccept == true && isOrdered == true) {
      return 'ordered successfully'.tr();
    } else {
      return 'ok'.tr();
    }
  }

  getDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      height: 65.h,
                      width: 90.w,
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
                        padding: EdgeInsets.only(left: 5.w, right: 2.w),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 1.h,
                              ),
                              myText(
                                text: 'From: Damascus'.tr(),
                                fontSize: 5.sp,
                                color: lightBlue,
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              myText(
                                // text: 'To: Aleppo',
                                text: 'To: ${widget.to}',
                                fontSize: 5.sp,
                                color: lightBlue,
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              myText(
                                // text: 'Person: 4',
                                text: 'Person: ${widget.seats}',
                                fontSize: 5.sp,
                                color: lightBlue,
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              myText(
                                // text: 'Bags: 3',
                                text: 'Bags: ${widget.bags}',
                                fontSize: 5.sp,
                                color: lightBlue,
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              myText(
                                // text: 'On: 3/9/2022  3:16 pm',
                                text: 'On: ${widget.date}\n ${widget.time}',
                                fontSize: 5.sp,
                                color: lightBlue,
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RadioListTile(
                                    title: myText(
                                      text: "going".tr(),
                                      fontSize: 5.sp,
                                      color: primaryBlue,
                                    ),
                                    value: "going".tr(),
                                    groupValue: orderType,
                                    activeColor: primaryBlue,
                                    onChanged: (value) {
                                      setState(() {
                                        orderType = "going".tr();
                                        print(orderType);
                                        orderTypeId = '1';
                                        print(orderTypeId);
                                      });
                                    },
                                  ),
                                  RadioListTile(
                                    title: myText(
                                      text: "goingandback".tr(),
                                      fontSize: 5.sp,
                                      color: primaryBlue,
                                    ),
                                    value: "goingandback".tr(),
                                    groupValue: orderType,
                                    activeColor: primaryBlue,
                                    onChanged: (value) {
                                      setState(() {
                                        orderType = "goingandback".tr();
                                        print(orderType);
                                        orderTypeId = '2';
                                        print(orderTypeId);
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 5.w,
                                  right: 5.w,
                                ),
                                child: ContainerWidget(
                                    text: getText(),
                                    h: 5.h,
                                    w: 50.w,
                                    onTap: () async {
                                      var orderTrip = await Provider.of<
                                              OrderTripOutsideProvider>(context,
                                          listen: false);
                                      print('checkNetwork');
                                      checkNetwork(
                                          oneVechileId,
                                          widget.categoryId,
                                          widget.subCategoryId,
                                          widget.seats,
                                          widget.bags,
                                          widget.time,
                                          widget.date,
                                          orderTypeId,
                                          orderTrip);
                                      print(isAccept);
                                      setState(() {
                                        isAccept = true;
                                        print(isAccept);
                                      });
                                      Timer timer = Timer.periodic(
                                          Duration(seconds: 20), (timer) {
                                        // Duration(hours: 24), (timer) {
                                        setState(() {
                                          // isAccept = false;
                                          isOrdered = true;
                                          print(isAccept);
                                          print(isOrdered);
                                        });
                                      });
                                    }),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Visibility(
                                visible: isOrdered == true ? true : false,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 8.w, right: 8.w),
                                  child: InkWell(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          size: iconSize,
                                          color: lightBlue,
                                        ),
                                        myText(
                                          text: 'add a trip'.tr(),
                                          fontSize: 5.sp,
                                          color: lightBlue,
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      //Todo call api to add a trip
                                      print('call api to add a trip');
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        }).then((val) {});
  }

  @override
  Widget build(BuildContext context) {
    print('***************************');
    print(widget.time);
    print(widget.date);
    print(widget.to);
    print(widget.filteredLength);
    print(widget.categoryId);
    print(widget.subCategoryId);
    print(widget.vechileId);
    print('***************************');

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
                        Expanded(
                          flex: 8,
                          child: ListView.builder(
                              itemCount: widget.filteredLength,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 1.h),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isSelect = true;
                                            oneVechileId =
                                                widget.vechileId[index];
                                          });
                                        },
                                        child: Container(
                                          height: 20.h,
                                          width: 90.w,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    Colors.grey.withOpacity(0.3),
                                                spreadRadius: 2,
                                                blurRadius: 7,
                                                offset: const Offset(0, 0),
                                              ),
                                            ],
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(20)),
                                            color: isSelect == true
                                                ? primaryBlue
                                                : backgroundColor,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 2.w, right: 2.w),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 2.h,
                                                        ),
                                                        Text(
                                                          widget
                                                              .vechileType[index],
                                                          style: TextStyle(
                                                            color: grey,
                                                            fontSize: 5.sp,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 2.h,
                                                        ),
                                                        Text(
                                                          // "4 persons",
                                                          widget.seats,
                                                          style: TextStyle(
                                                            color: grey,
                                                            fontSize: 5.sp,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 2.h,
                                                        ),
                                                        Text(
                                                          '${widget.bags} bags',
                                                          style: TextStyle(
                                                            color: grey,
                                                            fontSize: 5.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Image.network(
                                                    widget.vechileImage[index],
                                                    height: 20.h,
                                                    width: 20.w,
                                                  ),
                                                ],
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
                        Expanded(
                            child: Column(
                          children: [
                            ContainerWidget(
                                text: 'done'.tr(),
                                h: 7.h,
                                w: 80.w,
                                onTap: () {
                                  getDialog();
                                }),
                            SizedBox(
                              height: 1.h,
                            ),
                          ],
                        )),
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