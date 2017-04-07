import 'package:flutter/material.dart';
import 'RecipeWidget.dart' show RecipeWidget;
import 'package:eggfn/services/Recipe.dart';
import 'package:eggfn/services/MockRecipeService.dart' show mockrecipes;

class RecipesWidget extends StatefulWidget {


  @override
  _RecipesState createState() => new _RecipesState();
}

class _RecipesState extends State<RecipesWidget> {
  final List<Recipe> recipes = mockrecipes;

  @override
  Widget build(BuildContext context) {
    return new ListView(children: mockrecipes.map((i) => new
    RecipeWidget(i.title, i.image_url, i.publisher, i.publisher_url, i.recipe_id)).toList()
    );
  }
}
