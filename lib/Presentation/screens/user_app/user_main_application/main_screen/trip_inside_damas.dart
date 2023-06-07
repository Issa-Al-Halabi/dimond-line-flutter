import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/loader_widget.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:diamond_line/Presentation/widgets/container_widget2.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:intl/intl.dart';
import '../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripInsideDamasScreen extends StatefulWidget {
  const TripInsideDamasScreen({Key? key}) : super(key: key);

  @override
  State<TripInsideDamasScreen> createState() => _TripInsideDamasScreenState();
}

class _TripInsideDamasScreenState extends State<TripInsideDamasScreen> {
  String? type;

  bool showTime = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  bool showDate = false;
  DateTime selectedDate = DateTime.now();
  String getTime(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  //  Select for Time
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
      });
    }
    return selectedTime;
  }

  String getDate() {
    if (selectedDate == null) {
      return 'select date';
    } else {
      return DateFormat('MMM d, yyyy').format(selectedDate);
    }
  }

  // Select for Date
  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      // firstDate: DateTime(2000),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
    return selectedDate;
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          myText(
                            text: 'trip inside'.tr(),
                            fontSize: 7.sp,
                            color: primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          const Divider(
                            color: lightBlue2,
                            thickness: 7,
                            indent: 35,
                            endIndent: 45,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Container(
                            height: 6.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: Offset(0, 0),
                                ),
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              color: backgroundColor,
                            ),
                            child: DropdownButton(
                              underline:
                                  DropdownButtonHideUnderline(child: Container()),
                              isExpanded: true,
                              hint: Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: Text(
                                  'person'.tr(),
                                  style: TextStyle(color: grey, fontSize: 4.sp),
                                ),
                              ),
                              value: dropDownValue,
                              icon: Padding(
                                padding: EdgeInsets.only(right: 1.w),
                                child: const Icon(Icons.keyboard_arrow_down),
                              ),
                              items: personItems.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 1.w),
                                      child: Text(items)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  dropDownValue = val.toString();
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Container(
                            height: 6.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: Offset(0, 0),
                                ),
                              ],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              color: backgroundColor,
                            ),
                            child: DropdownButton(
                              underline:
                                  DropdownButtonHideUnderline(child: Container()),
                              isExpanded: true,
                              hint: Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: Text(
                                  'bags'.tr(),
                                  style: TextStyle(color: grey, fontSize: 4.sp),
                                ),
                              ),
                              value: dropDownValue2,
                              icon: Padding(
                                padding: EdgeInsets.only(right: 2.w),
                                child: const Icon(Icons.keyboard_arrow_down),
                              ),
                              items: bagsItems.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 1.w),
                                      child: Text(items)),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  dropDownValue2 = val.toString();
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          const Divider(
                            color: lightBlue2,
                            thickness: 7,
                            indent: 35,
                            endIndent: 45,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          ContainerWidget2(
                            text: 'select date'.tr(),
                            h: 6.h,
                            w: 80.w,
                            onTap: () {
                              _selectDate(context);
                              showDate = true;
                            },
                            color: backgroundColor,
                            textColor: lightBlue,
                          ),
                          showDate
                              ? Center(child: Text(getDate()))
                              : const SizedBox(),
                          SizedBox(
                            height: 2.h,
                          ),
                          ContainerWidget2(
                            text: 'select time'.tr(),
                            h: 6.h,
                            w: 80.w,
                            onTap: () {
                              _selectTime(context);
                              showTime = true;
                            },
                            color: backgroundColor,
                            textColor: lightBlue,
                          ),
                          showTime
                              ? Center(child: Text(getTime(selectedTime)))
                              : const SizedBox(),
                          SizedBox(
                            height: 12.h,
                          ),
                          ContainerWidget(
                            text: 'done'.tr(),
                            h: 6.h,
                            w: 80.w,
                            onTap: () {},
                            color: backgroundColor,
                          ),
                          SizedBox(
                            height: 2.h,
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