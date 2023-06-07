import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import '../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Functions/helper.dart';

class TripDetailsSettings extends StatefulWidget {
  const TripDetailsSettings({Key? key}) : super(key: key);

  @override
  State<TripDetailsSettings> createState() => _TripDetailsSettingsState();
}

class _TripDetailsSettingsState extends State<TripDetailsSettings> {
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
                        Container(
                          height: 50.h,
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
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: backgroundColor,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    logo,
                                    height: 12.h,
                                    width: 25.w,
                                    color: primaryBlue,
                                  ),
                                  Column(
                                    children: [
                                      myText(
                                        text: 'khaled Nader',
                                        fontSize: 4.sp,
                                        color: grey,
                                      ),
                                      SizedBox(
                                        height: 0.5.h,
                                      ),
                                      Container(
                                        height: 5.h,
                                        width: 40.w,
                                        decoration: BoxDecoration(
                                          color: backgroundColor,
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
                                        ),
                                        child: Center(
                                            child: myText(
                                              text: '099454851633',
                                              fontSize: 4.sp,
                                              color: primaryBlue,
                                            )),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(
                                color: grey,
                                thickness: 2,
                                indent: 15,
                                endIndent: 25,
                              ),
                              ListTile(
                                  leading: const Icon(
                                    Icons.date_range,
                                    color: primaryBlue,
                                  ),
                                  title: Text(
                                    "14/9/2022",
                                    style: TextStyle(
                                      color: grey,
                                      fontSize: 5.sp,
                                    ),
                                  )),
                              ListTile(
                                  leading: Image.asset(
                                    clock,
                                    color: primaryBlue,
                                  ),
                                  title: Text(
                                    "9:10 pm",
                                    style: TextStyle(
                                      color: grey,
                                      fontSize: 5.sp,
                                    ),
                                  )),
                              ListTile(
                                  leading: const Icon(
                                    Icons.location_on,
                                    color: primaryBlue,
                                  ),
                                  title: Text(
                                    "from damascus to aleppo",
                                    style: TextStyle(
                                      color: grey,
                                      fontSize: 5.sp,
                                    ),
                                  )),
                              ListTile(
                                  leading: Image.asset(
                                    trip,
                                    color: primaryBlue,
                                  ),
                                  title: Text(
                                    "trip type: inside syria",
                                    style: TextStyle(
                                      color: grey,
                                      fontSize: 5.sp,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        ContainerWidget(
                            text: 'done'.tr(),
                            h: 7.h,
                            w: 80.w,
                            onTap: () {
                              Navigator.pushNamed(context, 'select');
                            }),
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
