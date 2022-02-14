import 'package:food_app/model/ingredient.dart';

class Recipe {
  final int id;
  final String title;
  final String image;
  final int servings;
  final List<Ingredient> ingredients;

  Recipe(this.id, this.title, this.image, this.servings, this.ingredients);
}
