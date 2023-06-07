import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import '../../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/get_goverment_provider.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import '../../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../Functions/helper.dart';
import 'map_screen.dart';

class SelectGoverment extends StatefulWidget {
  const SelectGoverment({Key? key}) : super(key: key);

  @override
  State<SelectGoverment> createState() => _SelectGovermentState();
}

class _SelectGovermentState extends State<SelectGoverment> {
  bool _isNetworkAvail = true;
  late List titleList;
  late List subCategoryIdList;
  late List categoryIdList;
  String subCategoryId = '';
  String categoryId = '';
  String title = '';
  int countGoverment = 0;
  String govermentType = '';

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    var creat = await Provider.of<GetGovermentProvider>(context, listen: false);
    GetGovermentApi(creat);
  }

  /////////////////////////get goverment api //////////////////////////////////
  Future<void> GetGovermentApi(GetGovermentProvider creat) async {
    subCategoryIdList = [];
    titleList = [];
    categoryIdList = [];
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: LoaderWidget());
      await creat.getGoverment();
      if (creat.data.error == false) {
        for (int i = 0; i < creat.data.data!.length; i++) {
          setState(() {
            subCategoryIdList.add(creat.data.data![i].id.toString());
            categoryIdList.add(creat.data.data![i].categoryId);
            titleList.add(creat.data.data![i].title);
          });
        }
        countGoverment = creat.data.data!.length;
        print(titleList);
        Loader.hide();
        setState(() {});
      } else {
        Loader.hide();
        setSnackbar("creat.data.message.toString()", context);
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
                            height: 2.h,
                          ),
                          Expanded(
                            child: myText(
                              text: 'select the destination'.tr(),
                              fontSize: 8.sp,
                              color: primaryBlue,
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: ListView.builder(
                                itemCount: countGoverment,
                                itemBuilder: (BuildContext context, int index) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            height: 8.h,
                                            width: 50.w,
                                            child: RadioListTile<String>(
                                              title: Text(
                                                titleList[index].toString(),
                                                style: TextStyle(
                                                    fontSize: 5.sp,
                                                    color: primaryBlue3),
                                              ),
                                              value: titleList[index].toString(),
                                              groupValue: govermentType,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  print(value);
                                                  print(subCategoryIdList[index]);
                                                  print(categoryIdList[index]);
                                                  print(titleList[index]);
                                                  govermentType = value!;
                                                  subCategoryId =
                                                      subCategoryIdList[index]
                                                          .toString();
                                                  categoryId =
                                                      categoryIdList[index]
                                                          .toString();
                                                  title = titleList[index];
                                                });
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                        ],
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
                                    if(title == ''){
                                      print('no');
                                      setSnackbar('please select the destination'.tr(), context);
                                    }
                                    else{ Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => MapScreen(
                                          country: 'damas',
                                          categoryId: categoryId.toString(),
                                          subCategoryId: subCategoryId,
                                          to: title,
                                        )));
                                    }
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
            )),
      ),
    );
  }
}