import 'package:flutter/material.dart';
import 'package:food_app/constants.dart';
import 'package:food_app/screens/common/text.dart';

class TopCircle extends StatelessWidget {
  const TopCircle({
    Key? key,
    required this.size,
    this.title = "",
    this.subTitle = "",
  }) : super(key: key);

  final Size size;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset(-2.4, -.5),
      child: Container(
        height: size.height * 0.6,
        width: size.width * 0.9,
        decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(60.0, 70.0, 0, 0),
              child: Text(
                title,
                style: buildTitleTextStyle(textWhiteColor),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(55.0, 15.0, 0, 0),
              child: Text(
                subTitle,
                textAlign: TextAlign.center,
                style: buildBigTextStyle(textWhiteColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
