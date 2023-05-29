import 'package:flutter/material.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:diamond_line/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContainerWithIcon extends StatefulWidget {
  ContainerWithIcon(
      {required this.text,
      required this.h,
      required this.w,
      required this.onTap,
      this.child,
      this.color = primaryBlue3,
      this.textColor = backgroundColor,
      // this.icon = const Icon(Icons.add),
      // this.iconData,
      this.iconImage,
      this.iconColor,
      Key? key})
      : super(key: key);

  String? text;
  double? h;
  double? w;
  Color? color;
  Widget? child;
  Color? textColor;
  // Icon? icon ;
  // IconData? iconData;
  String? iconImage;
  Color? iconColor;

  Function()? onTap;

  @override
  State<ContainerWithIcon> createState() => _ContainerWithIconState();
}

class _ContainerWithIconState extends State<ContainerWithIcon> {
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
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          color: widget.color,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 3.w, right: 3.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              myText(
                text: widget.text,
                fontSize: 5.sp,
                color: widget.textColor,
              ),
              // widget.icon!,
              // Icon(
              //   widget.iconData,
              //   color: widget.iconColor,
              //   size: iconSize,
              // ),
              ImageIcon(
                AssetImage(widget.iconImage!),
                color: widget.iconColor,
                size: iconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
