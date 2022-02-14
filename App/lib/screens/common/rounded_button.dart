import 'package:flutter/material.dart';
import 'package:food_app/constants.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    required this.text,
    required this.action,
  }) : super(key: key);

  final String text;
  final void Function() action;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: action,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Text(
            text,
            style: TextStyle(
                color: textWhiteColor,
                fontFamily: defaultFont,
                fontSize: 25,
                fontWeight: FontWeight.w100),
          ),
        ),
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(150.0, 0.0)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius))),
          backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
        ),
      ),
    );
  }
}