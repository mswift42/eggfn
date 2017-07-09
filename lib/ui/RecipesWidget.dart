import 'package:flutter/material.dart';
import 'RecipeWidget.dart' show RecipeWidget;
import 'package:eggfn/services/Recipe.dart';
import 'package:eggfn/services/MockRecipeService.dart' show mockrecipes;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'dart:io';
import 'dart:async';
import 'dart:convert';

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
    _readFavourites().then((String contents) {
      setState(() {
        _favourites = contents.split(",").toSet();
      });
    });
  }

  @override
  void dispose() {
    saveFavourites();
    super.dispose();
  }

  void _handleFavouriteToggle(Recipe recipe) {
    setState(() {
      if (isFavourite(recipe.recipeID)) {
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
                      isFavourite: _favourites.contains(i.recipeID),
                      onChanged: _handleFavouriteToggle,
                    ))
                .toList(),
            maxCrossAxisExtent: 340.00),
      ),
    ]);
  }

  Set<String> get favourites => _favourites;

  Future<Null> addFavourite(Recipe recipe) async {
    _favourites.add(recipe);
    await saveFavourites();
  }

  Future<Null> deleteFavourite(Recipe recipe) async {
    _favourites.remove(recipe);
    await saveFavourites();
  }

  bool isFavourite(Recipe recipe) {
    return _favourites.contains(recipe);
  }

  Future<File> _getLocalFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/favourites.json');
  }


  Future<List<Recipe>> _readFavourites() async {
    try {
      File file = await _getLocalFile();
      String contents = await file.readAsString();
      return _convertToRecipes(contents);
    } on FileSystemException {
      return new List();
    }
  }



  List<Recipe> _convertToRecipes(String contents) {
    List parsedList = JSON.decode(contents);
    return parsedList.map((i) => new Recipe(
        publisher: i["publisher"],
        title: i["title"],
        sourceUrl: i["source_url"],
        imageUrl: i["image_url"],
        publisherUrl: i["publisher_url"],
        recipeID: i["recipe_id"]));
  }

  String _convertFavouritesToJson(List<Recipe> favourites) {
    List favmap = recipes.map((i) => i.toJson()).toList();
    return JSON.encode(favmap);
  }


  Future<Null> saveFavourites() async {
    String contents = _convertFavouritesToJson(_favourites.toList());
    await (await _getLocalFile()).writeAsString(contents);
  }


  void restoreFavourites() {
    _readFavourites().then((String contents) {
      _favourites = contents.split(",").toSet();
    });
  }
}

final _kThemeData = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blueGrey,
  accentColor: Colors.pink,
  buttonColor: Colors.grey[200],
  dividerColor: Colors.grey[400],
);
