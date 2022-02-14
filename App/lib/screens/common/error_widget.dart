import 'package:flutter/material.dart';

import '../../constants.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: defaultFont,
            fontWeight: FontWeight.w500,
            fontSize: 25,
            color: errorColor),
      ),
    );
  }
}
