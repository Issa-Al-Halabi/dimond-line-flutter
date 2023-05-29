import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants.dart';

class TextWithTextField extends StatefulWidget {
  TextWithTextField(
      {this.onTap,
      this.hintText,
      this.color = primaryBlue2,
      this.icon,
      this.text,
      this.controller,
      // required this.formKey,
      this.validateFunction,
      Key? key})
      : super(key: key);

  String? hintText;
  Color? color;
  String? text;
  Icon? icon;
  Function()? onTap;
  String? Function(String?)? validateFunction;
  TextEditingController? controller = TextEditingController();
  // var formKey = GlobalKey<FormState>();

  @override
  State<TextWithTextField> createState() => _TextWithTextFieldState();
}

class _TextWithTextFieldState extends State<TextWithTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          myText(
            text: widget.text,
            fontSize: 5.sp,
            color: widget.color,
            fontWeight: FontWeight.bold,
          ),
          // TextFormField(
          //   controller:widget.controller,
          //   // obscureText: true,
          //   decoration: InputDecoration(
          //     fillColor: Colors.white,
          //     hintStyle: TextStyle(
          //       color: widget.color,
          //       fontSize: 5.sp,
          //     ),
          //     icon: widget.icon,
          //     hintText: widget.hintText,
          //     // border: InputBorder.,
          //   ),
          //   onChanged: (value) {},
          // ),
          TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              errorStyle: TextStyle(fontSize: 4.sp, height: 0.1.h),
              fillColor: Colors.white,
              hintStyle: TextStyle(
                color: widget.color,
                fontSize: 5.sp,
              ),
              suffixIcon: widget.icon,
              hintText: widget.hintText,
            ),
            validator: widget.validateFunction,
            onSaved: (value) {
              widget.controller!.text = value!;
            },
          ),
          // ElevatedButton(onPressed: (){
          //   widget.formKey.currentState?.validate();
          // },
          //  child: Text('preeeeeeeees'))
        ],
      ),
    );
  }
}
