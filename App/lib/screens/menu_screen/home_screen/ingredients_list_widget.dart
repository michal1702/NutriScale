import 'package:flutter/material.dart';
import 'package:food_app/controller/api_controller/spoonacular_controller.dart';
import 'package:food_app/model/ingredient.dart';
import 'package:food_app/model/product.dart';
import 'package:food_app/screens/menu_screen/scale_screen/product_tile.dart';
import 'package:food_app/screens/menu_screen/scale_screen/scale_widget.dart';

import '../../../constants.dart';

class IngredientsList extends StatefulWidget {
  final List<Ingredient> ingredients;
  final Function(bool) onIngredientsListScreen;

  const IngredientsList(
      {Key? key,
      required this.ingredients,
      required this.onIngredientsListScreen})
      : super(key: key);

  @override
  _IngredientsListState createState() => _IngredientsListState();
}

class _IngredientsListState extends State<IngredientsList> {
  SpoonacularController _spoonacularController = SpoonacularController();
  bool _showScaleScreen = false;
  late Product _product;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: _showScaleScreen
          ? ScaleWidget(
              product: _product,
              onShowScaleScreen: (showScaleScreen) {
                setState(() {
                  _showScaleScreen = showScaleScreen;
                });
              })
          : Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    iconSize: 40.0,
                    color: primaryColor,
                    onPressed: () {
                      widget.onIngredientsListScreen(false);
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    width: size.width * 0.95,
                    child: ListView.separated(
                      shrinkWrap: true,
                      clipBehavior: Clip.none,
                      physics: BouncingScrollPhysics(),
                      itemCount: widget.ingredients.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: ProductTile(
                              size: size,
                              listProduct: widget.ingredients[index]),
                          onTap: () async {
                            _product = await _spoonacularController
                                .getProductById(widget.ingredients[index].id);
                            setState(() {
                              _showScaleScreen = true;
                            });
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10.0),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
