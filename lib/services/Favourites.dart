import 'dart:io';
import 'dart:async';
import 'package:eggfn/services/Recipe.dart' show Recipe;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'dart:convert' show JSON;

class FavouriteService {
  Set<Recipe> _favourites = new Set<Recipe>();

  Set<Recipe> get favourites => _favourites;

  void addFavourite(Recipe recipe) {
    _favourites.add(recipe);
    _saveFavourites();
  }

  void deleteFavourite(Recipe recipe) {
    _favourites.remove(recipe);
    _saveFavourites();
  }

  bool isFavourite(String recipeid) {
    return _favourites.takeWhile((i) => (i.recipeID == recipeid)).length > 0;
  }

  Future<File> _getLocalFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/favourites.json');
  }

  List<Recipe> _convertToRecipes(String contents) {
    List parsedList = JSON.decode(contents);
    return parsedList.map((i) => new Recipe(
        publisher: i["publisher"],
        title: i["title"],
        sourceUrl: i["source_url"],
        imageUrl: i["image_url"],
        publisherUrl: i["publisher_url"],
        recipeID: i["recipe_id"]));
  }

  Future<String> _readFavourites() async {
    try {
      File file = await _getLocalFile();
      String contents = await file.readAsString();
      return contents;
    } on FileSystemException {
      return "";
    }
  }

  String _convertToJson(List<Recipe> favourites) {
    List favmap = favourites.map((i) => i.toJson()).toList();
    return JSON.encode(favmap);
  }

  Future<Null> _saveFavourites() async {
    String contents = _convertToJson(_favourites.toList());
    await (await _getLocalFile()).writeAsString(contents);
  }
}
