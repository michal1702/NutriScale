class ListProduct {
  late String _imageUrl;
  final String _productName;
  final int _productId;
  final int _imageSize = 100;

  String get imageUrl => _imageUrl;

  String get name => _productName;

  int get productId => _productId;

  ListProduct(this._productId, this._productName, String imageName) {
    _imageUrl =
        'https://spoonacular.com/cdn/ingredients_${_imageSize}x$_imageSize/$imageName';
  }

  factory ListProduct.fromMap(Map<String, dynamic> product) {
    return ListProduct(product['id'], product['name'], product['image']);
  }
}
