import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../constants.dart';

class VerificationCodeField extends StatefulWidget {
  VerificationCodeField({Key? key,required this.onChange, required this.textEditingController,required this.length}) : super(key: key);

  TextEditingController textEditingController;
  int length;
  Function(String) onChange;
  @override
  _VerificationCodeFieldState createState() => _VerificationCodeFieldState();
}

class _VerificationCodeFieldState extends State<VerificationCodeField> {
  String currentText = '';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: PinCodeTextField(
          appContext: context,
          length: widget.length,
          obscureText: false,
          animationType: AnimationType.scale,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            activeColor: primaryBlue,
            inactiveColor: primaryBlue,
            selectedColor: Colors.lightBlueAccent,
            activeFillColor: Colors.grey.shade300,
            selectedFillColor: Colors.grey.shade300,
            inactiveFillColor: Colors.grey.shade300,
          ),
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: const Color(0x008ebcd2),
          enableActiveFill: true,
          keyboardType: TextInputType.phone,
          onCompleted: (v) {
            widget.onChange(v);
          },
          onChanged: (value){
            setState(() {
              currentText = value;
            });
          }
        ),
      ),
    );
  }
}
