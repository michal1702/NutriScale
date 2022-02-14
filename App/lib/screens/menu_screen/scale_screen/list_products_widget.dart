import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_app/controller/api_controller/spoonacular_controller.dart';
import 'package:food_app/model/list_product.dart';
import 'package:food_app/model/product.dart';
import 'package:food_app/screens/common/dismiss_keyboard_widget.dart';
import 'package:food_app/screens/common/input_fields/text_input_field.dart';
import 'package:food_app/screens/menu_screen/scale_screen/product_tile.dart';

import '../../../constants.dart';

class ListProductsWidget extends StatefulWidget {
  const ListProductsWidget(
      {Key? key, required this.size, required this.onProductSet})
      : super(key: key);

  final Size size;
  final Function(Product, bool) onProductSet;

  @override
  _ListProductsWidgetState createState() => _ListProductsWidgetState();
}

class _ListProductsWidgetState extends State<ListProductsWidget> {
  AppLocalizations? _localization;
  final _spoonacularController = SpoonacularController();
  final _productController = TextEditingController();

  bool _isListLoading = false;
  int _listSize = 0;
  List<ListProduct> productsList = List.empty();

  @override
  Widget build(BuildContext context) {
    _localization = AppLocalizations.of(context)!;
    return WillPopScope(
      onWillPop: () async => false,
      child: DismissKeyboard(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            Row(
              children: <Widget>[
                Expanded(
                    child: TextInputField(
                        hint: _localization!.searchProduct,
                        controller: _productController)),
                IconButton(
                  icon: Icon(Icons.search),
                  color: primaryColor,
                  iconSize: 40.0,
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {
                      _isListLoading = true;
                    });
                    String productName;
                      productName = _productController.text;
                      await _spoonacularController
                          .getProductsByQuery(productName)
                          .then((value) => productsList = value);
                    setState(() {
                      _listSize = productsList.length;
                      _isListLoading = false;
                    });
                  },
                )
              ],
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: _isListLoading
                  ? SpinKitFadingCircle(
                      size: 80.0,
                      color: primaryColor,
                    )
                  : ListView.separated(
                      clipBehavior: Clip.none,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: ProductTile(
                            size: widget.size,
                            listProduct: productsList[index],
                          ),
                          onTap: () async {
                            final product = await _spoonacularController
                                .getProductById(productsList[index].productId);
                            widget.onProductSet(product, true);
                          },
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: _listSize),
            ),
          ],
        ),
      ),
    );
  }
}
