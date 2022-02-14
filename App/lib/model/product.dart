import 'package:food_app/model/nutrient.dart';

class Product {
  final int _id;
  final String _name;
  List<Nutrient> nutrientsList;
  final String _imgUrl;
  int weight;

  String get name => _name;

  int get id => _id;

  String get imgUrl => _imgUrl;

  Product(this._id, this._name, this.weight, this._imgUrl, this.nutrientsList);

  factory Product.spoonacularFromMap(int id, String name, String imageName,
      List<dynamic> nutrients, List<String> availableNutrients,
      {int weight = 0}) {
    List<Nutrient> nutrientList = List.empty(growable: true);
    for (var nutrient in nutrients) {
      if (availableNutrients.contains(nutrient['name'])) {
        String nutrientName = nutrient['name'];
        nutrientList.add(Nutrient(nutrientName, nutrient['unit'],
            nutrient['amount'].toStringAsFixed(2)));
      }
    }
    final imgUrl = 'https://spoonacular.com/cdn/ingredients_100x100/$imageName';
    return Product(id, name, weight, imgUrl, nutrientList);
  }

  factory Product.fromMap(int id, String name, int weight, String imageUrl,
      List<Nutrient> nutrientsList) {
    return Product(id, name, weight, imageUrl, nutrientsList);
  }

  Map toJson() => {
        'id': this._id,
        'name': this.name,
        'imgUrl': this._imgUrl,
        'nutrients':
            this.nutrientsList.map((nutrient) => nutrient.toJson()).toList(),
        'weight': this.weight,
      };
}
