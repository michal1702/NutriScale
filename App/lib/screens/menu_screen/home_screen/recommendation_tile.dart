import 'package:flutter/material.dart';
import 'package:food_app/constants.dart';
import 'package:food_app/screens/common/text.dart';

class RecommendationTile extends StatelessWidget {
  const RecommendationTile(
      {Key? key,
      required this.size,
      required this.product,
      required this.tileHeight,
      required this.onTap})
      : super(key: key);

  final Size size;
  final dynamic product;
  final double tileHeight;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final double width = size.width * 0.4;
    final double height = tileHeight;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: textWhiteColor,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            boxShadow: [
              BoxShadow(
                color: shadowBlackColor,
                blurRadius: 4.0,
                spreadRadius: 0.0,
                offset: Offset(0.0, 4.0),
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(6.0, 8.0, 6.0, 0.0),
              child: Container(
                height: height * 0.55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0)),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(product.imgUrl),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 5.0),
              child: Container(
                width: width,
                height: height * 0.35,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(borderRadius),
                      bottomRight: Radius.circular(borderRadius)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 2.0, right: 2.0),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Text(
                      product.name,
                      style: buildSmallTextStyle(textWhiteColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
