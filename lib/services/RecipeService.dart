import 'package:eggfn/services/Recipe.dart' show Recipe;

class RecipeService {
  final String _food2forkapikey = '7987c43afcf8a03a964bbcb0c9152c84';

  String get food2forkapikey => _food2forkapikey;

  static String queryUrl(String query) {
    var split = query.trim().split(" ");
    var url = ""
  }
}