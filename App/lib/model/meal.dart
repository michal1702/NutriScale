import 'package:food_app/model/product.dart';
import 'package:intl/intl.dart';

import 'nutrient.dart';

class Meal {
  final Product _product;
  final DateTime _dateTime;

  Product get product => _product;

  DateTime get dateTime => _dateTime;

  Meal(this._product, this._dateTime);

  factory Meal.fromMap(String date, Map<dynamic, dynamic> productMap){
    final mealDate = DateFormat('dd/MM/yyyy - HH:mm').parse(date);
    List<Nutrient> nutrients = List.empty(growable: true);
    for(var nutrient in productMap['nutrients']){
      nutrients.add(Nutrient.fromMap(nutrient));
    }
    final product = Product.fromMap(productMap['id'], productMap['name'], productMap['weight'], productMap['imgUrl'], nutrients);
    return Meal(product, mealDate);
  }

  Map toJson() => {
        'date': DateFormat('dd/MM/yyyy - HH:mm').format(this._dateTime),
        'product': this._product.toJson()
      };

}
