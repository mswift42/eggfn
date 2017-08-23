import 'package:quiver/core.dart' show hash2;

class Recipe {
  Recipe(
      {this.publisher,
      this.title,
      this.sourceUrl,
      this.imageUrl,
      this.publisherUrl,
      this.recipeID,
      this.ingredients});
  String publisher, title, sourceUrl, imageUrl, publisherUrl, recipeID;
  List<String> ingredients;

  bool operator ==(o) => o is Recipe && o.recipeID == recipeID;

  int get hashCode => hash2(title.hashCode, recipeID.hashCode);



  Recipe.fromJsonMap(Map recipemap) {
    publisher = recipemap["publisher"];
    title = _unsanitize(recipemap["title"]);
    sourceUrl = recipemap["source_url"].toString();
    imageUrl = recipemap["image_url"];
    publisherUrl = recipemap["publisher_url"];
    recipeID = recipemap["recipe_id"];
    ingredients = recipemap["ingredients"] ?? new List<String>();
  }

  String _unsanitize(String s) {
    s = s.replaceAll("&nbsp;", " ");
    s = s.replaceAll("&#8217;", "'");
    return s.replaceAll("&amp;", "&");
  }

  Map toJson() {
    return {
      "title": title,
      "publisher": publisher,
      "source_url": sourceUrl,
      "image_url": imageUrl,
      "publisher_url": publisherUrl,
      "recipe_id": recipeID,
      "ingredients" : ingredients,
    };
  }
}
