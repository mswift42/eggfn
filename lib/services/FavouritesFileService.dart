import 'dart:async' show Future;
import 'dart:io' show File, FileSystemException;
import 'dart:convert' show JSON;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:eggfn/services/Recipe.dart' show Recipe;

class FavouritesFileService {
  static Future<File> _getLocalFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/favourites.json');
  }

  static String _convertFavouritesToJson(List<Recipe> favourites) {
    List favmap = favourites.map((i) => i.toJson()).toList();
    return JSON.encode(favmap);
  }

  static Future<Null> saveFavourites(Set<Recipe> favourites) async {
    String contents = _convertFavouritesToJson(favourites.toList());
    await (await _getLocalFile()).writeAsString(contents);
  }

  static List<Recipe> _convertToRecipes(String contents) {
    List parsedList = JSON.decode(contents);
    return parsedList
            .map((i) => new Recipe(
                publisher: i["publisher"],
                title: i["title"],
                sourceUrl: i["source_url"],
                imageUrl: i["image_url"],
                publisherUrl: i["publisher_url"],
                recipeID: i["recipe_id"],
                ingredients: i["ingredients"] ?? new List<String>()))
            .toList() ??
        new List();
  }

  static Future<List<Recipe>> readFavourites() async {
    try {
      File file = await _getLocalFile();
      String contents = await file.readAsString();
      return _convertToRecipes(contents);
    } on FileSystemException {
      return new List();
    }
  }
}
