import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_app/controller/api_controller/spoonacular_controller.dart';
import 'package:food_app/model/recipe.dart';
import 'package:food_app/screens/common/rounded_button.dart';
import 'package:food_app/screens/common/text.dart';
import 'package:food_app/screens/menu_screen/home_screen/ingredients_list_widget.dart';

import '../../../constants.dart';

class RecommendedRecipe extends StatefulWidget {
  final Recipe recipe;
  final Function(bool) onShowRecipeScreen;

  const RecommendedRecipe(
      {Key? key, required this.recipe, required this.onShowRecipeScreen})
      : super(key: key);

  @override
  _RecommendedRecipeState createState() => _RecommendedRecipeState();
}

class _RecommendedRecipeState extends State<RecommendedRecipe> {
  SpoonacularController _spoonacularController = SpoonacularController();

  bool _showSteps = false;
  bool _showProductsList = false;
  List<String> _recipeSteps = List.empty();

  @override
  Widget build(BuildContext context) {
    AppLocalizations? localization = AppLocalizations.of(context)!;
    return WillPopScope(
      onWillPop: () async => false,
      child: _showProductsList
          ? IngredientsList(
              ingredients: widget.recipe.ingredients,
              onIngredientsListScreen: (showProductsList) {
                setState(() {
                  _showProductsList = showProductsList;
                });
              })
          : ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        iconSize: 40.0,
                        color: primaryColor,
                        onPressed: () {
                          widget.onShowRecipeScreen(false);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.point_of_sale),
                        iconSize: 40.0,
                        color: primaryColor,
                        onPressed: () {
                          setState(() {
                            _showProductsList = true;
                          });
                        },
                      )
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(widget.recipe.image),
                ),
                SizedBox(height: 20),
                Text(
                  "Ingredients",
                  style: buildHeaderTextStyle(textBlackColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.recipe.ingredients.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Text(
                          "${widget.recipe.ingredients[index].name} - ${widget.recipe.ingredients[index].amount} ${widget.recipe.ingredients[index].unit}",
                          style: buildMediumTextStyle(textBlackColor),
                        ),
                      );
                    }),
                SizedBox(height: 20),
                _showSteps
                    ? Column(
                        children: <Widget>[
                          Text(
                            "Steps",
                            style: buildHeaderTextStyle(textBlackColor),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _recipeSteps.length,
                                itemBuilder: (context, index) {
                                  return Text(
                                    '${index + 1}. ${_recipeSteps[index]}',
                                    style: buildSmallTextStyle(textBlackColor),
                                  );
                                }),
                          )
                        ],
                      )
                    : RoundedButton(
                        text: "Show steps",
                        action: () async {
                          _recipeSteps = await _spoonacularController
                              .getRecipeSteps(widget.recipe.id);
                          setState(() {
                            _showSteps = true;
                          });
                        })
              ],
            ),
    );
  }
}
