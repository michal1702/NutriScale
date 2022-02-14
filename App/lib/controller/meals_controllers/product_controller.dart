import 'package:food_app/model/product.dart';
import 'package:food_app/repository/meals_repository.dart';

class ProductController {
  late MealsRepository _mealsRepository;

  ProductController() {
    _mealsRepository = MealsRepository();
  }

  void addProduct(Product product) async {
    await _mealsRepository.insertProduct(product);
  }
}
