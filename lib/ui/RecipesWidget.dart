import 'package:flutter/material.dart';
import 'RecipeWidget.dart' show RecipeWidget;
import 'package:eggfn/services/Recipe.dart';
import 'package:eggfn/services/MockRecipeService.dart' show mockrecipes;
import 'package:flutter/foundation.dart';
import 'dart:async';

class EggCrackin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new RecipesHome(),
      theme: _kThemeData,
    );
  }
}

class RecipesHome extends StatefulWidget {

  RecipesHomeState createState() => new RecipesHomeState();
}

class RecipesHomeState  extends State<RecipesHome> {
  ValueNotifier<bool> open = new ValueNotifier<bool>(false);


  void _handlePress() {
    setState(() {
      open.value = !open.value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("EggCrackin!"),
        actions: <Widget>[
          new IconButton(
              icon:
                  new Icon(Icons.search, color: Theme.of(context).buttonColor),
              onPressed: _handlePress),
        ],
      ),
      body: new RecipesWidget(open),
    );
  }
}
// TODO Add Empty Container / TextInput children widgets.
class RecipeSearch extends AnimatedWidget {
  final ValueNotifier<bool> open;
  RecipeSearch({@required this.open}) : super(listenable: open);
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: open.value ? new Text("open") : new Text("not open"),
    );
  }

}



class RecipesWidget extends StatefulWidget {
  final ValueNotifier<bool> open;
  RecipesWidget(this.open);
  @override
  _RecipesState createState() => new _RecipesState();
}

class _RecipesState extends State<RecipesWidget> {
  _RecipesState();
  final List<Recipe> recipes = mockrecipes;

  @override
  Widget build(BuildContext context) {
    return new GridView.extent(
        children: mockrecipes.map((i) => new RecipeWidget(i)).toList(),
        maxCrossAxisExtent: 340.00);
  }
}

final _kThemeData = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blueGrey,
  accentColor: Colors.pink,
  buttonColor: Colors.grey[200],
  dividerColor: Colors.grey[400],
);
