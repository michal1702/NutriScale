import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_app/constants.dart';

import '../text.dart';

class NumbersInputField extends StatefulWidget {
  NumbersInputField({
    Key? key,
    required this.hint,
    required this.controller,
    this.isError = false,
    this.decimal = false,
  }) : super(key: key);

  final String hint;
  final TextEditingController controller;
  final bool decimal;
  bool isError;

  @override
  _NumbersInputFieldState createState() => _NumbersInputFieldState();
}

class _NumbersInputFieldState extends State<NumbersInputField> {
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
        keyboardType: TextInputType.number,
        inputFormatters: [
          widget.decimal
              ? FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              : FilteringTextInputFormatter.digitsOnly,
        ],
        controller: widget.controller,
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
