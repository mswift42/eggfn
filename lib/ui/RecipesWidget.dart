import 'package:flutter/material.dart';
import 'RecipeWidget.dart' show RecipeWidget;
import 'package:eggfn/services/Recipe.dart';
import 'package:eggfn/services/MockRecipeService.dart' show mockrecipes;

class EggCrackin extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new RecipesHome(),
      theme: _kThemeData,
    );
  }
}

class RecipesHome extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("EggCrackin!"),
      ),
    body: new RecipesWidget(),
    );
  }
}

class RecipeSearch extends StatefulWidget {

  @override
  _RecipeSearchState createState() => new _RecipeSearchState();
}

class _RecipeSearchState extends State<RecipeSearch> {

  @override
  Widget build(BuildContext context) {
    return new Container();
  }
}

class RecipesWidget extends StatefulWidget {


  @override
  _RecipesState createState() => new _RecipesState();
}

class _RecipesState extends State<RecipesWidget> {
  final List<Recipe> recipes = mockrecipes;

  @override
  Widget build(BuildContext context) {
    return new GridView.extent(children: mockrecipes.map((i) => new
    RecipeWidget(i)).toList(),
      maxCrossAxisExtent: 340.00
    );
  }
}


final _kThemeData = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blueGrey,
  accentColor: Colors.pink,
  buttonColor: Colors.grey[200],
  dividerColor: Colors.grey[400],
);