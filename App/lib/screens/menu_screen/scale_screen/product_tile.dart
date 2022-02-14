
import 'package:flutter/material.dart';
import 'package:food_app/model/list_product.dart';
import 'package:food_app/screens/common/text.dart';

import '../../../constants.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    Key? key,
    required this.size,
    required this.listProduct,
  }) : super(key: key);
  final Size size;
  final dynamic listProduct;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.1,
      decoration: BoxDecoration(
          color: textWhiteColor,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
              color: shadowBlackColor,
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: Offset(0.0, 4.0),
            )
          ]),
      child: Row(
        children: <Widget>[
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.network(
                      listProduct.imageUrl,
                      height: constraints.maxHeight * 0.85,
                    ),
                  ),
                );
              }),
          Flexible(
              child: Text(listProduct.name,
                  style: buildBigTextStyle(textLighterBlackColor))
          )
        ],
      ),
    );
  }
}