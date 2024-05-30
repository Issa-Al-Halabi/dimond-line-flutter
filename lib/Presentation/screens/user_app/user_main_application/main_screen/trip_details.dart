import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import '../../../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripDetails extends StatefulWidget {
  const TripDetails({Key? key}) : super(key: key);

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: 8.h,
                      ),
                      Container(
                        height: 40.h,
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
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 2.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 1.h,
                              ),
                              myText(
                                text: 'From: Damascus',
                                fontSize: 5.sp,
                                color: lightBlue,
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              myText(
                                text: 'To: Aleppo',
                                fontSize: 5.sp,
                                color: lightBlue,
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              myText(
                                text: 'Person: 4',
                                fontSize: 5.sp,
                                color: lightBlue,
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              myText(
                                text: 'Bags: 3',
                                fontSize: 5.sp,
                                color: lightBlue,
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              myText(
                                text: 'On: 3/9/2022  3:16 pm',
                                fontSize: 5.sp,
                                color: lightBlue,
                              ),
                              SizedBox(
                                height: 6.h,
                              ),

                              //////
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 10.w,
                                  right: 10.w,
                                ),
                                child: ContainerWidget(
                                    text: 'ok'.tr(),
                                    h: 5.h,
                                    w: 50.w,
                                    onTap: () {}),
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 20.w, right: 15.w),
                                child: InkWell(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: iconSize,
                                        color: lightBlue,
                                      ),
                                      myText(
                                        text: 'add a trip',
                                        fontSize: 5.sp,
                                        color: lightBlue,
                                      )
                                    ],
                                  ),
                                  onTap: (){
                                    print(',,,,,,');
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}