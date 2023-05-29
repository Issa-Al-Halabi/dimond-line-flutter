import 'package:flutter/material.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:diamond_line/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContainerWidget extends StatefulWidget {
  ContainerWidget(
      {required this.text,
      required this.h,
      required this.w,
      required this.onTap,
      this.child,
      this.color = primaryBlue3,
      this.textColor = backgroundColor,
      this.borderRadius = 100,
      Key? key})
      : super(key: key);

  String? text;
  double? h;
  double? w;
  Color? color;
  Widget? child;
  Color? textColor;
  double? borderRadius;

  Function()? onTap;

  @override
  State<ContainerWidget> createState() => _ContainerState();
}

class _ContainerState extends State<ContainerWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: widget.h!,
        width: widget.w!,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 0),
            ),
          ],
          gradient: const RadialGradient(
            colors: [Colors.blueGrey, primaryBlue3],
            radius: 1.2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius!)),
          color: widget.color,
        ),
        child: Center(
            child: myText(
          text: widget.text,
          fontSize: 6.sp,
          color: widget.textColor,
        )),
      ),
    );
  }
}
