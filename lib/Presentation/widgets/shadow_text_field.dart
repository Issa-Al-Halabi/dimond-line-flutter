import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants.dart';

class ShadowTextField extends StatefulWidget {
  String? errorLabel;
  String? title;
  String? hintText;
  double? fontSizeForTitle;
  double? fontSizeForHintText = 5.sp;
  Function(String)? onChange;
  Color? titleColor;
  Color? containerColor;
  Icon? icon;
  Icon? icon2;
  bool showPassword = false;
  double? height = 10.h;
  double? width = 70.w;
  String? Function(String?)? validateFunction;
  TextEditingController textEditingController = TextEditingController();

  ShadowTextField(
      {required this.hintText,
      required this.title,
      required this.fontSizeForHintText,
      required this.errorLabel,
      required this.fontSizeForTitle,
      required this.onChange,
      this.titleColor = primaryBlue,
      this.containerColor = Colors.white,
      this.icon,
      this.icon2,
      this.height,
      this.width,
      this.validateFunction,
      required this.textEditingController,
      Key? key})
      : super(key: key);

  @override
  _ShadowTextFieldState createState() => _ShadowTextFieldState();
}

class _ShadowTextFieldState extends State<ShadowTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title.toString(),
            style: TextStyle(
                color: widget.titleColor, fontSize: widget.fontSizeForTitle),
          ),
          SizedBox(height: 1.h),
          Stack(
            children: <Widget>[
              Container(
                height: widget.height,
                width: widget.width,
                decoration: BoxDecoration(
                  color: widget.containerColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                ),
              ),
              SizedBox(
                height: 10.h,
                width: 60.w,
                child: Padding(
                  padding: EdgeInsets.only(left: 3.w),
                  child: TextFormField(
                    controller: widget.textEditingController,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(fontSize: 4.sp, height: 0.01.h),
                      fillColor: Colors.white,
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: widget.fontSizeForHintText),
                      errorText:
                          widget.errorLabel == '' ? null : widget.errorLabel,
                      border: InputBorder.none,
                      icon: widget.icon,
                    ),
                    onChanged: widget.onChange,
                    validator: widget.validateFunction,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
