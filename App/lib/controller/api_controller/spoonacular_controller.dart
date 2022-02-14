import 'package:food_app/api/spoonacular_api.dart';
import 'package:food_app/config/available_nutrients.dart';
import 'package:food_app/model/ingredient.dart';
import 'package:food_app/model/list_product.dart';
import 'package:food_app/model/list_recipe.dart';
import 'package:food_app/model/product.dart';
import 'package:food_app/model/recipe.dart';

class SpoonacularController {
  late SpoonacularApi _spoonacularApi;

  SpoonacularController() {
    _spoonacularApi = SpoonacularApi();
  }

  Future<List<ListProduct>> getProductsByQuery(String query) async {
    List<ListProduct> productsList = List.empty(growable: true);
    if (query != '') {
      final products = await _spoonacularApi.request('/food/ingredients/search',
          _spoonacularApi.buildProductListParams(query));
      for (var product in products['results']) {
        productsList.add(ListProduct.fromMap(product));
      }
      return productsList;
    } else {
      return productsList;
    }
  }

  Future<List<ListRecipe>> getRecipesByNutrients(int maxCalories) async {
    List<ListRecipe> recipesList = List.empty(growable: true);
    final recipes = await _spoonacularApi.requestList(
        '/recipes/findByNutrients',
        _spoonacularApi.buildRecipeParams(maxCalories));
    for (var recipe in recipes) {
      recipesList.add(ListRecipe.fromMap(recipe));
    }
    return recipesList;
  }

  Future<Recipe> getRecipeById(int id) async {
    final recipe = await _spoonacularApi.request('/recipes/$id/information',
        _spoonacularApi.buildRecipeInformationParams());
    final ingredients = recipe['extendedIngredients'];
    List<Ingredient> ingredientsList = List.empty(growable: true);
    for (var ingredient in ingredients) {
      ingredientsList.add(Ingredient.fromMap(ingredient));
    }
    return Recipe(recipe['id'], recipe['title'], recipe['image'],
        recipe['servings'], ingredientsList);
  }

  Future<List<String>> getRecipeSteps(int id) async {
    final recipeSteps = await _spoonacularApi.requestList(
        '/recipes/$id/analyzedInstructions',
        _spoonacularApi.buildRecipeStepsParams());
    List<String> recipeStepsList = List.empty(growable: true);
    for (var step in recipeSteps) {
      for (var substep in step['steps']) {
        recipeStepsList.add(substep['step']);
      }
    }
    return recipeStepsList;
  }

  Future<Product> getProductById(int id) async {
    List<String> availableNutrients =
        AvailableNutrients.getAvailableNutrients();
    final response = await _spoonacularApi.request(
        '/food/ingredients/$id/information',
        _spoonacularApi.buildProductParams());
    return Product.spoonacularFromMap(id, response['name'], response['image'],
        response['nutrition']['nutrients'], availableNutrients);
  }
}
