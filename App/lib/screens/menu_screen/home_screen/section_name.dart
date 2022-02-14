import 'package:flutter/material.dart';
import 'package:food_app/screens/common/text.dart';

import '../../../constants.dart';

class SectionName extends StatelessWidget {
  const SectionName({
    Key? key,
    required this.sectionName,
    required this.buttonAction,
  }) : super(key: key);

  final String sectionName;
  final void Function() buttonAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            sectionName,
            style: buildBigTextStyle(textBlackColor),
          ),
        ],
      ),
    );
  }
}
