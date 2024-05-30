import 'package:flutter/material.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_main_screen/internal_driver_screen.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_main_screen/external_driver_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../screens/driver_app/driver_main_application/driver_main_screen/driver_efficient_trips.dart';
import '../screens/driver_app/driver_main_application/driver_profile_screen/driver_settings.dart';

class BottomIconsDriver extends StatefulWidget {
  BottomIconsDriver({
    Key? key,
  }) : super(key: key);

  @override
  _BottomIconsDriverState createState() => _BottomIconsDriverState();
}

class _BottomIconsDriverState extends State<BottomIconsDriver> {
  late SharedPreferences prefs;
  late String type;

  Future initShared() async {
    prefs = await SharedPreferences.getInstance();
    type = prefs.getString('type_of_customer') ?? '';
    print('type_of_customer');
    print(type);
  }

  @override
  void initState() {
    initShared();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          child: ImageIcon(
            const AssetImage(choices),
            color: backgroundColor,
            size: iconSize,
          ),
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return DriverSettings();

                  // return type == 'external_driver' ? OutDriverMainScreen()
                  // : InDriverMainScreen();
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
        // ImageIcon(
        //   // const AssetImage(notification),
        //   const AssetImage(notification),
        //   color: backgroundColor,
        //   size: iconSize,
        // ),
        InkWell(child: Icon(Icons.home, color: backgroundColor, size: iconSize2),
        onTap: (){
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                // return DriverSettings();

                return type == 'external_driver' ? OutDriverMainScreen()
                : InDriverMainScreen();
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
        }),


        // InkWell(child: Icon(Icons.person, color: backgroundColor, size: iconSize2),
        // onTap: (){
        //   Navigator.of(context).push(
        //     PageRouteBuilder(
        //       pageBuilder: (BuildContext context, Animation<double> animation,
        //           Animation<double> secondaryAnimation) {
        //         return DriverSettings();
        //
        //         // return type == 'external_driver' ? OutDriverMainScreen()
        //         // : InDriverMainScreen();
        //       },
        //       transitionsBuilder: (BuildContext context,
        //           Animation<double> animation,
        //           Animation<double> secondaryAnimation,
        //           Widget child) {
        //         return Align(
        //           child: SizeTransition(
        //             sizeFactor: animation,
        //             child: child,
        //           ),
        //         );
        //       },
        //       transitionDuration: Duration(milliseconds: 500),
        //     ),
        //   );
        // }),

        InkWell(
          child: ImageIcon(
            const AssetImage(trips),
            color: backgroundColor,
            size: iconSize,
          ),
          onTap: () {
             Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  // return DriverTrips();
                  return EfficientDriverTrips();
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

        // InkWell(
        //   child: ImageIcon(
        //     const AssetImage(notification),
        //     color: Colors.red,
        //     size: iconSize,
        //   ),
        //   onTap: () {
        //      Navigator.of(context).push(
        //       PageRouteBuilder(
        //         pageBuilder: (BuildContext context, Animation<double> animation,
        //             Animation<double> secondaryAnimation) {
        //           return OutDriverMainScreen();
        //         },
        //         transitionsBuilder: (BuildContext context,
        //             Animation<double> animation,
        //             Animation<double> secondaryAnimation,
        //             Widget child) {
        //           return Align(
        //             child: SizeTransition(
        //               sizeFactor: animation,
        //               child: child,
        //             ),
        //           );
        //         },
        //         transitionDuration: Duration(milliseconds: 500),
        //       ),
        //     );
        //   },
        // ),

        // ImageIcon(
        //   // const AssetImage(search),
        //   const AssetImage(profile),
        //   color: backgroundColor,
        //   size: iconSize,
        // ),
      ],
    );
  }
}
