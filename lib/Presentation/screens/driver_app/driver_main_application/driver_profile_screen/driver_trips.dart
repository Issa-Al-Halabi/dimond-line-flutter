import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../Buisness_logic/provider/Driver_Provider/driver_trips_provider.dart';

class DriverTrips extends StatefulWidget {
  const DriverTrips({Key? key}) : super(key: key);

  @override
  State<DriverTrips> createState() => _DriverTripsState();
}

class _DriverTripsState extends State<DriverTrips> {
  bool _isNetworkAvail = true;
  late final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  int length = 0;
  bool isGetTrips = false;
  late List tripsList;
  late SharedPreferences prefs;
  late String type;

  @override
  void initState() {
    init();
    _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
    initShared();
    super.initState();
  }

  Future initShared() async {
    prefs = await SharedPreferences.getInstance();
    type = prefs.getString('type_of_customer') ?? '';
    print('type_of_customer');
    print(type);
  }

  Future<void> init() async {
    tripsList = [];
    var creat =
        await Provider.of<GetDriverTripsProvider>(context, listen: false);
    getDriverTripsApi(creat);
  }

  //////////////////////////// get driver trips ended api ///////////////////////////
  Future<void> getDriverTripsApi(GetDriverTripsProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: CircularProgressIndicator());
      await creat.getDriverTrips();
      if (creat.data.error == false) {
        length = creat.data.data!.allTrips!.length;
        if (length != 0) {
          for (int i = 0; i < creat.data.data!.allTrips!.length; i++) {
            setState(() {
              tripsList.add(creat.data.data!.allTrips![i]);
              isGetTrips = true;
            });
          }
        }
        Loader.hide();
        setState(() {
          Future.delayed(const Duration(seconds: 1)).then((_) async {});
        });
      } else {
        Loader.hide();
        isGetTrips = true;
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
                  child: RefreshIndicator(
                    color: primaryBlue,
                    key: _refreshIndicatorKey,
                    onRefresh: init,
                    child: length == 0
                        ?
                    Center(child: Column(
                      children: [
                        SizedBox(
                          height:
                          20.h,
                        ),
                        Image.asset(
                          noData,
                          fit: BoxFit
                              .fill,
                          height:
                          30.h,
                        ),
                        SizedBox(
                          height:
                          2.h,
                        ),
                        Text(
                          'there are no trips'
                              .tr(),
                          style: TextStyle(
                              fontFamily:
                              'cairo',
                              color:
                              primaryBlue,
                              fontSize: 6.sp),
                        )
                      ],
                    ))
                    : Column(
                            children: [
                              Expanded(
                                flex: 8,
                                child: ListView.builder(
                                    itemCount: tripsList.length,
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
                                              child: Container(
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
                                                          Radius.circular(20)),
                                                  color: backgroundColor,
                                                ),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 1.h,
                                                      ),
                                                      tripsList[index]
                                                                  .categoryId
                                                                  .toString() !=
                                                              '2'
                                                          ? Center(
                                                              child: myText(
                                                                  text: tripsList[
                                                                          index]
                                                                      .requestType
                                                                      .toString()
                                                                      .tr(),
                                                                  fontSize:
                                                                      5.sp,
                                                                  color: Colors.black54,
                                                                  fontWeight: FontWeight.w600),
                                                            )
                                                          : Container(),
                                                      tripsList[index]
                                                                  .requestType !=
                                                              'moment'
                                                          ? ListTile(
                                                              leading:
                                                                  const Icon(
                                                                Icons
                                                                    .date_range,
                                                                color:
                                                                    primaryBlue,
                                                              ),
                                                              title: Text(
                                                                tripsList[index]
                                                                    .date
                                                                    .toString()
                                                                    .split(' ')
                                                                    .first,
                                                                style:
                                                                    TextStyle(
                                                                  color: primaryBlue,
                                                                  fontSize:
                                                                      5.sp,
                                                                ),
                                                              ))
                                                          :
                                                          ListTile(
                                                              leading:
                                                                  const Icon(
                                                                Icons
                                                                    .date_range,
                                                                color:
                                                                    primaryBlue,
                                                              ),
                                                              title: Text(
                                                                tripsList[index]
                                                                    .createdAt
                                                                    .toString()
                                                                    .split(' ')
                                                                    .first,
                                                                style:
                                                                    TextStyle(
                                                                  color: primaryBlue,
                                                                  fontSize:
                                                                      5.sp,
                                                                ),
                                                              )),
                                                      tripsList[index]
                                                                  .requestType !=
                                                              'moment'
                                                          ? ListTile(
                                                              leading:
                                                                  Image.asset(
                                                                clock,
                                                                color:
                                                                    primaryBlue,
                                                              ),
                                                              title: Text(
                                                                tripsList[index]
                                                                    .time
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  color: primaryBlue,
                                                                  fontSize:
                                                                      5.sp,
                                                                ),
                                                              ))
                                                          :
                                                          // Container(),
                                                          ListTile(
                                                              leading:
                                                                  Image.asset(
                                                                clock,
                                                                color:
                                                                    primaryBlue,
                                                              ),
                                                              title: Text(
                                                                tripsList[index]
                                                                    .createdAt
                                                                    .toString()
                                                                    .split(' ')
                                                                    .last,
                                                                style:
                                                                    TextStyle(
                                                                  color: primaryBlue,
                                                                  fontSize:
                                                                      5.sp,
                                                                ),
                                                              )),
                                                      ListTile(
                                                          leading: const Icon(
                                                            Icons.location_on,
                                                            color: primaryBlue,
                                                          ),
                                                          title: tripsList[
                                                                          index]
                                                                      .requestType !=
                                                                  'moment'
                                                              ? Text(
                                                                  'from'.tr() +
                                                                      ' ${tripsList[index].from.toString()}' +
                                                                      ' ' +
                                                                      'to'.tr() +
                                                                      ' ${tripsList[index].to.toString()}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: primaryBlue,
                                                                    fontSize:
                                                                        5.sp,
                                                                  ),
                                                                )
                                                              : Text(
                                                                  'from'.tr() +
                                                                      ' ' +
                                                                      ' ${tripsList[index].pickupAddr.toString()}' +
                                                                      ' ' +
                                                                      'to'.tr() +
                                                                      ' ' +
                                                                      '${tripsList[index].destAddr.toString()}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: primaryBlue,
                                                                    fontSize:
                                                                        5.sp,
                                                                  ),
                                                                )),
                                                      tripsList[index]
                                                                  .categoryId
                                                                  .toString() ==
                                                              '2'
                                                          ? ListTile(
                                                              leading:
                                                                  const Icon(
                                                                Icons
                                                                    .directions,
                                                                color:
                                                                    primaryBlue,
                                                              ),
                                                              title: Text(
                                                                ' ${tripsList[index].direction.toString()}',
                                                                style:
                                                                    TextStyle(
                                                                  color: primaryBlue,
                                                                  fontSize:
                                                                      5.sp,
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                      ListTile(
                                                        leading: const Icon(
                                                          Icons.money,
                                                          color: primaryBlue,
                                                        ),
                                                        title: Text(
                                                          formatter.format(int
                                                                  .parse(tripsList[
                                                                          index]
                                                                      .cost
                                                                      .toString())) +
                                                              'sp'.tr(),
                                                          style: TextStyle(
                                                            color: primaryBlue,
                                                            fontSize: 5.sp,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )),
                                          SizedBox(
                                            width: 3.w,
                                          )
                                        ],
                                      );
                                    }),
                              )
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