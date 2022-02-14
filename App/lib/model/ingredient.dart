class Ingredient{
  final int id;
  final String name;
  final double amount;
  late String imageUrl;
  final String unit;
  final int _imageSize = 100;

  Ingredient(this.id, this.name, this.amount, this.unit, String imageName){
    imageUrl = 'https://spoonacular.com/cdn/ingredients_${_imageSize}x$_imageSize/$imageName';
  }

  factory Ingredient.fromMap(Map<String, dynamic> ingredient) {
    final measuresMetric = ingredient['measures']['metric'];
    final measuresUs = ingredient['measures']['us'];
    double amount;
    String unit;
    if(measuresMetric['unitShort'] == 'ml'){
      unit = measuresUs['unitShort'];
      amount = measuresUs['amount'];
    }
    else {
      unit = measuresMetric['unitShort'];
      amount = measuresMetric['amount'];
    }
    return Ingredient(ingredient['id'], ingredient['name'], amount, unit, ingredient['image']);
  }
}
