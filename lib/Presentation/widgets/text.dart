import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class myText extends StatefulWidget {
  myText({
    this.color = Colors.black,
    this.align = null,
    this.fontWeight = FontWeight.normal,
    required this.text,
    required this.fontSize,
    Key? key,
  }) : super(key: key);

  String? text;
  double? fontSize;
  Color? color;
  TextAlign? align;
  FontWeight? fontWeight;

  @override
  _myTextState createState() => _myTextState();
}

class _myTextState extends State<myText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text!,
      style: TextStyle(
          color: widget.color,
          fontSize: widget.fontSize!,
          fontWeight: widget.fontWeight!,
          fontFamily: 'assets/fonts/Almarai-Regular'),
      textAlign: widget.align,
    );
  }
}
