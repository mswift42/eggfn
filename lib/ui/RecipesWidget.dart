import 'package:flutter/material.dart';
import 'RecipeWidget.dart' show RecipeWidget;
import 'package:eggfn/services/Recipe.dart';
import 'package:eggfn/services/MockRecipeService.dart' show mockrecipes;
import 'package:eggfn/services/FavouritesFileService.dart';
import 'package:eggfn/ui/FavouritesWidget.dart' show FavouritesWidget;
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

class RecipesHomeState extends State<RecipesHome> {
  ValueNotifier<bool> open = new ValueNotifier<bool>(false);

  void _handlePress() {
    setState(() {
      open.value = !open.value;
    });
  }

  void showFavourites(BuildContext context) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(title: new Text("Favourites")),
        body: new FavouritesWidget(),
      );
    }));
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
          new IconButton(
              icon: new Icon(Icons.star),
              onPressed: () {
                showFavourites(context);
              }),
        ],
      ),
      body: new RecipesWidget(open),
    );
  }
}

class RecipeSearch extends AnimatedWidget {
  final ValueNotifier<bool> open;
  RecipeSearch({@required this.open}) : super(listenable: open);
  @override
  Widget build(BuildContext context) {
    return new AnimatedCrossFade(
      firstChild: new Container(),
      secondChild: new RecipeSearchInput(),
      crossFadeState:
          open.value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: new Duration(milliseconds: 300),
    );
  }
}

class RecipeSearchInput extends StatefulWidget {
  _RecipeSearchInputState createState() => new _RecipeSearchInputState();
}

class _RecipeSearchInputState extends State<RecipeSearchInput> {
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new TextField(
      controller: _controller,
      onSubmitted: _handleSubmit,
      decoration:
          new InputDecoration(hintText: "Search for Recipes or Ingredients"),
    );
  }

  void _handleSubmit(String text) {
    // TODO Search using food2fork api.
    // TODO setup streambuilder to load recipes.
    print(text);
  }
}

class RecipesWidget extends StatefulWidget {
  // TODO load recipes asynchronously.
  final ValueNotifier<bool> open;
  RecipesWidget(this.open);

  @override
  _RecipesState createState() => new _RecipesState();
}

class _RecipesState extends State<RecipesWidget> {
  final List<Recipe> recipes = mockrecipes;
  Set<Recipe> _favourites = new Set<Recipe>();

  @override
  void initState() {
    super.initState();
    FavouritesFileService.readFavourites().then((List<Recipe> contents) {
      setState(() {
        _favourites = contents.toSet();
      });
    });
  }

  @override
  void dispose() {
    FavouritesFileService.saveFavourites(_favourites);
    super.dispose();
  }

  void _handleFavouriteToggle(String recipeid) {
    Recipe recipe = recipes.firstWhere((i) => i.recipeID == recipeid);
    setState(() {
      if (isFavourite(recipe)) {
        deleteFavourite(recipe);
      } else {
        addFavourite(recipe);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Column(children: <Widget>[
      new RecipeSearch(open: widget.open),
      new Expanded(
        child: new GridView.extent(
            children: mockrecipes
                .map((i) => new RecipeWidget(
                      recipe: i,
                      isFavourite: isFavourite(i),
                      onChanged: _handleFavouriteToggle,
                    ))
                .toList(),
            maxCrossAxisExtent: 340.00),
      ),
    ]);
  }

  Set<Recipe> get favourites => _favourites;

  Future<Null> addFavourite(Recipe recipe) async {
    _favourites.add(recipe);
    await FavouritesFileService.saveFavourites(_favourites);
  }

  Future<Null> deleteFavourite(Recipe recipe) async {
    _favourites =
        _favourites.where((i) => (i.recipeID != recipe.recipeID)).toSet();
    await FavouritesFileService.saveFavourites(_favourites);
  }

  bool isFavourite(Recipe recipe) {
    return _favourites.any((i) => i.recipeID == recipe.recipeID);
  }
}

final _kThemeData = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blueGrey,
  accentColor: Colors.pink,
  buttonColor: Colors.grey[200],
  dividerColor: Colors.grey[400],
);
