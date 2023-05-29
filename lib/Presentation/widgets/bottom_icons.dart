import 'package:flutter/material.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/profile_screen/user_settings.dart';
import '../../constants.dart';
import '../screens/user_app/user_main_application/main_screen/select_type.dart';
import '../screens/user_app/user_main_application/main_screen/user_orders.dart';
import '../screens/user_app/user_main_application/profile_screen/user_profile_settings.dart';

class BottomIcons extends StatefulWidget {
  BottomIcons({
    Key? key,
  }) : super(key: key);

  @override
  _BottomIconsState createState() => _BottomIconsState();
}

class _BottomIconsState extends State<BottomIcons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          focusColor:  Colors.red,
          hoverColor:  Colors.green,
          splashColor:  Colors.blue,
          highlightColor:  Colors.black,
          overlayColor:  MaterialStateProperty.resolveWith(
                (states) {
                  return states.contains(MaterialState.focused)
                      ? Colors.orange
                      : null;
                },
              ),
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
                  return UserSettings();
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

        // MaterialButton(
        //   onPressed: () {
        //     Navigator.of(context).push(
        //       PageRouteBuilder(
        //         pageBuilder: (BuildContext context, Animation<double> animation,
        //             Animation<double> secondaryAnimation) {
        //           return UserSettings();
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
        //   child: ImageIcon(
        //     const AssetImage(choices),
        //     color: backgroundColor,
        //     size: iconSize,
        //   ),
        //   // color: primaryBlue,
        //   // disabledColor: Colors.red,
        //   // focusColor: Colors.red,
        //   splashColor: backgroundColor,
        //   // hoverColor: Colors.red,
        // ),

        //  ElevatedButton(
        //     onPressed: () {
        //        Navigator.of(context).push(
        //       PageRouteBuilder(
        //         pageBuilder: (BuildContext context, Animation<double> animation,
        //             Animation<double> secondaryAnimation) {
        //           return UserSettings();
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
        //     },
        //     style: ButtonStyle(
        //       overlayColor: MaterialStateProperty.resolveWith(
        //         (states) {
        //           return states.contains(MaterialState.pressed)
        //               ? Colors.red
        //               : null;
        //         },
        //       ),
        //     ),
        //     child: const Text(
        //       'Elevated Button',
        //       style: TextStyle(fontSize: 20),
        //     ),
        //   ),


        InkWell(child: Icon(Icons.home, color: backgroundColor, size: iconSize2),
            onTap: (){
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (BuildContext context, Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return SelectType();
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
        //     onTap: (){
        //       Navigator.of(context).push(
        //         PageRouteBuilder(
        //           pageBuilder: (BuildContext context, Animation<double> animation,
        //               Animation<double> secondaryAnimation) {
        //             return UserProfileSettings();
        //           },
        //           transitionsBuilder: (BuildContext context,
        //               Animation<double> animation,
        //               Animation<double> secondaryAnimation,
        //               Widget child) {
        //             return Align(
        //               child: SizeTransition(
        //                 sizeFactor: animation,
        //                 child: child,
        //               ),
        //             );
        //           },
        //           transitionDuration: Duration(milliseconds: 500),
        //         ),
        //       );
        //     }),
        InkWell(child: ImageIcon(
          const AssetImage(trips),
          color: backgroundColor,
          size: iconSize,
        ),
            onTap: (){
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return UserOrders();
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

        // ImageIcon(
        //   const AssetImage(notification),
        //   color: backgroundColor,
        //   size: iconSize,
        // ),
        // ImageIcon(
        //   const AssetImage(search),
        //   color: backgroundColor,
        //   size: iconSize,
        // ),
      ],
    );
  }
}
