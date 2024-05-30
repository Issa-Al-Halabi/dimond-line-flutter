import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import '../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Maintenance extends StatefulWidget {
  const Maintenance({Key? key}) : super(key: key);

  @override
  State<Maintenance> createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {
  TextEditingController txt1 = TextEditingController();
  TextEditingController txt2 = TextEditingController();

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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8.h,
                        ),
                        myText(
                          text: 'mainten'.tr(),
                          fontSize: 8.sp,
                          color: primaryBlue,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Container(
                          height: 20.h,
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 2.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                myText(
                                  text: 'mainten type'.tr(),
                                  fontSize: 5.sp,
                                  color: grey,
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                myText(
                                  text: 'Replacing the windshield wipers',
                                  fontSize: 5.sp,
                                  color: primaryBlue,
                                  fontWeight: FontWeight.bold,
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
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                    color: white,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      size: iconSize,
                                      color: primaryBlue,
                                    ),
                                    onPressed: () {
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
                                                  text: 'mainten type'.tr(),
                                                  fontSize: 5.sp,
                                                  color: grey,
                                                ),
                                                SizedBox(
                                                  height: 1.h,
                                                ),
                                                TextField(
                                                  controller: txt1,
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
                                                  controller: txt2,
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                        btnOkOnPress: () {
                                        },
                                      ).show();
                                    },
                                  )),
                            ],
                          ),
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