import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../constants.dart';
import 'custom_icon.dart';

class CustomErrorScreen extends StatelessWidget {
  final Function()? onTap;
  const CustomErrorScreen({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Lottie.asset(iconNoInternet),
        const SizedBox(height: 100),
        CustomButton(label: "اعادة المحاولة",onTap: (){
          onTap!();
        },)
      ],
    );
  }
}
