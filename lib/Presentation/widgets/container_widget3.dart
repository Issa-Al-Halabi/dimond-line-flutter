import 'package:flutter/material.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:diamond_line/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContainerWidget3 extends StatefulWidget {
  ContainerWidget3(
      {required this.text,
      this.h,
      this.w,
      this.onIconPressed,
      this.icon,
      this.child,
      this.color = primaryBlue3,
      this.textColor = backgroundColor,
      this.borderRadius = 100,
      Key? key})
      : super(key: key);

  String? text;
  double? h = 6.h;
  double? w = 70.w;
  Color? color;
  Widget? child;
  Color? textColor;
  double? borderRadius;
  IconData? icon;

  Function()? onIconPressed;

  @override
  State<ContainerWidget3> createState() => _ContainerState();
}

class _ContainerState extends State<ContainerWidget3> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.h,
      width: widget.w,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius!)),
        color: widget.color,
      ),
      child: Padding(
        padding: EdgeInsets.only(right: 2.w, left: 2.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            myText(
              text: widget.text,
              fontSize: 5.sp,
              color: widget.textColor,
            ),
            IconButton(onPressed: widget.onIconPressed, icon: Icon(widget.icon)),
          ],
        ),
      ),
    );
  }
}
