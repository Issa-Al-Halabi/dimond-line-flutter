import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants.dart';

class ContainerWithTextField extends StatefulWidget {
  ContainerWithTextField(
      {required this.hintText,
      required this.onTap,
      this.h,
      this.w,
      this.child,
      this.color = primaryBlue3,
      this.txtController,
      this.icon,
      this.validateFunction,
      this.isPassword = false,
      Key? key})
      : super(key: key);

  String? hintText;
  double? h = 6.h;
  double? w = 80.w;
  Color? color;
  Widget? child;
  TextEditingController? txtController = TextEditingController();
  String? Function(String?)? validateFunction;

  Icon? icon;
  bool isPassword;

  Function()? onTap;

  @override
  State<ContainerWithTextField> createState() => _ContainerWithTextFieldState();
}

class _ContainerWithTextFieldState extends State<ContainerWithTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.h,
      width: widget.w,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 3.w, right: 3.w),
        child: TextFormField(
          controller: widget.txtController,
          obscureText: widget.isPassword,
          decoration: InputDecoration(
            errorStyle: TextStyle(fontSize: 4.sp, height: 0.01.h),
            fillColor: Colors.white,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 5.sp,
            ),
            suffixIcon: widget.icon,
            hintText: widget.hintText,
            border: InputBorder.none,
          ),
          onChanged: (value) {},
          validator: widget.validateFunction,
        ),
      ),
    );
  }
}
