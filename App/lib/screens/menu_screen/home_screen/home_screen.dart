import 'dart:collection';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_app/controller/api_controller/spoonacular_controller.dart';
import 'package:food_app/controller/food_controllers/meals_controller.dart';
import 'package:food_app/model/list_recipe.dart';
import 'package:food_app/model/meal.dart';
import 'package:food_app/model/product.dart';
import 'package:food_app/model/recipe.dart';
import 'package:food_app/screens/common/text.dart';
import 'package:food_app/screens/menu_screen/home_screen/latest_weighed_summary_screen.dart';
import 'package:food_app/screens/menu_screen/home_screen/recommendation_tile.dart';
import 'package:food_app/screens/menu_screen/home_screen/recommended_recipe_screen.dart';
import 'package:food_app/screens/menu_screen/home_screen/section_name.dart';
import 'package:food_app/screens/menu_screen/scale_screen/scale_widget.dart';

import '../../../constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.size}) : super(key: key);

  final Size size;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppLocalizations? localization;
  final _mealsController = MealsController();
  final _spoonacularController = SpoonacularController();
  final _asyncMemorizer = AsyncMemoizer<List<ListRecipe>>();
  List<Meal> _latestMealsList = List.empty();
  List<Meal> _favoritesMealsList = List.empty();
  List<ListRecipe> _recommendedRecipes = List.empty();
  Map<String, int> _userCalories = Map();
  late Recipe _clickedRecipe;

  bool _tooManyCalories = false;
  bool _showScaleScreen = false;
  bool _showRecipeScreen = false;
  Product? _weightProduct;
  String caloriesLastUpdated = "";

  Future<List<ListRecipe>> _getRecommendedMeals() async {
    final maxAvailable = _userCalories['MaxAvailable']!;
    final consumed = _userCalories['Consumed']!;
    if (consumed > maxAvailable) {
      _tooManyCalories = true;
      return Future.value(List.empty());
    }
    final meals = await _spoonacularController
        .getRecipesByNutrients(maxAvailable)
        .then((recipesList) {
      _recommendedRecipes = recipesList;
      return recipesList;
    });
    return meals;
  }

  Future<Map<String, int>> _getUserCalories() async {
    final calories = await _mealsController.getUserCalories().then((calories) {
      final consumed = double.parse(calories['Calories']!);
      final maxAvailable = double.parse(calories['TDEE']!);
      Map<String, int> caloriesMap = {
        'MaxAvailable': maxAvailable.toInt(),
        'Consumed': consumed.toInt()
      };
      _userCalories = caloriesMap;
      return caloriesMap;
    });
    return calories;
  }

  @override
  Widget build(BuildContext context) {
    localization = AppLocalizations.of(context)!;
    Future<List<Meal>> mealsFuture =
        _mealsController.getAllMeals().then((mealsList) {
      _latestMealsList = List.from(mealsList
          .sublist(mealsList.length - 5 < 0 ? 0 : mealsList.length - 5,
              mealsList.length)
          .reversed);
      _favoritesMealsList = _getFavorites(mealsList);
      return mealsList;
    });

    final double tileHeight = widget.size.height * 0.25;
    return _showScaleScreen
        ? ScaleWidget(
            product: _weightProduct!,
            onShowScaleScreen: (showScale) {
              setState(() {
                _showScaleScreen = showScale;
              });
            },
          )
        : _showRecipeScreen
            ? RecommendedRecipe(
                recipe: _clickedRecipe,
                onShowRecipeScreen: (showRecipe) {
                  setState(() {
                    _showRecipeScreen = showRecipe;
                  });
                },
              )
            : ListView(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  SizedBox(height: 15.0),
                  buildRecommendedFutureBuilder(tileHeight),
                  SizedBox(height: 35.0),
                  buildLatestAndFavoritesFutureBuilder(mealsFuture, tileHeight)
                ],
              );
  }

  FutureBuilder<Map<String, int>> buildRecommendedFutureBuilder(
      double tileHeight) {
    return FutureBuilder(
        future: _getUserCalories(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error while connecting: ${snapshot.error.toString()}');
            return Container();
          } else if (snapshot.hasData) {
            return FutureBuilder(future: _asyncMemorizer.runOnce(
              () async {
                return _getRecommendedMeals();
              },
            ), builder: (context, snapshot) {
              if (snapshot.hasError) {
                print('Error while connecting: ${snapshot.error.toString()}');
                return Text(
                  "",
                  style: buildMediumTextStyle(textBlackColor),
                  textAlign: TextAlign.center,
                );
              } else if (snapshot.hasData) {
                return ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    SectionName(
                        sectionName: localization!.recommended,
                        buttonAction: () {}),
                    SizedBox(height: 15.0),
                    _tooManyCalories
                        ? Text(
                            "Your daily limit of calories is ${_userCalories['MaxAvailable']} kcal",
                            style: buildMediumTextStyle(textBlackColor),
                            textAlign: TextAlign.center,
                          )
                        : _recommendedRecipes.isEmpty
                            ? Text(
                                "There is no recommendations yet",
                                style: buildMediumTextStyle(textBlackColor),
                                textAlign: TextAlign.center,
                              )
                            : _buildHomeScreenRecommendedList(tileHeight),
                  ],
                );
              } else {
                return SpinKitFadingCircle(
                  size: 80.0,
                  color: primaryColor,
                );
              }
            });
          } else {
            return SpinKitFadingCircle(
              size: 80.0,
              color: primaryColor,
            );
          }
        });
  }

  FutureBuilder<List<Meal>> buildLatestAndFavoritesFutureBuilder(
      Future<List<Meal>> mealsFuture, double tileHeight) {
    return FutureBuilder(
      future: mealsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('Error while connecting: ${snapshot.error.toString()}');
          return Text(
            "",
            style: buildMediumTextStyle(textBlackColor),
            textAlign: TextAlign.center,
          );
        } else if (snapshot.hasData) {
          return ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              SectionName(
                  sectionName: localization!.favourites, buttonAction: () {}),
              SizedBox(height: 15.0),
              _favoritesMealsList.isEmpty
                  ? Text(
                      "There is no favorites yet",
                      style: buildMediumTextStyle(textBlackColor),
                      textAlign: TextAlign.center,
                    )
                  : _buildHomeScreenFavoritesList(tileHeight),
              SizedBox(height: 35.0),
              SectionName(
                sectionName: localization!.latest,
                buttonAction: () {},
              ),
              SizedBox(height: 15.0),
              _latestMealsList.isEmpty
                  ? Text(
                      localization!.nothingHasBeenWeighedRecently,
                      style: buildMediumTextStyle(textBlackColor),
                      textAlign: TextAlign.center,
                    )
                  : _buildHomeScreenLatestList(tileHeight)
            ],
          );
        } else {
          return SpinKitFadingCircle(
            size: 80.0,
            color: primaryColor,
          );
        }
      },
    );
  }

  Container _buildHomeScreenLatestList(double tileHeight) {
    return Container(
      width: double.infinity,
      height: tileHeight,
      child: ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return RecommendationTile(
            size: widget.size,
            product: _latestMealsList[index].product,
            tileHeight: tileHeight,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LastWeighedSummaryScreen(
                      meal: _latestMealsList[index],
                    ),
                  ));
            },
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: 10.0),
        itemCount: _latestMealsList.length,
      ),
    );
  }

  Container _buildHomeScreenFavoritesList(double tileHeight) {
    return Container(
        width: double.infinity,
        height: tileHeight,
        child: ListView.separated(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return RecommendationTile(
                size: widget.size,
                product: _favoritesMealsList[index].product,
                tileHeight: tileHeight,
                onTap: () {
                  setState(() {
                    _weightProduct =
                        _getOriginalProduct(_favoritesMealsList[index].product);
                    _showScaleScreen = true;
                  });
                });
          },
          separatorBuilder: (context, index) => SizedBox(width: 10.0),
          itemCount: _favoritesMealsList.length,
        ));
  }

  Product _getOriginalProduct(Product product) {
    for (int i = 0; i < product.nutrientsList.length; i++) {
      product.nutrientsList[i].amount =
          (double.parse(product.nutrientsList[i].amount) / product.weight)
              .toStringAsFixed(2);
    }
    return product;
  }

  Container _buildHomeScreenRecommendedList(double tileHeight) {
    return Container(
        width: double.infinity,
        height: tileHeight,
        child: ListView.separated(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return RecommendationTile(
                size: widget.size,
                product: _recommendedRecipes[index],
                tileHeight: tileHeight,
                onTap: () async {
                  _clickedRecipe = await _spoonacularController
                      .getRecipeById(_recommendedRecipes[index].id);
                  setState(() {
                    _showRecipeScreen = true;
                  });
                });
          },
          separatorBuilder: (context, index) => SizedBox(width: 10.0),
          itemCount: _recommendedRecipes.length,
        ));
  }

  List<Meal> _getFavorites(List<Meal> meals) {
    var map = Map();
    final favorites = List<Meal>.empty(growable: true);
    meals.forEach((element) {
      if (!map.containsKey(element.product.id)) {
        map[element.product.id] = 1;
      } else {
        map[element.product.id] += 1;
      }
    });

    final sortedIds =
        SplayTreeMap<int, int>.from(map, (a, b) => map[a] < map[b] ? 1 : -1);
    sortedIds.forEach((key, value) {
      final item = (meals.firstWhere((element) => element.product.id == key));
      favorites.add(item);
    });
    return favorites;
  }
}
