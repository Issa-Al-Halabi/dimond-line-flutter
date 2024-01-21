import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../Buisness_logic/provider/Driver_Provider/charge_wallet_provider.dart';
import '../../../../../Buisness_logic/provider/Driver_Provider/create_payment_id_provider.dart';
import '../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:crypto/crypto.dart';
import '../../../../Functions/helper.dart';
import '../../../../widgets/container_widget.dart';
import 'driver_dashboard.dart';
import 'ecash_webview.dart';

class ChargeWalletScreen extends StatefulWidget {
  ChargeWalletScreen({Key? key}) : super(key: key);

  @override
  State<ChargeWalletScreen> createState() => _ChargeWalletScreenState();
}

class _ChargeWalletScreenState extends State<ChargeWalletScreen> {
  bool _isNetworkAvail = true;
  String type = '';
  TextEditingController amountController = TextEditingController();
  final picker = ImagePicker();
  File? imageFile;
  late SharedPreferences prefs;
  String typeOfDriver = '';

  @override
  void initState() {
    initShared();
    super.initState();
  }

  Future initShared() async {
    prefs = await SharedPreferences.getInstance();
    typeOfDriver = prefs.getString('type_of_customer') ?? '';
    print('type_of_customer');
    print(typeOfDriver);
  }

  /////////////////////////// create payment id api //////////////////////////////////
  Future<void> createPaymentIdApi(
      String amount, CreatePaymentIdProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.createId(amount);
      String orderId = creat.data.data!.id.toString();
      print('orderId ' + orderId);
      if (creat.data.error == false) {
        Loader.hide();
        setState(() {
          createPaymentEcash(orderId);
        });
      } else {
        Loader.hide();
        setState(() {
          setSnackbar(creat.data.message.toString(), context);
        });
      }
    } else {
      setSnackbar("nointernet".tr(), context);
    }
  }

  // /////////////////////////// ChargeWallet api //////////////////////////////////
  // Future<void> chargeWalletApi(String method, String amount, ChargeWalletProvider creat) async {
  //   _isNetworkAvail = await isNetworkAvailable();
  //   if (_isNetworkAvail) {
  //     print("There is internet");
  //     Loader.show(context, progressIndicator: LoaderWidget());
  //     await creat.chargeWallet(method, amount);
  //     if (creat.data.error == false) {
  //       Loader.hide();
  //       setState(() {
  //         // setSnackbar(creat.data.message.toString(), context);
  //         setSnackbar('your request is in process, please wait'.tr(), context);
  //         Future.delayed(const Duration(seconds: 3)).then((_) async {
  //           if (typeOfDriver == 'driver') {
  //             Navigator.of(context).push(
  //               PageRouteBuilder(
  //                 pageBuilder: (BuildContext context,
  //                     Animation<double> animation,
  //                     Animation<double> secondaryAnimation) {
  //                   // return InDriverMainScreen();
  //                   return DriverDashboard(driverType: 'driver',);
  //                 },
  //                 transitionsBuilder: (BuildContext context,
  //                     Animation<double> animation,
  //                     Animation<double> secondaryAnimation,
  //                     Widget child) {
  //                   return Align(
  //                     child: SizeTransition(
  //                       sizeFactor: animation,
  //                       child: child,
  //                     ),
  //                   );
  //                 },
  //                 transitionDuration: Duration(milliseconds: 500),
  //               ),
  //             );
  //           } else {
  //             Navigator.of(context).push(
  //               PageRouteBuilder(
  //                 pageBuilder: (BuildContext context,
  //                     Animation<double> animation,
  //                     Animation<double> secondaryAnimation) {
  //                   // return OutDriverMainScreen();
  //                   return DriverDashboard(driverType: 'external_driver',);
  //                 },
  //                 transitionsBuilder: (BuildContext context,
  //                     Animation<double> animation,
  //                     Animation<double> secondaryAnimation,
  //                     Widget child) {
  //                   return Align(
  //                     child: SizeTransition(
  //                       sizeFactor: animation,
  //                       child: child,
  //                     ),
  //                   );
  //                 },
  //                 transitionDuration: Duration(milliseconds: 500),
  //               ),
  //             );
  //           }
  //         });
  //       });
  //     } else {
  //       Loader.hide();
  //       setState(() {
  //         setSnackbar(creat.data.message.toString(), context);
  //       });
  //     }
  //   } else {
  //     setSnackbar("nointernet".tr(), context);
  //   }
  // }

  /////////////////////////// ChargeWalletTransfer api //////////////////////////////////
  Future<void> chargeWalletTransferApi(String method, String amount,
      File imageFile, ChargeWalletProvider creat) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.chargeWalletTransfer(method, amount, imageFile);
      if (creat.data.error == false) {
        Loader.hide();
        setState(() {
          Navigator.of(context).pop();
          // setSnackbar(creat.data.message.toString(), context);
          setSnackbar('your request is in process, please wait'.tr(), context);
          Future.delayed(const Duration(seconds: 3)).then((_) async {
            if (typeOfDriver == 'driver') {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    // return InDriverMainScreen();
                    return DriverDashboard(
                      driverType: 'driver',
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
            } else {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    // return OutDriverMainScreen();
                    return DriverDashboard(
                      driverType: 'external_driver',
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
            }
          });
        });
      } else {
        Loader.hide();
        if (mounted) {
          setState(() {
            setSnackbar(creat.data.message.toString(), context);
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
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 3.h,
                            ),
                            Container(
                              // height: 70.h,
                              width: 90.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                              ),
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 7.h,
                                      ),
                                      Center(
                                        child: myText(
                                            text: 'choose the charge wallet'.tr(),
                                            fontSize: 5.sp,
                                            color: primaryBlue,
                                            fontWeight: FontWeight.w600),
                                      ),
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
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      // RadioListTile(
                                      //   title: myText(
                                      //     text: "cash".tr(),
                                      //     fontSize: 5.sp,
                                      //     color: primaryBlue,
                                      //   ),
                                      //   value: "cash",
                                      //   groupValue: type,
                                      //   activeColor: primaryBlue,
                                      //   onChanged: (value) {
                                      //     setState(() {
                                      //       type = "cash";
                                      //     });
                                      //   },
                                      // ),



                                      // TODO
                                      RadioListTile(
                                        title: myText(
                                          text: "ecash".tr(),
                                          fontSize: 5.sp,
                                          color: primaryBlue,
                                        ),
                                        value: "ecash",
                                        groupValue: type,
                                        activeColor: primaryBlue,
                                        onChanged: (value) {
                                          setState(() {
                                            // type = "ecash".tr();
                                            type = "ecash";
                                          });
                                        },
                                      ),
                                      RadioListTile(
                                        title: myText(
                                          text: "transfer".tr(),
                                          fontSize: 5.sp,
                                          color: primaryBlue,
                                        ),
                                        value: "transfer",
                                        groupValue: type,
                                        activeColor: primaryBlue,
                                        onChanged: (value) {
                                          setState(() {
                                            type = "transfer";
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 10.w, right: 10.w),
                                          child: TextFormField(
                                            controller: amountController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              errorStyle: TextStyle(
                                                  fontSize: 4.sp, height: 0.01.h),
                                              fillColor: Colors.white,
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 5.sp,
                                              ),
                                              suffixIcon: Icon(
                                                // Icons.money,
                                                Icons.edit,
                                                // color: primaryBlue,
                                                color: grey,
                                                size: 18,
                                              ),
                                              hintText:
                                                  'tap your amount please'.tr(),
                                            ),
                                            onChanged: (value) {},
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Container(
                                        width: 40.w,
                                        height: 6.h,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: primaryBlue.withOpacity(0.3),
                                              spreadRadius: 2,
                                              blurRadius: 7,
                                              offset: const Offset(0, 0),
                                            ),
                                          ],
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          color: primaryBlue,
                                        ),
                                        child: TextButton(
                                            child: Text(
                                              'submit'.tr(),
                                              style: TextStyle(
                                                  color: backgroundColor,
                                                  fontSize: 5.sp),
                                            ),
                                            onPressed: () async {
                                              print(type);
                                              print(amountController.text);
                                              if (amountController.text != '') {
                                                if (type == 'ecash') {
                                                  var creat = Provider.of<
                                                          CreatePaymentIdProvider>(
                                                      context,
                                                      listen: false);
                                                  createPaymentIdApi(
                                                      amountController.text,
                                                      creat);
                                                  // createPaymentEcash(
                                                  //   // widget.tripId
                                                  // );
                                                } else if (type == 'transfer') {
                                                  // getDialog();

                                                  bool isAndroid13 = false;
                                                  final androidInfo = await DeviceInfoPlugin().androidInfo;
                                                  if (androidInfo.version.sdkInt! <= 32) {
                                                    isAndroid13 = false;
                                                  }  else {
                                                    isAndroid13 = true;
                                                  }
                                                  var res = isAndroid13 == true ? await Permission.photos.request().isGranted : await Permission.storage.request().isGranted;
                                                  if (res) { var im = await picker.pickImage(source: ImageSource.gallery);
                                                  if (im != null) {
                                                    setState(() {
                                                      imageFile = File(im.path);
                                                    });
                                                    print(imageFile);
                                                    var creat = Provider.of<ChargeWalletProvider>(context,
                                                        listen: false);
                                                    chargeWalletTransferApi(
                                                        type, amountController.text, imageFile!, creat);
                                                  } else {
                                                    setSnackbar('please select image'.tr(), context);
                                                  }
                                                  }
                                                  else{
                                                    showWarningGalleryDialog(context);
                                                  }

                                                }
                                                // else {
                                                //   var creat =
                                                //   Provider.of<ChargeWalletProvider>(
                                                //       context,
                                                //       listen: false);
                                                //   chargeWalletApi(type, amountController.text, creat);
                                                // }
                                                else {}
                                              } else {
                                                setSnackbar(
                                                    'The amount field is required'
                                                        .tr(),
                                                    context);
                                              }
                                            }),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 3.h,
                  // ),
                  // BottomIconsDriver(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String generateMd5(String data) {
    var value = md5.convert(utf8.encode(data)).toString();
    return value;
  }

  // ecash
  Future<void> createPaymentEcash(String paymentId) async {
    // String baseUrl = 'https://checkout.ecash-pay.co';
    String baseUrl = 'https://checkout.ecash-pay.com';
    // String MerchantId = '4K1L3P';
    String MerchantId = 'T26REL';
    // String MerchantSecret = 'OX7JBF77DJECOVTA5R9HIZG019UUAHP3DOLUEM3U5IA0P1UXOQIYWCGE2Q7EG1NS';
    String MerchantSecret = '6VFDA69N466ZZ8KAOVO081J2VG0CKG8BSRLUN3NIFAB13PU3S50P6VGBRPG3A3A8';
    // String TerminalKey = 'LX94AO';
    String TerminalKey = 'ZPALC4';
    // String Amount = '1500';
    String Amount = amountController.text;
    String paymentRef = paymentId;
    //TODO
    String data = '$MerchantId$MerchantSecret$Amount$paymentRef';
    // String data = '$MerchantId$MerchantSecret$Amount';
    String VerificationCode = generateMd5(data);

    print('VerificationCode after crypto ' + VerificationCode);
    VerificationCode = VerificationCode.toUpperCase();
    print('VerificationCode after crypto and uppercase ' + VerificationCode);

    String redirectUrl = 'https%3a%2f%2fdiamond-line.com.sy/https%3a%2f%2fdiamond-line.com.sy%2fapi%2fecash-payment/';

    // String url = '$baseUrl/Checkout/Card/$TerminalKey/$MerchantId/$VerificationCode/SYP/$Amount/EN/$paymentRef/$RedirectUrl/$CallBackUrl';
    // String url ='$baseUrl/Checkout/Card/$TerminalKey/$MerchantId/$VerificationCode/SYP/$Amount/EN/$paymentRef';
    // String url ='$baseUrl/Checkout/Card/$TerminalKey/$MerchantId/$VerificationCode/SYP/$Amount/EN';
    // String url ='https://checkout.ecash-pay.co/Checkout/Card/LX94AO/4K1L3P/DFD9E15A637C52DB1A7C7C671530090C/SYP/1000/EN/1/https%3a%2f%2fdiamond-line.com.sy/https%3a%2f%2fdiamond-line.com.sy%2fapi%2fecash-payment/';


    String url ='$baseUrl/Checkout/Card/$TerminalKey/$MerchantId/$VerificationCode/SYP/$Amount/EN/$paymentRef/$redirectUrl';

    print('this url\n');
    print(url);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EcashWebView(
                url: url,
                paymentId: paymentRef,
                total: Amount,
                VerificationCode: VerificationCode)));
  }

  void getDialog() {
    AwesomeDialog(
      context: context,
      animType: AnimType.SCALE,
      btnOkColor: primaryBlue,
      dialogType: DialogType.NO_HEADER,
      padding: const EdgeInsets.all(10),
      body: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              SizedBox(
                height: 2.h,
              ),
              ContainerWidget(
                  text: 'camera'.tr(),
                  h: 6.h,
                  w: 60.w,
                  onTap: () async {
                    bool isAndroid13 = false;
                    final androidInfo = await DeviceInfoPlugin().androidInfo;
                    if (androidInfo.version.sdkInt! <= 32) {
                      isAndroid13 = false;
                    }  else {
                      isAndroid13 = true;
                    }
                    var res = isAndroid13 == true ? await Permission.photos.request().isGranted : await Permission.storage.request().isGranted;
                    if (res) { var im = await picker.pickImage(source: ImageSource.camera);
                    if (im != null) {
                      setState(() {
                        imageFile = File(im.path);
                      });
                      print(imageFile);
                      print(type);
                      print(amountController.text);
                      var creat = Provider.of<ChargeWalletProvider>(context,
                          listen: false);
                      chargeWalletTransferApi(
                          type, amountController.text, imageFile!, creat);
                    } else {
                      setSnackbar('please select image'.tr(), context);
                    }
                    }
                    else{
                      showWarningGalleryDialog(context);
                    }

                  }),
              SizedBox(
                height: 2.h,
              ),
              ContainerWidget(
                  text: 'choose file'.tr(),
                  h: 6.h,
                  w: 60.w,
                  onTap: () async {
                    bool isAndroid13 = false;
                    final androidInfo = await DeviceInfoPlugin().androidInfo;
                    if (androidInfo.version.sdkInt! <= 32) {
                      isAndroid13 = false;
                    }  else {
                      isAndroid13 = true;
                    }
                    var res = isAndroid13 == true ? await Permission.photos.request().isGranted : await Permission.storage.request().isGranted;
                    if (res) { var im =
                    await picker.pickImage(source: ImageSource.gallery);
                    if (im != null) {
                      setState(() {
                        imageFile = File(im.path);
                      });
                      print(imageFile);
                      var creat = Provider.of<ChargeWalletProvider>(context,
                          listen: false);
                      chargeWalletTransferApi(
                          type, amountController.text, imageFile!, creat);
                    } else {
                      setSnackbar('please select image'.tr(), context);
                    }
                    }
                    else{
                      showWarningGalleryDialog(context);
                    }

                  }),
              SizedBox(
                height: 2.h,
              ),
            ],
          );
        },
      ),
    ).show();
  }
}
