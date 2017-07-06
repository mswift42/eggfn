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
  }

  void deleteFavourite(Recipe recipe) {
    _favourites.remove(recipe);
  }

  bool isFavourite(String recipeid) {
    return _favourites
            .takeWhile((i) => (i.recipeID == recipeid))
            .length >
        0;
  }


  Future<File> _getLocalFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/favourites.json');
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
