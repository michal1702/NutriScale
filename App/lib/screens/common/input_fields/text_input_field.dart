import 'package:flutter/material.dart';
import 'package:food_app/constants.dart';

import '../text.dart';

class TextInputField extends StatefulWidget {
  TextInputField({
    Key? key,
    required this.hint,
    this.isSensitive = false,
    required this.controller,
    this.isError = false,
  }) : super(key: key);

  final String hint;
  final bool isSensitive;
  final TextEditingController controller;
  bool isError;

  @override
  _TextInputFieldState createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      decoration: BoxDecoration(
          color: textWhiteColor,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          border: Border.all(
              color: widget.isError ? errorColor : textWhiteColor, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: shadowBlackColor,
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: Offset(0.0, 4.0),
            )
          ]),
      padding: EdgeInsets.only(left: 15.0),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isSensitive,
        style: TextStyle(
            decorationColor: textWhiteColor,
            fontFamily: defaultFont,
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: textBlackColor),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hint,
          hintStyle: buildHintTextStyle(shadowBlackColor),
        ),
      ),
    );
  }
}
