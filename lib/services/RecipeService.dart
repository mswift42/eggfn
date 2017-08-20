import 'package:eggfn/services/Recipe.dart' show Recipe;
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:convert';

class RecipeService {
   final String _food2forkapikey = '7987c43afcf8a03a964bbcb0c9152c84';


   String queryUrl(String query) {
    var split = query.trim().split(" ");
    var key = _food2forkapikey;
    var url = "http://food2fork.com/api/search?key=$key&q=";
    url += split[0];
    for (var s in split.sublist(1)) {
      url += "+" + s;
    }
    return url;
  }

  Future<String> _getRecipesResponse(String query) async {
    var url = queryUrl(query);
    var httpClient = createHttpClient();
    var response = await httpClient.read(url);
    return response;
  }

  Future<List<Recipe>> getRecipes(String query) async {
     List parsedList = JSON.decode(await _getRecipesResponse(query))["recipes"];
     return parsedList.map((i) => new Recipe.fromJsonMap(i)).toList();
  }

  Future<List<String>> getIngredients(String recipeid) async {
      var url = "http://food2fork.com/api/get?key=$_food2forkapikey&rId=$recipeid";
      var httpClient = createHttpClient();
      var response = await httpClient.read(url);
      var decoded = JSON.decode(response)["recipe"]["ingredients"];
      return decoded;
  }

  String queryPage(String query, int pagenumber) {
    return '$query&page=$pagenumber';
  }
}