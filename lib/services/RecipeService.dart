import 'package:eggfn/services/Recipe.dart' show Recipe;

class RecipeService {
  static final String food2forkapikey = '7987c43afcf8a03a964bbcb0c9152c84';


  static String queryUrl(String query) {
    var split = query.trim().split(" ");
    var key = food2forkapikey;
    var url = "http://food2fork.com/api/search?key=$key&q=";
    url += split[0];
    for (var s in split.sublist(1)) {
      url += "+" + s;
    }
    return url;
  }
}