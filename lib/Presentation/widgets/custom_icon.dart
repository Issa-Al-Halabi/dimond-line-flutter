import 'package:flutter/material.dart';
import '../../constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.fillColor = yellow,
    this.isFilled = true,
    this.labelColor = Colors.white,
    required this.label,
    this.onTap,
  }) : super(key: key);
  final Color fillColor;
  final bool isFilled;
  final Color labelColor;
  final String label;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
      onTap,

      child: Container(
        width: 300,
        decoration: BoxDecoration(
            color: isFilled ? fillColor : null,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: fillColor),
            boxShadow: isFilled
                ? [
              BoxShadow(
                color: grey,
                blurRadius: 4,
              )
            ]
                : []),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              label,
              // style: getBoldStyle(
              //   color: labelColor,
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
