import 'package:food_app/model/meal.dart';
import 'package:food_app/repository/meals_repository.dart';

class MealsController {
  late MealsRepository _mealsRepository;

  MealsController() {
    _mealsRepository = MealsRepository();
  }

  Future<List<Meal>> getAllMeals() async {
    final List<Meal> meals = (await _mealsRepository.getMealsList());
    return meals;
  }

  Future<Map<String, String>> getUserCalories() async {
    final calories = await _mealsRepository.getUserCalories();
    return calories;
  }
}
