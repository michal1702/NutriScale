class ListRecipe {
  final String _imageUrl;
  final String _recipeName;
  final int _recipeId;
  final int _imageSize = 100;

  String get imgUrl => _imageUrl;

  String get name => _recipeName;

  int get id => _recipeId;

  ListRecipe(this._recipeId, this._recipeName, this._imageUrl);

  factory ListRecipe.fromMap(Map<String, dynamic> recipe) {
    return ListRecipe(recipe['id'], recipe['title'], recipe['image']);
  }
}
