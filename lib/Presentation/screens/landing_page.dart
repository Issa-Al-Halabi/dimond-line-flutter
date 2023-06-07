import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_registration/are_you.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/text.dart';
import '../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  int bottomSelectedIndex = 0;

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  Widget getSkip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              pageController.jumpToPage(2);
            });
          },
          child: myText(
            text: 'skip'.tr(),
            fontSize: 6.sp,
            color: primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryBlue,
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            pageChanged(index);
            print(index);
          },
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: getScreenHeight(context),
                    width: getScreenWidth(context),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(background),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 5.h, bottom: 10.h),
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: backgroundColor,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              getSkip(),
                              SizedBox(height: 7.h),
                              Image.asset(images[0]),
                              SizedBox(height: 5.h),
                              Text(
                                'DIAMOND LINE ABYDOS',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 5.sp,
                                    color: primaryBlue2,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                texts[0].tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 5.sp,
                                  color: primaryBlue2,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              ContainerWidget(
                                h: 7.h,
                                w: 60.w,
                                text: 'next'.tr(),
                                onTap: () {
                                  pageController.jumpToPage(1);
                                },
                              ),
                               SizedBox(height: 2.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ///////////////////second page
            Container(
              height: getScreenHeight(context),
              width: getScreenWidth(context),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(background),
                  fit: BoxFit.fill,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 5.h, bottom: 7.h),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: backgroundColor,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 7.h),
                        Image.asset(images[1]),
                        SizedBox(height: 7.h),
                        Text(
                          "text2_1".tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 5.sp,
                              color: primaryBlue2,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          texts[1].tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 5.sp,
                            color: primaryBlue2,
                            // fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 6.h),
                        ContainerWidget(
                          h: 7.h,
                          w: 60.w,
                          text: 'next'.tr(),
                          onTap: () {
                            pageController.jumpToPage(2);
                          },
                        ),
                         SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        
            ///////////////////////////third page
            Container(
              height: getScreenHeight(context),
              width: getScreenWidth(context),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(background),
                  fit: BoxFit.fill,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 5.h, bottom: 7.h),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: backgroundColor,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 7.h),
                        Image.asset(images[2]),
                        SizedBox(height: 7.h),
                        Text(
                          texts[2].tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 5.sp,
                              color: primaryBlue2,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.h),
                        ContainerWidget(
                          h: 7.h,
                          w: 80.w,
                          text: 'discover'.tr(),
                          onTap: () async {
                            SharedPreferences pref = await SharedPreferences.getInstance();
                            pref.setBool('isFirstTimeUser', false);
                              // Navigator.of(context).push(
                              Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation) {
                                  return AreYou();
                                  // return LoginScreen();
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
                          },
                        ),
                         SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}