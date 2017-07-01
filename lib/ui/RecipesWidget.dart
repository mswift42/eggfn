import 'package:flutter/material.dart';
import 'RecipeWidget.dart' show RecipeWidget;
import 'package:eggfn/services/Recipe.dart';
import 'package:eggfn/services/MockRecipeService.dart' show mockrecipes;
import 'package:flutter/foundation.dart';
import 'package:eggfn/services/FavouriteService.dart';

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
  FavouriteService _favouriteService;
  Set<String> _favourites;

  @override
  void initState() {
    super.initState();
    _favouriteService = new FavouriteService();
    _favouriteService.restoreFavourites();
    _favourites = _favouriteService.favourites;
    print(_favourites);
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
                    ))
                .toList(),
            maxCrossAxisExtent: 340.00),
      ),
    ]);
  }
}

final _kThemeData = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blueGrey,
  accentColor: Colors.pink,
  buttonColor: Colors.grey[200],
  dividerColor: Colors.grey[400],
);
