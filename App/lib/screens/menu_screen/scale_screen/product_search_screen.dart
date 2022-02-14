import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:food_app/model/product.dart';
import 'package:food_app/screens/menu_screen/scale_screen/scale_widget.dart';

import 'list_products_widget.dart';

class ProductSearchWidget extends StatefulWidget {
  const ProductSearchWidget({Key? key, required this.size}) : super(key: key);

  final Size size;
  final double padding = 10.0;

  @override
  _ProductSearchWidgetState createState() => _ProductSearchWidgetState();
}

class _ProductSearchWidgetState extends State<ProductSearchWidget> {
  late Product _product;
  bool _showScaleScreen = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
          height: widget.size.height,
          width: widget.size.width * 0.92,
          child: _showScaleScreen
            ? ScaleWidget(
                product: _product,
                onShowScaleScreen: (showScale) {
                  setState(() {
                    _showScaleScreen = showScale;
                  });
                },
              )
            : ListProductsWidget(
                size: widget.size,
                onProductSet: (product, showScale) {
                  setState(() {
                    _product = product;
                    _showScaleScreen = showScale;
                  });
                },
              ),
          ),
    );
  }
}
