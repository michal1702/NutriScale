import 'package:firebase_database/firebase_database.dart';
import 'package:food_app/config/current_user.dart';
import 'package:food_app/model/meal.dart';
import 'package:food_app/model/product.dart';
import 'package:intl/intl.dart';

class MealsRepository {
  final _databaseReference = FirebaseDatabase.instance.reference();

  Future<void> insertProduct(Product product) async {
    final meal = Meal(product, DateTime.now());
    await _databaseReference
        .child('Users')
        .child(CurrentUser.user!.userCredentials.login)
        .child('Meals')
        .push()
        .set(meal.toJson());
  }

  Future<List<Meal>> getMealsList() async {
    final snapshot = await _databaseReference
        .child('Users')
        .child(CurrentUser.user!.userCredentials.login)
        .child('Meals')
        .once();
    if (snapshot.value == null) return List.empty();
    List<Meal> returnMeals = List.empty(growable: true);
    final inputMeals = snapshot.value.entries.map((e) => e.value).toList();
    for (var meal in inputMeals) {
      returnMeals.add(Meal.fromMap(meal['date'], meal['product']));
    }
    return returnMeals;
  }

  Future<Map<String, String>> getUserCalories() async {
    final userSnapshot = await _databaseReference
        .child('Users')
        .child(CurrentUser.user!.userCredentials.login)
        .once();
    final mealsSnapshot = await _databaseReference
        .child('Users')
        .child(CurrentUser.user!.userCredentials.login)
        .child('Meals')
        .once();
    Map<String, String> calories = {"Calories": "0.00", "TDEE": "0.00000"};

    if (userSnapshot.value == null) return calories;

    final user = userSnapshot.value;

    if (mealsSnapshot.value == null) {
      calories['TDEE'] = user['Details']['TDEE'];
      return calories;
    }
    final inputMeals = mealsSnapshot.value.entries.map((e) => e.value).toList();
    double userCalories = 0.0;
    String today = DateFormat('dd/MM/yy').format(DateTime.now());
    for (var meal in inputMeals) {
      var mealDate = DateFormat('dd/MM/yyyy - hh:mm').parse(meal['date']);
      if (DateFormat('dd/MM/yy').format(mealDate) == today) {
        final nutrients = meal['product']['nutrients'];
        for (var nutrient in nutrients) {
          if (nutrient['unit'] == 'kcal')
            userCalories += double.parse(nutrient['amount']);
        }
      }
    }
    calories['Calories'] = userCalories.toStringAsFixed(2);
    calories['TDEE'] = user['Details']['TDEE'];
    return calories;
  }
}
